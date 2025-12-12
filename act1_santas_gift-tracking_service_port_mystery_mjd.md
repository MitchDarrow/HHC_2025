---
layout: default
title: act1_santas_gift-tracking_service_port_mystery_mjd
---
| [Previous Objective: Act 1 Neighborhood Watch Bypass](/act1_neighborhood_watch_bypass_mjd.md) |   [Table of Contents](/index.md) | [Previous Objective: Act 1 Visual Networking](/act1_visual_networking_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Santa's Gift-Tracking Service Port   | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Chat with Yori near the apartment building about Santa's mysterious gift tracker and unravel the holiday mystery.| Location: Apratment Building |

## Solution Overview

This objective is a network service discovery and verification task focused on identifying and confirming the operational status of a process. The investigator used the ss (socket statistics) command-line utility, which is part of the iproute2 package, to enumerate active network connections and listening ports on the local system. The specific command ss -tlnp was executed with flags to show TCP connections (-t), listening sockets (-l), numeric addresses without DNS resolution (-n), and associated process information (-p). The output revealed a service actively listening on port 12321, which was identified as the Santa Tracker process. To verify the service was functioning properly, the investigator used curl with the -I flag to send an HTTP HEAD request to the local address at http://0.0.0.0:12321. The service responded successfully with an HTTP 200 OK status code and indicated a Content-Type header of application/json, confirming the service was running and responding to requests. 

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Execute ss -tlnp command to enumerate network connections | Discovery | T1049 | System Network Connections Discovery |
| Use curl to send HTTP HEAD request to identified port | Discovery | T1046 | Network Service Discovery |

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

**Answer: The service is running**

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
