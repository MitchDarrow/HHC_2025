---
layout: default
title: act2_going_in_reverse_mjd
nav: |
  |[Previous Objective: Act2 Quantgnome Leap](/act2_quantgnome_leap_mjd.md)  |   [Table of Contents](/index.md) | [Next Objective: Act 3 Gnome Tea](/act3_gnome_tea_mjd.md) |
  | :----------------------- | :--------------------------------: | --------------------------------: |
---
<table>
<thead>
<tr>
<th>Objective: Going in Reverse</th>
<br>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Kevin in the Retro Store needs help rewinding tech and going in reverse. Extract the flag and enter it here.</td>
<br>
<td>Location: Retro Store</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

Clicking on the BASIC program downloads it into the browser window. Reviewing the source code contains an encoded flag (line 30) and that the code applies a bitwise XOR (-bxor) with the number 7. The PowerShell script applies this logic to decode the encoded text.

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
<td>Decode encoded information</td>
<br>
<td>Defense Evasion (adversaries attempt to avoid detection or obfuscate activity)</td>
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

The basic program consists of the following code:

<pre><code class="language-basic">
<br>
10 REM <em><strong> COMMODORE 64 SECURITY SYSTEM </strong></em>
<br>
20 ENC_PASS$ = "D13URKBT"
<br>
30 ENC_FLAG$ = "DSA|auhts<em>wkfi=dhjwubtthut+dhhkfis+hnkz" ' old "DSA|qnisf`bX_huXariz"
<br>
40 INPUT "ENTER PASSWORD: "; PASS$
<br>
50 IF LEN(PASS$) <> LEN(ENC_PASS$) THEN GOTO 90
<br>
60 FOR I = 1 TO LEN(PASS$)
<br>
70 IF CHR$(ASC(MID$(PASS$,I,1)) XOR 7) <> MID$(ENC_PASS$,I,1) THEN GOTO 90
<br>
80 NEXT I
<br>
85 FLAG$ = "" : FOR I = 1 TO LEN(ENC_FLAG$) : FLAG$ = FLAG$ + CHR$(ASC(MID$(ENC_FLAG$,I,1)) XOR 7) : NEXT I : PRINT FLAG$
<br>
90 PRINT "ACCESS DENIED"
<br>
100 END
<br>
</code></pre>

The program has the encoded flag and the decoder. This PowerShell script will decode the string. Note that the ‘ denotes a comment in basic.

<pre><code class="language-powershell">
<br>
<h1>PowerShell script to decode the ENC_FLAG$ string using XOR</h1>
<br>
<h1>Encoded string</h1>
<br>
$encFlag = "DSA|auhts</em>wkfi=dhjwubtthut+dhhkfis+hnkz"

#"old DSA|qnisf`bX_huXariz"

<h1>Initialize decoded string</h1>
<br>
$decoded = ""

<h1>Loop through each character</h1>
<br>
for ($i = 0; $i -lt $encFlag.Length; $i++) {
<br>
<h1>Get ASCII code of character</h1>
<br>
    $ascii = [int][char]$encFlag[$i]
<br>
<h1>XOR with 7</h1>
<br>
    $decodedChar = <a href="/HHC_2025/$ascii -bxor 7">char</a>
<br>
<h1>Append to result</h1>
<br>
    $decoded += $decodedChar
<br>
}

<h1>Print decoded string</h1>
<br>
Write-Output $decoded
<br>
 CTF{frost-plan:compressors,coolant,oil}
<br>
</code></pre>

<strong>Answer: CTF{frost-plan:compressors,coolant,oil}</strong>

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
<td>PowerShell</td>
<br>
<td>5.1.26100.6899</td>
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
<td>Holy cow! Another retro floppy disk, what are the odds? Well it looks like this one is intact.</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>Maybe it is encrypted OR encoded?</td>
</tr>
<tr>
<td>Santa</td>
<br>
<td>It looks like the program on the disk contains some weird coding.</td>
</tr>
<tr>
<td>Kevin</td>
<br>
<td>You know, there's something beautifully nostalgic about stumbling across old computing artifacts. Just last week, I was sorting through some boxes in my garage and came across a collection of 5.25" floppies from my college days - mostly containing terrible attempts at programming assignments and a few games I'd copied from friends. Finding an old Commodore 64 disk with a mysterious BASIC program on it? That's like discovering a digital time capsule. The C64 was an incredible machine for its time - 64KB of RAM seemed like an ocean of possibility back then. I spent countless hours as a kid typing in program listings from Compute! magazine, usually making at least a dozen typos along the way. The thing about BASIC programs from that era is they were often written by clever programmers who knew how to hide things in plain sight. Sometimes the most interesting discoveries come from reading the code itself rather than watching it execute. It's like being a digital archaeologist - you're not just looking at what the program does, you're understanding how the programmer thought. Take your time with this one. The beauty of reverse engineering isn't in rushing to the answer, but in appreciating the craft of whoever wrote it. Those old-school programmers had to be creative within such tight constraints.</td>
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
<td>None</td>
<br>
<td>None</td>
</tr>
</tbody>
</table>