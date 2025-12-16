---
layout: default
title: act2_mail_detective_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act3_hackagnome_mjd.html">Previous Objective: Act2 Name</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_idorable_bistro_mjd.html">Next Objective: Act 2 IDORable Bistro</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Mail Detective</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Mo in City Hall solve a curly email caper and crack the IMAP case. What is the URL of the pastebin service the gnomes are using?</td>
<td>Location: City Hall</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
This objective investigates suspicious emails using IMAP (Internet Message Access Protocol) commands via curl. The investigator connected to an IMAP server running on localhost port 143 using telnet protocol. Authentication was performed using the credentials "dosismail" with password "holidaymagic". After successful login, the investigator selected the "Spam" mailbox to examine suspicious messages. Multiple search commands were executed to find emails containing HTTP URLs, with the search for "HTTP" (uppercase) returning positive results. The investigator used the IMAP FETCH command to retrieve the full body of message ID 2. Examination of the email body revealed embedded JavaScript code containing a suspicious variable assignment. The JavaScript code contained a URL pointing to "https://frostbin.atnas.mail/api/paste", which appears to be a pastebin-style service potentially used for command and control or data exfiltration. This investigation demonstrates how IMAP protocol commands can be used for email forensics and threat hunting.
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
<td>Connect to IMAP server on localhost port 143 using telnet</td>
<td>Discovery</td>
<td>T1046</td>
<td>Network Service Discovery</td>
</tr>
<tr>
<td>Authenticate to email server using credentials (dosismail/holidaymagic)</td>
<td>Initial Access</td>
<td>T1078.003</td>
<td>Valid Accounts: Local Accounts</td>
</tr>
<tr>
<td>Search for emails containing "http:" and "HTTP" text strings</td>
<td>Discovery</td>
<td>T1083</td>
<td>File and Directory Discovery</td>
</tr>
<tr>
<td>Examine email content for suspicious URLs and scripts</td>
<td>Discovery</td>
<td>T1213.002</td>
<td>Data from Information Repositories: Sharepoint</td>
</tr>
<tr>
<td>Extract malicious URL "https://frostbin.atnas.mail/api/paste"</td>
<td>Collection</td>
<td>T1005</td>
<td>Data from Local System</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<p>
<summary>Click to expand</summary>
<br>
</p>
<p>
This is a helpful resource for reading messages using curl: https://everything.curl.dev/usingcurl/reademail.html
<br>
</p>
<p>
<img src="/HHC_2025/images/maildetective_instructions.jpg" alt="Objective Instructions">
<br>
</p>
<p>
Connect to the server using curl:
<br>
</p>
<pre><code class="language-bash">
telnet://localhost:143
</code></pre>
<p>
The following commands were used:
<br>
</p>
<pre><code class="language-">
a001 login dosismail holidaymagic
a002 select Spam
a003 search text "http:"
a004 search text "HTTP"
a005 fetch 2 body[]
</code></pre>
<p>
This search returns a match.
<br>
</p>
<p>
<img src="/HHC_2025/images/maildetective_commands.jpg" alt="IMAP fetch command showing email message body">
<br>
</p>
<p>
Scrolling down the body is:
<br>
</p>
<p>
<img src="/HHC_2025/images/maildetective_answer.jpg" alt="Email body content revealing JavaScript variable with URL">
<br>
</p>
<pre><code class="language-javascript">
var pastebinUrl = "https://frostbin.atnas.mail/api/paste";
</code></pre>
<p>
<strong>Answer: https://frostbin.atnas.mail/api/paste</strong>
<br>
</p>
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
<td>curl</td>
<td>8.11.0</td>
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
<td>If I heard this correctly...our sneaky security gurus found a way to interact with the IMAP server using Curl! Yes...the CLI HTTP tool! Here are some helpful docs I found https://everything.curl.dev/usingcurl/reademail.html</td>
</tr>
<tr>
<td>Mo</td>
<td>So here's our situation: those gnomes have been sending JavaScript-enabled emails to everyone in the neighborhood, and it's causing chaos. We had to shut down all the email clients because they weren't blocking the malicious scripts - kind of like how we'd ground aircraft until we clear a security threat. The only safe way to access the email server now is through curl - yes, the HTTP tool! Think you can help me use curl to connect to the IMAP server and hunt down one of these gnome emails?</td>
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
<td>none</td>
<td>none</td>
</tr>
</tbody>
</table>
