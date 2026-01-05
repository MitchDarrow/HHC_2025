---
layout: default
title: act1_spare_key_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/act1_blob-storage_srt.html">Previous Objective: Act1 Blob Storage Challenge</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_the-open-door_srt.html">Next Objective: Act1 The Open Door</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Spare Key</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Goose Barry near the pond identify which identity has been granted excessive Owner permissions at the subscription level, violating the principle of least privilege.</td>
<td>Location: The Pond</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
Conduct reconnaisance of an Azure tenant looking for for interesting files that might contain valuable information. The $web directory was explored for configuration files. A terraform file contained a long-lived SAS migration token.
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
  <tr><td>Discovering SAS key in Azure Storage</td><td>Reconnaissance</td><td>T1526</td><td>Cloud Service Discovery</td></tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<summary>Click to expand</summary>
<br>
<p>
Start by listing all resource groups:
<br>
</p>
<pre><code class="language-ps">
az group list -o table
</code></pre> 
<p>
<img src="/HHC_2025/images/sparekey_resourcegroups.jpg" alt="Azure Resource Group Listing">
<br>
</p>
<p>
Next get a listing of storage accounts:
<br>
</p>
<pre><code class="language-ps">
az storage account list --resource-group rg-the-neighborhood -o table
</code></pre>  
<p>
<img src="/HHC_2025/images/sparekey_accounts.jpg" alt="Azure Resource Group Accounts">
<br>
</p>
<p>
Examining the files in the static website container:
<br>
</p>
<pre><code class="language-ps">
az storage blob list --container-name '$web' account-name neighborhoodhoa --auth-mode login
</code></pre>  
<p>
<img src="/HHC_2025/images/sparekey_blobs.jpg" alt="Azure Resource Blob Listing">
<br>
</p>
<p>
The metadata WARNING: LEAKED_SECRETS looks promising. Download the file to review:
</p>
 <pre><code class="language-ps">
az storage blob download \
  --account-name neighborhoodhoa \
  --container-name '$web' \
  --name 'iac/terraform.tfvars' \
  --file terraform.tfvars \
  --auth-mode login
</code></pre>  
<p>
<img src="/HHC_2025/images/sparekey_secret.jpg" alt="Long Lived SAS token found">
<br>
</p>

<strong>Answer: A migration_sas token within hte /iac/terraform.tfvars file exposed a long-lived SAS token</strong>
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
<td>Azure CLI</td>
<td>N/A</td>
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
<td>This terminal has built-in hints!</td>
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
