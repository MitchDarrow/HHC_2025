|[Previous Objective: Act2 Name](/act3_hackagnome_mjd.md)  |   [Home Page](/index.md) | [Next Objective: Act 2 IDORable Bistro](/act2_idorable_bistro_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Mail Detective    | Difficulty Level: 2 |
| :-----------------------: | :--------------------------: |
| Official Description | Location:   |

## Solution Overview

This objective investigates suspicious emails using IMAP (Internet Message Access Protocol) commands via curl. The investigator connected to an IMAP server running on localhost port 143 using telnet protocol. Authentication was performed using the credentials "dosismail" with password "holidaymagic". After successful login, the investigator selected the "Spam" mailbox to examine suspicious messages. Multiple search commands were executed to find emails containing HTTP URLs, with the search for "HTTP" (uppercase) returning positive results. The investigator used the IMAP FETCH command to retrieve the full body of message ID 2. Examination of the email body revealed embedded JavaScript code containing a suspicious variable assignment. The JavaScript code contained a URL pointing to "https://frostbin.atnas.mail/api/paste", which appears to be a pastebin-style service potentially used for command and control or data exfiltration. This investigation demonstrates how IMAP protocol commands can be used for email forensics and threat hunting.


| Activity | Primary Tactic | MITRE ATT&CK Technique ID | MITRE ATT&CK Technique Name |
|----------|----------------|---------------------------|----------------------------|
| Connect to IMAP server on localhost port 143 using telnet | Discovery | T1046 | Network Service Discovery |
| Authenticate to email server using credentials (dosismail/holidaymagic) | Initial Access | T1078.003 | Valid Accounts: Local Accounts |
| Search for emails containing "http:" and "HTTP" text strings | Discovery | T1083 | File and Directory Discovery |
| Examine email content for suspicious URLs and scripts | Discovery | T1213.002 | Data from Information Repositories: Sharepoint |
| Extract malicious URL "https://frostbin.atnas.mail/api/paste" | Collection | T1005 | Data from Local System |


## Detailed Solution
<details>
<summary>Click to expand</summary>

This is a helpful resource for reading messages using curl: https://everything.curl.dev/usingcurl/reademail.html

![IMAP server connection interface](images/image1.png)

Connect to the server using curl:

```bash
telnet://localhost:143
```

![Terminal showing IMAP connection command](images/image2.png)

Login to the server:

```
a001 login dosismail holidaymagic
```

![IMAP login response showing successful authentication](images/image3.png)


```
A002 select Spam
A003 search text "http:"
A004 search text "HTTP"
A005 fetch 2 body[]
```

This search returns a match.

![IMAP fetch command showing email message body](images/image4.png)

Scrolling down the body is:

![Email body content revealing JavaScript variable with URL](images/image5.png)

```javascript
var pastebinUrl = "https://frostbin.atnas.mail/api/paste";
```

**Answer: https://frostbin.atnas.mail/api/paste**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| curl |  | 
|  |  |
|  |  | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
|  |  |
|  |  |
|  |  |
|  |  |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act2 Name](/act3_hackagnome_mjd.md)  |   [Home Page](/index.md) | [Next Objective: Act 2 IDORable Bistro](/act2_idorable_bistro_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |
