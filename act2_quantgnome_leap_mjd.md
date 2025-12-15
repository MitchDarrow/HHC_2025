---
layout: default
title: act2_quantgnome_leap_mjd
nav: |
  |[Previous Objective: Act2 Rogue Gnome Identity Provider](/act2_rogue_gnome_identity_provider_mjd.md)  |   [Home Page](/index.md) | [Next Objective: Act 2 Going in Reverse](/act2_going_in_reverse_mjd.md) |
  | :----------------------- | :--------------------------------: | --------------------------------: |
---
<table>
<thead>
<tr>
<th>Objective: Quantgnome Leap</th>
<br>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Charlie in the hotel has quantum gnome mysteries waiting to be solved. What is the flag that you find?</td>
<br>
<td>Location: Grand Hotel</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

Reconnaissance located ssh keys that belonged to another user. These keys were used to move laterally in the system and gain access to another user. This was repeated until admin level access was achieved. The flag was located under the directory where the SSH daemon was running.

<table>
<thead>
<tr>
<th>Activity</th>
<br>
<th>Primary Tactic</th>
<br>
<th>MITRE ATT&CK Technique ID</th>
<br>
<th>MITRE ATT&CK Technique Name</th>
</tr>
</thead>
<tbody>
<tr>
<td>Locating inadequately secured SSH keys</td>
<br>
<td>Credential Access</td>
<br>
<td>T1552.004</td>
<br>
<td>Unsecured Credentials: Private Keys</td>
</tr>
<tr>
<td>Using keys to gain unauthorized access</td>
<br>
<td>Persistence / Lateral Movement</td>
<br>
<td>T1078.004</td>
<br>
<td>Valid Accounts: SSH</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

RSA keys were found in the Qgnome directory during recon

<img src="/images/quantgnome_rsakeys.jpg" alt="RSA Keys">

Inspecting the knownhosts file, there is a key referenced at /opt/oqs-key/ssh_host_ecdsa_nistp521_mldsa-87_key. This directory is accessible.

Using this key:

<pre><code class="language-sh">
<br>
ssh -p 2222 -i /opt/oqs-key/ssh_host_ecdsa_nistp521_mldsa-87_key gnome1@localhost
<br>
</code></pre>

<img src="/images/quantgnome_gnome1.jpg" alt="SSH as Gnome1">

The Gnome1 user has access to a new key:

<pre><code class="language-sh">
<br>
ssh -p 2222 -i /opt/oqs-key/id_ed25519 gnome2@localhost
<br>
</code></pre>

<img src="/images/quantgnome_gnome2.jpg" alt="SSH as Gnome2">

The Gnome2 user has access to a new key:

<pre><code class="language-sh">
<br>
ssh -p 2222 -i /opt/oqs-key/id_mayo2 gnome3@localhost
<br>
</code></pre>

<img src="/images/quantgnome_gnome3.jpg" alt="SSH as Gnome3">

The Gnome3 user has access to a new key:

<pre><code class="language-sh">
<br>
ssh -p 2222 -i /opt/oqs-key/id_ecdsa_nistp256_sphincssha2128fsimple gnome4@localhost
<br>
</code></pre>
<img src="/images/quantgnome_gnome4.jpg" alt="SSH as Gnome4">

The Gnome4 user has access to a new key:

<pre><code class="language-sh">
<br>
ssh -p 2222 -i /opt/oqs-key/id_ecdsa_nistp521_mldsa87 admin@localhost
<br>
</code></pre>

The instructions direct towards the directory where the SSH daemon is running (/opt/oqs-ssh), and The flag is in the directory /opt/oqs-ssh/flag

<img src="/images/quantgnome_flagdir.jpg" alt="Flag Directory">

<strong>Answer: HHC{L3aping_0v3r_Quantum_Crypt0}</strong>

</details>

<h2>Tools Reference</h2>

<table>
<thead>
<tr>
<th>Tools Used</th>
<br>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>none</td>
<br>
<td>none</td>
</tr>
</tbody>
</table>


<h2>Hints Reference</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<br>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<br>
<td>When you give a present, you often put a label on it to let someone know that the present is for them. Sometimes you even say who the present is from. The label is always put on the outside of the present so the public knows the present is for a specific person. SSH keys have something similar called a comment. SSH keys sometimes have a comment that can help determine who and where the key can be used.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>User keys are like presents. The keys are kept in a hidden location until they need to be used. Hidden files in Linux always start with a dot. Since everything in Linux is a file, directories that start with a dot are also...hidden!</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Process information is very useful to determine where an application configuration file is located. I bet there is a secret located in that application directory, you just need the right user to read it!</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>If you want to create SSH keys, you would use the ssh-keygen tool. We have a special tool that generates post-quantum cryptographic keys. The suffix is the same as ssh-keygen. It is only the first three letters that change.</td>
</tr>
<tr>
<td>JJ</td>
<br>
<td>I just spotted a mysterious gnome - he winked and vanished, or maybe he's still here? Things are getting strange, and I think we've wandered into a quantum conundrum! If you help me unravel these riddles, we might just outsmart future quantum computers. Cryptic puzzles, quirky gnomes, and post-quantum secrets-will you leap with me?</td>
</tr>
</tbody>
</table>

<h2>Acknowledgements</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<br>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>none</td>
<br>
<td>none</td>
</tr>
</tbody>
</table>