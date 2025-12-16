---
layout: default
title: act1_blob_storage_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_intro_to_nmap_mjd.html">Previous Objective: Act1 Intro to Nmap</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act1_spare_key_mjd.html">Next Objective: Act1 Spare Key</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Blob Storage Challenge in the Neighborhood</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help the Goose Grace near the pond find which Azure Storage account has been misconfigured to allow public blob access by analyzing the export file.</td>
<td>Location: The Pond</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
The objective of this challenge is to connect using Azure CLI to the "neighborhood" tenant. Investigate and find where a security vulnerability exists. The neighborhood2 storage account was misconfigured to allow public blob access. The security vulnerability was a file named admin_credentials.txt that contained users and unencrypted passwords.
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
<td>Enumerate Azure storage accounts in tenant</td>
<td>Discovery</td>
<td>T1580</td>
<td>Cloud Infrastructure Discovery</td>
</tr>
<tr>
<td>List containers in storage account</td>
<td>Discovery</td>
<td>T1619</td>
<td>Cloud Storage Object Discovery</td>
</tr>
<tr>
<td>Identify misconfigured public blob access on storage account</td>
<td>Discovery</td>
<td>T1613</td>
<td>Container and Resource Discovery</td>
</tr>
<tr>
<td>Discover admin_credentials.txt file containing sensitive data</td>
<td>Discovery</td>
<td>T1619</td>
<td>Cloud Storage Object Discovery</td>
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
Step 1: Review the storage accounts
<br>
</p>
<pre><code class="language-sh">
az storage account list | less
</code></pre>
<p>
<img src="/HHC_2025/images/blobstorage_misconfig.jpg" alt="Misconfigured Storage Account allows Public Access">
<br>
</p>
<p>
The following commands were used to dive deeper:
<br>
</p>
<pre><code class="language-sh">
az storage container list --account-name neighborhood2 --output table
az storage blob list --container-name public --account-name neighborhood2
az storage blob download \
  --container-name public \
  --account-name neighborhood2 \
  --name admin_passwords.txt \
  --file admin_passwords.txt
</code></pre>
<p>
<img src="/HHC_2025/images/blobstorage_passwords.jpg" alt="Misconfigured Storage Account allows Public Access">
<br>
</p>
<p>
<strong>Answer: allowBlobPublicAccesss: True</strong>
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
<td>Azure Cli</td>
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
<td>This terminal has built-in hints.</td>
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
