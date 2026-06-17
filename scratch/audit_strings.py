import os
import re

def audit_strings():
    print("Auditing UI labels for hardcoded text...")
    label_pattern = re.compile(r'text = "([^"]+)"')
    
    # Audit TSCN files in src/ui
    for root, _, files in os.walk("src/ui"):
        for file in files:
            if file.endswith(".tscn"):
                path = os.path.join(root, file)
                print(f"\nUI File: {path}")
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    matches = label_pattern.findall(content)
                    for match in matches:
                        # Skip short symbols or numbers
                        if len(match) > 1 and not match.startswith("res://"):
                            print(f"  - Hardcoded Label: \"{match}\"")

    # Audit GDScript files for user facing strings (simplified regex)
    string_pattern = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
    print("\nAuditing GDScript files for raw strings in src/ui...")
    for root, _, files in os.walk("src/ui"):
        for file in files:
            if file.endswith(".gd"):
                path = os.path.join(root, file)
                print(f"\nScript File: {path}")
                with open(path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    for idx, line in enumerate(lines):
                        # Simple check for print, text =, etc.
                        if "tr(" in line:
                            continue
                        matches = string_pattern.findall(line)
                        for match in matches:
                            if len(match) > 3 and not match.endswith(".gd") and not match.endswith(".tscn") and not match.startswith("res://") and not match.startswith("SaveManager") and not match.startswith("AudioManager"):
                                # If it's a UI assignment or warning, print it
                                if any(x in line for x in ["text =", "print(", "warn(", "log(", "error("]):
                                    print(f"  - L{idx+1}: {line.strip()} (String: \"{match}\")")

if __name__ == "__main__":
    audit_strings()
