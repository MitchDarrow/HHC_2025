|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Objective name    | Difficulty Level: # |
| :-----------------------: | :--------------------------: |
| Official Description | Location:   |

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


01101001 = 105 = 'i'

01101101 = 109 = 'm' 

01100001 = 97 = 'a'

01101110 = 110 = 'n'

01101111 = 111 = 'o'

01001011 = 75 = 'k'

Converting letters to their integer position in the alphabet makes no sense. Neither does trying to convert them to compass directions. So it must be something simpler. This looks like konami spelled in reverse. A quick google explains:


Konami code is a classic cheat sequence (↑ ↑ ↓ ↓ ← → ← → B A) often repurposed in games and puzzles.  Because the word is inverted, the code sequence is likely inverted as well.

Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑

-	Door Labels clockwise from NE corner: 1 B, 2 Up, 3 A, 4 B, 5 Up, 6 A, 7 A, 8 Up, 9 B, 10 A, 11 Up, 12 B

-	Door Numbers per Walls: North 1–3, East 4–6, South 7–9, West 10–12

-	Orientation: Keep North up
  
-	Sequence per room: A, B, Right, Left, Right, Left, Down, Down, Up, Up

Trail and error reveals that all doors in room one work. Room 2 testing shows that all A labeled doors work. Room 3 testing indicates that all B labeled doors work.  This confirms that the pattern is a reversed konami code. Finishing the sequence:

| Room | Valid Exits | Konami Position | Pattern |
|------|-------------|-----------------|---------|
| 1 | All 12 doors | Start | All doors |
| 2 | A doors: 3, 6, 7, 10 | **A** | All A-type |
| 3 | B doors: 1, 4, 9, 12 | **B** | All B-type |
| 4 | West: 10, 11, 12 | **←** Left | West wall |
| 5 | East: 4, 5, 6 | **→** Right | East wall |
| 6 | West: 10, 11, 12 | **←** Left | West wall |
| 7 | East: 4, 5, 6 | **→** Right | East wall |
| 8 | South: 7, 8, 9 | **↓** Down | South wall |
| 9 | South: 7, 8, 9 | **↓** Down | South wall |
| 10 | North: 1, 2, 3 | **↑** Up | North wall |
| 11 | North: 1, 2, 3 | **↑** Up | North wall |

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
|  |  |
|  |  |
|  |  |
|  |  |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
|  |  |
|  |  |


|[Previous Objective](HHC_2025_Template/act3_hackagnome_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
