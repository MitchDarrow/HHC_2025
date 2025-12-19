---
layout: default
title: index
---
<p>
<h1>BerryDunn Holiday Hack Challenge Solution Report</h1>
<br>
</p>
<table>
<thead>
<tr>
<th>SANS Holiday Hack Challenge 2025:<br>Revenge of the Gnome(s)</th>
<th><img src="/HHC_2025/images/HHC.webp" alt="Holiday Hack Challenge Logo"></th>
</tr>
</thead>
<tbody>
</tbody>
</table>
<p>
<h3>About the Holiday Hack Challenge (HHC)</h3>
<br>
The SANS Holiday Hack Challenge is a free, annual cybersecurity competition designed to help participants strengthen their technical skills through practical, hands-on challenges. At its core, the event is a large-scale capture-the-flag (CTF) exercise where players engage in penetration testing, reverse engineering, cryptography, network analysis, and other security disciplines. Each challenge is crafted to simulate real-world scenarios, giving participants the opportunity to practice problem-solving and apply security concepts in a safe environment. Since its early beginnings in the 2000s, the challenge has steadily evolved, incorporating increasingly sophisticated puzzles and interactive environments that encourage both individual learning and team collaboration. Its primary purpose is to make skill development accessible to all levels of expertise, from students just starting out to seasoned professionals looking to refine their techniques. By offering a structured yet engaging platform, the Holiday Hack Challenge has become a respected training ground in the cybersecurity community, fostering growth, knowledge sharing, and the advancement of practical defensive and offensive security skills.
<br>
</p>
<p>
Some participation statistics from the 2024 HHC:
<br>
</p>
<ul>
<li>Total Players Starting the Prologue: 19,036</li>
<li>Total participants starting Act 1: 5937</li>
<li>Total participants starting Act 2: 2659</li>
<li>Total participants starting Act3: 814</li>
<li>Total participants completing the HHC: 191</li>
</ul>
<p>
This year's HHC is structured in 3 Acts. Act 1 is intended to practice and polish skills. Some of these tools are old friends, and some of these tools may be new. Act 2 increases the difficulty, in some cases chaining attacks to achieve the objective. Act 3 increases the complexity and difficulty for most of the objectives.  The difficulty of an objective is rated on a 1-5 scale, with 1 being less difficult, and 5 being the most difficult
<br>
</p>
<p>
Members of BerryDunn's IT Security Consulting team have participated in this event the last several years. The team uses the HHC for honing and developing staff member's skills. Each participant works independently. The team gathers once a week for a social hour where we are able to discuss objectives, tools, and techniques.
<br>
</p>
<p>
The list below is a curated list of the best of class solution for each objective, as determined by team consensus. Each write-up includes the following features:
<br>
</p>
<ul>
<li>An high level summary of the solution including a MITRE ATT&CK Mapping</li>
<li>An expandable section with the detailed solution, including screenshots and code snippets</li>
<li>A summary of tools used</li>
<li>A summary of hints for the objective</li>
<li>An acknoledgements summary, thanking other participants for any guidance in solving the objective</li>
</ul>
<p>
A matrix of solution write-ups for each objective that team members completed may be found here: <a href="/HHC_2025/allwriteups.html">All Solutions</a>
<br>
</p>
<p>
The following are the BerryDunn IT Security team's official solutions to this year's HHC objectives:
<br>
</p>
<table>
<thead>
<tr>
<th>Act 1 Official Solutions</th>
<th>Act 2 Official Solutions</th>
<th>Act 3 Official Solutions</th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="/HHC_2025/act1_orientation_mjd.html">Holiday Hack Orientation</a></td>
<td><a href="/HHC_2025/act2_retro_recovery_mjd.html">Retro Recovery</a></td>
<td><a href="/HHC_2025/act3_gnome_tea_mjd.html">Gnome Tea</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_its_all_about_defang_mjd.html">Its All About Defang</a></td>
<td><a href="/HHC_2025/act2_mail_detective_mjd.html">Mail Detective</a></td>
<td><a href="/HHC_2025/act3_hack-a-gnomesnowcat_mjd.html">Hack-a-Gnome</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_neighborhood_watch_bypass_mjd.html">Neighborhood Watch Bypass</a></td>
<td><a href="/HHC_2025/act2_idorable_bistro_mjd.html">IDORable Bistro </a></td>
<td><a href="/HHC_2025/act3_snowcat_mjd.html">Snowcat RCE and Command Injection</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_santas_gift-tracking_service_port_mystery_mjd.html">Santa’s Gift-Tracking Service Port Mystery</a></td>
<td><a href="/HHC_2025/act2_dosis_network_down_mjd.html">Dosis Network Down</a></td>
<td><a href="/HHC_2025/act3_schrodingersscope_mjd.html">Schrodinger's Scope</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_visual_networking_mjd.html">Visual Networking</a></td>
<td><a href="/HHC_2025/act2_rogue_gnome_identity_provider_mjd.html">Rogue Gnome Identity Provider</a></td>
<td><a href="/HHC_2025/act3_snowglobe_mjd.html">Find and Shutdown Frosty's Snow Globe</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_visual_firewall_mjd.html">Visual Firewall</a></td>
<td><a href="/HHC_2025/act2_quantgnome_leap_mjd.html">Quantgnome Leap</a></td>
<td><a href="/HHC_2025/act3_onthewire_mjd.html">On The Wire</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_intro_to_nmap_mjd.html">Into to NMAP</a></td>
<td><a href="/HHC_2025/act2_going_in_reverse_mjd.html">Going in Reverse</a></td>
<td><a href="/HHC_2025/act3_free_ski_mjd.html">Free Ski</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_blob_storage_mjd.html">Blob Storage Challenge in the Neighborhood </a></td>
<td> </td>
<td><a href="/HHC_2025/act3_snowblindambush_mjd.html">SnowBlind Ambush</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_spare_key_mjd.html">Spare Key </a></td>
<td> </td>
<td> </td>  
</tr>
<tr>
<td><a href="/HHC_2025/act1_the_open_door_mjd.html">The Open Door </a></td>
<td> </td>
<td> </td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_owner_mjd.html">Owner</a></td>
<td> </td> 
<td> </td>  
</tr>
</tbody>
</table>
<p>
For more information about BerryDunn <a href="/HHC_2025/about_berrydunn.html">About BerryDunn</a>
<br>
</p>
<p>
For more information about the BerryDunn's IT Security Team and the services offered <a href="/HHC_2025/about_its.html">About BerryDunn's Cybersecurity Team</a>
<br>
</p>
<p>
Meet the BerryDunn team members who participated in this year's challenge:
<br>
</p>
<table style="width:100%;">
<tr>
<td style="width:25%;"><a href="/HHC_2025/bio_mjd.html">Mitch Darrow</a></td>
<td style="width:25%;"><a href="/HHC_2025/bio_srt.html">Spencer Treece</a></td>
<td style="width:25%;"><a href="/HHC_2025/bio_kgb.html">Kodi Berube</a></td>
<td style="width:25%;"><a href="/HHC_2025/bio_lk.html">Louis Krupp</a></td>
</tr>
<tbody>
</tbody>
</table>
