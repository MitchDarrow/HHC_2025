---
layout: default
title: act1_visual-networking_srt
nav: |-
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
<th>Objective: Visual Networking Thinger</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Skate over to Jared at the frozen pond for some network magic and learn the ropes by the hockey rink.</td>
<td>Location: Frozen Pond</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
This is an interactive visualization serving as a basic introduction to networking concepts.
<br>
The challenge goes through the building blocks of the HTTP/S request process, starting with a DNS request to resolve the hostname's IP address. Users then construct an HTTP request, a TCP three-way handshake, a TLS certificate exchange, and finally an HTTPS request.
<br>
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
<td>DNS Lookup</td>
<td>Reconnaissance</td>
<td>T1590.002</td>
<td>Gather Network Information: DNS</td>
</tr>
<tr>
<td>TCP 3-Way Handshake</td>
<td>Discovery</td>
<td>T1046</td>
<td>Network Service Discovery</td>
</tr>
<tr>
<td>HTTP GET Request</td>
<td>Command and Control</td>
<td>T1071.001</td>
<td>Application Layer Protocol: Web Protocols</td>
</tr>
<tr>
<td>TLS Handshake</td>
<td>Command and Control</td>
<td>T1573.001</td>
<td>Encrypted Channel: Symmetric Cryptography</td>
</tr>
<tr>
<td>HTTPS GET Request</td>
<td>Command and Control</td>
<td>T1071.001</td>
<td>Application Layer Protocol: Web Protocols</td>
</tr>
</tbody>
</table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>
Jared gives us a challenge that provides a visual walkthrough for several steps in the web request and response process. 
<br></p>
We begin by constructing a DNS request for the <strong>A record</strong> associated with the domain <strong><code>visual-networking.holidayhackchallenge.com via port</code></strong> <strong>53</strong>. We receive a response giving us the IP <strong>34.160.145.134</strong>. 
<p>
<br>
With the IP address of the web server in hand, we are then prompted to complete a TCP 3-way handshake. We arrange our well-known <strong>SYN-ACKSYN-ACK</strong> sequence to proceed to the next step. 
<br>
To construct a valid HTTP request, we must select the following:
<br>
</p>
<ul>
<li>HTTP Verb</li>
<li>HTTP Version</li>
<li>Host</li>
<li>User-Agent</li>
</ul>
<br>
By making a <strong>GET</strong> request to the <strong><code>visual-networking.holidayhackchallenge.com</code></strong> host with <strong>HTTP/1.1</strong> and a user agent of <strong>Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7</strong> (this can vary so long as it's a valid user agent string), we receive a 302 response redirecting us to upgrade our connection to HTTPS.
<p>
<br>
Completing the TLS Handshake requires us to send a <strong>client hello</strong> followed by a <strong>server hello</strong> and the sending of the <strong>server's  certificate</strong>. The client then initiates the <strong>client key exchange</strong>, whereupon the server responds with the <strong>server change cipher spec</strong> step. The exchange is then declared <strong>finished</strong> by the server. 
<br>
<br>
We must then construct an HTTPS <strong>GET</strong> request with HTTPS version <strong>HTTP/2</strong>. Our host and user agent remain unchanged. Sending this HTTPS request yields a <code>200 OK</code> response. 
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
<td>Visual Networking Thinger</td>
<td>1.0</td>
</tr>
</tbody>
</table>
