#!/usr/bin/env python3
"""
Bulk Directory and Permission Management Script
"""

import os
import sys
import json
import yaml
import stat
from pathlib import Path
from datetime import datetime
import argparse
import logging

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('.github/bulk-ops/logs/operations.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class BulkOperationsManager:
    def __init__(self, dry_run=False):
        self.dry_run = dry_run
        self.base_path = Path.cwd()
        self.config_path = Path('.github/bulk-ops/configs')
        self.operation_log = []
        
    def load_template_config(self):
        """Load directory templates configuration"""
        config_file = self.config_path / 'directory-templates.yml'
        try:
            with open(config_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            logger.error(f"Template config not found: {config_file}")
            return {}
            
    def load_permission_config(self):
        """Load permission templates configuration"""
        config_file = self.config_path / 'permission-templates.yml'
        try:
            with open(config_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            logger.error(f"Permission config not found: {config_file}")
            return {}
            
    def create_directories(self, template_name, custom_dirs=None):
        """Create directories based on template"""
        templates = self.load_template_config()
        
        if template_name not in templates.get('templates', {}):
            logger.error(f"Template '{template_name}' not found")
            return False
            
        template = templates['templates'][template_name]
        directories = template.get('directories', [])
        
        if custom_dirs:
            directories.extend(custom_dirs.split(','))
            
        logger.info(f"Creating directories for template: {template_name}")
        
        created_dirs = []
        for directory in directories:
            dir_path = self.base_path / directory.strip()
            
            if self.dry_run:
                logger.info(f"[DRY RUN] Would create directory: {dir_path}")
                created_dirs.append(str(dir_path))
            else:
                try:
                    dir_path.mkdir(parents=True, exist_ok=True)
                    logger.info(f"Created directory: {dir_path}")
                    created_dirs.append(str(dir_path))
                    
                    # Create .gitkeep file for empty directories
                    gitkeep_file = dir_path / '.gitkeep'
                    if not any(dir_path.iterdir()):
                        gitkeep_file.touch()
                        
                except Exception as e:
                    logger.error(f"Failed to create directory {dir_path}: {e}")
                    
        self.operation_log.append({
            'operation': 'create_directories',
            'template': template_name,
            'created': created_dirs,
            'timestamp': datetime.now().isoformat()
        })
        
        return True
        
    def apply_permissions(self, permission_level, target_dirs=None):
        """Apply permissions based on permission level"""
        permissions = self.load_permission_config()
        
        if permission_level not in permissions.get('permission_levels', {}):
            logger.error(f"Permission level '{permission_level}' not found")
            return False
            
        perm_config = permissions['permission_levels'][permission_level]
        file_patterns = permissions.get('file_patterns', {})
        
        logger.info(f"Applying permissions with level: {permission_level}")
        
        if target_dirs is None:
            target_dirs = ['.']
            
        for target_dir in target_dirs:
            self._apply_permissions_recursive(
                Path(target_dir), perm_config, file_patterns
            )
            
        self.operation_log.append({
            'operation': 'apply_permissions',
            'permission_level': permission_level,
            'target_dirs': target_dirs,
            'timestamp': datetime.now().isoformat()
        })
        
        return True
        
    def _apply_permissions_recursive(self, path, perm_config, file_patterns):
        """Recursively apply permissions to files and directories"""
        if not path.exists():
            return
            
        for item in path.rglob('*'):
            if item.is_dir():
                perm = perm_config.get('default_dir', '755')
            else:
                perm = self._get_file_permission(item, perm_config, file_patterns)
                
            if self.dry_run:
                logger.info(f"[DRY RUN] Would set permission {perm} on: {item}")
            else:
                try:
                    item.chmod(int(perm, 8))
                    logger.debug(f"Set permission {perm} on: {item}")
                except Exception as e:
                    logger.error(f"Failed to set permission on {item}: {e}")
                    
    def _get_file_permission(self, file_path, perm_config, file_patterns):
        """Determine appropriate permission for a file based on patterns"""
        file_str = str(file_path)
        
        # Check each pattern type
        for pattern_type, patterns in file_patterns.items():
            for pattern in patterns:
                if file_str.endswith(pattern.replace('*', '')) or \
                   pattern.replace('*', '') in file_str:
                    return perm_config.get(pattern_type, perm_config['default_file'])
                    
        return perm_config['default_file']
        
    def create_permission_files(self):
        """Create permission-related files (.gitattributes, .gitignore, etc.)"""
        logger.info("Creating permission and configuration files")
        
        # Create .gitattributes for line endings and file handling
        gitattributes_content = """
# Auto detect text files and perform LF normalization
* text=auto

# Shell scripts should always use LF
*.sh text eol=lf
*.bash text eol=lf

# Windows scripts should use CRLF
*.bat text eol=crlf
*.cmd text eol=crlf
*.ps1 text eol=crlf

# Binary files
*.jar binary
*.war binary
*.ear binary
*.zip binary
*.tar.gz binary
*.tgz binary

# Images
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.svg text

# Fonts
*.woff binary
*.woff2 binary
*.eot binary
*.ttf binary
*.otf binary

# Documents
*.pdf binary
*.doc binary
*.docx binary
"""

        # Enhanced .gitignore
        gitignore_additions = """

# Bulk Operations
.github/bulk-ops/logs/*.log
.github/bulk-ops/temp/*
!.github/bulk-ops/temp/.gitkeep

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.temp
*.cache

# Log files
*.log
logs/

# Security files
*.key
*.pem
*.p12
*.jks
.env
.env.local
.env.*.local
"""

        if not self.dry_run:
            # Write .gitattributes
            with open('.gitattributes', 'w') as f:
                f.write(gitattributes_content.strip())
            logger.info("Created .gitattributes file")
            
            # Append to .gitignore
            with open('.gitignore', 'a') as f:
                f.write(gitignore_additions)
            logger.info("Updated .gitignore file")
            
            # Create CODEOWNERS file
            codeowners_content = """
# Global owners
* @davidkims

# Docker files
Dockerfile* @davidkims
docker-compose*.yml @davidkims
.dockerignore @davidkims

# GitHub workflows
.github/ @davidkims

# Security files
*.key @davidkims
*.pem @davidkims
.env* @davidkims
"""
            
            with open('.github/CODEOWNERS', 'w') as f:
                f.write(codeowners_content.strip())
            logger.info("Created .github/CODEOWNERS file")
        else:
            logger.info("[DRY RUN] Would create .gitattributes, update .gitignore, and create CODEOWNERS")
            
        self.operation_log.append({
            'operation': 'create_permission_files',
            'files': ['.gitattributes', '.gitignore', '.github/CODEOWNERS'],
            'timestamp': datetime.now().isoformat()
        })
        
    def save_operation_log(self):
        """Save operation log to file"""
        log_file = Path('.github/bulk-ops/logs/operation-log.json')
        log_file.parent.mkdir(parents=True, exist_ok=True)
        
        if not self.dry_run:
            with open(log_file, 'w') as f:
                json.dump(self.operation_log, f, indent=2)
            logger.info(f"Operation log saved to: {log_file}")
        else:
            logger.info(f"[DRY RUN] Would save operation log to: {log_file}")

def main():
    parser = argparse.ArgumentParser(description='Bulk Directory and Permission Management')
    parser.add_argument('operation', choices=['create-directories', 'create-permission-files', 'update-permissions', 'bulk-setup'])
    parser.add_argument('--template', default='standard', help='Directory template')
    parser.add_argument('--permission-level', default='standard', help='Permission level')
    parser.add_argument('--custom-dirs', help='Custom directories (comma-separated)')
    parser.add_argument('--dry-run', action='store_true', help='Dry run mode')
    
    args = parser.parse_args()
    
    manager = BulkOperationsManager(dry_run=args.dry_run)
    
    if args.operation == 'create-directories':
        manager.create_directories(args.template, args.custom_dirs)
    elif args.operation == 'create-permission-files':
        manager.create_permission_files()
    elif args.operation == 'update-permissions':
        manager.apply_permissions(args.permission_level)
    elif args.operation == 'bulk-setup':
        # Perform all operations
        manager.create_directories(args.template, args.custom_dirs)
        manager.apply_permissions(args.permission_level)
        manager.create_permission_files()
        
    manager.save_operation_log()
    logger.info("Bulk operations completed successfully")

if __name__ == '__main__':
    main()
