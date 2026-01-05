---
layout: default
title: act2_dosis-network-down_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_idorable-bistro_srt.html">Previous Objective: Act2 IDORable Bistro</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_rogue-gnome-identity-provider_srt.html">Next Objective: Act2 Rogue Gnome Identity Provider</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Dosis Network Down</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Drop by JJ's 24-7 for a network rescue and help restore the holiday cheer. What is the WiFi password found in the router's config?</td>
<td>Location: JJ's 24-7</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
Janusz tells us that the neighborhood's wifi has been sabotged by the gnomes who have changed the admin password and probably other settings as well. We have to take back what is ours. 
<br>
Inspecting router login page's elements doesn't reveal much, however we are given a banner with hardware and firmware information on the bottom of the page. A quick search reveals an unauthenticated RCE vulnerability (CVE-2023-1389) in this very same platform!
<br>
We can leverage this vulnerability to execute commands on the router. To solve the challenge, the objective states that we have to find the password within the router's config files. We identify a nonstandard <code>/etc/config</code> directory, which contains a text file named <code>wireless</code> containing the password.
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
<td>Identify Firmware Version</td>
<td>Discovery</td>
<td>T1082</td>
<td>System Information DIscovery</td>
</tr>
<tr>
<td>Exploit CVE-2023-1389</td>
<td>Initial Access</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Execute Shell Commands</td>
<td>Execution</td>
<td>T1059.004</td>
<td>Command and Scripting Interpreter: Unix Shell</td>
</tr>
<tr>
<td>Extract Wireless Password</td>
<td>Credential Access</td>
<td>T1552.001</td>
<td>Unsecured Credentials: Credentials in Files</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<summary>Click to expand</summary>
<br>
<p>
The challenge presents us with a local login page to an AX1800 WiFI 6 Router. This presents much like a simple single page web app with minimal content. The console gives us some small nudges along the way, but ultimately our breakthrough comes from observing the text located at the bottom of the login page: <code><strong>Firmware Version: 1.1.4 Build 20230219 rel.69802 Hardware Version: Archer AX21 v2.0</strong></code>.
<br>
Running a search for part or all of this string should direct the user towards CVE-2023-1389, an unauthenticated remote code execution (RCE) vulnerability affecting our target platform. 
<br>
This vulnerability revolves around the <code>write</code> callback function of the <code>country</code> form, located at the <code>/cgi-bin/luci/;stok=/locale</code> endpoint. The <code>country</code> parameter in this form is used in a call to <code>popen()</code> in the backend, which ultimately runs as the root user. <code>POST</code> requests with data in the request body are not vulnerable, while requests with that same data included as request parameters are vulnerable. 
</p>
<pre><code class="language-http">
POST /cgi-bin/luci/;stok=/locale?form=country HTTP/1.1  
Host: [target router]  
Content-Type: application/x-www-form-urlencoded  
operation=write&country=$(id>/tmp/out)
</code></pre>
<ul>
<li>This is the request included in the Tenable alert, which ultimately does not fire</li>
<pre><code class="language-http">
POST /cgi-bin/luci/;stok=/locale?form=country&operation=write&country=$(ls%20/etc/config) HTTP/1.1  
Host: [target router] 
</code></pre>
<li>This request fires</li>
</ul>
<br>
When executing commands, we ultimately have to send each request twice. The first will return a 200 response with a single line reading <code>OK</code>, while the second will return the command output. 
With this as our foothold, we want to remember our objective of identifying login credentials from a configuration file. On most unix systems, the <code>/etc/</code> directory serves as a directory for global or system-level configuration data. We send a series of requests to enumerate <code>/etc/</code> before identifying the <code>/etc/config</code> directory, which is not a part of standard naming conventions. This directory contains the <code>wireless</code> text file, containing the password: <strong><code>SprinklesandPackets2025!</code></strong>. 
The screenshot below displays the contents of the <code>/etc/config/wireless</code> file:
<br>
<img src="/HHC_2025/HHC_2025/images/dosis-network_file-contents.png" alt="Caido Replay /etc/config/wireless"> 
<br>
</details>
<p>
<h2>Tools Reference</h2>
<br>
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
<td>Caido</td>
<td>0.54.1</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
<br>
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
<td>You know ... if my memory serves me correctly .. there was a lot of fuss going on about a UCI (I forgot the exact term ...) for that router.</td>
</tr>
<tr>
<td>Santa</td>
<td>I can't believe nobody created a backup account on our main router ... the only thing I can think of is to check the version number of the router to see if there are any ... ways around it ...</td>
</tr>
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
<br>
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
<td>Mitch Darrow</td>
<td>Mitch helped me to understand the nature of the challenge and he confirmed I was on the right path in solving!</td>
</tr>
</tbody>
</table>
