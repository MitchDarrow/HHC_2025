---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act1_visual_networking_mjd.html">Previous Objective: Act1 Visual Networking</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act1_intro_to_nmap_mjd.html">Next Objective: Act1 Intro to NMAP</a></th></table>
---
<table>
<thead><tr><th>Objective: Visual Firewall</th> <th>Difficulty Level: 1</th><tr><td>Find Elgee in the big hotel for a firewall frolic and some techy fun.</td> <td>Location: Grand Hotel</td></table>
<h2>Solution Overview</h2>
The objective is to correctly configure firewall rules to best security practices. Without proper firewall configuration, security analysts lose a crucial control point for preventing, detecting, and responding to threats. 
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Review existing firewall rules and policies</td> <td>Discovery</td> <td>T1082</td> <td>System Information Discovery</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>Rule: Internet to DMZ: Allow only HTTP and HTTPS traffic</p>
<p>Rule: DMZ to Internal: Allow HTTP, HTTPS and SSH traffic</p>
<p>Rule: Internal to DMZ: Allow HTTP, HTTPS and SSH traffic</p>
<p>Rule: Internal to Cloud: Allow HTTP, HTTPS, SSH and SMTP traffic</p>
<p>Rule: Internal to Workstations: Allow all traffic types</p>
<p>Rule: Internet to Internal: Block direct Internet to Internal access</p>
<p><strong>Answer: Configure rules to Security Best Practice</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>none</td> <td>none</td> <td></td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>This terminal has built-in hints.</td><tr><td>Elgee</td> <td>Welcome to my little corner of network security! finger guns I've whipped up something sweeter than my favorite whoopie pie - an interactive firewall simulator that'll teach you more in ten minutes than most textbooks do in ten chapters. Don't worry about breaking anything; that's half the fun of learning! Ready to dig in?</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act1_visual_networking_mjd.html">Previous Objective: Act1 Visual Networking</a></th> <th><a href="/HHC_2025/index.html">Table of Contents</a></th> <th><a href="/HHC_2025/act1_intro_to_nmap_mjd.html">Next Objective: Act1 Intro to NMAP</a></th></table>