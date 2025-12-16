---
layout: default
title: act2_idorable_bistro_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_mail_detective_mjd.html">Previous Objective: Act2 Mail Detective</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_dosis_network_down_mjd.html">Next Objective: Act2 Dosis Network Down</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: IDORable Bistro</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Josh has a tasty IDOR treat for you-stop by Sasabune for a bite of vulnerability. What is the name of the gnome?</td>
<td>Location: Sasabune</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
This objective is the exploitation of an Insecure Direct Object Reference (IDOR) vulnerability at the IDORable Bistro website. The initial reconnaissance involved scanning a QR code on a restaurant receipt that directed to https://its-idorable.hhc25-ops.com/. Inspection of the page source code revealed a hidden comment containing a sample receipt URL with a predictable identifier pattern. Using Burp Suite, the attacker intercepted HTTP requests and discovered that while initial requests used tokens, the initial request generated additional requests which exposed a numeric ID parameter. Using Burp Suite's Intruder feature to enumerate receipt IDs from 100 to 200, discovering that valid receipts existed from ID 100 to 152. Manual review of the enumerated responses revealed a receipt at ID 139 containing a gnomish customer name "Quibblefrost". The full name extracted from this receipt was "Bartholomew Quibblefrost". This vulnerability demonstrates a classic IDOR flaw where sequential numeric identifiers allow unauthorized access to other users' data without proper access controls. The attack required no authentication bypass and relied solely on predictable resource identifiers.
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
<td>Access hidden receipt URL endpoint with sample identifier</td>
<td>Initial Access</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Identify exposed ID parameter in subsequent requests</td>
<td>Discovery</td>
<td>T1046</td>
<td>Network Service Discovery</td>
</tr>
<tr>
<td>Send automated requests to enumerate valid receipt identifiers</td>
<td>Collection</td>
<td>T1530</td>
<td>Data from Cloud Storage</td>
</tr>
<tr>
<td>Review enumerated responses to locate gnomish customer name</td>
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
The following video is helpful for understanding Insecure Direct Object References: https://www.youtube.com/watch?v=hzrhtHrhwno
<br>
</p>
<p>
The receipt outside the restaurant has a QR code that points to this URL: https://its-idorable.hhc25-ops.com/
<br>
</p>
<p>
<img src="/HHC_2025/images/idorablebistro_rvs.jpg" alt="Initial website landing page">
<br>
</p>
<p>
Inspecting the page source code reveals a comment:
<br>
</p>
<p>
<img src="/HHC_2025/images/idorablebistro_comment.jpg" alt="HTML source code showing hidden comment">
<br>
</p>
<p>
Trying the URL from the comment: https://its-idorable.hhc25-ops.com/receipt/a1b2c3d4
<br>
</p>
<p>
<img src="/HHC_2025/images/idorablebistro_receipt.jpg" alt="Sample receipt page accessed via hidden URL">
<br>
</p>
<p>
Using Burp Suite to view the requests. The first request uses a token, but a subsequent request exposes the ID parameter.
<br>
</p>
<p>
<img src="/HHC_2025/images/idorablebistro_burp.jpg" alt="Burp Suite showing requests with exposed ID parameter">
<br>
</p>
<p>
Using Burp's Intruder, send requests with values for ID from 100 to 200:
<br>
</p>
<p>
At ID=153, 404 responses begin, so valid receipts are from 100 to 152.
<br>
</p>
<p>
Reviewing the responses, a gnomish name "Quibblefrost" appears in ID=139.
<br>
</p>
<p>
<img src="/HHC_2025/images/idorablebistro_intruder.jpg" alt="Receipt showing Bartholomew Quibblefrost name at ID=139">
<br>
</p>
<p>
<strong>Answer: Bartholomew Quibblefrost</strong>
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
<td>Edge Developer Tools</td>
<td>Version 142.0.3595.94</td>
</tr>
<tr>
<td>Burp Suite Community Edition</td>
<td>v2024.11.2</td>
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
<td>I have been seeing a lot of receipts lying around with some kind of QR code on them. I am pretty sure they are for Duke Dosis's Holiday Bistro. Interesting...see you if you can find one and see what they are all about...</td>
</tr>
<tr>
<td>Santa</td>
<td>I had tried to scan one of the QR codes and it took me to somebody's meal receipt! I am afraid somebody could look up anyone's meal if they have the correct ID...in the correct place.</td>
</tr>
<tr>
<td>Santa</td>
<td>Sometimes...developers put in a lot of effort to anonymyze information by using randomly generated identifiers...but...there are also times where the "real" ID is used in a separate Network request...</td>
</tr>
<tr>
<td>Josh</td>
<td>I need your help with something urgent. A gnome came through Sasabune today, poorly disguising itself as human - apparently asking for frozen sushi, which is almost as terrible as that fusion disaster I had to endure that one time. Based on my previous work finding IDOR bugs in restaurant payment systems, I suspect we can exploit a similar vulnerability here. I was at a talk recently and learned some interesting things about some of these payment systems. Let's use that receipt to dig deeper and unmask this gnome's true identity.</td>
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
