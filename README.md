# fleet-template-ext

Minimal Fleet extension template: declarative UI + JSON-RPC worker.

**Repository:** [krate-apps/fleet-template-ext](https://github.com/krate-apps/fleet-template-ext)

## Docs

Follow **[Create an extension](https://github.com/krate-apps/fleet/blob/main/docs/developer/create-extension.md)** in the Fleet host docs.

Related:

- [SDK](https://github.com/krate-apps/fleet/blob/main/docs/developer/sdk.md)
- [Publishing](https://github.com/krate-apps/fleet/blob/main/docs/developer/publishing-extensions.md)
- [Create a bucket](https://github.com/krate-apps/fleet/blob/main/docs/developer/create-bucket.md)

## Quick start

1. Copy this tree to a new repo (for example `fleet-ext-mything`).
2. Change `id` / `name` in `fleet.ext.yaml` and `extensionId` in `ui/extension.json`.
3. Rename worker methods from `ext.template.*` to your short id.
4. `make build && make test`

```text
fleet-template-ext/
  fleet.ext.yaml
  ui/extension.json
  cmd/template-worker/
  scripts/pack.sh
  Makefile
  LICENSE
```

## Pack / publish

```bash
make pack   # dist/<id>-linux-amd64.tar.gz + dist/SHA256SUMS
```

Tag `v*` to run `.github/workflows/release.yml` (uploads the archive + `SHA256SUMS`).

Pin the Official (or community) bucket listing with [`fleet-bucket-action/pin`](https://github.com/krate-apps/fleet-bucket-action):

```bash
FLEET_BUCKET_ROOT=/path/to/bucket PIN_SUMS=./dist/SHA256SUMS PIN_TAG=v0.1.0 \
  python3 /path/to/fleet-bucket-action/scripts/pin-listings.py
```

## License

MIT — Copyright (c) 2026 Krate.

---

<p align="center">
  Developed by the <a href="https://runkrate.com">Krate</a> team.<br />
  Released under the MIT License.
</p>
