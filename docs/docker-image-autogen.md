# Unlimited Docker Image Generator Workflow

File: `.github/workflows/docker-image-autogen.yml`

This workflow builds arbitrarily many Docker images from the repository and optionally publishes them to a container registry. It also exports each image as a tarball artifact so that you can download builds with `curl` even without direct registry access.

## Triggers
- **Manual (`workflow_dispatch`)** – run with custom parameters from the Actions tab.

## Inputs
| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| `registry` | choice | `ghcr.io` | Target registry domain. |
| `repository` | string | (current `owner/repo`) | Repository path inside the registry. Leave blank to use the GitHub repo slug. |
| `base_tag` | string | `auto` | Prefix for generated tags. Unsafe characters are converted to hyphens. |
| `tag_count` | number | `5` | Number of sequential tags to create (`prefix-001` ... `prefix-XXX`). |
| `push_to_registry` | boolean | `true` | Push the generated images to the registry. |
| `export_tarball` | boolean | `true` | Export each build as a compressed tarball artifact. |

## Job Overview
1. **Matrix preparation** – sanitizes the tag prefix and builds a JSON matrix of sequential tags.
2. **Build & distribute** – iterates over each tag to:
   - Resolve registry credentials (uses `GITHUB_TOKEN` automatically for GHCR).
   - Build the image with Buildx using GHA cache and optionally push it.
   - Export a `.tar.gz` artifact for each image when enabled.
   - Append ready-to-run `curl` commands to the workflow summary.

## Registry Credentials
- **GHCR** – Works out of the box via `GITHUB_TOKEN`.
- **Other registries** – Add repository secrets `REGISTRY_USERNAME` and `REGISTRY_PASSWORD` with permissions to push.

If credentials are missing, the workflow gracefully skips the push step and still produces artifacts.

## Downloading Images with curl
### Download the manifest from the registry
```bash
curl -L -H "Authorization: Bearer <TOKEN>" \
  -H 'Accept: application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.v2+json' \
  "https://<registry>/v2/<repository>/manifests/<tag>"
```
- Replace `<TOKEN>` with a registry access token (`echo $GITHUB_TOKEN` for GHCR inside CI).
- `<registry>` is e.g. `ghcr.io`, `<repository>` is `owner/image`.

### Download the tarball artifact from Actions
```bash
curl -L -H 'Authorization: token <YOUR_GITHUB_TOKEN>' \
  -o docker-image-<tag>.zip \
  "https://api.github.com/repos/<owner>/<repo>/actions/artifacts/<artifact-id>/zip"
unzip docker-image-<tag>.zip
```
- Requires a GitHub token with `Actions: read` permission.
- The artifact URL is included in the workflow summary for each tag.

## Extending the Workflow
- Update the build context or Dockerfile as needed; the workflow builds from repository root by default.
- Adjust caching behavior (`cache-from`/`cache-to`) or Buildx arguments in the workflow file.
- Integrate additional verification steps (tests, vulnerability scans) before publishing.

## Troubleshooting
- **Push skipped warning** – Set `REGISTRY_USERNAME`/`REGISTRY_PASSWORD` for non-GHCR registries.
- **Missing tarball** – Ensure `export_tarball` input is `true`; the archive is stored under the `docker-image-<tag>` artifact.
- **Artifact download** – Use `curl` with a token or download via the Actions UI.
