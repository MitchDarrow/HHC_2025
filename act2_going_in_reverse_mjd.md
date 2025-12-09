|[Previous Objective: Act2 Quantgnome Leap](/act2_quantgnome_leap_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 3 Name](/act3_gnome_tea_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Going in Reverse    | Difficulty Level: 2 |
| :-----------------------: | :--------------------------: |
| Kevin in the Retro Store needs help rewinding tech and going in reverse. Extract the flag and enter it here. | Location: Retro Store  |

## Solution Overview

Clicking on the BASIC program downloads it into the browser window. Reviewing the source code contains an encoded flag (line 30) and that the code applies a bitwise XOR (-bxor) with the number 7. The PowerShell script applies this logic to decode the encoded text.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Decode encoded information | Defense Evasion (adversaries attempt to avoid detection or obfuscate activity) | T1140 | Deobfuscate/Decode Files or Information |


## Detailed Solution
<details>
<summary>Click to expand</summary>

The basic program consists of the following code:

```basic
10 REM *** COMMODORE 64 SECURITY SYSTEM ***
20 ENC_PASS$ = "D13URKBT"
30 ENC_FLAG$ = "DSA|auhts*wkfi=dhjwubtthut+dhhkfis+hnkz" ' old "DSA|qnisf`bX_huXariz"
40 INPUT "ENTER PASSWORD: "; PASS$
50 IF LEN(PASS$) <> LEN(ENC_PASS$) THEN GOTO 90
60 FOR I = 1 TO LEN(PASS$)
70 IF CHR$(ASC(MID$(PASS$,I,1)) XOR 7) <> MID$(ENC_PASS$,I,1) THEN GOTO 90
80 NEXT I
85 FLAG$ = "" : FOR I = 1 TO LEN(ENC_FLAG$) : FLAG$ = FLAG$ + CHR$(ASC(MID$(ENC_FLAG$,I,1)) XOR 7) : NEXT I : PRINT FLAG$
90 PRINT "ACCESS DENIED"
100 END
```

The program has the encoded flag and the decoder. This PowerShell script will decode the string. Note that the ‘ denotes a comment in basic.

```powershell
# PowerShell script to decode the ENC_FLAG$ string using XOR 
# Encoded string
$encFlag = "DSA|auhts*wkfi=dhjwubtthut+dhhkfis+hnkz" 
 
#"old DSA|qnisf`bX_huXariz"

# Initialize decoded string
$decoded = ""

# Loop through each character
for ($i = 0; $i -lt $encFlag.Length; $i++) {
    # Get ASCII code of character
    $ascii = [int][char]$encFlag[$i]
    # XOR with 7
    $decodedChar = [char]($ascii -bxor 7)
    # Append to result
    $decoded += $decodedChar
}

# Print decoded string
Write-Output $decoded
 CTF{frost-plan:compressors,coolant,oil}
```

**Answer: CTF{frost-plan:compressors,coolant,oil}**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| PowerShell | 5.1.26100.6899 | 


## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Holy cow! Another retro floppy disk, what are the odds? Well it looks like this one is intact. |
| Santa | Maybe it is encrypted OR encoded? |
| Santa | It looks like the program on the disk contains some weird coding. |
| Kevin | You know, there's something beautifully nostalgic about stumbling across old computing artifacts. Just last week, I was sorting through some boxes in my garage and came across a collection of 5.25" floppies from my college days - mostly containing terrible attempts at programming assignments and a few games I'd copied from friends. Finding an old Commodore 64 disk with a mysterious BASIC program on it? That's like discovering a digital time capsule. The C64 was an incredible machine for its time - 64KB of RAM seemed like an ocean of possibility back then. I spent countless hours as a kid typing in program listings from Compute! magazine, usually making at least a dozen typos along the way. The thing about BASIC programs from that era is they were often written by clever programmers who knew how to hide things in plain sight. Sometimes the most interesting discoveries come from reading the code itself rather than watching it execute. It's like being a digital archaeologist - you're not just looking at what the program does, you're understanding how the programmer thought. Take your time with this one. The beauty of reverse engineering isn't in rushing to the answer, but in appreciating the craft of whoever wrote it. Those old-school programmers had to be creative within such tight constraints. |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| None | None |


|[Previous Objective: Act2 Quantgnome Leap](/act2_quantgnome_leap_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 3 Name](/act3_gnome_tea_mjd.md)
| :----------------------- | :--------------------------------: | --------------------------------: |
