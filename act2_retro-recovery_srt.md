---
layout: default
title: act2_retro-recovery_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act1_owner_mjd.html">Previous Objective: Act1 Owner</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_mail-detective_srt.html">Next Objective: Act2 Mail Detective</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Retro Recovery</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Join Mark in the retro shop. Analyze his disk image for a blast from the retro past and recovery some classic treasures.</td>
<td>Location: Retro Shop</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
Mark is an avid collector of things of the past. While cleaning up the Retro Store, he found a FAT12 floppy disk image. These disks were used in machines like the Commodore 64. He tells us we can hide malicious data as deleted files. File system mechanics mean that 'deleted' does not always mean gone forever!
<br>
</p>
<code>testdisk</code> must be used to recover the files deleted from the <code>.img</code> partition. We recover an <code>all_i_want_for_christmas.bas</code> file. After some digging, line 21 holds a base64 encoded secret "merry christmas to all and to all a good night".
<br>
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
<td>Analyze Disk Image</td>
<td>Discovery</td>
<td>T1083</td>
<td>File and Directory Discovery</td>
</tr>
<tr>
<td>Recover Deleted File</td>
<td>Collection</td>
<td>T1005</td>
<td>Data from Local System</td>
</tr>
<tr>
<td>Decode Base64</td>
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
This challenge begins with the receipt of the <code>floppy.img</code> file from Mark. Downloading this file, we have a number of different routes available for exploration. 
While it may be tempting to mount the <code>.img</code> file to poke around the various <code>.com</code>, <code>.exe</code>, and <code>.ini</code> files, the straightforward path is to use <code>testdisk</code> to analyze the <code>floppy.img</code> file. 
The <code>testdisk</code> utility allows us to identify and possibly recover deleted files within the analyzed media. Undertaking this, we find and recover an <code>all_i-want_for_christmas.bas</code> file. 
If we use <code>cat</code> or a similar text processing tool to view the contents of this file, we find an old Quick Basic game called Star Trek (thanks for the hint, Santa!). Peeling through the code, we are able to bounce around the game logic which is an interesting exercise in its own right. However, line 27 contains the following base64 string: <code>bWVycnkgY2hyaXN0bWFzIHRvIGFsbCBhbmQgdG8gYWxsIGEgZ29vZCBuaWdodAo=</code>
<p>
Decoding this string we find the following text: <strong>"merry Christmas to all and to all a good night"</strong>
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
<td><code>testdisk</code></td>
<td>7.2</td>
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
<td>I miss old school games. I wonder if there is anything on this disk? I remember, when kids would accidentally delete things... it wasn't too hard to recover files. I wonder if you can still mount these disks?</td>
</tr>
<tr>
<td>Santa</td>
<td>Wow! A disk from the 1980's! I remember delivering those computer disks to the good boys and girls. Games were their favorite, but they weren't like they are now.</td>
</tr>
<tr>
<td>Santa</td>
<td>I know there are still tools available that can help you find deleted files. Maybe that might help. Ya know, one of of my favorite games was a Quick Basic game called Star Trek.</td>
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
<td>Mitch Darrow</td>
<td>Thank you for pointing me towards <code>testdisk</code>!</td>
</tr>
</tbody>
</table>
