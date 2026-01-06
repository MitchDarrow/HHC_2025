---
layout: default
title: act2_mail-detective_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_retro-recovery_srt.html">Previous Objective: Act2 Retro Recovery</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_idorable-bistro_srt.html">Next Objective: Act 2 IDORable Bistro</a></th>
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
Maurice has a cool samurai outfit and warthog pet. We need to use curl to help him investigate the gnomes sending JS-enabled emails to everyone in the nieghborhood. We need to connect to the IMAP server and investigate the source.
<br>
We can't connect via HTTP, but we can use <code>imap://127.0.01:143</code> within our curl command to use the IMAP protocol instead. We have to poke through the content of each email and find the URL for the pastebin service used by the gnomes. 
Digging through the inbox and provided emails, we find the URL within the spam folder: <code>https://frostbin.atnas.mail/api/paste</code>.
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
<td>Retrieve Emails via IMAP</td>
<td>Collection</td>
<td>T1114.002</td>
<td>Email Collection: Remote Email Collection</td>
</tr>
<tr>
<td>IMAP Protocol Usage</td>
<td>Command and Control</td>
<td>T1071.003</td>
<td>Application Layer Protocol: Mail Protocols</td>
</tr>
<tr>
<td>Analyze Phishing Content</td>
<td>Initial Access</td>
<td>T1566</td>
<td>Phishing</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
<br>
We are dropped into a terminal with <code>curl</code> and some user credentials to use with our targeted IMAP server. 
A simple <code>curl "imap://127.0.0.1:143" -u "dosismail:holidaymagic"</code> shows five mailboxes to explore:
<br></p>
<ul>
<li>Spam</li>
<li>Sent</li>
<li>Archives</li>
<li>Drafts</li>
<li>INBOX</li>
</ul>
<br>
To navigate these mailboxes, we need knowledge of some basic IMAP commands. <code>STATUS [mailbox_name] (MESSAGES)</code> will return the number of messages in the designated mailbox. We can also attach a <code>MAILINDEX</code> paramater to a given <code>curl</code> request to view specific messages. The following example should help to illustrate this:
<pre><code class="language-sh">
curl "imap://127.0.0.1:143" -u "dosismail:holidaymagic" -X "STATUS Drafts (MESSAGES)"
STATUS Drafts (MESSAGES 2)
curl "imap://127.0.0.1:143/Drafts;MAILINDEX=1" -u "dosismail:holidaymagic"
</code></pre>
<br>
By providing a <code>MAILINDEX</code> value that's within the total number of messages stated to be in each mailbox, we can request and view individual messages within a mailbox. By this method, we are able to enumerate and inspect each message in an attempt to identify the malicious pastebin link. 
Continuing in this way we find that the second message in the <code>Spam</code> mailbox contains a suspicious script with an <code>exfiltrateData()</code> function. Within this function is a <code>pastebinUrl</code> variable containing our sought-after information! 
<p>
The following code block contains the discovered script:
<br>
</p>
<pre><code class="language-js">
function initCryptoMiner() {
    var worker = {
        start: function() {
            console.log("Frost's crypto miner started - mining FrostCoin for perpetual winter fund");
            this.interval = setInterval(function() {
                console.log("Mining FrostCoin... Hash rate: " + Math.floor(Math.random() <em> 1000) + " H/s");
            }, 5000);
        },
        stop: function() {
            clearInterval(this.interval);
        }
    };
    worker.start();
    return worker;
}
function exfiltrateData() {
    var sensitiveData = {
        hvacSystems: "Located " + Math.floor(Math.random() </em> 50) + " cooling units",
        thermostatData: "Temperature ranges: " + Math.floor(Math.random() <em> 30 + 60) + "°F",
        refrigerationUnits: "Found " + Math.floor(Math.random() </em> 20) + " commercial freezers",
        timestamp: new Date().toISOString()
    };
    console.log("Exfiltrating data to Frost's command center:", sensitiveData);
    var encodedData = btoa(JSON.stringify(sensitiveData));
    console.log("Encoded payload for Frost: " + encodedData.substr(0, 50) + "...");
    // pastebin exfiltration
    var pastebinUrl = "https://frostbin.atnas.mail/api/paste";
    var exfilPayload = {
        title: "HVAC_Survey_" + Date.now(),
        content: encodedData,
        expiration: "1W",
        private: "1",
        format: "json"
    };
    console.log("Sending stolen data to FrostBin pastebin service...");
    console.log("POST " + pastebinUrl);
    console.log("Payload: " + JSON.stringify(exfilPayload).substr(0, 100) + "...");
    console.log("Response: {\"id\":\"" + Math.random().toString(36).substr(2, 8) + "\",\"url\":\"https://frostbin.atnas.mail/raw/" + Math.random().toString(36).substr(2, 8) + "\"}");
}
function establishPersistence() {
</code></pre>
<strong>The URL to complete the objective is <code>https://frostbin.atnas.mail/api/paste</code></strong>
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
<td><code>curl</code></td>
<td>8.17.0</td>
</tr>
</tbody>
</table>
