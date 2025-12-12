---
layout: default
title: act1_visual_firewall_mjd
---
|[Previous Objective: Act1 Visual Networking](/act1_visual_networking_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Intro to NMAP](/act1_intro_to_nmap_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Visual Firewall    | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Find Elgee in the big hotel for a firewall frolic and some techy fun. | Location: Grand Hotel  |

## Solution Overview

The objective is to correctly configure firewall rules to best security practices. Without proper firewall configuration, security analysts lose a crucial control point for preventing, detecting, and responding to threats. 

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Review existing firewall rules and policies | Discovery | T1082 | System Information Discovery |


## Detailed Solution
<details>
<summary>Click to expand</summary>

Rule: Internet to DMZ: Allow only HTTP and HTTPS traffic

Rule: DMZ to Internal: Allow HTTP, HTTPS and SSH traffic

Rule: Internal to DMZ: Allow HTTP, HTTPS and SSH traffic

Rule: Internal to Cloud: Allow HTTP, HTTPS, SSH and SMTP traffic

Rule: Internal to Workstations: Allow all traffic types

Rule: Internet to Internal: Block direct Internet to Internal access

**Answer: Configure rules to Security Best Practice**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| none | none | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | This terminal has built-in hints. |
| Elgee | Welcome to my little corner of network security! finger guns I've whipped up something sweeter than my favorite whoopie pie - an interactive firewall simulator that'll teach you more in ten minutes than most textbooks do in ten chapters. Don't worry about breaking anything; that's half the fun of learning! Ready to dig in? |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |

|[Previous Objective: Act1 Visual Networking](/act1_visual_networking_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Intro to NMAP](/act1_intro_to_nmap_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |
