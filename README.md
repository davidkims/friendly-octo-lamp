# 🐙 Friendly Octo Lamp - Dependabot Enhanced Operations

An enterprise-grade repository with comprehensive Dependabot enhancements, Docker image management, bulk operations, and automated security scanning.

## 🚀 Features

### Enhanced Dependabot Configuration
- **Multi-ecosystem monitoring** (Docker, Maven, Node.js)
- **Daily Docker image updates** with Asia/Seoul timezone
- **Advanced security labeling** and review workflows
- **Comprehensive ignore/allow rules** for dependency management
- **Automated PR management** with proper reviewers and assignees

### Docker Image & Container Management
- **Automated image inventory generation** with vulnerability scanning
- **Container file analysis and updates** with security enhancements
- **Multi-registry support** (Docker Hub, GHCR, Quay, GCR)
- **Security-focused templates** for Dockerfiles and Compose files
- **Multi-architecture build preparation**

### Bulk Directory & Permission Management
- **Template-based directory creation** (Standard, Microservices, Monorepo, Docker)
- **Automated permission management** with configurable security levels
- **Bulk file operations** with .gitkeep, .gitattributes, and CODEOWNERS
- **Custom directory structures** with comma-separated input support

### Security & Compliance
- **Comprehensive vulnerability scanning** for containers and dependencies
- **Security best practices enforcement** in all container configurations
- **Automated security reporting** with actionable recommendations
- **CODEOWNERS file management** for repository governance

## 📁 Repository Structure

```
friendly-octo-lamp/
├── .github/
│   ├── workflows/                 # Enhanced automation workflows
│   │   ├── dependabot-enhanced-operations.yml  # Main orchestrator
│   │   ├── docker-image-info.yml               # Docker image management  
│   │   ├── bulk-directory-management.yml       # Directory operations
│   │   └── container-file-update.yml           # Container security updates
│   ├── bulk-ops/                 # Bulk operation tools and configs
│   │   ├── configs/              # Templates and configuration files
│   │   ├── scripts/              # Python automation scripts
│   │   └── logs/                 # Operation logs and reports
│   ├── dependabot.yml            # Enhanced Dependabot configuration
│   └── CODEOWNERS               # Repository governance
├── docker-info/                 # Docker image information
│   ├── images/                  # Image inventories and metadata
│   ├── vulnerabilities/         # Security scan results
│   ├── reports/                 # Analysis reports
│   └── registries/              # Registry-specific data
├── container-management/        # Container file management
│   ├── tools/                   # Analysis and update scripts
│   ├── templates/               # Modern secure templates
│   ├── configs/                 # Configuration files
│   └── reports/                 # Operation reports
└── security-analysis/           # Security scanning tools
    ├── tools/                   # Security scanners and analyzers
    └── reports/                 # Security reports and summaries
```

## 🛠️ Available Workflows

### 1. Dependabot Enhanced Operations (Main)
**File:** `.github/workflows/dependabot-enhanced-operations.yml`

The main orchestrator workflow that coordinates all operations.

**Trigger Options:**
- **Schedule:** Weekly on Mondays at 1 AM UTC
- **Manual:** Workflow dispatch with customizable parameters
- **Automatic:** On Dependabot configuration changes

**Operation Modes:**
- `full-automation` - Run all operations (default)
- `docker-focus` - Docker and security operations only
- `directory-setup` - Directory management only  
- `security-scan` - Security analysis only
- `custom` - All operations with custom parameters

**Parameters:**
- `docker_registry` - Target registry (docker.io, ghcr.io, quay.io, gcr.io)
- `directory_template` - Template type (standard, microservices, monorepo, docker)
- `enable_notifications` - Enable/disable notifications
- `dry_run` - Preview mode without making changes

### 2. Docker Image Information Generator
**File:** `.github/workflows/docker-image-info.yml`

Automated Docker image analysis and vulnerability scanning.

**Features:**
- Daily image inventory generation
- Vulnerability scanning with Trivy and Docker Scout
- Multi-registry support
- Architecture-specific analysis
- Automated security reporting

**Manual Trigger Parameters:**
- `registry` - Docker registry to scan
- `image_pattern` - Image search pattern
- `include_vulnerabilities` - Enable vulnerability scanning

### 3. Unlimited Docker Image Generator
**File:** `.github/workflows/docker-image-autogen.yml`

Matrix-driven Docker image generation with on-demand distribution.

**Highlights:**
- Generate sequential image tags from a base prefix (e.g. `auto-001`, `auto-002`, ...)
- Push images to GHCR out-of-the-box or other registries with provided credentials
- Export each build as a compressed tarball artifact
- Provide official `curl` commands for both registry manifest access and artifact downloads

**Manual Trigger Parameters:**
- `registry` - Target registry domain (defaults to `ghcr.io`)
- `repository` - Repository path; defaults to the current repository owner/name when left blank
- `base_tag` - Prefix for generated tags (sanitized for registry compatibility)
- `tag_count` - Number of sequential tags to create (e.g. `10` to produce `prefix-001`..`prefix-010`)
- `push_to_registry` - Enable/disable registry publishing
- `export_tarball` - Enable/disable tarball artifact export for each image

**Download via curl:**
After the workflow runs, check the job summary for ready-to-run commands such as:

```bash
# Retrieve the image manifest directly from the registry (token required)
curl -L -H "Authorization: Bearer <TOKEN>" \
  -H 'Accept: application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.v2+json' \
  https://ghcr.io/v2/<owner>/<image>/manifests/prefix-001

# Download the generated tarball artifact (requires GitHub token with Actions:read)
curl -L -H 'Authorization: token <YOUR_GITHUB_TOKEN>' \
  -o docker-image-prefix-001.zip \
  "https://api.github.com/repos/<owner>/<repo>/actions/artifacts/<artifact-id>/zip"
unzip docker-image-prefix-001.zip
```

