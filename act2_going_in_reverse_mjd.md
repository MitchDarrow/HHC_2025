---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act2_quantgnome_leap_mjd.html">Previous Objective: Act2 Quantgnome Leap</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_gnome_tea_mjd.html">Next Objective: Act 3 Gnome Tea</a></th></table>
---
<table>
<thead><tr><th>Objective: Going in Reverse</th> <th>Difficulty Level: 2</th><tr><td>Kevin in the Retro Store needs help rewinding tech and going in reverse. Extract the flag and enter it here.</td> <td>Location: Retro Store</td></table>
<h2>Solution Overview</h2>
Clicking on the BASIC program downloads it into the browser window. Reviewing the source code contains an encoded flag (line 30) and that the code applies a bitwise XOR (-bxor) with the number 7. The PowerShell script applies this logic to decode the encoded text.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Decode encoded information</td> <td>Defense Evasion (adversaries attempt to avoid detection or obfuscate activity)</td> <td>T1140</td> <td>Deobfuscate/Decode Files or Information</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>The basic program consists of the following code:</p>
<p><pre><code></p>
<p></code></pre></p>
<p>The program has the encoded flag and the decoder. This PowerShell script will decode the string. Note that the â€˜ denotes a comment in basic.</p>
<p><pre><code></p>
<p></code></pre></p>
<p><strong>Answer: CTF{frost-plan:compressors,coolant,oil}</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>PowerShell</td> <td>5.1.26100.6899</td> <td></td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Holy cow! Another retro floppy disk, what are the odds? Well it looks like this one is intact.</td><tr><td>Santa</td> <td>Maybe it is encrypted OR encoded?</td><tr><td>Santa</td> <td>It looks like the program on the disk contains some weird coding.</td><tr><td>Kevin</td> <td>You know, there's something beautifully nostalgic about stumbling across old computing artifacts. Just last week, I was sorting through some boxes in my garage and came across a collection of 5.25" floppies from my college days - mostly containing terrible attempts at programming assignments and a few games I'd copied from friends. Finding an old Commodore 64 disk with a mysterious BASIC program on it? That's like discovering a digital time capsule. The C64 was an incredible machine for its time - 64KB of RAM seemed like an ocean of possibility back then. I spent countless hours as a kid typing in program listings from Compute! magazine, usually making at least a dozen typos along the way. The thing about BASIC programs from that era is they were often written by clever programmers who knew how to hide things in plain sight. Sometimes the most interesting discoveries come from reading the code itself rather than watching it execute. It's like being a digital archaeologist - you're not just looking at what the program does, you're understanding how the programmer thought. Take your time with this one. The beauty of reverse engineering isn't in rushing to the answer, but in appreciating the craft of whoever wrote it. Those old-school programmers had to be creative within such tight constraints.</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>None</td> <td>None</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act2_quantgnome_leap_mjd.html">Previous Objective: Act2 Quantgnome Leap</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act3_gnome_tea_mjd.html">Next Objective: Act 3 Gnome Tea</a></th></table>