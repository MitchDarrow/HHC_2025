|[Previous Objective: Act2 Rogue Gnome Identity Provider](/act3_rogue_identity_provider_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 2 Going in Reverse](/act2_going_in_reverse_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Quantgnome Leap    | Difficulty Level: 2 |
| :-----------------------: | :--------------------------: |
| Charlie in the hotel has quantum gnome mysteries waiting to be solved. What is the flag that you find? | Location: Grand Hotel  |

## Solution Overview

Reconnaissance located ssh keys that belonged to another user. These keys were used to move laterally in the system and gain access to another user. This was repeated until admin level access was achieved. The flag was located under the directory where the SSH daemon was running.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Locating poorly secured SSH keys | Credential Access | T1552.004 | Unsecured Credentials: Private Keys |
| Using keys to gain unauthorized access | Persistence / Lateral Movement | T1078.004 | Valid Accounts: SSH |

## Detailed Solution
<details>
<summary>Click to expand</summary>

RSA keys were found in the Qgnome directory during recon
  
![RSA Keys](/images/quantgnome_rsakeys.jpg) 

Inspecting the knownhosts file, there is a key referenced at /opt/oqs-key/ssh_host_ecdsa_nistp521_mldsa-87_key. This directory is accessible.
 
Using this key:

```sh
ssh -p 2222 -i /opt/oqs-key/ssh_host_ecdsa_nistp521_mldsa-87_key gnome1@localhost
```

![SSH as Gnome1](/images/quantgnome_gnome1.jpg) 

The Gnome1 user has access to a new key:

```sh
ssh -p 2222 -i /opt/oqs-key/id_ed25519 gnome2@localhost
```

![SSH as Gnome2](/images/quantgnome_gnome2.jpg) 

The Gnome2 user has access to a new key:

```sh
ssh -p 2222 -i /opt/oqs-key/id_mayo2 gnome3@localhost
```

![SSH as Gnome3](/images/quantgnome_gnome3.jpg) 

The Gnome3 user has access to a new key:

```sh
ssh -p 2222 -i /opt/oqs-key/id_ecdsa_nistp256_sphincssha2128fsimple gnome4@localhost
```
![SSH as Gnome4](/images/quantgnome_gnome4.jpg) 

The Gnome4 user has access to a new key:

```sh
ssh -p 2222 -i /opt/oqs-key/id_ecdsa_nistp521_mldsa87 admin@localhost
```

The instructions direct towards the directory where the SSH daemon is running (/opt/oqs-ssh), and The flag is in the directory /opt/oqs-ssh/flag

![Flag Directory](/images/quantgnome_flagdir.jpg) 

**Answer: HHC{L3aping_0v3r_Quantum_Crypt0}**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| none | none | 


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | When you give a present, you often put a label on it to let someone know that the present is for them. Sometimes you even say who the present is from. The label is always put on the outside of the present so the public knows the present is for a specific person. SSH keys have something similar called a comment. SSH keys sometimes have a comment that can help determine who and where the key can be used. |
| Santa | User keys are like presents. The keys are kept in a hidden location until they need to be used. Hidden files in Linux always start with a dot. Since everything in Linux is a file, directories that start with a dot are also...hidden! |
| Santa | Process information is very useful to determine where an application configuration file is located. I bet there is a secret located in that application directory, you just need the right user to read it! |
| Santa | If you want to create SSH keys, you would use the ssh-keygen tool. We have a special tool that generates post-quantum cryptographic keys. The suffix is the same as ssh-keygen. It is only the first three letters that change. |
| JJ | I just spotted a mysterious gnome - he winked and vanished, or maybe he's still here? Things are getting strange, and I think we've wandered into a quantum conundrum! If you help me unravel these riddles, we might just outsmart future quantum computers. Cryptic puzzles, quirky gnomes, and post-quantum secrets—will you leap with me? |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act2 Rogue Gnome Identity Provider](/act3_rogue_identity_provider_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 2 Going in Reverse](/act2_going_in_reverse_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |
