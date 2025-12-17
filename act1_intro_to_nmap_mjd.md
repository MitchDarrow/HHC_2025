---
layout: default
title: act1_intro_to_nmap_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_visual_firewall_mjd.html">Previous Objective: Act1 Visual Firewall</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_blob_storage_mjd.html">Next Objective: Act1 Blob Storage Challenge</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Intro to NMAP</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Meet Eric in the hotel parking lot for Nmap know-how and scanning secrets. Help him connect to the wardriving rig on his motorcycle!</td>
<td>Location: Grand Hotel parking lot</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
This objective is designed to test fundamental knowledge of the Nmap tool. Nmap is an essential tool in the penetration testers toolkit, used to discover open ports and services.
<br>
</p>
<table>
<thead>
<tr>
<th>Activity</th>
<th>Primary Tactic</th>
<th>MITRE ATT&CK Technique ID</th>
<th>MITRE ATT&CK Technique Name</th>
</tr>
</thead>
<tbody>
<tr>
<td>Scan network targets</td>
<td>Discovery</td>
<td>T1046</td>
<td>Network Service Discovery</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>

<summary>Click to expand</summary>

</p>
<ol>
<li>Run the following command to do a default scan of the top 1000 ports: nmap 127.0.12.25</li>
</ol>
<pre><code class="language-sh">
elf@bd65e17d2fa9:~$ nmap 127.0.12.25
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:28 UTC
Nmap scan report for 127.0.12.25
Host is up (0.000069s latency).
Not shown: 999 closed ports
PORT     STATE SERVICE
8080/tcp open  http-proxy
Nmap done: 1 IP address (1 host up) scanned in 0.20 seconds
</code></pre>
<p>
Answer: Port 8080
<br>
</p>
<ol>
<li>Run the following command to do a scan of all ports: nmap 127.0.12.25 -p-</li>
</ol>
<pre><code class="language-sh">
elf@bd65e17d2fa9:~$ nmap 127.0.12.25 -p-
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:30 UTC
Nmap scan report for 127.0.12.25
Host is up (0.000046s latency).
Not shown: 65534 closed ports
PORT      STATE SERVICE
24601/tcp open  unknown
Nmap done: 1 IP address (1 host up) scanned in 2.10 seconds
</code></pre>
<p>
Answer: Port 24601
<br>
</p>
<ol>
<li>Run the following command to do a scan of the range 127.0.12.20 - 127.0.12.28 to find an open port: nmap 127.0.12.20-28</li>
</ol>
<pre><code class="language-sh">
elf@bd65e17d2fa9:~$ nmap 127.0.12.20-28
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:34 UTC
Nmap scan report for 127.0.12.20
Host is up (0.00018s latency).
All 1000 scanned ports on 127.0.12.20 are closed
Nmap scan report for 127.0.12.21
Host is up (0.00020s latency).
All 1000 scanned ports on 127.0.12.21 are closed
Nmap scan report for 127.0.12.22
Host is up (0.00018s latency).
All 1000 scanned ports on 127.0.12.22 are closed
Nmap scan report for 127.0.12.23
Host is up (0.00017s latency).
Not shown: 999 closed ports
PORT     STATE SERVICE
8080/tcp open  http-proxy
Nmap scan report for 127.0.12.24
Host is up (0.00017s latency).
All 1000 scanned ports on 127.0.12.24 are closed
Nmap scan report for 127.0.12.25
Host is up (0.00019s latency).
All 1000 scanned ports on 127.0.12.25 are closed
Nmap scan report for 127.0.12.26
Host is up (0.00017s latency).
All 1000 scanned ports on 127.0.12.26 are closed
Nmap scan report for 127.0.12.27
Host is up (0.00016s latency).
All 1000 scanned ports on 127.0.12.27 are closed
Nmap scan report for 127.0.12.28
Host is up (0.00019s latency).
All 1000 scanned ports on 127.0.12.28 are closed
Nmap done: 9 IP addresses (9 hosts up) scanned in 0.44 seconds
``
<ol>
<li>What is the service running on 127.0.12.25 TCP port 8080?  nmap -p 8080 127.0.12.25</li>
</ol>
</code></pre>
<p>
elf@bd65e17d2fa9:~$ nmap -sV -p 8080 127.0.12.25
<br>
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:39 UTC
<br>
Nmap scan report for 127.0.12.25
<br>
Host is up (0.000091s latency).
<br>
</p>
<p>
PORT     STATE SERVICE VERSION
<br>
8080/tcp open  http    SimpleHTTPServer 0.6 (Python 3.10.12)
<br>
</p>
<p>
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
<br>
Nmap done: 1 IP address (1 host up) scanned in 6.82 seconds
<br>
</p>
<pre><code class="language-">
Answer: http
<ol>
<li>Use ncat to connect to TCP port 24601 on 127.0.12.25 and view the banner:  ncat 127.0.12.25 24601</li>
</ol>
</code></pre>
<p>
elf@bd65e17d2fa9:~$ ncat 127.0.12.25 24601
<br>
Welcome to the WarDriver 9000!
<br>
Terminated
<br>
</p>
