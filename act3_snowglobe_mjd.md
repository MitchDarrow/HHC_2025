|[Previous Objective](HHC_2025_Template/act3_shrodingersscope_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_onthewire_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Find and Shutdown Frosty's Snowglobe Machine  | Difficulty Level: 3 |
| :-----------------------: | :--------------------------: |
| You've heard murmurings around the city about a wise, elderly gnome having a change of heart. He must have information about where Frosty's Snowglobe Machine is. You should find and talk to the gnome so you can get some help with how to make your way through the Data Center's labrynthian halls. Once you find the Snowglobe Machine, figure out how to shut it down and melt Frosty's cold, nefarious plans. | Location: Old Data Center |

## Solution Overview

The code on the outside of the building is binary and decodes to "imanok" which is konami spelled backwards. Konami code is a classic cheat sequence (↑ ↑ ↓ ↓ ← → ← → B A) often repurposed in games and puzzles.  Because the word is inverted, the code sequence is also inverted (Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑). Each door is marked with one of three symbols A, ↑, B.  The konami code gives the choice for working doorways in each room, with the code arrows being interpreted as compass directions.  All doors work in the first room, and is designated the start of the code. Following the code leads to the destination and the flag.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Decode hidden payload | Defense Evasion | T1140 | Deobfuscate/Decode Files or Information |


## Detailed Solution
<details>
<summary>Click to expand</summary>

Viewing the exterior wall of the datacenter, there is a pattern in the bricks that looks binary, six bytes of data:
  
![snowglobe code](/images/snowglobe_code.jpg) 

Decoding the patterns gives:

01101001 = 105 = 'i'

01101101 = 109 = 'm' 

01100001 = 97 = 'a'

01101110 = 110 = 'n'

01101111 = 111 = 'o'

01001011 = 75 = 'k'

Converting letters to their integer position in the alphabet makes no sense in the context. Neither does trying to convert them to compass directions. So it must be something simpler. This looks like konami spelled in reverse. A quick google explains:


Konami code is a classic cheat sequence (↑ ↑ ↓ ↓ ← → ← → B A) often repurposed in games and puzzles.  Because the word is inverted, the code sequence is likely inverted as well.

Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑

-	Door Labels clockwise from NE corner: 1 B, 2 Up, 3 A, 4 B, 5 Up, 6 A, 7 A, 8 Up, 9 B, 10 A, 11 Up, 12 B

-	Door Numbers per Walls: North 1–3, East 4–6, South 7–9, West 10–12

-	Orientation: Keep North up


Trial and error reveals that all doors in room 1 work. Room 2 testing shows that all A labeled doors work. Room 3 testing indicates that all B labeled doors work.  This confirms that the pattern is a reversed konami code. Finishing the sequence:

| Room | Valid Exits | Konami Position | Pattern |
|------|-------------|-----------------|---------|
| 1 | All 12 doors | Start | All doors |
| 2 | A doors: 3, 6, 7, 10 | **A** | All A-type |
| 3 | B doors: 1, 4, 9, 12 | **B** | All B-type |
| 4 | East: 4, 5, 6 | **→** Right | East wall |
| 5 | West: 10, 11, 12 | **←** Left | West wall |
| 6 | East: 4, 5, 6 | **→** Right | East wall |
| 7 | West: 10, 11, 12 | **←** Left | West wall |
| 8 | South: 7, 8, 9 | **↓** Down | South wall |
| 9 | South: 7, 8, 9 | **↓** Down | South wall |
| 10 | North: 1, 2, 3 | **↑** Up | North wall |
| 11 | North: 1, 2, 3 | **↑** Up | North wall |

**Answer: Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| None | None | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Elder Gnome | The Elder Gnome said the route to the old secret lab inside the Data Center starts on the far East wing inside the building, and that the hallways leading to it are probably pitch dark. He also said the employees that used to work there left some kind of code outside the building as a reminder of the route. Perhaps you can search in the vicinity of the Data Center for this code. |
| Elder Gnome | Backwards you should look: The Elder also recalled a story of another "computer person" like yourself who managed to find an intern that got lost inside the Data Center about 10 years ago. But that was before the reconstruction, so the current route likely isn't exactly the same. Maybe you can search for the Data Center's past in the historical archives that is the Internet for more information that may be helpful. |


## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| None | None |


|[Previous Objective](HHC_2025_Template/act3_shrodingersscope_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_onthewire_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
