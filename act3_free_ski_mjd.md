|[Previous Objective](HHC_2025_Template/act3_onthewire_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_snow_blind_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: Free Ski    | Difficulty Level: 4 |
| :-----------------------: | :--------------------------: |
| Go to the retro store and help Goose Olivia ski down the mountain and collect all five treasure chests to reveal the hidden flag in this classic SkiFree-inspired challenge. | Location: Retro Store  |

## Solution Overview

Reverse engineer an executable to reveal hidden information.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Decompile executable file  | Defense Evasion | T1027 |Obfuscated Files or Information |
| Decode hidden payload | Defense Evasion | T1140 | Deobfuscate/Decode Files or Information |


## Detailed Solution
<details>
<summary>Click to expand</summary>

Git clone both repositories to my kali machine.
git clone https://github.com/extremecoders-re/pyinstxtractor.git
git clone https://github.com/zrax/pycdc.git     

Run PyInstaller Extractor to create the pyc file:
python ./pyinstxtractor.py FreeSki.exe     
![Results of Pyextractor](/images/freeskipyextractor.jpg) 

Install cmake: 
```sh
sudo apt install cmake    
cmake .
make
```
Copy the extracted folder into the /pycdc folder

![pydcdc folder](/images/freeski_pycdcfolder.png) 

Extract the code: ./pycdas ~/pycdc/FreeSki.exe_extracted/FreeSki.pyc

[Free Ski Source Code](/images/FreeSkiCode.txt) 

Flag Decoding Process (in SetFlag function):
1.	Product Calculation: Takes the 5 collected treasure values and combines them:
python
   product = 0
   for treasure_val in treasure_list:
       product = (product << 8) ^ treasure_val
2.	Random Seeding: Uses this product as a seed:
python
   random.seed(product)
3.	XOR Decryption: Each mountain has an encoded_flag (bytes). The flag is decoded by XORing each byte with random values generated from the seeded RNG:
python
   for i in range(len(mountain.encoded_flag)):
       r = random.randint(0, 255)
       decoded.append(chr(mountain.encoded_flag[i] ^ r))

![Flag decoding](/images/free_ski_flagdecoding.jpg) 

There are **7 mountains** with encoded flags:
- Mount Snow, Aspen, Whistler, Mount Baker, Mount Norquay, Mount Erciyes, Dragonmount

![The Mountains](/images/free_ski_themountains.jpg) 

1. **Find treasure locations** - They're deterministically generated using `random.seed(binascii.crc32(mountain_name))` in `GetTreasureLocations()`
2. **Calculate treasure values** - Each treasure's value is `(elevation * mountain_width) + horizontal_offset`
3. **Compute the product** - XOR the 5 treasure values together with bit shifts
4. **Decrypt the flag** - Use that product to seed random and XOR-decode the flag

Interesting strings:
"find all the lost bears. don't drill into a rock. Win game."
Combined with the victory message:
"You win! Drill Baby is reunited with all its bears."

The key insight is that the game's "randomness" is actually deterministic - everything is seeded based on the mountain name, so you can predict exactly where treasures will spawn without playing the game!

The script solvefreeski.py does the following:
1.	Recreates the treasure generation algorithm - Uses the same seeding method (CRC32 of mountain name) to deterministically find where all 5 treasures are located on each mountain
2.	Calculates treasure values - Each treasure's value is (elevation × 1000) + horizontal_offset
3.	Computes the decryption key - XORs all 5 treasure values together with bit shifts to create a product
4.	Decodes the flag - Seeds Python's random number generator with that product, then XORs each byte of the encoded flag with the generated random values

Script: [Solve Free Ski](act3_solvefreeski.py)   

![Free Ski Solution](/images/Free_ski_solution.jpg) 

**Answer: frosty_yet_predictably_random**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| claude.ai | v4.5 | 
| PyInstaller Extractor | ? |
| pycdas | ? | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Many Python decompilers don't understand Python 3.13, but Decompyle++ does! |
| Santa | Have you ever used PyInstaller Extractor? |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |



|[Previous Objective](HHC_2025_Template/act3_onthewire_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/act3_snow_blind_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

