|[Previous Objective: Act1 Intro to Nmap](/act1_intro_to_nmap_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Spare Key](/act1_spare_key_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Blob Storage Challenge in the Neighborhood    | Difficulty Level: 1 |
| :-----------------------: | :--------------------------: |
| Help the Goose Grace near the pond find which Azure Storage account has been misconfigured to allow public blob access by analyzing the export file.| Location: The Pond  |

## Solution Overview

The objective of this challenge is to connect using Azure CLI to the "neighborhood" tenant. Investigate and find where a security vulnerabliity exists. The neighborhood2 storage account was misconfigured to allow public blob access. The security vulnerability was a file named admin_credentials.txt that contained users and unencrypted passwords.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |


## Detailed Solution
<details>
<summary>Click to expand</summary>
  
Step 1: Review the storage accounts

```sh
az storage account list | less
```
![Misconfigured Storage Account allows Public Access](/images/blobstorage_misconfig.jpg) 

The following commands were used to dive deeper:
```sh
az storage container list --account-name neighborhood2 --output table
az storage blob list --container-name public --account-name neighborhood2
az storage blob download \
  --container-name public \
  --account-name neighborhood2 \
  --name admin_passwords.txt \
  --file admin_passwords.txt
```

![Misconfigured Storage Account allows Public Access](/images/blobstorage_passwordfile.jpg) 

**Answer: allowBlobPublicAccesss: True**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| Azure Cli | N/A | 


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | This terminal has built-in hints. |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act1 Intro to Nmap](/act1_intro_to_nmap_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act1 Spare Key](/act1_spare_key_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |
