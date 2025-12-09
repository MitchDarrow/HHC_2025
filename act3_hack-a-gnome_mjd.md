|[Previous Objective](HHC_2025_Template/act3_gnome_tea_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_snowcat_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Hack-a-Gnome    | Difficulty Level: 3 |
| :-----------------------: | :--------------------------: |
| Davis in the Data Center is fighting a gnome army—join the hack-a-gnome fun. | Location: Data Center  |

## Solution Overview

High level executive summary of how the objective was solved. Details belong in the detail section.

| Methods Used             | MITRE ATT&CK Framework Methods |
| :-----------------------: | :--------------------------------: |
|   |   |
|   |   |
|   |   |


## Detailed Solution
<details>
<summary>Click to expand</summary>

Step by step solution complete with any code used
  
![Sample image alt text](/images/objectivename_purpose.jpg) 


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
|  |  | 
|  |  |
|  |  | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Sometimes, client-side code can interfere with what you submit. Try proxying your requests through a tool like Burp Suite or OWASP ZAP. You might be able to trigger a revealing error message. |
| Santa | Oh no, it sounds like the CAN bus controls are not sending the correct signals! If only there was a way to hack into your gnome's control stats/signal container to get command-line access to the smart-gnome. This would allow you to fix the signals and control the bot to shut down the factory. During my development of the robotic prototype, we found the factory's pollution to be undesirable, which is why we shut it down. If not updated since then, the gnome might be running on old and outdated packages. |
| Santa | I actually helped design the software that controls the factory back when we used it to make toys. It's quite complex. After logging in, there is a front-end that proxies requests to two main components: a backend Statistics page, which uses a per-gnome container to render a template with your gnome's stats, and the UI, which connects to the camera feed and sends control signals to the factory, relaying them to your gnome (assuming the CAN bus controls are hooked up correctly). Be careful, the gnomes shutdown if you logout and also shutdown if they run out of their 2-hour battery life (which means you'd have to start all over again). |
| Santa | There might be a way to check if an attribute IS_DEFINED on a given entry. This could allow you to brute-force possible attribute names for the target user's entry, which stores their password hash. Depending on the hash type, it might already be cracked and available online where you could find an online cracking station to break it. |
| Santa | Once you determine the type of database the gnome control factory's login is using, look up its documentation on default document types and properties. This information could help you generate a list of common English first names to try in your attack. |
| Santa | Nice! Once you have command-line access to the gnome, you'll need to fix the signals in the canbus_client.py file so they match up correctly. After that, the signals you send through the web UI to the factory should properly control the smart-gnome. You could try sniffing CAN bus traffic, enumerating signals based on any documentation you find, or brute-forcing combinations until you discover the right signals to control the gnome from the web UI. |
| Chris | Hey, I could really use another set of eyes on this gnome takeover situation. Their systems have multiple layers of protection now - database authentication, web application vulnerabilities, and more! But every system has weaknesses if you know where to look. Ready to help me turn one of these rebellious bots against its own kind? |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
|  |  |
|  |  |


|[Previous Objective](HHC_2025_Template/act3_gnome_tea_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_snowcat_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
