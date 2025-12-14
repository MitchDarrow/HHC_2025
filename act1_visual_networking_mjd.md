---
layout: default
title: act1_visual_networking_mjd
---
<table>
<thead>
<tr>
<th><a href="/HHC_2025/act1+santas_gift-tracking_service_port_mystery_mjd.html">Previous Objective: Act1 Santa’s Gift-Tracking Service Port Mystery</a></th>
<br>
<th><a href="/HHC_2025/index.html">Table of Contents</a></th>
<br>
<th><a href="/HHC_2025/act1_visual_firewall_mjd.html">Next Objective: Act1 Visual Firewall</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

<table>
<thead>
<tr>
<th>Objective: Visual Neworking</th>
<br>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Skate over to Jared at the frozen pond for some network magic and learn the ropes by the hockey rink</td>
<br>
<td>Location: The Pond</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

This objective is designed to test knowledge of networking communications. This knowledge is useful when analyzing network traffic.

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
<td>Monitor network traffic flows and protocols</td>
<br>
<td>Discovery</td>
<br>
<td>T1049</td>
<br>
<td>System Network Connections Discovery</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

<ol>
<li>Build an IPv4 DNS Request:</li>
</ol>

Port: 53

Domain: visual-networking.holidayhackchallenge.com

Request Type: A

<ol>
<li>Build a 3-Way Handshake:</li>
</ol>

Client sends a packet with the TCP SYN flag set to the server.

The Server response with a packet with the TCP ACK and SYN flags set to the client.

The client responds with a packed with the TCP ACK flag to the server, completing the handshake.

<ol>
<li>Build an HTTP GET request:</li>
</ol>

HTTP verb: GET

HTTP Version: HTTP/1.1

Host: visual-networking.holidayhackchallenge.com

User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0

<ol>
<li>Build a TLS Handshake:</li>
</ol>

Client Hello >>

<< Server Hello

<< Server Certificate

Client Key Exchange >>

<< Server Change Cipher Spec

<< Fnished

<ol>
<li>Build an HTTPS GET request:</li>
</ol>

HTTP verb: GET

HTTP Version: HTTP/1.1

Host: visual-networking.holidayhackchallenge.com

User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0

<strong>Answer: Complete all 5 Challenges</strong>

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
<td>none</td>
<br>
<td>none</td>
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
<td>This terminal has built-in hints!</td>
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

<table>
<thead>
<tr>
<th><a href="/HHC_2025/act1+santas_gift-tracking_service_port_mystery_mjd.html">Previous Objective: Act1 Santa’s Gift-Tracking Service Port Mystery</a></th>
<br>
<th><a href="/HHC_2025/index.html">Table of Contents</a></th>
<br>
<th><a href="/HHC_2025/act1_visual_firewall_mjd.html">Next Objective: Act1 Visual Firewall</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>
