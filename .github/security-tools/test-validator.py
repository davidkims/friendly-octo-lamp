#!/usr/bin/env python3
import os, yaml, sys
from pathlib import Path
print('🛡️ Security validation script test')
workflows_dir = Path('.github/workflows')
if workflows_dir.exists():
    workflow_files = list(workflows_dir.glob('*.yml')) + list(workflows_dir.glob('*.yaml'))
    print(f'Found {len(workflow_files)} workflow files')
    for f in workflow_files:
        try:
            with open(f) as file:
                yaml.safe_load(file)
            print(f'✅ {f.name}: Valid YAML')
        except Exception as e:
            print(f'❌ {f.name}: {e}')
else:
    print('No workflows directory found')
print('✅ Validation test completed')
