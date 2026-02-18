---
layout: default
title: act1_santas-gift-tracking_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_neighborhood_watch_bypass_mjd.html">Next Objective: Act1 Neighborhood Watch Bypass</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_visual_networking_mjd.html">Previous Objective: Act1 Visual Networking</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table class="quest-table">
<thead>
<tr>
<th>Objective: Santa's Gift-Tracking Service Port Mystery</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Chat with Yori near the apartment building about Santa's mysterious gift tracker and unravel the holiday mystery.</td>
<td>Location: Outside the Apartment Building</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
Yori is located in front of Modern Scandinavia with the Santa's Gift-Tracking Machine. Yori tells us that we need to use curl to access the gift tracker system and identify which port the <code>santa_tracker</code> process is running on after the gnomes meddled with the app and changed its port from <code>8080</code> to an unknown value. 
We use the <code>ss -tlnp</code> command, analagous to a <code>netstat</code> command, and identify port <code>12321</code> on the localhost showing activity. <code>curl 127.0.0.1:12321</code> successfully connects to the service.
</p>
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
<td>Enumerate Listening Ports</td>
<td>Discovery</td>
<td>T1049</td>
<td>System Network Connections Discovery</td>
</tr>
<tr>
<td>Identify Process Owner</td>
<td>Discovery</td>
<td>T1057</td>
<td>Process Discovery</td>
</tr>
<tr>
<td>Connect to Service</td>
<td>Command and Control</td>
<td>T1071.001</td>
<td>Application Layer Protocol</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
Utilizing <code>ss -tlnp</code> as indicated in the terminal introductory text, we identify the open port <code>12321</code> listening on <code>0.0.0.0</code>. Since <code>0.0.0.0</code> exposes the service to external connections on all network interfaces, a simple <code>curl 127.0.0.1:12321</code> successfully connects to the gift-tracking service to complete the challenge. 
</p>
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
<td>curl</td>
<td>8.17.0</td>
</tr>
<tr>
<td>ss (included as part of the iproute2 package)</td>
<td>6.18.0</td>
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
<tr>
<td>Santa</td>
<td>Since we don't have a web browser to connect to this HTTP service...There is another common tool that you can use from the cli.</td>
</tr>
<tr>
<td>Yuri</td>
<td>Think you can check out this terminal for me? I need to use cURL to access the gift tracker system, but it has me stumped.</td>
</tr>
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
<tr>
<td>none</td>
<td>none</td>
</tr>
</tbody>
</table>
