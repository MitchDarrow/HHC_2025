---
layout: default
title: act2_mail_detective_mjd
nav: |
  |[Previous Objective: Act2 Name](/act3_hackagnome_mjd.md)  |   [Home Page](/index.md) | [Next Objective: Act 2 IDORable Bistro](/act2_idorable_bistro_mjd.md) |
  | :----------------------- | :--------------------------------: | --------------------------------: |
---
<table>
<thead>
<tr>
<th>Objective: Mail Detective</th>
<br>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Mo in City Hall solve a curly email caper and crack the IMAP case. What is the URL of the pastebin service the gnomes are using?</td>
<br>
<td>Location: City Hall</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

This objective investigates suspicious emails using IMAP (Internet Message Access Protocol) commands via curl. The investigator connected to an IMAP server running on localhost port 143 using telnet protocol. Authentication was performed using the credentials "dosismail" with password "holidaymagic". After successful login, the investigator selected the "Spam" mailbox to examine suspicious messages. Multiple search commands were executed to find emails containing HTTP URLs, with the search for "HTTP" (uppercase) returning positive results. The investigator used the IMAP FETCH command to retrieve the full body of message ID 2. Examination of the email body revealed embedded JavaScript code containing a suspicious variable assignment. The JavaScript code contained a URL pointing to "https://frostbin.atnas.mail/api/paste", which appears to be a pastebin-style service potentially used for command and control or data exfiltration. This investigation demonstrates how IMAP protocol commands can be used for email forensics and threat hunting.


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
<td>Connect to IMAP server on localhost port 143 using telnet</td>
<br>
<td>Discovery</td>
<br>
<td>T1046</td>
<br>
<td>Network Service Discovery</td>
</tr>
<tr>
<td>Authenticate to email server using credentials (dosismail/holidaymagic)</td>
<br>
<td>Initial Access</td>
<br>
<td>T1078.003</td>
<br>
<td>Valid Accounts: Local Accounts</td>
</tr>
<tr>
<td>Search for emails containing "http:" and "HTTP" text strings</td>
<br>
<td>Discovery</td>
<br>
<td>T1083</td>
<br>
<td>File and Directory Discovery</td>
</tr>
<tr>
<td>Examine email content for suspicious URLs and scripts</td>
<br>
<td>Discovery</td>
<br>
<td>T1213.002</td>
<br>
<td>Data from Information Repositories: Sharepoint</td>
</tr>
<tr>
<td>Extract malicious URL "https://frostbin.atnas.mail/api/paste"</td>
<br>
<td>Collection</td>
<br>
<td>T1005</td>
<br>
<td>Data from Local System</td>
</tr>
</tbody>
</table>


<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

This is a helpful resource for reading messages using curl: https://everything.curl.dev/usingcurl/reademail.html

<img src="/HHC_2025/images/maildetective_instructions.jpg" alt="Objective Instructions">

Connect to the server using curl:

<pre><code class="language-bash">
<br>
telnet://localhost:143
<br>
</code></pre>
<br>
The following commands were used:

<pre><code class="language-">
<br>
a001 login dosismail holidaymagic
<br>
a002 select Spam
<br>
a003 search text "http:"
<br>
a004 search text "HTTP"
<br>
a005 fetch 2 body[]
<br>
</code></pre>

This search returns a match.

<img src="/HHC_2025/images/maildetective_commands.jpg" alt="IMAP fetch command showing email message body">

Scrolling down the body is:

<img src="/HHC_2025/images/maildetective_answer.jpg" alt="Email body content revealing JavaScript variable with URL">

<pre><code class="language-javascript">
<br>
var pastebinUrl = "https://frostbin.atnas.mail/api/paste";
<br>
</code></pre>

<strong>Answer: https://frostbin.atnas.mail/api/paste</strong>

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
<td>If I heard this correctly...our sneaky security gurus found a way to interact with the IMAP server using Curl! Yes...the CLI HTTP tool! Here are some helpful docs I found https://everything.curl.dev/usingcurl/reademail.html</td>
</tr>
<tr>
<td>Mo</td>
<br>
<td>So here's our situation: those gnomes have been sending JavaScript-enabled emails to everyone in the neighborhood, and it's causing chaos. We had to shut down all the email clients because they weren't blocking the malicious scripts - kind of like how we'd ground aircraft until we clear a security threat. The only safe way to access the email server now is through curl - yes, the HTTP tool! Think you can help me use curl to connect to the IMAP server and hunt down one of these gnome emails?</td>
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