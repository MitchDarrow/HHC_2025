---
layout: default
title: act1_the_open_door_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th></th>
  <th><a href="/HHC_2025/allwriteups.html">All Writeups Index</a></th>
  <th></th>
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
<td>Location: Grand Hotel Parking Lot</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
</p>
<p>
Conducted reconnaisance of an Azure tenant. Discovered a Network Sec=urity Group (NSG) misconfiguration allowing Remote Desktop Protocol (RDP) from the public internet. 
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
<tr><td>Discovering that RDP is exposed to the internet</td><td>Reconnaisance</td><td>T1590.003</td><td>Gather Victim Network Information: Internet Exposed Services</td></tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
Start by listing the groups with this command:
<br>
</p>
<pre><code class="language-ps">
az group list
</code></pre>
<p>
<img src="/HHC_2025/images/opendoor_groups.jpg" alt="Azure tenant group list">
<br>
</p>
<p>
Next display the Network Security Groups (NSGs) with this command: 
<br>
</p>
<pre><code class="language-ps">
az network nsg list -o table
</code></pre>
<p>
<img src="/HHC_2025/images/opendoor_nsgs.jpg" alt="Azure Network Security Groups">
<br>
Looking at the Production group NSG Rules:
<br>
</p>
<pre><code class="language-ps">
az network nsg rule list --nsg-name nsg-production-eastus --resource-group theneighborhood-rg1 --output table
</code></pre>
<p>
<img src="/HHC_2025/images/opendoor_production.jpg" alt="Azure Production Group NSG Rules">
<br>
</p>
<strong>There is a rule that allows RDP from anywhere on the internet.</strong>
Show the rule to complete the objective with this command:
<pre><code class="language-ps">
  az network nsg rule show \
  --nsg-name nsg-production-eastus \
  --resource-group theneighborhood-rg1 \
  --name Allow-RDP-From-Internet \
  --output json
</code></pre>
<p>
<strong>Answer: NSG misconfiguration allowing RDP (port 3389) from the public internet</strong>
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
<td>Azure CLI</td>
<td>N/A</td>
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
<td>This terminal has built-in hints!</td>
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
<td>none</td>
<td>none</td>
</tr>
</tbody>
</table>
