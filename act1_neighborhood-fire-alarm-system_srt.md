---
layout: default
title: act1_neighborhood-fire-alarm-system_srt
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
<th>Objective: Neighborhood Watch Bypass</th>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Assist Kyle at the old data center with a fire alarm that just won't chill.</td>
<td>Location: Data Center</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
Kyle says that he has been locked out of the neighborhood fire alarm system, which has been giving erroneous data ever since the gnomes came to town. We must restore access by elevating our current access to admin privileges. 
</p>
<br>
Enumeration of scripts in <code>$PATH</code> reveals one script at <code>/usr/local/bin/system_status.sh</code>. <code>sudo --list</code> tells us that this binary can be executed as root for the current user via <code>sudo NOPASS</code>. The script uses local paths to call commands such as <code>free</code>, <code>df</code>, and <code>w</code>. We can exploit this behavior to replace the global binary with a script of the same name containing a simple privilege escalation payload.
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
<td>Enumerate <code>$PATH</code></td>
<td>DIscovery</td>
<td>T1083</td>
<td>File and Directory Discovery</td>
</tr>
<tr>
<td>Check Sudo Privileges</td>
<td>Discovery</td>
<td>T1033</td>
<td>System Owner and User Discovery</td>
</tr>
<tr>
<td>Hijack Binary Path</td>
<td>Privilege Escalation</td>
<td>T1574.007</td>
<td>Hijack Execution Flow: Path Interception by <code>$PATH</code> Environment Varaiable</td>
</tr>
<tr>
<td>Execute Sudo</td>
<td>Privilege Escalation</td>
<td>T1548.003</td>
<td>Abuse Elevation Control Mechanism: Sudo and Sudo Caching</td>
</tr>
</tbody>
</table>
<br>
<h2>Detailed Solution</h2>
<details>
<br>
<summary>Click to expand</summary>
<br>
We are dropped into bash shell with basic user access. We notably are given a local <code>bin/</code> directory, which is included in the list of directories from which we can call scripts and binaries without any directory prefix (colloquially known as our our <code>$PATH</code>). The content of our <code>$PATH</code> environment variable can be enumerated via <code>echo $PATH</code>. We can further drill down to find any scripts in our path with the following bash one liner:
<pre><code class="language-sh">
for d in <code>echo $PATH | tr ":" "\n"</code>; do find $d -name "*.sh" 2>/dev/null; done
</code></pre>
This identifies the <code>/usr/local/bin/system_status.sh</code> script as being present in our <code>$PATH</code>. 
Exploring this line of inquiry further, we want to enumerate the <code>sudo</code> privileges available to our user. The <code>sudo --list</code> command reveals two key insights:
<ol>
<li><code>/home/chiuser/bin</code>, our local <code>bin/</code> directory, is included in the sudo <code>secure_path</code>.</li>
<li>The <code>chiuser</code> user may run <code>/usr/local/bin/system_status.sh</code> as root (via <code>sudo</code>) without a password check. </li>
</ol>
To tie these pieces together, we should really understand what <code>/usr/local/bin/system_status.sh</code> is doing under the hood. This script calls a number of seemingly harmless commands to monitor system resource usage. The script does have one key weakness, which is that it uses local paths to call these commands. Instead of using an explicit path like <code>/bin/df</code>, the script simply uses the command <code>df</code>. The script also calls a custom command <code>w</code>, which will be leveraged within our attack chain. 
<p>
<strong>All of these factors in concert present a fairly straightforward path to privilege escalation:</strong>
<br>
</p>
<ol>
<li>We first place a basic privilege escalation payload into a  new <code>/tmp/w</code> file. For this challenge, our file simply contained the following:</li>

<pre><code class="language-sh">
#!/bin/bash
/bin/bash -p
</code></pre>
<p>
<br>
executing this file with root permissions will spawn a new shell as the root user
</p>
<br>
<li>We move this file into our <code>/home/chiuser/bin/</code> directory and <code>cd</code> into this directory</li>
<li>We call <code>sudo /usr/local/bin/system_status.sh</code> in this local directory with our malicious <code>w</code> script file. When the <code>system_status.sh</code> script runs, it calls our local <code>w</code> file before searching the rest of the <code>$PATH</code>, resulting in execution of our script with root-level permissions. </li>
</ol>
To complete the challenge, we need to run the <code>/home/chiuser/bin/runtoanswer</code> binary as the root user, which promptly restores administrative control over the alarm system to the neighborhood!
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
<td>bash</td>
<td>5.3</td>
</tr>
</tbody>
</table>