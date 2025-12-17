---
layout: default
title: act3_free_ski_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act3_onthewire_mjd.html">Previous Objective: Act3 On The Wire</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act3_snowblindambush_mjd.html">Next Objective: Act3 SnowBlind Ambush</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Free Ski</th>
<th>Difficulty Level: 4</th>
</tr>
</thead>
<tbody>
<tr>
<td>Go to the retro store and help Goose Olivia ski down the mountain and collect all five treasure chests to reveal the hidden flag in this classic SkiFree-inspired challenge.</td>
<td>Location: Retro Store</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
<p>
Reverse engineer an executable to reveal hidden information.
<br>
</p>
<table>
<thead>
<tr>
<th>Activity</th>
<th>Primary Tactic</th>
<th>MITRE ATT&CK Technique ID</th>
<th>MITRE ATT&CK Technique Name</th>
</tr>
</thead>
<tbody>
<tr>
<td>Decompile executable file</td>
<td>Defense Evasion</td>
<td>T1027</td>
<td>Obfuscated Files or Information</td>
</tr>
<tr>
<td>Decode hidden payload</td>
<td>Defense Evasion</td>
<td>T1140</td>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>

<summary>Click to expand</summary>
<br>
<p>
Git clone both repositories to my kali machine.
<br>
git clone https://github.com/extremecoders-re/pyinstxtractor.git
<br>
git clone https://github.com/zrax/pycdc.git
<br>
</p>
<p>
Run PyInstaller Extractor to create the pyc file:
<br>
python ./pyinstxtractor.py FreeSki.exe
<br>
<img src="/HHC_2025/images/freeskipyextractor.jpg" alt="Results of Pyextractor">
<br>
</p>
<p>
Install cmake:
<br>
</p>
<pre><code class="language-sh">
sudo apt install cmake
cmake .
make
</code></pre>
<p>
Copy the extracted folder into the /pycdc folder
<br>
</p>
<p>
<img src="/HHC_2025/images/freeski_pycdcfolder.png" alt="pydcdc folder">
<br>
</p>
<p>
Extract the code: ./pycdas ~/pycdc/FreeSki.exe_extracted/FreeSki.pyc
<br>
</p>
<p>
<a href="/HHC_2025/images/FreeSkiCode.txt">Free Ski Source Code</a>
<br>
</p>
<p>
Flag Decoding Process (in SetFlag function):
<br>
</p>
<ol>
<li>Product Calculation: Takes the 5 collected treasure values and combines them:</li>
<p>
python
<br>
   product = 0
<br>
   for treasure_val in treasure_list:
<br>
       product = (product << 8) ^ treasure_val
<br>
</p>
<li>Random Seeding: Uses this product as a seed:</li>
<p>
python
<br>
   random.seed(product)
<br>
</p>
<li>XOR Decryption: Each mountain has an encoded_flag (bytes). The flag is decoded by XORing each byte with random values generated from the seeded RNG:</li>
<p>
python
<br>
   for i in range(len(mountain.encoded_flag)):
<br>
       r = random.randint(0, 255)
<br>
       decoded.append(chr(mountain.encoded_flag[i] ^ r))
<br>
</p>
<p>
<img src="/HHC_2025/images/free_ski_flagdecoding.jpg" alt="Flag decoding">
<br>
</p>
<p>
There are <strong>7 mountains</strong> with encoded flags:
<br>
</p>
<ul>
<li>Mount Snow, Aspen, Whistler, Mount Baker, Mount Norquay, Mount Erciyes, Dragonmount</li>
</ul>
<p>
<img src="/HHC_2025/images/free_ski_themountains.jpg" alt="The Mountains">
<br>
</p>
<ol>
<li><strong>Find treasure locations</strong> - They're deterministically generated using <code>random.seed(binascii.crc32(mountain_name))</code> in <code>GetTreasureLocations()</code></li>
<li><strong>Calculate treasure values</strong> - Each treasure's value is <code>(elevation * mountain_width) + horizontal_offset</code></li>
<li><strong>Compute the product</strong> - XOR the 5 treasure values together with bit shifts</li>
<li><strong>Decrypt the flag</strong> - Use that product to seed random and XOR-decode the flag</li>
</ol>
<p>
Interesting strings:
<br>
"find all the lost bears. don't drill into a rock. Win game."
<br>
Combined with the victory message:
<br>
"You win! Drill Baby is reunited with all its bears."
<br>
</p>
<p>
The key insight is that the game's "randomness" is actually deterministic - everything is seeded based on the mountain name, so you can predict exactly where treasures will spawn without playing the game!
<br>
</p>
<p>
The script solvefreeski.py does the following:
<br>
</p>
<ol>
<li>Recreates the treasure generation algorithm - Uses the same seeding method (CRC32 of mountain name) to deterministically find where all 5 treasures are located on each mountain</li>
<li>Calculates treasure values - Each treasure's value is (elevation × 1000) + horizontal_offset</li>
<li>Computes the decryption key - XORs all 5 treasure values together with bit shifts to create a product</li>
<li>Decodes the flag - Seeds Python's random number generator with that product, then XORs each byte of the encoded flag with the generated random values</li>
</ol>
<p>
Script: <a href="/HHC_2025/act3_solvefreeski.py">Solve Free Ski</a>
<br>
</p>
<p>
<img src="/HHC_2025/images/Free_ski_solution.jpg" alt="Free Ski Solution">
<br>
</p>
<p>
<strong>Answer: frosty_yet_predictably_random</strong>
<br>
</p>
</details>
<p>
<h2>Tools Reference</h2>
<br>
</p>
<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>claude.ai</td>
<td>v4.5</td>
</tr>
<tr>
<td>PyInstaller Extractor</td>
<td>?</td>
</tr>
<tr>
<td>pycdas</td>
<td>?</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
<br>
</p>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<td>Many Python decompilers don't understand Python 3.13, but Decompyle++ does!</td>
</tr>
<tr>
<td>Santa</td>
<td>Have you ever used PyInstaller Extractor?</td>
</tr>
<tr>
<td>Olivia Goose</td>
<td>This game looks simple enough, doesn't it? Almost too simple. But between you and me... it seems nearly impossible to win fair and square. My advice? If you ain't cheatin', you ain't tryin'. wink Now get out there and show that mountain who's boss!</td>
</tr>
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
<br>
</p>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>none</td>
<td>none</td>
</tr>
</tbody>
</table>
