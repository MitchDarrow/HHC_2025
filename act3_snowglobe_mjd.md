---
layout: default
title: act3_snowglobe_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th>[Previous Objective: Act3 Schrodingers Scope](/act3_schrodingersscope_mjd.md)</th>
  <th>[Table of Contents](/index.md)</th>
  <th>[Next Objective: Act3 On the Wire3](/act3_onthewire_mjd.md)</th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Find and Shutdown Frosty's Snowglobe Machine</th>
<th>Difficulty Level: 3</th>
</tr>
</thead>
<tbody>
<tr>
<td>You've heard murmurings around the city about a wise, elderly gnome having a change of heart. He must have information about where Frosty's Snowglobe Machine is. You should find and talk to the gnome so you can get some help with how to make your way through the Data Center's labrynthian halls. Once you find the Snowglobe Machine, figure out how to shut it down and melt Frosty's cold, nefarious plans.</td>
<td>Location: Old Data Center</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

The code on the outside of the building is binary and decodes to "imanok" which is konami spelled backwards. Konami code is a classic cheat sequence (↑ ↑ ↓ ↓ ← → ← → B A) often repurposed in games and puzzles.  Because the word is inverted, the code sequence is also inverted (Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑). Each door is marked with one of three symbols A, ↑, B.  The konami code gives the choice for working doorways in each room, with the code arrows being interpreted as compass directions.  All doors work in the first room, and is designated the start of the code. Following the code leads to the destination and the flag.

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
<td>Decode hidden payload</td>
<td>Defense Evasion</td>
<td>T1140</td>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

Viewing the exterior wall of the datacenter, there is a pattern in the bricks that looks binary, six bytes of data:

<img src="/HHC_2025/images/snowglobe_code.jpg" alt="snowglobe code">

Decoding the patterns gives:

01101001 = 105 = 'i'

01101101 = 109 = 'm'

01100001 = 97 = 'a'

01101110 = 110 = 'n'

01101111 = 111 = 'o'

01001011 = 75 = 'k'

Converting letters to their integer position in the alphabet makes no sense in the context of the rooms. Nor does trying to convert the numeric values into compass directions. It must be something simpler. This looks like konami spelled in reverse ("Backwards you should look" seems to apply here). A quick google search explains:

Konami code is a classic cheat sequence (↑ ↑ ↓ ↓ ← → ← → B A) often repurposed in games and puzzles.  Because the word is inverted, the code sequence is likely inverted as well.

Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑

<ul>
<li>Door Labels clockwise from NE corner: 1 B, 2 Up, 3 A, 4 B, 5 Up, 6 A, 7 A, 8 Up, 9 B, 10 A, 11 Up, 12 B</li>
</ul>

<ul>
<li>Door Numbers per Walls: North 1-3, East 4-6, South 7-9, West 10-12</li>
</ul>

<ul>
<li>Orientation: Keep North up</li>
</ul>

Trial and error reveals that all doors in room 1 work. Room 2 testing shows that all A labeled doors work. Room 3 testing indicates that all B labeled doors work.  This confirms that the pattern is a reversed konami code. Finishing the sequence:

<table>
<thead>
<tr>
<th>Room</th>
<th>Valid Exits</th>
<th>Konami Position</th>
<th>Pattern</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>All 12 doors</td>
<td>Start</td>
<td>All doors</td>
</tr>
<tr>
<td>2</td>
<td>A doors: 3, 6, 7, 10</td>
<td><strong>A</strong></td>
<td>All A-type</td>
</tr>
<tr>
<td>3</td>
<td>B doors: 1, 4, 9, 12</td>
<td><strong>B</strong></td>
<td>All B-type</td>
</tr>
<tr>
<td>4</td>
<td>East: 4, 5, 6</td>
<td><strong>→</strong> Right</td>
<td>East wall</td>
</tr>
<tr>
<td>5</td>
<td>West: 10, 11, 12</td>
<td><strong>←</strong> Left</td>
<td>West wall</td>
</tr>
<tr>
<td>6</td>
<td>East: 4, 5, 6</td>
<td><strong>→</strong> Right</td>
<td>East wall</td>
</tr>
<tr>
<td>7</td>
<td>West: 10, 11, 12</td>
<td><strong>←</strong> Left</td>
<td>West wall</td>
</tr>
<tr>
<td>8</td>
<td>South: 7, 8, 9</td>
<td><strong>↓</strong> Down</td>
<td>South wall</td>
</tr>
<tr>
<td>9</td>
<td>South: 7, 8, 9</td>
<td><strong>↓</strong> Down</td>
<td>South wall</td>
</tr>
<tr>
<td>10</td>
<td>North: 1, 2, 3</td>
<td><strong>↑</strong> Up</td>
<td>North wall</td>
</tr>
<tr>
<td>11</td>
<td>North: 1, 2, 3</td>
<td><strong>↑</strong> Up</td>
<td>North wall</td>
</tr>
</tbody>
</table>

<strong>Answer: Reversed Konami Code: A B →←  →← ↓ ↓ ↑ ↑</strong>

</details>

<h2>Tools Reference</h2>

<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>None</td>
<td>None</td>
</tr>
</tbody>
</table>

<h2>Hints Reference</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Elder Gnome</td>
<td>The Elder Gnome said the route to the old secret lab inside the Data Center starts on the far East wing inside the building, and that the hallways leading to it are probably pitch dark. He also said the employees that used to work there left some kind of code outside the building as a reminder of the route. Perhaps you can search in the vicinity of the Data Center for this code.</td>
</tr>
<tr>
<td>Elder Gnome</td>
<td>Backwards you should look: The Elder also recalled a story of another "computer person" like yourself who managed to find an intern that got lost inside the Data Center about 10 years ago. But that was before the reconstruction, so the current route likely isn't exactly the same. Maybe you can search for the Data Center's past in the historical archives that is the Internet for more information that may be helpful.</td>
</tr>
</tbody>
</table>

<h2>Acknowledgements</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>None</td>
<td>None</td>
</tr>
</tbody>
</table>