# example-service

[![CI](https://github.com/xdlc-labs/example-service/actions/workflows/ci.yml/badge.svg)](https://github.com/xdlc-labs/example-service/actions/workflows/ci.yml)
[![Go](https://img.shields.io/badge/go-1.25-00ADD8?logo=go&logoColor=white)](go.mod)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Public demo HTTP service for [xdlc-agent](https://github.com/xdlc-labs/xdlc-agent).

Tiny service so CI, DEV smoke, and prod-health have something real to fail: `/healthz` for probes, `/metrics` (and optional OTLP) for the prod-health gate.

## Run locally

```sh
git clone https://github.com/xdlc-labs/example-service.git
cd example-service
OTEL_SDK_DISABLED=true go run .
# curl http://127.0.0.1:8080/healthz
```

Point xdlc at this repo:

```yaml
repos:
  - name: example-service
    github: xdlc-labs/example-service
    gates: [ci]
```

Then [install xdlc](https://xdlc-labs.github.io/documentation/xdlc-agent/install/) and run `xdlc daemon`.

## Try a Fix without changing this repo

Do not break `main` by hand. Sample PRs that fail CI live in [xdlc-labs/fixtures](https://github.com/xdlc-labs/fixtures).

## Related

- [xdlc-agent](https://github.com/xdlc-labs/xdlc-agent) — daemon that can Fix this app when CI fails
- [Guides](https://xdlc-labs.github.io/documentation/)

## License

[MIT](LICENSE)
