---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act1_its_all_about-defang_mjd.html">Previous Objective: Act1 Its All About Defang</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act1_santas_gift-tracking_service_port_mystery_mjd.html">Next Objective: Act 1 Santa's Gift-Tracking Service Port</a></th></table>
---
<table>
<thead><tr><th>Objective: Neighborhood Watch Bypass</th> <th>Difficulty Level: 1</th><tr><td>Assist Kyle at the old data center with a fire alarm that just won't chill.</td> <td>Location: Data Center</td></table>
<h2>Solution Overview</h2>
This objective identifies a path hijacking privilege escalation attack against a Linux system where the user "chiuser" had limited sudo privileges. Initial reconnaissance revealed a bash script called <code>system_status</code> that executed the <code>ps</code> command to display process information. Investigation of the user's sudo privileges using <code>sudo -l</code> revealed critical security misconfigurations in the sudoers file. The secure_path configuration included the user's home directory bin folder (<code>/home/chiuser/bin</code>) in the PATH, and crucially, the PATH environment variable was preserved when executing commands with sudo. This configuration created a path hijacking vulnerability where a malicious binary could be placed in <code>~/bin</code> to intercept legitimate command calls. The attacker created a fake <code>ps</code> binary in the <code>~/bin</code> directory containing a simple bash script that spawned an interactive shell. When the <code>system_status</code> script was executed with sudo privileges, it called the <code>ps</code> command without using an absolute path, causing the system to execute the malicious version from <code>~/bin</code> first. Because the script ran with root privileges, the spawned bash shell inherited those elevated permissions, granting the attacker full root access to the system. 
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Enumerate running processes and system scripts during reconnaissance</td> <td>Discovery</td> <td>T1057</td> <td>Process Discovery</td><tr><td>Execute <code>sudo -l</code> to enumerate sudo privileges and configurations</td> <td>Discovery</td> <td>T1087.001</td> <td>Account Discovery: Local Account</td><tr><td>Recognize PATH preservation as privilege escalation vector</td> <td>Privilege Escalation</td> <td>T1548.003</td> <td>Abuse Elevation Control Mechanism: Sudo and Sudo Caching</td><tr><td>Create malicious ps binary in user's ~/bin directory</td> <td>Persistence</td> <td>T1574.007</td> <td>Hijack Execution Flow: Path Interception by PATH Environment Variable</td><tr><td>Spawn root shell through sudo-executed malicious script</td> <td>Privilege Escalation</td> <td>T1548.003</td> <td>Abuse Elevation Control Mechanism: Sudo and Sudo Caching</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>Access the terminal provided:</p>
<p>!<a href="/HHC_2025/images/neighborhoodwatchbypass_instructions.jpg">Terminal access showing initial shell prompt</a></p>
<p>During reconnaissance, the bash script <code>system_status</code> is discovered. The script is running a <code>ps</code> command.</p>
<p>!<a href="/HHC_2025/images/neighborhoodwatchbypass_script.jpg">System status script showing ps command execution</a></p>
<p>Let's see what chiuser can do:</p>
<p><pre><code></p>
<p></code></pre></p>
<p>This is useful:</p>
<p><pre><code></p>
<p></code></pre></p>
<p>- The <code>~/bin</code> directory is <strong>included</strong> in the secure path</p>
<p>- The PATH is <strong>preserved</strong> when using sudo</p>
<p>This means if you create a <strong>fake version of a command</strong> (like <code>ps</code>, <code>head</code>, <code>grep</code>, etc.) in <code>~/bin</code>, and <code>system_status.sh</code> calls that command <strong>without an absolute path</strong>, it might run <strong>the malicious version</strong> instead â€” <strong>as root</strong>.</p>
<p>Executing the Path Hijacking Attack</p>
<p>Create a malicious script:</p>
<p><pre><code></p>
<p></code></pre></p>
<p>The path hijack attack works and the malicious version of the <code>ps</code> command runs, creating a new shell with root privileges.</p>
<p>!<a href="/HHC_2025/images/neighborhoodwatchbypass_answer.jpg">Successful privilege escalation showing root shell access</a></p>
<p>Successfully obtained a new shell with root privileges and can run the <code>runtoanswer</code> link, which runs the restore_fire_alarm.</p>
<p><strong>Answer:Successfully obtained a new shell with root privileges and can run the <code>runtoanswer</code> link.</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>bash</td> <td>5.2.37(1)-release</td> <td></td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>You know, Sudo is a REALLY powerful tool. It allows you to run executables as ROOT!!! There is even a handy switch that will tell you what powers your user has.</td><tr><td>Santa</td> <td>Be careful when writing scripts that allow regular users to run them. One thing to be wary of is not using full paths to executables...these can be hijacked.</td><tr><td>Kyle</td> <td>Anyway, I could use some help here. This fire alarm keeps going nuts but there's no fire. I checked. I think someone has locked us out of the system. Can you see if you can get back in?</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act1_its_all_about-defang_mjd.html">Previous Objective: Act1 Its All About Defang</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act1_santas_gift-tracking_service_port_mystery_mjd.html">Next Objective: Act 1 Santa's Gift-Tracking Service Port</a></th></table>