|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Schrödinger's Scope   | Difficulty Level: 3 |
| :-----------------------: | :--------------------------: |
| Kevin in the Retro Store ponders pentest paradoxes—can you solve Schrödinger's Scope?| Location: Retro Store  |

## Solution Overview

The objective is to conduct a penetration test of a Neighborhood College Registration system. The test is scoped to a specific path of the application, accessing other paths is limited by an active monitoring system. When a threshold is reached, the engagement is reset. This resets the cookies that track the session and achievements. When this occurs, any vulnerabilities achieved are no longer logged and must be redone. The testing begins with reconnaisance of the application. Vulnerabilities are tested and exploited if possible.

| Activity           | Primary Tactic | Technique ID             | Technique Name |
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



```sh
bash script code block
```

Ordered list:
1. Item 1
2. Item 2
3. Item 3

Unordered list:

- Item
- Item
- Item
/usr/local/weather/temperature

**Answer: Flag or Answer**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| Edge Developer Tools |  | 
| Burpsuite Community Edition |  |
|  |  | 

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
| khesperus |  |
| eucrates |  |


|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
