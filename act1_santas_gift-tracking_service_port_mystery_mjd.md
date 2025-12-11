| [Previous Objective: Act 1 Neighborhood Watch Bypass](/act1_neighborhood_watch_bypass_mjd.md) |   [Table of Contents](/index.md) | [Previous Objective: Act 1 Visual Networking](/act1_visual_networking_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Santa's Gift-Tracking Service Port   | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Chat with Yori near the apartment building about Santa's mysterious gift tracker and unravel the holiday mystery.| Location: Apratment Building |

## Solution Overview

High level executive summary of how the objective was solved. Details belong in the detail section.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |


## Detailed Solution
<details>
<summary>Click to expand</summary>

The objective is to:

1. Identify the port that the santa_tracker process is running on

2. Connecct to the port and verify the servide is running

![Objective Instructions](/images/santatracking_instructions.jpg) 

Use the SS tool to discover the port using the command:
```sh
ss -tlnp
```

There is a service running on port 12321
 
Use curl to connect:
  
![Sample image alt text](/images/santatracker_connect.jpg) 


```sh
curl -I http://0.0.0.0:12321
```
The service responds with a 200 OK and Content-Type of application/json

**Answer: Flag or Answer**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| ss | iproute2-6.13.0| 
| curl | 8.11.0 |


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Since we don't have a web browser to connect to this HTTP service...There is another common tool that you can use from the cli. |
| Yuri | Think you can check out this terminal for me? I need to use cURL to access the gift tracker system, but it has me stumped. |


## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


| [Previous Objective: Act 1 Neighborhood Watch Bypass](/act1_neighborhood_watch_bypass_mjd.md) |   [Table of Contents](/index.md) | [Previous Objective: Act 1 Visual Networking](/act1_visual_networking_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |
