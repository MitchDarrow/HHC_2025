---
layout: default
title: act1_its-all-about-defang_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_orientation_mjd.html">Previous Objective: Act1 Holiday Hack Orientation</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_neighborhood_watch_bypass_mjd.html">Next Objective: Act1 Neighborhood Watch Bypass</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table class="quest-table">
<thead>
<tr>
<th>Objective: Its All About Defang</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Find Ed Skoudis upstairs in City Hall and help him troubleshoot a clever phishing tool in his cozy office.</td>
<td>Location: City Hall</td>
</tr>
</tbody>
</table>
<h2>Solution Overview</h2>
<p>Ed and his team have been working on a new SOC tool that helps triage phishing emails. He asks us to help fix some issues with their detections, where some sketchy emails still made it through. We need to make sure all IoCs are blocked.
<br>
We are brought to their Defang tool, where we must analyze a suspicious email. We need to use Regular Expressions (regex) to help the tool identify information such as the domains, IP addresses, URLs, and email addresses contained in the email. We are provided with sample regex patterns to use and must then manually exclude false positives provided by those patterns. 
</p>
<br>
All of our identified IoCs are then manually defanged via a chained <code>sed</code> command: <code>s/\./[.]/g; s/@/[@]/g; s/http/hxxp/g; s/:\//[://]/g</code>.
<table class="quest-table">
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
<td>Analyze Phishing Email</td>
<td>Initial Access</td>
<td>T1566</td>
<td>Phishing</td>
</tr>
<tr>
<td>Defang Indicators</td>
<td>Defense Evasion</td>
<td>T1027</td>
<td>Obfuscated Files or Information</td>
</tr>
<tr>
<td>Execute <code>sed</code> Command</td>
<td>Execution</td>
<td>T1059.004</td>
<td>Command and Scripting Interpreter: Unix Shell</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
The Defang tool presents us with an example of an email that made it through Ed's security filters. We are first tasked with identifying malicious content within four classes of indicators of compromise (IoC): 
</p>
<ul>
<li>Domains</li>
<li>IP Addresses</li>
<li>URLs</li>
<li>Email Addresses</li>
</ul>
<p>
For each of these classes, the tool provides us with a sample regular expression (regex) pattern that is used to identify content within the text of the email. After running each provided regex pattern, we must manually exclude friendly assets in our IoC identification. We <em>do</em> need to modify the IP address regex to properly capture the entirety of the field. The supplied query only selects three, not four couplets. 
<br>
</p>
To manually identify and exclude friendly assets, we must simply analyze the content within which each identified IoC arises. The <code>dosisneighborhood.corp</code> domain, for example, is indicated as the receiving domain and should **not* be targeted by security filtering tools. 
By following a process of iterating upon and fine-tuning the regex patterns provided by the Defang tool, we are able to identify malicious nine IoCs within the provided email. These IoCs are manually defanged, or made benign, by the following chained <code>sed</code> command: <strong><code>s/\./[.]/g; s/@/[@]/g; s/http/hxxp/g; s/:\//[://]/g</code></strong>
</details>
<h2>Tools Reference</h2>
<table class="quest-table">
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>Defang Tool</td>
<td>1.0</td>
</tr>
<tr>
<td><code>sed</code></td>
<td>4.9-2</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
</p>
<table class="quest-table">
<thead>
<tr>
<th>Provided By</th>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<td>The PTAS does a pretty good job at defanging, however, the feature we are still working on is one that defangs ALL scenarios. For now, you will need to write a custom sed command combining all defang options.</td>
</tr>
<tr>
<td>Santa</td>
<td>Remember, the new Phishing Threat Analysis Station (PTAS) is still under construction. Even though the regex patterns are provided, they haven't been fine tuned. Some of the matches may need to be manually removed.</td>
</tr>
<tr>
<td>Ed</td>
<td>Oh gosh, I could talk for hours about this stuff but I really need your help! The team has been working on this new SOC tool that helps triage phishing emails...and there are some...issues. We have had some pretty sketchy emails coming through and we need to make sure we block ALL of the indicators of compromise. Can you help me? No pressure...</td>
</tr>
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
</p>
<table class="quest-table">
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
