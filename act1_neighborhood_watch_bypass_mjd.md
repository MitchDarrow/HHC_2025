---
layout: default
title: act1_neighborhood_watch_bypass_mjd
---
<table>
<thead>
<tr>
<th><a href="/HHC_2025/act1_its_all_about-defang_mjd.html">Previous Objective: Act1 Its All About Defang</a></th>
<br>
<th><a href="/HHC_2025/index.html">Table of Contents</a></th>
<br>
<th><a href="/HHC_2025/act1_santas_gift-tracking_service_port_mystery_mjd.html">Next Objective: Act 1 Santa's Gift-Tracking Service Port</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

<table>
<thead>
<tr>
<th>Objective: Neighborhood Watch Bypass</th>
<br>
<th>Difficulty Level: 1</th>
</tr>
</thead>
<tbody>
<tr>
<td>Assist Kyle at the old data center with a fire alarm that just won't chill.</td>
<br>
<td>Location: Data Center</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

This objective identifies a path hijacking privilege escalation attack against a Linux system where the user "chiuser" had limited sudo privileges. Initial reconnaissance revealed a bash script called <code>system_status</code> that executed the <code>ps</code> command to display process information. Investigation of the user's sudo privileges using <code>sudo -l</code> revealed critical security misconfigurations in the sudoers file. The secure_path configuration included the user's home directory bin folder (<code>/home/chiuser/bin</code>) in the PATH, and crucially, the PATH environment variable was preserved when executing commands with sudo. This configuration created a path hijacking vulnerability where a malicious binary could be placed in <code>~/bin</code> to intercept legitimate command calls. The attacker created a fake <code>ps</code> binary in the <code>~/bin</code> directory containing a simple bash script that spawned an interactive shell. When the <code>system_status</code> script was executed with sudo privileges, it called the <code>ps</code> command without using an absolute path, causing the system to execute the malicious version from <code>~/bin</code> first. Because the script ran with root privileges, the spawned bash shell inherited those elevated permissions, granting the attacker full root access to the system.


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
<td>Enumerate running processes and system scripts during reconnaissance</td>
<br>
<td>Discovery</td>
<br>
<td>T1057</td>
<br>
<td>Process Discovery</td>
</tr>
<tr>
<td>Execute <code>sudo -l</code> to enumerate sudo privileges and configurations</td>
<br>
<td>Discovery</td>
<br>
<td>T1087.001</td>
<br>
<td>Account Discovery: Local Account</td>
</tr>
<tr>
<td>Recognize PATH preservation as privilege escalation vector</td>
<br>
<td>Privilege Escalation</td>
<br>
<td>T1548.003</td>
<br>
<td>Abuse Elevation Control Mechanism: Sudo and Sudo Caching</td>
</tr>
<tr>
<td>Create malicious ps binary in user's ~/bin directory</td>
<br>
<td>Persistence</td>
<br>
<td>T1574.007</td>
<br>
<td>Hijack Execution Flow: Path Interception by PATH Environment Variable</td>
</tr>
<tr>
<td>Spawn root shell through sudo-executed malicious script</td>
<br>
<td>Privilege Escalation</td>
<br>
<td>T1548.003</td>
<br>
<td>Abuse Elevation Control Mechanism: Sudo and Sudo Caching</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

Access the terminal provided:

<img src="/HHC_2025/images/neighborhoodwatchbypass_instructions.jpg" alt="Terminal access showing initial shell prompt">

During reconnaissance, the bash script <code>system_status</code> is discovered. The script is running a <code>ps</code> command.

<img src="/HHC_2025/images/neighborhoodwatchbypass_script.jpg" alt="System status script showing ps command execution">

Let's see what chiuser can do:

<pre><code class="language-bash">
<br>
sudo -l
<br>
</code></pre>

This is useful:

<pre><code class="language-">
<br>
Matching Defaults entries for chiuser on 633a785ffc6c:
<br>
    env_reset, mail_badpass,
<br>
    secure_path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin,
<br>
    use_pty,
<br>
    secure_path=/home/chiuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin,
<br>
    env_keep+="API_ENDPOINT API_PORT RESOURCE_ID HHCUSERNAME",
<br>
    env_keep+=PATH
<br>
</code></pre>

<ul>
<li>The <code>~/bin</code> directory is <strong>included</strong> in the secure path</li>
<br>
<li>The PATH is <strong>preserved</strong> when using sudo</li>
</ul>

This means if you create a <strong>fake version of a command</strong> (like <code>ps</code>, <code>head</code>, <code>grep</code>, etc.) in <code>~/bin</code>, and <code>system_status.sh</code> calls that command <strong>without an absolute path</strong>, it might run <strong>the malicious version</strong> instead - <strong>as root</strong>.

Executing the Path Hijacking Attack

Create a malicious script:

<pre><code class="language-bash">
<br>
echo -e '#!/bin/bash\n/bin/bash' > ~/bin/ps
<br>
chmod +x ~/bin/ps
<br>
</code></pre>

The path hijack attack works and the malicious version of the <code>ps</code> command runs, creating a new shell with root privileges.

<img src="/HHC_2025/images/neighborhoodwatchbypass_answer.jpg" alt="Successful privilege escalation showing root shell access">

Successfully obtained a new shell with root privileges and can run the <code>runtoanswer</code> link, which runs the restore_fire_alarm.

<strong>Answer:Successfully obtained a new shell with root privileges and can run the <code>runtoanswer</code> link.</strong>

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
<td>bash</td>
<br>
<td>5.2.37(1)-release</td>
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
<td>You know, Sudo is a REALLY powerful tool. It allows you to run executables as ROOT!!! There is even a handy switch that will tell you what powers your user has.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Be careful when writing scripts that allow regular users to run them. One thing to be wary of is not using full paths to executables...these can be hijacked.</td>
</tr>
<tr>
<td>Kyle</td>
<br>
<td>Anyway, I could use some help here. This fire alarm keeps going nuts but there's no fire. I checked. I think someone has locked us out of the system. Can you see if you can get back in?</td>
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


<table>
<thead>
<tr>
<th><a href="/HHC_2025/act1_its_all_about-defang_mjd.html">Previous Objective: Act1 Its All About Defang</a></th>
<br>
<th><a href="/HHC_2025/index.html">Table of Contents</a></th>
<br>
<th><a href="/HHC_2025/act1_santas_gift-tracking_service_port_mystery_mjd.html">Next Objective: Act 1 Santa's Gift-Tracking Service Port</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>
