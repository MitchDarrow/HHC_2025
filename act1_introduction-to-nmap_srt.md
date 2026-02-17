---
layout: default
title: act1_introduction-to-nmap_srt
nav: |
  <table>
  <thead>
  <tr>
  <th></th>
  <th><a href="/HHC_2025/allwriteups.html">All Writeups Index</a></th>
  <th></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table class="quest-table">
<thead>
<tr>
<th>Objective: Intro to Nmap</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Meet Eric in the hotel parking lot for Nmap know-how and scanning secrets. Help him connect to the wardriving rig on his motorcycle!</td>
<td>Location: Hotel Parking Lot</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
</p>
<br>
Eric Pursley provides an NMAP introduction requiring us to use nmap to discover and connect to the wardriving rig on his motorcycle. We first scan a single IP, then all ports on a single IP, all ports on an IP range. We run a service scan on a discovered port, then use <code>nc [IP][PORT]</code> to connect to the service and grab its banner.  
<table class="quest-table">
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
<td>Port Scanning and Service Enumeration</td>
<td>Discovery</td>
<td>T1046</td>
<td>Network Service Discovery</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
</details>
<h2>Tools Reference</h2>
<table class="quest-table">
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>nmap</td>
<td>7.98</td>
</tr>
<tr>
<td>GNU netcat</td>
<td>0.7.1</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
</p>
<table class="quest-table">
<thead>
<tr>
<th>Provided By</th>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr><td>Santa</td><td>This terminal has built-in hints!</td></tr>
<tr><td>Eric</td><td>Speaking of tools, let me introduce you to one of the most essential weapons in any pentester's arsenal: Nmap. It's like having X-ray vision for networks, and I've set up a perfect environment for you to learn the fundamentals. Help me find and connect to the wardriving rig's service on my motorcycle!</td></tr>  
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
</p>
<table class="quest-table">
<thead>
<tr>
<th>Provided By</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr><td>none</td><td>none</td></tr>
</tbody>
</table>
