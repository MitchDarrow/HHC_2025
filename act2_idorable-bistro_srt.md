---
layout: default
title: act2_idorable-bistro_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_mail-detective_srt.html">Previous Objective: Act2 Mail Detective</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_dosis-network-down_srt.html">Next Objective: Act2 Dosis Network Down</a></th>
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
<td>Josh has a tasty IDOR treat for you -- stop by Sasabune for a bite of vulnerability. What is the name of the gnome?</td>
<td>Location: Sasabune</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
A gnome has come through Sasabune earlier, poorly disguised as a human and asking for frozen sushi. He suspects an IDOR bug could be present in the payment system. We recover a crumpled receipt from the peretrator outside the restaurant, noting that the gnome tried to pay with a rare 'Glimmerfin' trading card. 
<br>
When we load the receipt and inspect the request flow via proxy, we notice two GET requests to retreive the receipt information. The first is a <code>GET /receipt/[uniqueID]</code>, which loads the page that displays the receipt, and the second is a <code>GET /api/receipt?id=[SEQUENTIALID]</code> which retrieves the receipt information.
Taking this second request to a repeater tool in the proxy we discover a sequence of valid IDs between 101-152. There are a couple easter eggs here ("the flag is delicious"??) but ultimately we are after Bartholomew Quibblefrost on <strong><code>id=139</code></strong>. 
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
<td>Analyze Request Flow</td>
<td>Discovery</td>
<td>T1040</td>
<td>Network Sniffing</td>
</tr>
<tr>
<td>Exploit IDOR</td>
<td>Initial Access</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Enumerate Receipts</td>
<td>Collection</td>
<td>T1213</td>
<td>Data from Information Repositories</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<summary>Click to expand</summary>
<p><br>
The first step in this challenge is recovering the crumpled receipt from outside the restaurant. 
<br>
We load the receipt information in our browser of choice sitting behind the Caido web proxy. Inspecting the request flow when loading this information reveals two <code>GET</code> requests. The first <code>GET</code> request targets a <code>/receipt</code> endpoint with a seemingly unique and randomly-generated ID. However, the second <code>GET</code> request to <code>/api/receipt</code> utilizes an <code>id</code> parameter with the value of <code>103</code>, which appears to be sequentially generated.<br><br> 
To validate this, we first load this request into Caido's Replay tool. This allows us to manually replace the value of <code>id</code> with sequential values of <code>104</code>, <code>105</code>, and <code>106</code>, each of which returns a valid receipt.<br> <br>
Now, to find the name of the gnome in question, we can use Caido's Automate tool to fuzz the <code>/api/receipt</code> endpoint for valid <code>id</code> values and useful information.<br><br> 
Ultimately, we find a rather distinct name and a distinct order to match it. Remember the gnome described by Josh earlier? He told us the creature was poorly disguised as a human and asking for <em>frozen sushi</em>. Well, <code>/api/receipts/id=139</code> is an order by one <strong>Bartholomew Quibblefrost</strong> insisting on being delivered a <strong>frozen roll</strong>. Case closed. 
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
<td>Caido</td>
<td>0.54.1</td>
</tr>
</tbody>
</table>
