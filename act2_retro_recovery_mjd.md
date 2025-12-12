---
layout: default
title: act2_retro_recovery_mjd
---
|[Previous Objective: Act1 Owner](/act1_owner_mjd.md)  |   [Home Page](/index.md) | [Next Objective: Act2 Mail Detective](/act2_mail_detective_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Retro Recovery   | Difficulty Level: 2 |
| :-----------------------: | :--------------------------: |
| Join Mark in the retro shop. Analyze his disk image for a blast from the retro past and recover some classic treasures. | Location: Retro Shop  |

## Solution Overview

This objective is a digital forensics investigation involving a floppy disk image file that required data recovery. The investigator used the Linux `losetup` command to mount the floppy disk image as a loop device, treating the image file as a physical block device. TestDisk was then executed against the loop device `/dev/loop0` to search for deleted files. After selecting the appropriate disk and partition type settings, the "undelete" function was used to browse recoverable files. Among the deleted files, a BASIC source code file named `all_i-want_for_christmas.bas` was identified as interesting. Upon opening the recovered BASIC file in a text editor (mousepad), the investigator discovered an embedded base64-encoded string within the source code. The base64 string `bWVycnkgY2hyaXN0bWFzIHRvIGFsbCBhbmQgdG8gYWxsIGEgZ29vZCBuaWdodAo=` was decoded to reveal the hidden message: "merry christmas to all and to all a good night". This investigation demonstrates common digital forensics techniques including disk imaging, file carving, and data decoding.

| Activity | Primary Tactic | MITRE ATT&CK Technique ID | MITRE ATT&CK Technique Name |
|----------|----------------|---------------------------|----------------------------|
| Execute TestDisk against loop device /dev/loop0 | Discovery | T1083 |  File and Directory Discovery |
| Recover deleted file "all_i-want_for_christmas.bas" | Collection | T1074.001 | Data Staged: Local Data Staging |
| Decode base64 string to reveal hidden message | Deobfuscate/Decode Files or Information | T1140 | Deobfuscate/Decode Files or Information |


## Detailed Solution
<details>
<summary>Click to expand</summary>

[Floppy Disk Image File](/resources/retrorecovery_floppy.img)

`losetup` is a Linux command used to set up and manage loop devices, which let you treat a regular file as if it were a block device (like a disk).

Setup the disk image as a block device using the command:

```bash
sudo losetup -fP floppy.img

sudo testdisk /dev/loop0
```

1. Select the disk0 as the media and click proceed

2. Accept the default "none" as the partition type

3. Select "undelete" as the action

![TestDisk interface showing file listing on floppy disk image](/images/retrorecovery_explorefiles.jpg)

There is an interesting file: `all_i-want_for_christmas.bas`

Highlight the file and select "C" to copy the selected file.

Successfully recovered the deleted file `all_i-want_for_christmas.bas` to the current directory.

Open in mousepad and explore:

![BASIC source code file contents showing encoded string](/images/retrorecovery_sourcecode.jpg)

There is a base64 encoded string:

```
bWVycnkgY2hyaXN0bWFzIHRvIGFsbCBhbmQgdG8gYWxsIGEgZ29vZCBuaWdodAo=
```

Which decodes to:

```
merry christmas to all and to all a good night
```

**Answer: merry christmas to all and to all a good night**

---


**Answer: Flag or Answer**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| losetup | 2.40.4 | 
| testdisk | 7.2 |

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | I miss old school games. I wonder if there is anything on this disk? I remember, when kids would accidentlly delete things.......... it wasn't to hard to recover files. I wonder if you can still mount these disks? |
| Santa | Wow! A disk from the 1980s! I remember delivering those computer disks to the good boys and girls. Games were their favorite, but they weren't like they are now. |
| Santa | I know there are still tools available that can help you find deleted files. Maybe that might help. Ya know, one of my favorite games was a Quick Basic game called Star Trek. |
| Mark | This FAT12 floppy disk image must have been under an arcade machine here in the Retro Store. When I was a kid we shared warez by hiding things as deleted files. I remember writing programs in BASIC. So much fun! My favorite was Star Trek. The beauty of file systems is that 'deleted' doesn't always mean gone forever. Ready to dive into some digital archaeology and see what secrets this old disk is hiding? Download the floppy disk image, and see what you can find! |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act1 Owner](/act1_owner_mjd.md)  |   [Home Page](/index.md) | [Next Objective: Act2 Mail Detective](/act2_mail_detective_mjd.md) |
| :----------------------- | :--------------------------------: | --------------------------------: |
