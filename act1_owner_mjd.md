---
layout: default
title: act1_owner_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_the_open_door_mjd.html">Previous Objective: Act1 The Open Door</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act2_retro_recovery_mjd.html">Next Objective: Act2 Retro Recovery</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Owner</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Goose James near the park discover the accidentally leaked SAS token in a public JavaScript file and determine what Azure Storage resource it exposes and what permissions it grants.</td>
<td>Location: The Park</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
Conduct reconnaisance of an Azure tenant looking for permission misconfigurations. The group IT Admins wass found on subscription the neighborhood-sub-3. Another group was nested inside IT Admins that contained a permanent permission assignment to a user. This violates the principle of least privilege and creates a permanent attack path.
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
  <tr><td>Discovering a permanent owner assignment in Azure Storage</td><td>Reconnaissance</td><td>T1526</td><td>Cloud Service Discovery</td></tr>
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
Start by listing the accounts with this command:
<br>
</p>
<pre><code class="language-ps">
az account list --query "[].name"
</code></pre>
<p>
<img src="/HHC_2025/images/owner_accounts.jpg" alt="Azure tenant accounts list">
<br>
</p>
<p>
Next lets find which accounts are enabled:
<br>
</p>
<pre><code class="language-ps">
az account list --query "[?state=='Enabled'].{Name:name, ID:id}"
</code></pre>
<p>
<img src="/HHC_2025/images/owner_enabled.jpg" alt="Azure tenant enabled accounts">
<br>
</p>
<p>
Reviewing the Owner's of the each listed subscription: pass in each subscription id.
<br>
</p>
<pre><code class="language-ps">
az role assignment list --scope "/subscriptions/065cc24a-077e-40b9-b666-2f4dd9f3a617" --query [?roleDefinition=='Owner']
</code></pre>
<p>
<img src="/HHC_2025/images/owner_owners.jpg" alt="Azure tenant Subscription iD ownwers">
<br>
</p>
<p>
In addition to the PIM group, there is a group called IT Admins. Let's figure out the membership of the IT Admins group.
<br>
</p>
<pre><code class="language-ps">
az ad group member list --group 6b982f2f-78a0-44a8-b915-79240b2b4796 | less
</code></pre>
<p>
<img src="/HHC_2025/images/owner_itadminsGroup.jpg" alt="Azure tenant IT Admins Group properties">
<br>
</p>
<p>
IT Admins is a nested group. Let's figure out the membership of the Subscription Admins group.
<br>
</p>
<pre><code class="language-ps">
az ad group member list --group 631ebd3f-39f9-4492-a780-aef2aec8c94e | less
</code></pre>
<p>
<img src="/HHC_2025/images/owner_subscriptionadminsGroup.jpg" alt="Azure tenant subscription Admins Group properties">
<br>
</p>
<p>
IT Admins is a nested group. Let's figure out the membership of the Subscription Admins group.
<br>
</p>
<pre><code class="language-ps">
az ad group member list --group 631ebd3f-39f9-4492-a780-aef2aec8c94e | less
</code></pre>
<p>
<img src="/HHC_2025/images/owner_subscriptionadminsGroup.jpg" alt="Azure tenant subscription Admins Group properties">
<br>
</p>  
<p>
<strong>Answer: Use just-in-time elevated access instead of permanent assignments. Permanent Owner roles create persistente attack paths and violate least-privilege principles.  </strong>
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
