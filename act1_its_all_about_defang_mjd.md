|[Previous Objective: Act1 Holiday Hack Orientation](/act1_orientation_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Neighborhood Watch Bypass](/act1_neighborhood_watch_bypass_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Its All About Defang | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Find Ed Skoudis upstairs in City Hall and help him troubleshoot a clever phishing tool in his cozy office. | Location: City Hall |

## Solution Overview

Defanging Indicators of Compromise (IoC)
Defanging is a cybersecurity practice of deliberately modifying malicious indicators such as URLs, IP addresses, email addresses, and domain names to render them non-functional while preserving their investigative value. This technique prevents accidental clicks, automated processing, or unintended execution when sharing threat intelligence in reports, emails, or public forums. Common defanging methods include replacing dots with "[.]" in domains (example[.]com), adding brackets to protocols (hxxp:// or hxxps://), replacing "@" symbols with "[at]" in email addresses, and modifying IP addresses (192[.]168[.]1[.]1). The practice is essential for security analysts, incident responders, and threat intelligence teams who need to document and communicate about malicious infrastructure without risking accidental exposure or triggering security controls. Defanging allows organizations to safely share IoCs across teams, with partners, or in public threat reports while maintaining the ability to quickly "refang" or restore the indicators to their original functional form when needed for analysis or blocking.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Identify malicious URLs, domains, and IP addresses from security incidents | Discovery | T1590 | Gather Victim Network Information |

## Detailed Solution
<details>
<summary>Click to expand</summary>

Using the Extract IOCs tab:

Set the domain regex to: \b(?:[a-zA-Z0-9-]+\.)*icicleinnovations\.([a-zA-Z]{2,})\b

Set the IP Address Regex to: (?<=\b(?:mail|core)?\.?icicleinnovations\.mail\s*\()\d{1,3}(?:\.\d{1,3}){3}(?=\))
 
Set the URL regex to: https?:\/\/[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(:[0-9]+)?(/[^\s]*\.exe)\b
 
Set the Email address regex to: \b[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)*icicleinnovations\.[a-zA-Z]{2,}\b
 
To Defang the IOCs:

Use this combined Sed command: s/http/hxxp/g; s/@/[@]/g; s#://#[://]#g; s/\./[.]/g

![Applying the combined Regex to Defang the IOCs](/images/itsallaboutdefang_solution.jpg)

The following were defanged: 3 domains, 2 addresses, 2 URLs, and 2 email addresses 

**Answer: Defanged: 3 domains, 2 addresses, 2 URLs, and 2 email addressesr**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| sed | 4.9 | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | The PTAS does a pretty good job at defanging, however, the feature we are still working on is one that defangs ALL scenarios. For now, you will need to write a custom sed command combining all defang options. |
| Santa | Remember, the new Phishing Threat Analysis Station (PTAS) is still under construction. Even though the regex patterns are provided, they haven't been fine tuned. Some of the matches may need to be manually removed. |
| Ed | Oh gosh, I could talk for hours about this stuff but I really need your help! The team has been working on this new SOC tool that helps triage phishing emails...and there are some...issues. We have had some pretty sketchy emails coming through and we need to make sure we block ALL of the indicators of compromise. Can you help me? No pressure... |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act1 Holiday Hack Orientation](/act1_orientation_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Neighborhood Watch Bypass](/act1_neighborhood_watch_bypass_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |
