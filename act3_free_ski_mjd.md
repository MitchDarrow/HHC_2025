---
layout: default
title: act3_free_ski_mjd
---
<table>
<thead>
<tr>
<th><a href="/HHC_2025/act3_onthewire_mjd.html">Previous Objective: Act3 On The Wire</a></th>
<br>
<th><a href="/HHC_2025/index.html">Table of Contents</a></th>
<br>
<th><a href="/HHC_2025/act3_snowblindambush_mjd.html">Next Objective: Act3 SnowBlind Ambush</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

<table>
<thead>
<tr>
<th>Objective: Free Ski</th>
<br>
<th>Difficulty Level: 4</th>
</tr>
</thead>
<tbody>
<tr>
<td>Go to the retro store and help Goose Olivia ski down the mountain and collect all five treasure chests to reveal the hidden flag in this classic SkiFree-inspired challenge.</td>
<br>
<td>Location: Retro Store</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

Reverse engineer an executable to reveal hidden information.

<table>
<thead>
<tr>
<th>Activity</th>
<br>
<th>Primary Tactic</th>
<br>
<th>MITRE ATT&CK Technique ID</th>
<br>
<th>MITRE ATT&CK Technique Name</th>
</tr>
</thead>
<tbody>
<tr>
<td>Decompile executable file</td>
<br>
<td>Defense Evasion</td>
<br>
<td>T1027</td>
<br>
<td>Obfuscated Files or Information</td>
</tr>
<tr>
<td>Decode hidden payload</td>
<br>
<td>Defense Evasion</td>
<br>
<td>T1140</td>
<br>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
</tbody>
</table>


<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

Git clone both repositories to my kali machine.
<br>
git clone https://github.com/extremecoders-re/pyinstxtractor.git
<br>
git clone https://github.com/zrax/pycdc.git

Run PyInstaller Extractor to create the pyc file:
<br>
python ./pyinstxtractor.py FreeSki.exe
<img src="/images/freeskipyextractor.jpg" alt="Results of Pyextractor">

Install cmake:
<br>
<pre><code class="language-sh">
<br>
sudo apt install cmake
<br>
cmake .
<br>
make
<br>
</code></pre>
<br>
Copy the extracted folder into the /pycdc folder

<img src="/images/freeski_pycdcfolder.png" alt="pydcdc folder">

Extract the code: ./pycdas ~/pycdc/FreeSki.exe_extracted/FreeSki.pyc

<a href="/images/FreeSkiCode.txt">Free Ski Source Code</a>

Flag Decoding Process (in SetFlag function):
<ol>
<li>Product Calculation: Takes the 5 collected treasure values and combines them:</li>
</ol>
python
<br>
   product = 0
<br>
   for treasure_val in treasure_list:
<br>
       product = (product << 8) ^ treasure_val
<ol>
<li>Random Seeding: Uses this product as a seed:</li>
</ol>
python
<br>
   random.seed(product)
<ol>
<li>XOR Decryption: Each mountain has an encoded_flag (bytes). The flag is decoded by XORing each byte with random values generated from the seeded RNG:</li>
</ol>
python
<br>
   for i in range(len(mountain.encoded_flag)):
<br>
       r = random.randint(0, 255)
<br>
       decoded.append(chr(mountain.encoded_flag[i] ^ r))

<img src="/images/free_ski_flagdecoding.jpg" alt="Flag decoding">

There are <strong>7 mountains</strong> with encoded flags:
<ul>
<li>Mount Snow, Aspen, Whistler, Mount Baker, Mount Norquay, Mount Erciyes, Dragonmount</li>
</ul>

<img src="/images/free_ski_themountains.jpg" alt="The Mountains">

<ol>
<li><strong>Find treasure locations</strong> - They're deterministically generated using <code>random.seed(binascii.crc32(mountain_name))</code> in <code>GetTreasureLocations()</code></li>
<br>
<li><strong>Calculate treasure values</strong> - Each treasure's value is <code>(elevation * mountain_width) + horizontal_offset</code></li>
<br>
<li><strong>Compute the product</strong> - XOR the 5 treasure values together with bit shifts</li>
<br>
<li><strong>Decrypt the flag</strong> - Use that product to seed random and XOR-decode the flag</li>
</ol>

Interesting strings:
<br>
"find all the lost bears. don't drill into a rock. Win game."
<br>
Combined with the victory message:
<br>
"You win! Drill Baby is reunited with all its bears."

The key insight is that the game's "randomness" is actually deterministic - everything is seeded based on the mountain name, so you can predict exactly where treasures will spawn without playing the game!

The script solvefreeski.py does the following:
<ol>
<li>Recreates the treasure generation algorithm - Uses the same seeding method (CRC32 of mountain name) to deterministically find where all 5 treasures are located on each mountain</li>
<br>
<li>Calculates treasure values - Each treasure's value is (elevation × 1000) + horizontal_offset</li>
<br>
<li>Computes the decryption key - XORs all 5 treasure values together with bit shifts to create a product</li>
<br>
<li>Decodes the flag - Seeds Python's random number generator with that product, then XORs each byte of the encoded flag with the generated random values</li>
</ol>

Script: <a href="/HHC_2025/act3_solvefreeski.py">Solve Free Ski</a>

<img src="/images/Free_ski_solution.jpg" alt="Free Ski Solution">

<strong>Answer: frosty_yet_predictably_random</strong>

</details>

<h2>Tools Reference</h2>

<table>
<thead>
<tr>
<th>Tools Used</th>
<br>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>claude.ai</td>
<br>
<td>v4.5</td>
</tr>
<tr>
<td>PyInstaller Extractor</td>
<br>
<td>?</td>
</tr>
<tr>
<td>pycdas</td>
<br>
<td>?</td>
</tr>
</tbody>
</table>

<h2>Hints Reference</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<br>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<br>
<td>Many Python decompilers don't understand Python 3.13, but Decompyle++ does!</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Have you ever used PyInstaller Extractor?</td>
</tr>
<tr>
<td>Olivia Goose</td>
<br>
<td>This game looks simple enough, doesn't it? Almost too simple. But between you and me... it seems nearly impossible to win fair and square. My advice? If you ain't cheatin', you ain't tryin'. wink Now get out there and show that mountain who's boss!</td>
</tr>
</tbody>
</table>

<h2>Acknowledgements</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<br>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>none</td>
<br>
<td>none</td>
</tr>
</tbody>
</table>


<table>
<thead>
<tr>
<th><a href="/HHC_2025/act3_onthewire_mjd.html">Previous Objective: Act3 On The Wire</a></th>
<br>
<th><a href="/HHC_2025/index.html">Table of Contents</a></th>
<br>
<th><a href="/HHC_2025/act3_snowblindambush_mjd.html">Next Objective: Act3 SnowBlind Ambush</a></th>
</tr>
</thead>
<tbody>
</tbody>
</table>
