---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act1_owner_mjd.html">Previous Objective: Act1 Owner</a></th> <th><a href="/HHC_2025/index.html">Home Page</a></th> <th><a href="/HHC_2025/act2_mail_detective_mjd.html">Next Objective: Act2 Mail Detective</a></th></table>
---
<table>
<thead><tr><th>Objective: Retro Recovery</th> <th>Difficulty Level: 2</th><tr><td>Join Mark in the retro shop. Analyze his disk image for a blast from the retro past and recover some classic treasures.</td> <td>Location: Retro Shop</td></table>
<br>
<h2>Solution Overview</h2>
<br>
This objective is a digital forensics investigation involving a floppy disk image file that required data recovery. The investigator used the Linux <code>losetup</code> command to mount the floppy disk image as a loop device, treating the image file as a physical block device. TestDisk was then executed against the loop device <code>/dev/loop0</code> to search for deleted files. After selecting the appropriate disk and partition type settings, the "undelete" function was used to browse recoverable files. Among the deleted files, a BASIC source code file named <code>all_i-want_for_christmas.bas</code> was identified as interesting. Upon opening the recovered BASIC file in a text editor (mousepad), the investigator discovered an embedded base64-encoded string within the source code. The base64 string <code>bWVycnkgY2hyaXN0bWFzIHRvIGFsbCBhbmQgdG8gYWxsIGEgZ29vZCBuaWdodAo=</code> was decoded to reveal the hidden message: "merry christmas to all and to all a good night". This investigation demonstrates common digital forensics techniques including disk imaging, file carving, and data decoding.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Execute TestDisk against loop device /dev/loop0</td> <td>Discovery</td> <td>T1083</td> <td>File and Directory Discovery</td><tr><td>Recover deleted file "all_i-want_for_christmas.bas"</td> <td>Collection</td> <td>T1074.001</td> <td>Data Staged: Local Data Staging</td><tr><td>Decode base64 string to reveal hidden message</td> <td>Deobfuscate/Decode Files or Information</td> <td>T1140</td> <td>Deobfuscate/Decode Files or Information</td></table>
<br>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<br>
<p><a href="/HHC_2025/resources/retrorecovery_floppy.img">Floppy Disk Image File</a></p>
<br>
<p><code>losetup</code> is a Linux command used to set up and manage loop devices, which let you treat a regular file as if it were a block device (like a disk).</p>
<br>
<p>Setup the disk image as a block device using the command:</p>
<br>
<p><pre><code></p>
<br>
<p></code></pre></p>
<br>
<p>1. Select the disk0 as the media and click proceed</p>
<br>
<p>2. Accept the default "none" as the partition type</p>
<br>
<p>3. Select "undelete" as the action</p>
<br>
<p>!<a href="/HHC_2025/images/retrorecovery_explorefiles.jpg">TestDisk interface showing file listing on floppy disk image</a></p>
<br>
<p>There is an interesting file: <code>all_i-want_for_christmas.bas</code></p>
<br>
<p>Highlight the file and select "C" to copy the selected file.</p>
<br>
<p>Successfully recovered the deleted file <code>all_i-want_for_christmas.bas</code> to the current directory.</p>
<br>
<p>Open in mousepad and explore:</p>
<br>
<p>!<a href="/HHC_2025/images/retrorecovery_sourcecode.jpg">BASIC source code file contents showing encoded string</a></p>
<br>
<p>There is a base64 encoded string:</p>
<br>
<p><pre><code></p>
<br>
<p></code></pre></p>
<br>
<p>Which decodes to:</p>
<br>
<p><pre><code></p>
<br>
<p></code></pre></p>
<br>
<p><strong>Answer: merry christmas to all and to all a good night</strong></p>
<br>
<p>---</p>
<br>
<p><strong>Answer: Flag or Answer</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>losetup</td> <td>2.40.4</td> <td></td><tr><td>testdisk</td> <td>7.2</td></table>
<br>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>I miss old school games. I wonder if there is anything on this disk? I remember, when kids would accidentlly delete things.......... it wasn't to hard to recover files. I wonder if you can still mount these disks?</td><tr><td>Santa</td> <td>Wow! A disk from the 1980s! I remember delivering those computer disks to the good boys and girls. Games were their favorite, but they weren't like they are now.</td><tr><td>Santa</td> <td>I know there are still tools available that can help you find deleted files. Maybe that might help. Ya know, one of my favorite games was a Quick Basic game called Star Trek.</td><tr><td>Mark</td> <td>This FAT12 floppy disk image must have been under an arcade machine here in the Retro Store. When I was a kid we shared warez by hiding things as deleted files. I remember writing programs in BASIC. So much fun! My favorite was Star Trek. The beauty of file systems is that 'deleted' doesn't always mean gone forever. Ready to dive into some digital archaeology and see what secrets this old disk is hiding? Download the floppy disk image, and see what you can find!</td></table>
<br>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act1_owner_mjd.html">Previous Objective: Act1 Owner</a></th> <th><a href="/HHC_2025/index.html">Home Page</a></th> <th><a href="/HHC_2025/act2_mail_detective_mjd.html">Next Objective: Act2 Mail Detective</a></th></table>