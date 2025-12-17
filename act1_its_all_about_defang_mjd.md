---
layout: default
title: act1_its_all_about_defang_mjd
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
<table>
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
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
Defanging Indicators of Compromise (IoC)
<br>
Defanging is a cybersecurity practice of deliberately modifying malicious indicators such as URLs, IP addresses, email addresses, and domain names to render them non-functional while preserving their investigative value. This technique prevents accidental clicks, automated processing, or unintended execution when sharing threat intelligence in reports, emails, or public forums. Common defanging methods include replacing dots with "[.]" in domains (example[.]com), adding brackets to protocols (hxxp:// or hxxps://), replacing "@" symbols with "[at]" in email addresses, and modifying IP addresses (192[.]168[.]1[.]1). The practice is essential for security analysts, incident responders, and threat intelligence teams who need to document and communicate about malicious infrastructure without risking accidental exposure or triggering security controls. Defanging allows organizations to safely share IoCs across teams, with partners, or in public threat reports while maintaining the ability to quickly "refang" or restore the indicators to their original functional form when needed for analysis or blocking.
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
<td>Identify malicious URLs, domains, and IP addresses from security incidents</td>
<td>Discovery</td>
<td>T1590</td>
<td>Gather Victim Network Information</td>
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
Using the Extract IOCs tab:
<br>
</p>
<p>
Set the domain regex to: \b(?:[a-zA-Z0-9-]+\.)*icicleinnovations\.([a-zA-Z]{2,})\b
<br>
</p>
<p>
Set the IP Address Regex to: (?<=\b(?:mail|core)?\.?icicleinnovations\.mail\s*\()\d{1,3}(?:\.\d{1,3}){3}(?=\))
<br>
</p>
<p>
Set the URL regex to: https?:\/\/[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(:[0-9]+)?(/[^\s]\.exe)\b
<br>
</p>
<p>
Set the Email address regex to: \b[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)icicleinnovations\.[a-zA-Z]{2,}\b
<br>
</p>
<p>
To Defang the IOCs:
<br>
</p>
<p>
Use this combined Sed command: s/http/hxxp/g; s/@/[@]/g; s#://#[://]#g; s/\./[.]/g
<br>
</p>
<p>
<img src="/HHC_2025/images/itsallaboutdefang_solution.jpg" alt="Applying the combined Regex to Defang the IOCs">
<br>
</p>
<p>
The following were defanged: 3 domains, 2 addresses, 2 URLs, and 2 email addresses
<br>
</p>
<p>
<strong>Answer: Defanged: 3 domains, 2 addresses, 2 URLs, and 2 email addressesr</strong>
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
<td>sed</td>
<td>4.9</td>
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
