---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act1_visual_firewall_mjd.html">Previous Objective: Act1 Visual Firewall</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act1_blob_storage_mjd.html">Next Objective: Act1 Blob Storage Challenge</a></th></table>
---
<table>
<thead><tr><th>Objective: Intro to NMAP</th> <th>Difficulty Level: 1</th><tr><td>Meet Eric in the hotel parking lot for Nmap know-how and scanning secrets. Help him connect to the wardriving rig on his motorcycle!</td> <td>Location: Grand Hotel parking lot</td></table>
<h2>Solution Overview</h2>
This objective is designed to test fundamental knowledge of the Nmap tool. Nmap is an essential tool in the penetration testers toolkit, used to discover open ports and services.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Scan network targets</td> <td>Discovery</td> <td>T1046</td> <td>Network Service Discovery</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>1. Run the following command to do a default scan of the top 1000 ports: nmap 127.0.12.25</p>
<p><pre><code></p>
<p></code></pre></p>
<p>Answer: Port 8080</p>
<p>2. Run the following command to do a scan of all ports: nmap 127.0.12.25 -p-</p>
<p><pre><code></p>
<p></code></pre></p>
<p>Answer: Port 24601</p>
<p>3. Run the following command to do a scan of the range 127.0.12.20 - 127.0.12.28 to find an open port: nmap 127.0.12.20-28</p>
<p><pre><code></p>
<p></code></pre></p>
<p>elf@bd65e17d2fa9:~$ nmap -sV -p 8080 127.0.12.25</p>
<p>Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:39 UTC</p>
<p>Nmap scan report for 127.0.12.25</p>
<p>Host is up (0.000091s latency).</p>
<p>PORT     STATE SERVICE VERSION</p>
<p>8080/tcp open  http    SimpleHTTPServer 0.6 (Python 3.10.12)</p>
<p>Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .</p>
<p>Nmap done: 1 IP address (1 host up) scanned in 6.82 seconds</p>
<p><pre><code></p>
<p></code></pre></p>
<p>elf@bd65e17d2fa9:~$ ncat 127.0.12.25 24601</p>
<p>Welcome to the WarDriver 9000!</p>
<p>Terminated</p>
<p><pre><code></p>
<p></code></pre></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>nmap</td> <td>7.80</td> <td></td><tr><td>ncat</td> <td>7.80</td> <td></td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>This terminal has built-in hints!</td></table>
<table>
<thead><tr><th>Eric</th> <th>Speaking of tools, let me introduce you to one of the most essential weapons in any pentester's arsenal: Nmap. It's like having X-ray vision for networks, and I've set up a perfect environment for you to learn the fundamentals. Help me find and connect to the wardriving rig's service on my motorcycle!</th> </tr></thead>
</table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act1_visual_firewall_mjd.html">Previous Objective: Act1 Visual Firewall</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act1_blob_storage_mjd.html">Next Objective: Act1 Blob Storage Challenge</a></th></table>