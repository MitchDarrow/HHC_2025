|[Previous Objective: Act1 Santa’s Gift-Tracking Service Port Mystery](/act1+santas_gift-tracking_service_port_mystery_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Visual Firewall](/act1visual_firewall_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Visual Neworking    | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Skate over to Jared at the frozen pond for some network magic and learn the ropes by the hockey rink | Location: The Pond|

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

1. Build an IPv4 DNS Request:
Port: 53

Domain: visual-networking.holidayhackchallenge.com

Request Type: A

2. Build a 3-Way Handshake:

Client sends a packet with the TCP SYN flag set to the server.

The Server response with a packet with the TCP ACK and SYN flags set to the client.

The client responds with a packed with the TCP ACK flag to the server, completing the handshake.

3. Build an HTTP GET request:

HTTP verb: GET

HTTP Version: HTTP/1.1

Host: visual-networking.holidayhackchallenge.com

User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0

4. Build a TLS Handshake:

Client Hello >>
<< Server Hello
<< Server Certificate
Client Key Exchange >>
<< Server Change Cipher Spec
<< Fnished

5. Build an HTTPS GET request:

HTTP verb: GET

HTTP Version: HTTP/1.1

Host: visual-networking.holidayhackchallenge.com

User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0

**Answer: Complete all 5 Challenges**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| none | none | 


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Thisterminal has built-in hints! |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |

|[Previous Objective: Act1 Santa’s Gift-Tracking Service Port Mystery](/act1+santas_gift-tracking_service_port_mystery_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Visual Firewall](/act1visual_firewall_mjd.md)|
| :----------------------- | :--------------------------------: | --------------------------------: |
