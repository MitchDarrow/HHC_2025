---
layout: default
title: act1_santas_gift-tracking_service_port_mystery_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th>[Previous Objective: Act 1 Neighborhood Watch Bypass](/act1_neighborhood_watch_bypass_mjd.md)</th>
  <th>[Table of Contents](/index.md)</th>
  <th>[Previous Objective: Act 1 Visual Networking](/act1_visual_networking_mjd.md)</th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Santa's Gift-Tracking Service Port</th>
<br>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Chat with Yori near the apartment building about Santa's mysterious gift tracker and unravel the holiday mystery.</td>
<br>
<td>Location: Apratment Building</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

This objective is a network service discovery and verification task focused on identifying and confirming the operational status of a process. The investigator used the ss (socket statistics) command-line utility, which is part of the iproute2 package, to enumerate active network connections and listening ports on the local system. The specific command ss -tlnp was executed with flags to show TCP connections (-t), listening sockets (-l), numeric addresses without DNS resolution (-n), and associated process information (-p). The output revealed a service actively listening on port 12321, which was identified as the Santa Tracker process. To verify the service was functioning properly, the investigator used curl with the -I flag to send an HTTP HEAD request to the local address at http://0.0.0.0:12321. The service responded successfully with an HTTP 200 OK status code and indicated a Content-Type header of application/json, confirming the service was running and responding to requests.

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
<td>Execute ss -tlnp command to enumerate network connections</td>
<br>
<td>Discovery</td>
<br>
<td>T1049</td>
<br>
<td>System Network Connections Discovery</td>
</tr>
<tr>
<td>Use curl to send HTTP HEAD request to identified port</td>
<br>
<td>Discovery</td>
<br>
<td>T1046</td>
<br>
<td>Network Service Discovery</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

The objective is to:

<ol>
<li>Identify the port that the santa_tracker process is running on</li>
</ol>

<ol>
<li>Connecct to the port and verify the servide is running</li>
</ol>

<img src="/HHC_2025/images/santatracking_instructions.jpg" alt="Objective Instructions">

Use the SS tool to discover the port using the command:
<br>
<pre><code class="language-sh">
<br>
ss -tlnp
<br>
</code></pre>

There is a service running on port 12321

Use curl to connect:

<img src="/HHC_2025/images/santatracker_connect.jpg" alt="Sample image alt text">

<pre><code class="language-sh">
<br>
curl -I http://0.0.0.0:12321
<br>
</code></pre>
<br>
The service responds with a 200 OK and Content-Type of application/json

<strong>Answer: The service is running</strong>

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
<td>ss</td>
<br>
<td>iproute2-6.13.0</td>
</tr>
<tr>
<td>curl</td>
<br>
<td>8.11.0</td>
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
<td>Since we don't have a web browser to connect to this HTTP service...There is another common tool that you can use from the cli.</td>
</tr>
<tr>
<td>Yuri</td>
<br>
<td>Think you can check out this terminal for me? I need to use cURL to access the gift tracker system, but it has me stumped.</td>
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
<td>none</td>
<br>
<td>none</td>
</tr>
</tbody>
</table>