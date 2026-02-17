---
layout: default
title: act2_quantgnome-leap_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_rogue-gnome-identity-provider_srt.html">Previous Objective: Act2 Rogue Gnome Identity Provider</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_going-in-reverse_srt.html">Next Objective: Act 2 Going in Reverse</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table class="quest-table">
<thead>
<tr>
<th>Objective: Quantgnome Leap</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Charlie in the hotel has quantim gnome mysteries waiting to be solved. What is the flag that you find?</td>
<td>Location: The Hotel</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
Charlie has spotted a mysterious gnome - he winked and vanished, or maybe he’s still here? We must help him decode cryptic post quantum mysteries. 
<br>
This challenge functions more as a demonstration of post-quantum encryption schemes. We first generate a set of PQC keys, observing their bit lengths and NIST security levels. We are then given a clue about viewing the key length which allows us to discover the <code>gnome1</code> username to use with the SSH challenge. 
From there, it is pretty straightforward to escalate to admin; each <code>gnome{1,2,3,4}</code> user possesses keys of increasing strength. When we log into a new user via ssh (no trickery required), the banner gives us information about each key scheme, its limitations, strengths, etc. After escalating to admin, we check <code>/opt</code> to find the PQC ssh daemon's directory, within which is hidden the flag. 
</p>
<table class="quest-table">
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
<td>Generate PQC Keys</td>
<td>Resource Development</td>
<td>T1587.003</td>
<td>Develop Capabilities: Digital Certificates</td>
</tr>
<tr>
<td>SSH Lateral Movement</td>
<td>Lateral Movement</td>
<td>T1021.004</td>
<td>Remote Services: SSH</td>
</tr>
<tr>
<td>Enumerate Key Info</td>
<td>Discovery</td>
<td>T1082</td>
<td>Ssytem Information Discovery</td>
</tr>
<tr>
<td>Locate Hidden Flag</td>
<td>Discovery</td>
<td>T1083</td>
<td>File and Directory Discovery</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
</p>
<details>
<summary>Click to expand</summary>
<p>
We are first given a dazzling quantgnome introduction to load the terminal, then told that there is a tool used to generate post-quantum cryptography (PQC) keys accessible to our user. We are tasked with finding and executing that program.
<br>
There are many ways to find this command; I simply typed <code>pqc</code> and pressed the tab key repeatedly until the terminal filled in the <code>pqc-keygen</code> command. 
<br>
Running this command will generate a set of 28 keys of varying strengths, types, and algorithms. Some keys are generated using classical methods, some using post-quantum methods, and some using a mixture of both. 
<br>
We then use the hint provided by <code>pqc-keygen -t</code> to identify the target user of our first quantgnome leap: <code>gnome1</code>. This is the result of listing detailed information about our <code>.ssh/id_rsa</code> file via <code>ssh-keygen -l -f</code>. <br><br>
We use this RSA key to make our first leap. The <code>.ssh</code> directory of the <code>gnome1</code> user contains an ED25519 key which we can use to authenticate as <code>gnome2</code> with the <code>ssh -i</code> command. We are told that both the RSA and ED25519 key generation algorithms are not safe in a post-quantum world due to the reduction of the time complexity requirements in solving classical algorithms.<br><br> 
To authenticate as <code>gnome3</code>, we use a MAYO2 post-quantum key. While this key type is promising for embedded systems, there is currently no standardized MAYO2 implementation. We next use a hybrid key type, <code>nistp256_sphincssha2128fsimple</code>. This key combines a NIST P-256 ECDSA classical elliptical curve key type with the post-quantum SPHINCS+ key type. This key is unique in that it produces two keys that are both checked together, one classical and one post-quantum. If either key fails authentication, the authentication process fails.<br><br> 
To login to the <code>admin</code> account we use a <code>nistp521_mldsa87</code> key. This is another hybrid key type using the NIST P-521 elliptic curve (roughly equivalent to a 15360-bit RSA key) paired with the ML-DSA-87 post-quantum algorithm. ML-DSA-87 is a security level 5 algorithm which is intended for the highest security requirements. This hybrid key is one of the strongest post-quantum algorithms currently available. <br><br>
We are told that the flag is within the configuration directory of the SSH daemon. We typically find configuration data related to optional or non-standard applications under the <code>/opt</code> directory. Using the administrator account, we poke around the <code>/opt/oqs-ssh/flag</code> directory to find the <strong>HHC{L3aping_0v3r_Quantum_Crypto}</strong> flag.
</p>
</details>
<p>
<h2>Tools Reference</h2>
</p>
<table class="quest-table">
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>pqc-keygen</td>
<td>1.0</td>
</tr>
<tr>
<td>OpenSSH</td>
<td>1:9.5p1-1</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
</p>
<table class="quest-table">
<thead>
<tr>
<th>Provided By</th>
<th>Hint</th>
</tr>
</thead>
<tbody>
<tr>
<td>Santa</td>
<td>When you give a present, you often put a label on it to let someone know that the present is for them. Sometimes you even say who the present is from. The label is always put on the outside of the present so the public knows the present is for a specific person. SSH keys have something similar called a comment. SSH keys sometimes have a comment that can help determine who and where the key can be used.</td>
</tr>
<tr>
<td>Santa</td>
<td>User keys are like presents. The keys are kept in a hidden location until they need to be used. Hidden files in Linux always start with a dot. Since everything in Linux is a file, directories that start with a dot are also...hidden!</td>
</tr>
<tr>
<td>Santa</td>
<td>Process information is very useful to determine where an application configuration file is located. I bet there is a secret located in that application directory, you just need the right user to read it!</td>
</tr>
<tr>
<td>Santa</td>
<td>If you want to create SSH keys, you would use the ssh-keygen tool. We have a special tool that generates post-quantum cryptographic keys. The suffix is the same as ssh-keygen. It is only the first three letters that change.</td>
</tr>
<tr>
<td>JJ</td>
<td>I just spotted a mysterious gnome - he winked and vanished, or maybe he's still here? Things are getting strange, and I think we've wandered into a quantum conundrum! If you help me unravel these riddles, we might just outsmart future quantum computers. Cryptic puzzles, quirky gnomes, and post-quantum secrets-will you leap with me?</td>
</tr>
</tbody>
</table>
<p>
<h2>Acknowledgements</h2>
</p>
<table class="quest-table">
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
