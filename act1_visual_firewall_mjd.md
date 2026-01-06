---
layout: default
title: act1_visual_firewall_mjd
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
<table>
<thead>
<tr>
<th>Objective: Visual Firewall</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Find Elgee in the big hotel for a firewall frolic and some techy fun.</td>
<td>Location: Grand Hotel</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
</p>
<p>
The objective is to correctly configure firewall rules to best security practices. Without proper firewall configuration, security analysts lose a crucial control point for preventing, detecting, and responding to threats.
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
<td>Review existing firewall rules and policies</td>
<td>Discovery</td>
<td>T1082</td>
<td>System Information Discovery</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
Rule: Internet to DMZ: Allow only HTTP and HTTPS traffic
<br>
</p>
<p>
Rule: DMZ to Internal: Allow HTTP, HTTPS and SSH traffic
<br>
</p>
<p>
Rule: Internal to DMZ: Allow HTTP, HTTPS and SSH traffic
<br>
</p>
<p>
Rule: Internal to Cloud: Allow HTTP, HTTPS, SSH and SMTP traffic
<br>
</p>
<p>
Rule: Internal to Workstations: Allow all traffic types
<br>
</p>
<p>
Rule: Internet to Internal: Block direct Internet to Internal access
<br>
</p>
<p>
<strong>Answer: Configure rules to Security Best Practice</strong>
<br>
</p>
</details>
<p>
<h2>Tools Reference</h2>
</p>
<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>none</td>
<td>none</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
</p>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<td>This terminal has built-in hints.</td>
</tr>
<tr>
<td>Elgee</td>
<td>Welcome to my little corner of network security! finger guns I've whipped up something sweeter than my favorite whoopie pie - an interactive firewall simulator that'll teach you more in ten minutes than most textbooks do in ten chapters. Don't worry about breaking anything; that's half the fun of learning! Ready to dig in?</td>
</tr>
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
</p>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>none</td>
<td>none</td>
</tr>
</tbody>
</table>
