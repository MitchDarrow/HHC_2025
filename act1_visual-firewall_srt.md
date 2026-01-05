---
layout: default
title: act1_blob_storage_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_intro_to_nmap_mjd.html">Previous Objective: Act1 Intro to Nmap</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_spare_key_mjd.html">Next Objective: Act1 Spare Key</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Visual Firewall Thinger</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Find Elgee in the big hotel for a firewall frolic and some techy fun.</td>
<td>Location: Hotel</td>
</tr>
</tbody>
</table>
<p>
<br>
<h2>Solution Overview</h2>
<br>
Chris provides us a basic firewall exercise where we must allow specified ports for each connection point based on stated firewall configuration goals. 
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
<td>Modify Firewall Rules</td>
<td>Defense Evasion</td>
<td>T1562.004</td>
<td>Impair Defenses: Disable or Modify System Firewall</td>
</tr>
<tr>
<td>Enable Port Access</td>
<td>Persistence</td>
<td>T1133</td>
<td>External Remote Services</td>
</tr>
</tbody>
</table>
<p>
<br>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<summary>Click to expand</summary>
<p>
<br>
<br>
Dropping into the Visual Firewall Thinger tool, we are given six configuration goals that detail specific connections that must be allowed between five different connection points. 
<br>
<br>
Our six configuration goals are:
<br>
<br>
</p>
<ol>
<li>Allow only HTTP and HTTPS from Internet to DMZ</li>
<li>Allow HTTP, HTTPS, and SSH from DMZ to Internal Network</li>
<li>Allow HTTP, HTTPS, and SSH from Internal Network to DMZ</li>
<li>Allow HTTP, HTTPS, SSH, and SMTP from Internal Network to Cloud Network</li>
<li>Allow all traffic from Internal Network to Workstations</li>
<li>Block direct traffic from Internet to Internal Network</li>
</ol>
<p>
<br>
Our five connection points, as you may surmise from the above, are:
<br>
</p>
<ul>
<li>Internet</li>
<li>DMZ</li>
<li>Internal Network</li>
<li>Cloud Services</li>
<li>Workstations</li>
</ul>
<p>
<br>
<br>
Using the GUI provided by the tool, we are able to configure the connections as indicated by the stated configuration goals. The following relevant ports and services are used:
<br>
<br>
</p>
<ul>
<li>Port 22 - SSH</li>
<li>Port 25 - SMTP</li>
<li>Port 53 - DNS</li>
<li>Port 80 - HTTP</li>
<li>Port 443 - HTTPS</li>
<li>Port 445 - SMB</li>
</ul>
</details>
<br>
<br>
<h2>Tools Reference</h2>
<br>
<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>Visual Firewall Thinger</td>
<td>1.0</td>
</tr>
</tbody>
</table>