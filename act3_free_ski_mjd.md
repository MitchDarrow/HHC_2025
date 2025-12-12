---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act3_onthewire_mjd.html">Previous Objective: Act3 On The Wire</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_snowblindambush_mjd.html">Next Objective: Act3 SnowBlind Ambush</a></th></table>
---
<table>
<thead><tr><th>Objective: Free Ski</th> <th>Difficulty Level: 4</th><tr><td>Go to the retro store and help Goose Olivia ski down the mountain and collect all five treasure chests to reveal the hidden flag in this classic SkiFree-inspired challenge.</td> <td>Location: Retro Store</td></table>
<h2>Solution Overview</h2>
Reverse engineer an executable to reveal hidden information.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Decompile executable file</td> <td>Defense Evasion</td> <td>T1027</td> <td>Obfuscated Files or Information</td><tr><td>Decode hidden payload</td> <td>Defense Evasion</td> <td>T1140</td> <td>Deobfuscate/Decode Files or Information</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>Git clone both repositories to my kali machine.</p>
<p>git clone https://github.com/extremecoders-re/pyinstxtractor.git</p>
<p>git clone https://github.com/zrax/pycdc.git     </p>
<p>Run PyInstaller Extractor to create the pyc file:</p>
<p>python ./pyinstxtractor.py FreeSki.exe     </p>
<p>!<a href="/HHC_2025/images/freeskipyextractor.jpg">Results of Pyextractor</a> </p>
<p>Install cmake: </p>
<pre><code>
sudo apt install cmake    
cmake .
make
</code></pre>
<p>Copy the extracted folder into the /pycdc folder</p>
<p>!<a href="/HHC_2025/images/freeski_pycdcfolder.png">pydcdc folder</a> </p>
<p>Extract the code: ./pycdas ~/pycdc/FreeSki.exe_extracted/FreeSki.pyc</p>
<p><a href="/HHC_2025/images/FreeSkiCode.txt">Free Ski Source Code</a> </p>
<p>Flag Decoding Process (in SetFlag function):</p>
<p>1.	Product Calculation: Takes the 5 collected treasure values and combines them:</p>
<p>python</p>
<p>   product = 0</p>
<p>   for treasure_val in treasure_list:</p>
<p>       product = (product << 8) ^ treasure_val</p>
<p>2.	Random Seeding: Uses this product as a seed:</p>
<p>python</p>
<p>   random.seed(product)</p>
<p>3.	XOR Decryption: Each mountain has an encoded_flag (bytes). The flag is decoded by XORing each byte with random values generated from the seeded RNG:</p>
<p>python</p>
<p>   for i in range(len(mountain.encoded_flag)):</p>
<p>       r = random.randint(0, 255)</p>
<p>       decoded.append(chr(mountain.encoded_flag[i] ^ r))</p>
<p>!<a href="/HHC_2025/images/free_ski_flagdecoding.jpg">Flag decoding</a> </p>
<p>There are <strong>7 mountains</strong> with encoded flags:</p>
<p>- Mount Snow, Aspen, Whistler, Mount Baker, Mount Norquay, Mount Erciyes, Dragonmount</p>
<p>!<a href="/HHC_2025/images/free_ski_themountains.jpg">The Mountains</a> </p>
<p>1. <strong>Find treasure locations</strong> - They're deterministically generated using <code>random.seed(binascii.crc32(mountain_name))</code> in <code>GetTreasureLocations()</code></p>
<p>2. <strong>Calculate treasure values</strong> - Each treasure's value is <code>(elevation * mountain_width) + horizontal_offset</code></p>
<p>3. <strong>Compute the product</strong> - XOR the 5 treasure values together with bit shifts</p>
<p>4. <strong>Decrypt the flag</strong> - Use that product to seed random and XOR-decode the flag</p>
<p>Interesting strings:</p>
<p>"find all the lost bears. don't drill into a rock. Win game."</p>
<p>Combined with the victory message:</p>
<p>"You win! Drill Baby is reunited with all its bears."</p>
<p>The key insight is that the game's "randomness" is actually deterministic - everything is seeded based on the mountain name, so you can predict exactly where treasures will spawn without playing the game!</p>
<p>The script solvefreeski.py does the following:</p>
<p>1.	Recreates the treasure generation algorithm - Uses the same seeding method (CRC32 of mountain name) to deterministically find where all 5 treasures are located on each mountain</p>
<p>2.	Calculates treasure values - Each treasure's value is (elevation Ã— 1000) + horizontal_offset</p>
<p>3.	Computes the decryption key - XORs all 5 treasure values together with bit shifts to create a product</p>
<p>4.	Decodes the flag - Seeds Python's random number generator with that product, then XORs each byte of the encoded flag with the generated random values</p>
<p>Script: <a href="/HHC_2025/act3_solvefreeski.py">Solve Free Ski</a>   </p>
<p>!<a href="/HHC_2025/images/Free_ski_solution.jpg">Free Ski Solution</a> </p>
<p><strong>Answer: frosty_yet_predictably_random</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>claude.ai</td> <td>v4.5</td> <td></td><tr><td>PyInstaller Extractor</td> <td>?</td><tr><td>pycdas</td> <td>?</td> <td></td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Many Python decompilers don't understand Python 3.13, but Decompyle++ does!</td><tr><td>Santa</td> <td>Have you ever used PyInstaller Extractor?</td><tr><td>Olivia Goose</td> <td>This game looks simple enough, doesn't it? Almost too simple. But between you and me... it seems nearly impossible to win fair and square. My advice? If you ain't cheatin', you ain't tryin'. wink Now get out there and show that mountain who's boss!</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act3_onthewire_mjd.html">Previous Objective: Act3 On The Wire</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_snowblindambush_mjd.html">Next Objective: Act3 SnowBlind Ambush</a></th></table>