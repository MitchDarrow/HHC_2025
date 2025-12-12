---
nav: |
  <table>
  <thead><tr><th><a href="/act1_neighborhood_watch_bypass_mjd.html">Previous Objective: Act 1 Neighborhood Watch Bypass</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act1_visual_networking_mjd.html">Previous Objective: Act 1 Visual Networking</a></th></table>
  
---

<table>
<thead><tr><th>Objective: Santa's Gift-Tracking Service Port</th> <th>Difficulty Level: 1</th><tr><td>Chat with Yori near the apartment building about Santa's mysterious gift tracker and unravel the holiday mystery.</td> <td>Location: Apratment Building</td></table>


## Solution Overview

This objective is a network service discovery and verification task focused on identifying and confirming the operational status of a process. The investigator used the ss (socket statistics) command-line utility, which is part of the iproute2 package, to enumerate active network connections and listening ports on the local system. The specific command ss -tlnp was executed with flags to show TCP connections (-t), listening sockets (-l), numeric addresses without DNS resolution (-n), and associated process information (-p). The output revealed a service actively listening on port 12321, which was identified as the Santa Tracker process. To verify the service was functioning properly, the investigator used curl with the -I flag to send an HTTP HEAD request to the local address at http://0.0.0.0:12321. The service responded successfully with an HTTP 200 OK status code and indicated a Content-Type header of application/json, confirming the service was running and responding to requests. 

<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Execute ss -tlnp command to enumerate network connections</td> <td>Discovery</td> <td>T1049</td> <td>System Network Connections Discovery</td><tr><td>Use curl to send HTTP HEAD request to identified port</td> <td>Discovery</td> <td>T1046</td> <td>Network Service Discovery</td></table>


## Detailed Solution
<details>
<summary>Click to expand</summary>
<p>The objective is to:</p>
<p>1. Identify the port that the santa_tracker process is running on</p>
<p>2. Connecct to the port and verify the servide is running</p>
<p>!<a href="/images/santatracking_instructions.jpg">Objective Instructions</a> </p>
<p>Use the SS tool to discover the port using the command:</p>
<p><pre><code></p>
<p></code></pre></p>
<p>There is a service running on port 12321</p>
<p>Use curl to connect:</p>
<p>!<a href="/images/santatracker_connect.jpg">Sample image alt text</a> </p>
<p><pre><code></p>
<p></code></pre></p>
<p>The service responds with a 200 OK and Content-Type of application/json</p>
<p><strong>Answer: The service is running</strong></p>
</details>

## Tools Reference

<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>ss</td> <td>iproute2-6.13.0</td> <td></td><tr><td>curl</td> <td>8.11.0</td></table>



## Hints Reference
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Since we don't have a web browser to connect to this HTTP service...There is another common tool that you can use from the cli.</td><tr><td>Yuri</td> <td>Think you can check out this terminal for me? I need to use cURL to access the gift tracker system, but it has me stumped.</td></table>



## Acknowledgements
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>



<table>
<thead><tr><th><a href="/act1_neighborhood_watch_bypass_mjd.html">Previous Objective: Act 1 Neighborhood Watch Bypass</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act1_visual_networking_mjd.html">Previous Objective: Act 1 Visual Networking</a></th></table>







