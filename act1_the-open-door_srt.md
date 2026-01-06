---
layout: default
title: act1_the-open-door_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_sparekey_mjd.html">Previous Objective: Act1 Spare Key</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_owner_mjd.html">Next Objective: Act1 Owner</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: The Open Door</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Goose Lucas in the hotel parking lot find the dangerously misconfigured Network Security Group rule that's allowing unrestricted internet access to sensitive ports like RDP or SSH.</td>
<td>Location: Hotel Parking Lot</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
Lucas is located just east of the Grand Hotel. We must help him secure the Neighboorhood's Azure network security infrastructure. To do this, we must audit the tenant's NSG rules and ensure nothing is overly permissive.
<br>
We use <code>az network nsg rule list</code> and <code>az network nsg rule show</code> to identify a suspicious rule in the <code>nsg-production-eastus</code> nsg, resource group <code>theneighborhood-rg1</code>. <code>Allow-RDP-From-Internet</code>.
</p><table>
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
<td>Enumerate NSG Rules</td>
<td>Discovery</td>
<td>T1526</td>
<td>Cloud Service Discovery</td>
</tr>
<tr>
<td>Identify Insecure Rule</td>
<td>Discovery</td>
<td>T1526</td>
<td>Cloud Service Discovery</td>
</tr>
<tr>
<td>Exposed RDP Access</td>
<td>Initial Access</td>
<td>T1133</td>
<td>External Remote Services</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
Guided terminal prompts help us to perform essential enumeration steps for this challenge. 
<br></p>
We begin by listing available resource groups with the <code>az group list -o table</code> command (note that <code>-o table</code> simply specifies the format in which data is output). This reveals one neighborhood resource group hosted in the <code>eastus</code> region and one hosted in <code>westus</code>. 
<code>az network nsg list -o table</code> similarly allows us to list the network security groups (NSGs) available to our user, each with an associated resource group. 
<p>
<br>
From here, understanding our objective is centered on the tenant's NSG rules, we want to enumerate the rules associated with each NSG and manually inspect the rules for anything overly permissive. 
<br>
Most NSGs will contain rules such as <code>Allow-HTTPS-Inbound</code>, with properly restricted ports, protocols, and rule priorities. However, when exploring the rule set of the <code>nsg-production-eastus</code> NSG, we discover an odd-looking <strong><code>Allow-RDP-From-Internet</code></strong> rule. This rule has three suspicious properties:
<br>
</p>
<ol>
<li><strong><code>"access": "Allow"</code></strong></li>
<li><strong><code>"destinationPortRange": "3389"</code></strong></li>
<li><strong><code>"sourceAddressPrefix": "0.0.0.0/0"</code></strong></li>
</ol>
Our first two properties allow for inbound access to port 3389, which is the standard port of access for remote desktop protocol (RDP) software. This is enough to raise the hairs of any security-conscious user, with our third property verifying the insecure nature of this rule. Utilizing the <code>0.0.0.0/0</code> source address prefix allows for the rule to bind on any network interface, effectively allowing access from any local or remote host. 
<p>
<br>
<strong>This is the insecure rule targeted by the challenge</strong>. With this rule in effect, attackers and legitimate users alike can arbitrarily initialize RDP connections into any host covered by the NSG. 
</p>
</details>
<h2>Tools Reference</h2>
<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>Azure CLI</td>
<td>2.81.0</td>
</tr>
</tbody>
</table>