> ℹ️ For non-GHCR registries, configure `REGISTRY_USERNAME` and `REGISTRY_PASSWORD` secrets so the workflow can authenticate before pushing.


### 4. Bulk Directory and Permission Management
**File:** `.github/workflows/bulk-directory-management.yml`

Comprehensive directory and permission automation.

**Templates Available:**
- **Standard:** Traditional project structure
- **Microservices:** Service-oriented architecture
- **Monorepo:** Multiple projects in one repository
- **Docker:** Container-focused project structure

**Permission Levels:**
- **Strict:** High-security permissions (750/640)
- **Standard:** Balanced permissions (755/644)
- **Permissive:** Development-friendly permissions (775/664)

**Manual Trigger Parameters:**
- `operation` - Type of operation to perform
- `directory_template` - Template to use
- `permission_level` - Security level to apply
- `custom_directories` - Additional directories to create
- `dry_run` - Preview mode

### 5. Container File Update and Management  
**File:** `.github/workflows/container-file-update.yml`

Container security enhancement and modernization.

**Update Types:**
- `dockerfiles` - Dockerfile security updates
- `compose-files` - Docker Compose enhancements
- `kubernetes-manifests` - K8s security contexts
- `helm-charts` - Helm chart updates
- `all-containers` - Comprehensive updates

**Security Enhancements:**
- Multi-stage builds for reduced attack surface
- Non-root user execution
- Read-only root filesystem
- Health checks and monitoring
- Resource limits and security contexts

## 🔧 Usage Instructions

### Quick Start

1. **Run Full Automation** (Recommended)
   ```
   Go to Actions → Dependabot Enhanced Operations → Run workflow
   Select "full-automation" mode
   ```

2. **Docker-Focused Operations**
   ```
   Go to Actions → Dependabot Enhanced Operations → Run workflow
   Select "docker-focus" mode
   Choose your container registry
   ```

3. **Directory Setup Only**
   ```
   Go to Actions → Bulk Directory and Permission Management → Run workflow
   Select your template (docker, microservices, etc.)
   Choose permission level
   ```

### Advanced Configuration

#### Custom Directory Templates
Add your own directory structures by editing:
`.github/bulk-ops/configs/directory-templates.yml`

#### Permission Customization
Modify permission levels in:
`.github/bulk-ops/configs/permission-templates.yml`

#### Dependabot Settings
Enhance Dependabot behavior in:
`.github/dependabot.yml`

### Manual Operations

#### Run Docker Analysis
```bash
# From repository root
python docker-info/generate-inventory.sh docker.io "*" true
```

#### Create Directory Structure
```bash
# From repository root  
python .github/bulk-ops/scripts/bulk-operations.py bulk-setup --template docker
```

#### Security Scan
```bash
# From repository root
python security-analysis/tools/security-scanner.py
```

## 📊 Reports and Monitoring

### Automated Reports
- **Daily:** Docker image and vulnerability reports
- **Weekly:** Comprehensive security analysis
- **On-demand:** Manual workflow execution reports

### Report Locations
- `docker-info/reports/` - Docker analysis reports
- `container-management/reports/` - Container update reports
- `security-analysis/reports/` - Security scan results
- `.github/bulk-ops/logs/` - Operation logs

### GitHub Integration
- **Issues:** Automatic creation for critical vulnerabilities
- **Pull Requests:** Container update PRs with security enhancements
- **Security Alerts:** Integration with GitHub security features
- **Notifications:** Slack/Discord integration support

## 🔒 Security Features

### Container Security
- ✅ Non-root user execution
- ✅ Read-only root filesystem  
- ✅ Security contexts and capabilities
- ✅ Health checks and monitoring
- ✅ Resource limits and constraints
- ✅ Multi-stage builds

### Dependency Security  
- ✅ Daily vulnerability scanning
- ✅ Automated security updates
- ✅ Multi-ecosystem monitoring
- ✅ Dependency integrity verification

### Infrastructure Security
- ✅ Proper file permissions
- ✅ Secret management
- ✅ Access control (CODEOWNERS)
- ✅ Audit trails and logging

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Test your changes with dry-run mode
4. Submit a pull request
5. Automated workflows will validate changes

### Testing
```bash
# Test directory operations
python .github/bulk-ops/scripts/bulk-operations.py --dry-run bulk-setup

# Test container analysis  
python container-management/tools/container-analyzer.py --output test-analysis.json

# Test security scanning
python security-analysis/tools/security-scanner.py
```

## 📚 Documentation

### Generated Documentation
- Operation reports in respective `/reports/` directories
- Security analysis summaries
- Best practices guides
- Template usage examples

### External Resources
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [Kubernetes Security Contexts](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Troubleshooting
1. **Workflow Failures:** Check Actions logs for detailed error messages
2. **Permission Issues:** Verify GitHub token permissions
3. **Container Errors:** Review Docker and container configurations
4. **Security Alerts:** Check security analysis reports

### Getting Help
- **Issues:** Create GitHub issues for bugs and feature requests
- **Discussions:** Use GitHub Discussions for questions
- **Security:** Report security issues privately

---

## 🎉 **Implementation Complete!**

This repository now provides enterprise-grade dependency and container management with:

- ✅ **Enhanced Dependabot** with multi-ecosystem support
- ✅ **Docker image management** with automated updates
- ✅ **Bulk directory operations** with template support
- ✅ **Permission management** with security levels
- ✅ **Container security** enhancements and scanning
- ✅ **Comprehensive automation** workflows
- ✅ **Security monitoring** and reporting

All requested Korean features have been implemented and are ready for use! 🚀
