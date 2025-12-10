|[Previous Objective: Act2 Dosis Network Down](/act2_dosis_network_down_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 2 Quantgnome Leap](/act2_quantgnome_leap_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Rogue Gnome Identity Provider | Difficulty Level: 2 |
| :-----------------------: | :--------------------------: |
| Hike over to Paul in the park for a gnomey authentication puzzle adventure. What malicious firmware image are the gnomes downloading? | Location: Dosis Neighborhood Park  |

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
| Santa | If you need to host any files for the attack, the server is running a webserver available locally at http://paulweb.neighborhood/ . The files for the site are stored in ~/www |
| Santa | https://github.com/ticarpi/jwt_tool/wiki and https://portswigger.net/web-security/jwt have some great information on analyzing JWT's and performing JWT attacks. |
| Santa | It looks like the JWT uses JWKS. Maybe a JWKS spoofing attack would work. |
| Paul | As a pentester, I proper love a good privilege escalation challenge, and that's exactly what we've got here. I've got access to a Gnome's Diagnostic Interface at gnome-48371.atnascorp with the creds gnome:SittingOnAShelf, but it's just a low-privilege account. The gnomes are getting some dodgy updates, and I need admin access to see what's actually going on. Ready to help me find a way to bump up our access level, yeah? |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| eucrates |  |


|[Previous Objective: Act2 Dosis Network Down](/act2_dosis_network_down_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 2 Quantgnome Leap](/act2_quantgnome_leap_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |
