import os
import re
import sys

def check_resources(root_dir):
    tscn_pattern = re.compile(r'path="res://([^"]+)"')
    missing_assets = []
    checked_files = 0
    missing_count = 0

    abs_root = os.path.abspath(root_dir)
    print(f"Auditing resources in: {abs_root}")

    for root, dirs, files in os.walk(abs_root):
        # Filter out dot directories and build/addons directories
        dirs[:] = [d for d in dirs if not d.startswith('.')]
        parts = root.split(os.sep)
        if 'addons' in parts or 'android' in parts or 'build' in parts:
            continue
            
        for file in files:
            if file.endswith(('.tscn', '.tres', '.gd')):
                filepath = os.path.join(root, file)
                checked_files += 1
                try:
                    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        
                        # Find all res:// references
                        for match in tscn_pattern.finditer(content):
                            rel_path = match.group(1)
                            full_path = os.path.join(abs_root, rel_path)
                            if not os.path.exists(full_path):
                                missing_assets.append({
                                    "file": filepath,
                                    "ref": f"res://{rel_path}"
                                })
                                missing_count += 1
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")

    print(f"Checked {checked_files} files.")
    if missing_count > 0:
        print(f"Found {missing_count} missing resource references:")
        for missing in missing_assets:
            print(f"- In {missing['file']}: references {missing['ref']}")
        sys.exit(1)
    else:
        print("No missing resource references found! All assets and scripts are correctly linked.")
        sys.exit(0)

if __name__ == "__main__":
    check_resources(".")
