---
nav: |
  <table>
  <thead><tr><th><a href="/act1_intro_to_nmap_mjd.html">Previous Objective: Act1 Intro to Nmap</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act1_spare_key_mjd.html">Next Objective: Act1 Spare Key</a></th></table>
  
---

<table>
<thead><tr><th>Objective: Blob Storage Challenge in the Neighborhood</th> <th>Difficulty Level: 1</th><tr><td>Help the Goose Grace near the pond find which Azure Storage account has been misconfigured to allow public blob access by analyzing the export file.</td> <td>Location: The Pond</td></table>


## Solution Overview

The objective of this challenge is to connect using Azure CLI to the "neighborhood" tenant. Investigate and find where a security vulnerability exists. The neighborhood2 storage account was misconfigured to allow public blob access. The security vulnerability was a file named admin_credentials.txt that contained users and unencrypted passwords.

<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Enumerate Azure storage accounts in tenant</td> <td>Discovery</td> <td>T1580</td> <td>Cloud Infrastructure Discovery</td><tr><td>List containers in storage account</td> <td>Discovery</td> <td>T1619</td> <td>Cloud Storage Object Discovery</td><tr><td>Identify misconfigured public blob access on storage account</td> <td>Discovery</td> <td>T1613</td> <td>Container and Resource Discovery</td><tr><td>Discover admin_credentials.txt file containing sensitive data</td> <td>Discovery</td> <td>T1619</td> <td>Cloud Storage Object Discovery</td></table>


## Detailed Solution
<details>
<summary>Click to expand</summary>
<p>Step 1: Review the storage accounts</p>
<p><pre><code></p>
<p></code></pre></p>
<p>!<a href="/images/blobstorage_misconfig.jpg">Misconfigured Storage Account allows Public Access</a> </p>
<p>The following commands were used to dive deeper:</p>
<p><pre><code></p>
<p></code></pre></p>
<p>!<a href="/images/blobstorage_passwords.jpg">Misconfigured Storage Account allows Public Access</a> </p>
<p><strong>Answer: allowBlobPublicAccesss: True</strong></p>
</details>

## Tools Reference

<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>Azure Cli</td> <td>N/A</td> <td></td></table>



## Hints Reference
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>This terminal has built-in hints.</td></table>


## Acknowledgements
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>



<table>
<thead><tr><th><a href="/act1_intro_to_nmap_mjd.html">Previous Objective: Act1 Intro to Nmap</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act1_spare_key_mjd.html">Next Objective: Act1 Spare Key</a></th></table>







