---
layout: default
title: act1_owner_srt
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
<th>Objective: Owner</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Help Goose James near the park discover the accidentally leaked SAS token in a public JavaScript file and determine what Azure Storage resource it exposes and what persmissions it grants.</td>
<td>Location: The Park</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
James is a goose who tells us that we need to audit the neighborhood's RBAC configuration to ensure best practices are being followed. We must verify that all access uses PIM and that there are no permanently assigned Owner roles. Following the prompts we discover permanent owner roles assigned within <code>subscription03</code>.
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
<td>Audit RBAC Settings</td>
<td>Discovery</td>
<td>T1069.003</td>
<td>Permission Groups Discovery: Cloud Groups</td>
</tr>
<tr>
<td>Identify Privileged Accounts</td>
<td>Discovery</td>
<td>T1087.004</td>
<td>Account Discovery: Cloud Account</td>
</tr>
<tr>
<td>Enumerate Subscriptions</td>
<td>Discovery</td>
<td>T1526</td>
<td>Cloud Service Discovery</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
Dropping into the Azure CLI instance, we are given some introductory commands to identify different groups within our Azure Active Directory (AD) instance. 
<br>
We are ultimately led to the <code>6b982f2f-78a0-44a8-b915-79240b2b4796</code> group. Listing the members of this group via <code>az ad member list --group</code> identifies a Subscription Administrator user whose <code>expirationDateTime</code> property is set to <code>null</code>. This configuration results in a permanent assignment of elevated privileges to whomever is designated this role, which could lead to a number of access control violations. 
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
