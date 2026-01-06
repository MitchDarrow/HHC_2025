---
layout: default
title: act2_going-in-reverse_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_quantgnome-leap_srt.html">Previous Objective: Act2 Quantgnome Leap</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act3_gnome_tea_mjd.html">Next Objective: Act 3 Gnome Tea</a></th>
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
<br>
Kevin was digging through old equipment when he discovered a Commodore 64 disk with a mystery BASIC program on it. He tells us that BASIC programmers of that era were clever, often hiding things in plain sight. He tells us that in these cases, reading the code can often be more valuable than observing how it executes. "Take your time with this one. Those old-school programmers had to be creative within such tight constraints. You'll know the flag by the Christmas phrase that pays."
<br>

The key here is the name of the challenge. A bitwise XOR is used to encode user-provided strings in order to match these strings against a hard-coded encrypted password. Since XOR is a symmetrical operation, we can <em>go in reverse</em> of the original operation to decrypt these hard-coded credentials. A quick python script allows us to decrypt these values for a password of <code>C64RULES</code> and a flag of <strong><code>CTF{frost-plan:compressors,coolant,oil}</code></strong>. 
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
<td>Decode XOR Strings</td>
<td>Defense Evasion</td>
<td>T1140</td>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
<tr>
<td>Extract Hardcoded Password</td>
<td>Credential Access</td>
<td>T1552.001</td>
<td>Unsecured Credentials: Credentials in Files</td>
</tr>
<tr>
<td>Execute Python Solver</td>
<td>Execution</td>
<td>T1059.006</td>
<td>Command and Scripting Interpreter: Python</td>
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
We are given a text <code>.bas</code> file with a few lines of code:
<pre><code class="language-BASIC">
10 REM COMMODORE 64 SECURITY SYSTEM 
20 ENC_PASS$ = "D13URKBT"
30 ENC_FLAG$ = DSA|auhtswkfi=dhjwubtthut+dhhkfis+hnkz" ' old "DSA|qnisf`bX_huXariz"
40 INPUT "ENTER PASSWORD: "; PASS$
50 IF LEN(PASS$) <> LEN(ENC_PASS$) THEN GOTO 90
60 FOR I = 1 TO LEN(PASS$)
70 IF CHR$(ASC(MID$(PASS$,I,1)) XOR 7) <> MID$(ENC_PASS$,I,1) THEN GOTO 90
80 NEXT I
85 FLAG$ = "" : FOR I = 1 TO LEN(ENC_FLAG$) : FLAG$ = FLAG$ + CHR$(ASC(MID$(ENC_FLAG$,I,1)) XOR 7) : NEXT I : PRINT FLAG$
90 PRINT "ACCESS DENIED"
100 END
</code></pre>
<br>
This <code>login.bas</code> program is designed to accept an attempt at a login password, which is matched against a string that's obfuscated via function calls that perform a bitwise XOR 7 operation on the ASCII value of each character before converting the ASCII value back to C64-usable characters via <code>CHR()</code>. The bitwise XOR is a symmetrical operation; to find the original value of each character we can perform the same set of operations on the encrypted characters. The below python code below demonstrates this. 
<pre><code class="language-python">
enc_pass = "D13URKBT"
enc_flag = "DSA|auhtswkfi=dhjwubtthut+dhhkfis+hnkz"
def decrypt(text):
    return "".join([chr(ord(c) ^ 7) for c in text])
print("Password:", decrypt(enc_pass))
print("Flag:", decrypt(enc_flag))
</code></pre>
<p>
This code starts with an empty string, then iterates through each character in the given string to:
<br>
</p>
<ol>
<li>convert the character value to its ASCII <strong>integer</strong> value</li>
<li>bitwise XOR that ASCII value by 7</li>
<li>convert the resulting value back into its ASCII <strong>character</strong> value (more likely UTF-8 but it's indistinguishable for the purposes of this exercise)</li>
</ol>
<br>
Note lines <code>20</code> and <code>30</code> containing <code>ENC_PASS</code> and <code>ENC_FLAG</code> respectively. 
Using this code, we retrive a password of <code>C64RULES</code> and a flag of <strong><code>CTF{frost-plan:compressors,coolant,oil}</code></strong>.
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
<td>Python</td>
<td>3.15</td>
</tr>
</tbody>
</table>
