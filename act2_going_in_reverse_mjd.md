---
layout: default
title: act2_going_in_reverse_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th></th>
  <th><a href="/HHC_2025/allwriteups.html">All Writeups Index</a></th>
  <th></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Going in Reverse</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Kevin in the Retro Store needs help rewinding tech and going in reverse. Extract the flag and enter it here.</td>
<td>Location: Retro Store</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
</p>
<p>
Clicking on the BASIC program downloads it into the browser window. Reviewing the source code contains an encoded flag (line 30) and that the code applies a bitwise XOR (-bxor) with the number 7. The PowerShell script applies this logic to decode the encoded text.
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
<td>Decode encoded information</td>
<td>Defense Evasion (adversaries attempt to avoid detection or obfuscate activity)</td>
<td>T1140</td>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
The basic program consists of the following code:
<br>
</p>
<pre><code class="language-basic">
10 REM COMMODORE 64 SECURITY SYSTEM 
20 ENC_PASS$ = "D13URKBT"
30 ENC_FLAG$ = "DSA|auhtswkfi=dhjwubtthut+dhhkfis+hnkz" ' old "DSA|qnisf`bX_huXariz"
40 INPUT "ENTER PASSWORD: "; PASS$
50 IF LEN(PASS$) <> LEN(ENC_PASS$) THEN GOTO 90
60 FOR I = 1 TO LEN(PASS$)
70 IF CHR$(ASC(MID$(PASS$,I,1)) XOR 7) <> MID$(ENC_PASS$,I,1) THEN GOTO 90
80 NEXT I
85 FLAG$ = "" : FOR I = 1 TO LEN(ENC_FLAG$) : FLAG$ = FLAG$ + CHR$(ASC(MID$(ENC_FLAG$,I,1)) XOR 7) : NEXT I : PRINT FLAG$
90 PRINT "ACCESS DENIED"
100 END
</code></pre>
<p>
The program has the encoded flag and the decoder. This PowerShell script will decode the string. Note that the ‘ denotes a comment in basic.
<br>
</p>
<pre><code class="language-powershell">
# PowerShell script to decode the ENC_FLAG$ string using XOR
# Encoded string
$encFlag = "DSA|auhts</em>wkfi=dhjwubtthut+dhhkfis+hnkz"
#"old DSA|qnisf`bX_huXariz"
# Initialize decoded string
$decoded = ""
# Loop through each character
for ($i = 0; $i -lt $encFlag.Length; $i++) {
# Get ASCII code of character
    $ascii = [int][char]$encFlag[$i]
# XOR with 7
    $decodedChar = <a href="/HHC_2025/$ascii -bxor 7">char</a>
# Append to result
    $decoded += $decodedChar
}
# Print decoded string
Write-Output $decoded
 CTF{frost-plan:compressors,coolant,oil}
</code></pre>
<p>
<strong>Answer: CTF{frost-plan:compressors,coolant,oil}</strong>
<br>
</p>
</details>
<p>
<h2>Tools Reference</h2>
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
<td>PowerShell</td>
<td>5.1.26100.6899</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
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
<td>Holy cow! Another retro floppy disk, what are the odds? Well it looks like this one is intact.</td>
</tr>
<tr>
<td>Santa</td>
<td>Maybe it is encrypted OR encoded?</td>
</tr>
<tr>
<td>Santa</td>
<td>It looks like the program on the disk contains some weird coding.</td>
</tr>
<tr>
<td>Kevin</td>
<td>You know, there's something beautifully nostalgic about stumbling across old computing artifacts. Just last week, I was sorting through some boxes in my garage and came across a collection of 5.25" floppies from my college days - mostly containing terrible attempts at programming assignments and a few games I'd copied from friends. Finding an old Commodore 64 disk with a mysterious BASIC program on it? That's like discovering a digital time capsule. The C64 was an incredible machine for its time - 64KB of RAM seemed like an ocean of possibility back then. I spent countless hours as a kid typing in program listings from Compute! magazine, usually making at least a dozen typos along the way. The thing about BASIC programs from that era is they were often written by clever programmers who knew how to hide things in plain sight. Sometimes the most interesting discoveries come from reading the code itself rather than watching it execute. It's like being a digital archaeologist - you're not just looking at what the program does, you're understanding how the programmer thought. Take your time with this one. The beauty of reverse engineering isn't in rushing to the answer, but in appreciating the craft of whoever wrote it. Those old-school programmers had to be creative within such tight constraints.</td>
</tr>
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
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
<td>None</td>
<td>None</td>
</tr>
</tbody>
</table>
