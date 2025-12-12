|[Previous Objective: Act1 Visual Firewall](/act1_visual_firewall_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Blob Storage Challenge](/act1_blob_storage_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Intro to NMAP    | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Meet Eric in the hotel parking lot for Nmap know-how and scanning secrets. Help him connect to the wardriving rig on his motorcycle! | Location: Grand Hotel parking lot |

## Solution Overview

This objective is designed to test fundamental knowledge of the Nmap tool. Nmap is an essential tool in the penetration testers toolkit, used to discover open ports and services.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Scan network targets | Discovery | T1046 | Network Service Discovery |


## Detailed Solution
<details>
<summary>Click to expand</summary>

1. Run the following command to do a default scan of the top 1000 ports: nmap 127.0.12.25

```sh
elf@bd65e17d2fa9:~$ nmap 127.0.12.25
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:28 UTC
Nmap scan report for 127.0.12.25
Host is up (0.000069s latency).
Not shown: 999 closed ports
PORT     STATE SERVICE
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 0.20 seconds
```
Answer: Port 8080

2. Run the following command to do a scan of all ports: nmap 127.0.12.25 -p-
```sh
elf@bd65e17d2fa9:~$ nmap 127.0.12.25 -p-
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:30 UTC
Nmap scan report for 127.0.12.25
Host is up (0.000046s latency).
Not shown: 65534 closed ports
PORT      STATE SERVICE
24601/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 2.10 seconds
```

Answer: Port 24601

3. Run the following command to do a scan of the range 127.0.12.20 - 127.0.12.28 to find an open port: nmap 127.0.12.20-28
```sh
elf@bd65e17d2fa9:~$ nmap 127.0.12.20-28
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:34 UTC
Nmap scan report for 127.0.12.20
Host is up (0.00018s latency).
All 1000 scanned ports on 127.0.12.20 are closed

Nmap scan report for 127.0.12.21
Host is up (0.00020s latency).
All 1000 scanned ports on 127.0.12.21 are closed

Nmap scan report for 127.0.12.22
Host is up (0.00018s latency).
All 1000 scanned ports on 127.0.12.22 are closed

Nmap scan report for 127.0.12.23
Host is up (0.00017s latency).
Not shown: 999 closed ports
PORT     STATE SERVICE
8080/tcp open  http-proxy

Nmap scan report for 127.0.12.24
Host is up (0.00017s latency).
All 1000 scanned ports on 127.0.12.24 are closed

Nmap scan report for 127.0.12.25
Host is up (0.00019s latency).
All 1000 scanned ports on 127.0.12.25 are closed

Nmap scan report for 127.0.12.26
Host is up (0.00017s latency).
All 1000 scanned ports on 127.0.12.26 are closed

Nmap scan report for 127.0.12.27
Host is up (0.00016s latency).
All 1000 scanned ports on 127.0.12.27 are closed

Nmap scan report for 127.0.12.28
Host is up (0.00019s latency).
All 1000 scanned ports on 127.0.12.28 are closed

Nmap done: 9 IP addresses (9 hosts up) scanned in 0.44 seconds
``

4. What is the service running on 127.0.12.25 TCP port 8080?  nmap -p 8080 127.0.12.25

```sh
elf@bd65e17d2fa9:~$ nmap -sV -p 8080 127.0.12.25
Starting Nmap 7.80 ( https://nmap.org ) at 2025-12-11 21:39 UTC
Nmap scan report for 127.0.12.25
Host is up (0.000091s latency).

PORT     STATE SERVICE VERSION
8080/tcp open  http    SimpleHTTPServer 0.6 (Python 3.10.12)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.82 seconds
```

Answer: http

5.  Use ncat to connect to TCP port 24601 on 127.0.12.25 and view the banner:  ncat 127.0.12.25 24601

```sh
elf@bd65e17d2fa9:~$ ncat 127.0.12.25 24601
Welcome to the WarDriver 9000!
Terminated
```

**Answer: Welcome to the WarDriver 9000!**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| nmap | 7.80 | 
| ncat | 7.80 | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | This terminal has built-in hints! |
| Eric | Speaking of tools, let me introduce you to one of the most essential weapons in any pentester's arsenal: Nmap. It's like having X-ray vision for networks, and I've set up a perfect environment for you to learn the fundamentals. Help me find and connect to the wardriving rig's service on my motorcycle!

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |

|[Previous Objective: Act1 Visual Firewall](/act1_visual_firewall_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Blob Storage Challenge](/act1_blob_storage_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |
