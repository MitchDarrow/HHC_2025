---
layout: default
title: act1_blob-storage_srt
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
<td>Location: Frozen Pond</td>
</tr>
</tbody>
</table>
<p>
<br>
<h2>Solution Overview</h2>
<br>
</p>
<br>
<p>
<br>
Grace tells us that the Neighborhood HOA uses Azure storage accounts for its IT operations. We must audit their storage security config to ensure no sensitive data is publicly accessible. Recent security reports suggest some storage accounts could have public blob access enabled, which could be a potential data exposure risk. 
<br>
</p>
After running a few introductory commands, we are guided to discover a suspicious storage account <code>neighborhod2</code> with public access enabled, an outdated <code>minimumTlsVersion</code>, and blob encryption disabled. The account has a container <code>public</code>, with an accessible blob containing <code>refrigerator_inventory.pdf, admin_credentials.txt, network_config.json</code>. We are able to download and view the credentials file. 
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
<td>Analyze Export File</td>
<td>Discovery</td>
<td>T1526</td>
<td>Cloud Service Discovery</td>
</tr>
<tr>
<td>Enumerate Containers</td>
<td>Discovery</td>
<td>T1619</td>
<td>Cloud Storage Object Discovery</td>
</tr>
<tr>
<td>Identify Misconfiguration</td>
<td>Discovery</td>
<td>T1526</td>
<td>Cloud Service Discovery</td>
</tr>
<tr>
<td>Access Public Blob</td>
<td>Collection</td>
<td>T1530</td>
<td>Data from Cloud Storage</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<summary>Click to expand</summary>
<br>
We begin by enumerating a list of storage accounts. One of these storage accounts, <code>neighborhood2</code>, has a container named <code>public</code> with the <code>publicAccess</code> property set to <code>Blob</code>. This configuration allows for public access to blob storage contents within the property's associated container.
The <code>az storage blob list</code> command can then be used to list the contents of this publicly-accessible blob. We find three files: <code>refrigerator_inventory.pdf, admin_credentials.txt, network_config.json</code>. 
We then use the <code>az storage blob download</code> command alongside some minor bash I/O redirection syntax to capture the contents of the credentials file. The full command used is as follows:
<pre><code class="language-sh">
az storage blob download --container-name public --account-name neighborhood2 --name admin_credentials.txt --file /dev/stdout >> creds.txt
</code></pre>
<br>
By downloading the file contents to <code>/dev/stdout</code> we are able to then use the append operator (<code>>></code>) to create the local <code>creds.txt</code> file. 
A simple <code>cat creds.txt</code> reveals the Azure Administrator's portal credentials. 
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
<td>2.81.0</td>
</tr>
</tbody>
</table>
