#!/usr/bin/env bash
# Bootstrap ArgoCD on the current kube-context (minikube) and register
# example-service Applications from services/example-service/gitops/apps.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SVC="$ROOT/services/example-service"

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "waiting for argocd-server..."
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s

# Private-repo access for Argo (uses ambient GITHUB_TOKEN / gh auth token).
TOKEN="${GITHUB_TOKEN:-$(gh auth token)}"
kubectl -n argocd delete secret repo-example-service --ignore-not-found
kubectl -n argocd create secret generic repo-example-service \
  --from-literal=type=git \
  --from-literal=url=https://github.com/xdlc-labs/example-service.git \
  --from-literal=password="$TOKEN" \
  --from-literal=username=git
kubectl -n argocd label secret repo-example-service argocd.argoproj.io/secret-type=repository

# GHCR pull for private package (same token).
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
for ns in dev prod; do
  kubectl -n "$ns" delete secret ghcr-pull --ignore-not-found
  kubectl -n "$ns" create secret docker-registry ghcr-pull \
    --docker-server=ghcr.io \
    --docker-username=git \
    --docker-password="$TOKEN"
  kubectl -n "$ns" patch serviceaccount default \
    -p '{"imagePullSecrets":[{"name":"ghcr-pull"}]}'
done

kubectl apply -f "$SVC/gitops/apps/dev/example-service.yaml"
kubectl apply -f "$SVC/gitops/apps/prod/example-service.yaml"

echo "ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
echo
echo "Next: kubectl -n argocd port-forward svc/argocd-server 8443:443"
echo "      argocd login localhost:8443 --username admin --insecure"
