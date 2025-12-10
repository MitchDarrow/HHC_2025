|[Previous Objective: Act2 Mail Detective](/act2_mail_detective_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act2 Dosis Network Down](/act2_dosis_network_down_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: IDORable Bistro    | Difficulty Level: 2 |
| :-----------------------: | :--------------------------: |
| Josh has a tasty IDOR treat for you—stop by Sasabune for a bite of vulnerability. What is the name of the gnome? | Location: Sasabune  |

## Solution Overview

This objective is the exploitation of an Insecure Direct Object Reference (IDOR) vulnerability at the IDORable Bistro website. The initial reconnaissance involved scanning a QR code on a restaurant receipt that directed to https://its-idorable.hhc25-ops.com/. Inspection of the page source code revealed a hidden comment containing a sample receipt URL with a predictable identifier pattern. Using Burp Suite, the attacker intercepted HTTP requests and discovered that while initial requests used tokens, the initial request generated additional requests which exposed a simple numeric ID parameter. Using Burp Suite's Intruder feature to enumerate receipt IDs from 100 to 200, discovering that valid receipts existed from ID 100 to 152. Manual review of the enumerated responses revealed a receipt at ID 139 containing a gnomish customer name "Quibblefrost". The full name extracted from this receipt was "Bartholomew Quibblefrost". This vulnerability demonstrates a classic IDOR flaw where sequential numeric identifiers allow unauthorized access to other users' data without proper access controls. The attack required no authentication bypass and relied solely on predictable resource identifiers.


| Activity | Primary Tactic | MITRE ATT&CK Technique ID | MITRE ATT&CK Technique Name |
|----------|----------------|---------------------------|----------------------------|
| Scan QR code on restaurant receipt to identify web application | Reconnaissance | T1593.002 | Search Open Websites/Domains: Search Engines |
| Inspect HTML source code to find hidden comments and URLs | Discovery | T1213.002 | Data from Information Repositories: Sharepoint |
| Access hidden receipt URL endpoint with sample identifier | Initial Access | T1190 | Exploit Public-Facing Application |
| Use Burp Suite to intercept and analyze HTTP requests | Collection | T1557.001 | Adversary-in-the-Middle: LLMNR/NBT-NS Poisoning and SMB Relay |
| Identify exposed ID parameter in subsequent requests | Discovery | T1046 | Network Service Discovery |
| Configure Burp Intruder to enumerate receipt IDs from 100-200 | Discovery | T1083 | File and Directory Discovery |
| Send automated requests to enumerate valid receipt identifiers | Collection | T1530 | Data from Cloud Storage |
| Identify valid ID range (100-152) based on HTTP response codes | Discovery | T1595.002 | Active Scanning: Vulnerability Scanning |
| Review enumerated responses to locate gnomish customer name | Collection | T1005 | Data from Local System |
| Extract target name "Bartholomew Quibblefrost" from receipt ID 139 | Credential Access | T1552.001 | Unsecured Credentials: Credentials In Files |


## Detailed Solution
<details>
<summary>Click to expand</summary>

The following video is helpful for understanding Insecure Direct Object References: https://www.youtube.com/watch?v=hzrhtHrhwno

The receipt outside the restaurant has a QR code that points to this URL: https://its-idorable.hhc25-ops.com/

![Initial website landing page](media/image1.png)

Inspecting the page source code reveals a comment:

![HTML source code showing hidden comment](media/image2.png)


Trying the URL from the comment: https://its-idorable.hhc25-ops.com/receipt/a1b2c3d4

![Sample receipt page accessed via hidden URL](media/image3.png)

Using Burp Suite to view the requests. The first request uses a token, but a subsequent request exposes the ID parameter.

![Burp Suite showing requests with exposed ID parameter](media/image4.png)

Using Burp's Intruder, send requests with values for ID from 100 to 200:

At ID=153, 404 responses begin, so valid receipts are from 100 to 152.

Reviewing the responses, a gnomish name "Quibblefrost" appears in ID=139.

![Receipt showing Bartholomew Quibblefrost name at ID=139](media/image5.png)

**Answer: Bartholomew Quibblefrost**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| Burp Suite Community Edition |  | 


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | I have been seeing a lot of receipts lying around with some kind of QR code on them. I am pretty sure they are for Duke Dosis's Holiday Bistro. Interesting...see you if you can find one and see what they are all about... |
| Santa | I had tried to scan one of the QR codes and it took me to somebody's meal receipt! I am afraid somebody could look up anyone's meal if they have the correct ID...in the correct place. |
| Santa | Sometimes...developers put in a lot of effort to anonymyze information by using randomly generated identifiers...but...there are also times where the "real" ID is used in a separate Network request... |
| Josh | I need your help with something urgent. A gnome came through Sasabune today, poorly disguising itself as human - apparently asking for frozen sushi, which is almost as terrible as that fusion disaster I had to endure that one time. Based on my previous work finding IDOR bugs in restaurant payment systems, I suspect we can exploit a similar vulnerability here. I was at a talk recently and learned some interesting things about some of these payment systems. Let's use that receipt to dig deeper and unmask this gnome's true identity. |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act2 Mail Detective](/act2_mail_detective_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act2 Dosis Network Down](/act2_dosis_network_down_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |
