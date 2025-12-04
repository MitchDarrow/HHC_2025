|[Previous Objective](HHC_2025_Template/act3_freeski_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [About BerryDunn](HHC_2025_Template/hhc_2025_berrydunn.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Snowblind Ambush    | Difficulty Level: 5 |
| :-----------------------: | :--------------------------: |
| Head to the Hotel to stop Frosty's plan. Torkel is waiting at the Grand Web Terminal. | Location: Hotel |

## Solution Overview

High level executive summary of how the objective was solved. Details belong in the detail section.

| Methods Used             | MITRE ATT&CK Framework Methods | Methods Used             | MITRE ATT&CK Framework Methods |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Gain Access to web application: Leak Sensitive Information | Reconnaissance | T1589 | Gather Victim Identity Information |
| Explore SSTI and achieve RCE: Insecure Software | Execution | T1190 | Exploit Public-Facing Application |
| Achieve Shell Access: Insecure File Upload	Resource | Development | T1608.001 | Upload Malware |
| Exfiltrate Data | Exfiltration | T1041 | Exfiltration Over C2 Channel |
| Decode PNG file | Defense Evasion | T1140 | Deobfuscate/Decode Files or Information |
| Crack hashed password for Root | Credential Access | T1110.002 | Password Cracking |
| Escalate Privileges | Privilege Escalation | T1548 | Abuse Elevation Control Mechanism |

## Detailed Solution
<details>
<summary>Click to expand</summary>
##Step One: Gain Access to web application : Leak Sensitive Information
  
Initial discovery activities of the website uncovered the following:
   
  - The landing page code included a javascript file that was not actually loaded, egg.js
    
    ![Landing Page Code](/images/snowblind_egg.js.jpg)
     
  - Reviewing the code gives a hint: "AI Gnomes do not know the difference between left and right"
    
    ![Chatbot Admin Password](/images/snowblind_egghint.jpg)
    
   - AI chatbot gives redacted and conflicting hints about the password for the application login
   
   Conversations with the chatbot revealed that it had information about the application admin account in the form of hints. Some of the hints are conflicting, making them unreliable. The chatbot redacts phrases, so it knows the password. The chatbot reveals the information when prompted to spell the password one character per line, defeating the redaction mechanisms. The password works for login, and additional functionality is available to explore. The left and right hint works as well. The chatbot will spell the password in reverse order.
   *admin password: an_elf_and_password_on_a_bird*
   
    ![Landing Page Code](/images/snowblind_adminpassword.jpg)
 
  - File upload mechanism
    The profile page contains a file upload mechanism. While the page indicates only allowed filetypes, it is possible to upload a file that contains script code. Upon upload, the file is renamed to admin_XXXXXXXXXXXXXXXX.png, with the placeholder changing with every upload. This is a way to get a payload into the application, but not a way to trigger it.

    ![File Upload](/images/snowblind_fileupload.jpg)
    
  - Parameter used after file upload
  After upload the page redirects and uses a parameter username.

      ![Redirect Parameter](/images/snowblind_parameter.jpg)
    
Step Two: Explore SSTI and achieve RCE : Insecure Software
Step Three: Achieve Shell Access : Insecure File Upload
Step Four: Exfilitrate Data : Insecure processes / Data Leakage
Step Five:  Decode PNG file : Leak Sensitive Information
Step Six: Crack Hash for Root : Weak Password 
Step Seven: Escalate privileges : Escalate privileges
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
| John the Ripper | 1.9.0-jumbo-1+bleeding-aec1328d6c | 
|  |  |
|  |  | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Codes: If you can't get your payload to work, perhaps you are missing some form of obfuscation? A computer can understand many languages and formats, find one that works! Don't give up until you have tried at least eight different ones, if not, then it's truely hopeless. |
| Santa | Overtly Helpful?: I think admin is having trouble, remembering his password. I wonder how he is retaining access, I'm sure someone or something is helping him remembering. Ask around! |
| Torkel | I've been studying this web application that controls part of Frosty's infrastructure. There's a Flask backend with an AI chatbot that seems to have access to sensitive system information. Think of this as finding a way up the skorstein into Frosty's system - we need to exploit this chatbot to gain access and ultimately stop Frosty from freezing everything. Can you help me get through these defenses?|
## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| Fluffme | Helped to identify flaws in my method that I was using for RCE. My shell was deficient. |
| Khesperus | Sanity checks on achieving shell and on decrypting the png file. |


|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
