# TROLIE

Transmission Ratings and Operating Limits Information Exchange

[OpenAPI Specification docs](https://TROLIE.github.io/spec/)

### License

[Apache 2.0](https://github.com/TROLIE/spec/blob/1.0.0-wip/LICENSE)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://artwork.lfenergy.org/other/lf-energy-project/horizontal/white/lf-energy-project-horizontal-white.png">
  <source media="(prefers-color-scheme: light)" srcset="https://artwork.lfenergy.org/other/lf-energy-project/horizontal/color/lf-energy-project-horizontal-color.png">
  <img alt="Official LF Energy Project logo" src="https://artwork.lfenergy.org/other/lf-energy-project/horizontal/color/lf-energy-project-horizontal-color.png" width="200">
</picture>

## Specification Editors

The `docs/` folder contains a Jekyll site for the GH Pages along with the yaml
that is used with `redocly bundle` to created the OpenAPI specification.

To simply the local setup of the toolchain, a devcontainer is provided. This
will also install VS Code extensions to help with local editing as well.

If your company uses MITM, self-signed certificates through your Internet proxy
and/or proxies upstream RubyGem or npm repos, please follow the instructions in
the next section.

### Self-Signed Certs and Repo Proxies

Put your company's self-signed cert in a PEM file at: `.devcontainer/root.pem`

You can use your company's RubyGem and npm proxies by specifying them in
`.devcontainer\devcontainer.json` by replacing:

```json
  "containerEnv": {
      "GEM_REPO": "https://rubygems.org",
      "NPM_CONFIG_REGISTRY": "https://registry.npmjs.org"
  }
```
