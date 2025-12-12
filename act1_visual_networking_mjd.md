---
nav: |
  <table>
  <thead><tr><th><a href="/act1+santas_gift-tracking_service_port_mystery_mjd.html">Previous Objective: Act1 Santaâ€™s Gift-Tracking Service Port Mystery</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act1_visual_firewall_mjd.html">Next Objective: Act1 Visual Firewall</a></th></table>
  
---

<table>
<thead><tr><th>Objective: Visual Neworking</th> <th>Difficulty Level: 1</th><tr><td>Skate over to Jared at the frozen pond for some network magic and learn the ropes by the hockey rink</td> <td>Location: The Pond</td></table>


## Solution Overview

This objective is designed to test knowledge of networking communications. This knowledge is useful when analyzing network traffic.

<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Monitor network traffic flows and protocols</td> <td>Discovery</td> <td>T1049</td> <td>System Network Connections Discovery</td></table>


## Detailed Solution
<details>
<summary>Click to expand</summary>
<p>1. Build an IPv4 DNS Request:</p>
<p>Port: 53</p>
<p>Domain: visual-networking.holidayhackchallenge.com</p>
<p>Request Type: A</p>
<p>2. Build a 3-Way Handshake:</p>
<p>Client sends a packet with the TCP SYN flag set to the server.</p>
<p>The Server response with a packet with the TCP ACK and SYN flags set to the client.</p>
<p>The client responds with a packed with the TCP ACK flag to the server, completing the handshake.</p>
<p>3. Build an HTTP GET request:</p>
<p>HTTP verb: GET</p>
<p>HTTP Version: HTTP/1.1</p>
<p>Host: visual-networking.holidayhackchallenge.com</p>
<p>User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0</p>
<p>4. Build a TLS Handshake:</p>
<p>Client Hello >></p>
<p><< Server Hello</p>
<p><< Server Certificate</p>
<p>Client Key Exchange >></p>
<p><< Server Change Cipher Spec</p>
<p><< Fnished</p>
<p>5. Build an HTTPS GET request:</p>
<p>HTTP verb: GET</p>
<p>HTTP Version: HTTP/1.1</p>
<p>Host: visual-networking.holidayhackchallenge.com</p>
<p>User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0</p>
<p><strong>Answer: Complete all 5 Challenges</strong></p>
</details>

## Tools Reference

<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>none</td> <td>none</td> <td></td></table>



## Hints Reference
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>This terminal has built-in hints!</td></table>


## Acknowledgements
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>


<table>
<thead><tr><th><a href="/act1+santas_gift-tracking_service_port_mystery_mjd.html">Previous Objective: Act1 Santaâ€™s Gift-Tracking Service Port Mystery</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act1_visual_firewall_mjd.html">Next Objective: Act1 Visual Firewall</a></th></table>







