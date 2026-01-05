---
layout: default
title: act1_spare-key_srt
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
<th>Objective: Spare Key</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Goose Barry near the pond identify which identity has been granted excessive Onwer permissions at the subscription level, violating the principle of least privilege.</td>
<td>Location: Frozen Pond</td>
</tr>
</tbody>
</table>
<p><br>
<h2>Solution Overview</h2>
<br>
Next to Grace is Barry, who tells us that the Neighborhood HOA hosts a static website on Azure Storage. An admin accidentally uploaded an infrastructure config file containing a long-lived SAS token. We need to use azure cli to find the leak.
<br>
We're connected to a read-only AZ CLI session. We find the <code>neighborhoodhoa</code> storage account with a <code>$web</code> container. Listing the blob associated with that container shows an <code>iac/terraform.tfvars</code> file with likely exposed secrets. Downloading the file reveals the long-lived SAS token, expiring <code>2100-01-01</code>.
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
<td>Enumerate Storage Containers</td>
<td>Discovery</td>
<td>T1619</td>
<td>Cloud Storage Object Discovery</td>
</tr>
<tr>
<td>Download TFVars File</td>
<td>Collection</td>
<td>T1530</td>
<td>Data from Cloud Storage</td>
</tr>
<tr>
<td>Extract SAS Token</td>
<td>Credential Access</td>
<td>T1552.001</td>
<td>Unsecured Credentials: Credentials in Files</td>
</tr>
</tbody>
</table>
<br>
<h2>Detailed Solution</h2>
<br>
<details>
<summary>Click to expand</summary>
<p>
<br>
We begin with two introductory discovery commands:
<br>
<pre><code class="language-sh">
az group list -o table
az storage account list --resource-group rg-the-neighborhood -o table
</code></pre>
<p>
Since our objective tells us the issue is related to the Neighborhood HOA's static website, we first take a look at <code>rg-the-neighborhood</code>. 
The <code>az storage account list</code> command shows us a number of different storage accounts within the <code>rg-the-neighborhood</code> resource group. Again referencing our objective, we investigate the <code>neighborhoodhoa</code> account further. 
<br>
We aim to identify which container within this storage account contains the infrastructure configuration file holding the long-lived SAS token. 
<br>
</p>
<br>
Of the two containers found within the <code>neighborhoodhoa</code> storage account, the <code>$web</code> container most likely contains data related to the static website targeted by the objective. Listing the blob contents of this container reveals two static <code>.html</code> files and a file named <code>terraform.tfvars</code> within the <code>iac</code> folder. 
Infrastructure-as-code (IaC or <code>iac</code>) is a popular methodology used for the provisioning and management of modern digital resources. Terraform, developed by HashiCorp, is an IaC tool enabling users to safely and predictably build, change, and version infrastructure resources using declarative configuration files. The <code>terraform.tfvars</code> is therefore the infrastructure configuration file indicated by our objective.   
We utilize <code>az storage blob download</code> with some unix I/O redirection capability to download the contents of the infrastructure configuration file to our local terminal instance. By downloading the contents to <code>/dev/stdout</code>, we are then able to utilize the append (<code>>></code>) operator to create a local <code>tfvars.txt</code> file containing our targeted contents.
<pre><code class="language-sh">
az storage blob download --account-name neighborhoodhoa --container-name '$web' --auth-mode login --name 'iac/terraform.tfvars' --file /dev/stdout >> tfvars.txt
</code></pre>
<p>
<br>
The image below displays a subsection of this configuration file's contents, with the SAS token in question highlighted in green. 
<br>
<img src="/HHC_2025/HHC_2025/images/spare-key_sas-token.png" alt="Long-Lived SAS Token"> 
</details>
<br>
<h2>Tools Reference</h2>
<br>
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
