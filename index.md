---
layout: default
title: index
---
<style>
  th.hhc-title {
    font-size: 2em !important;        /* match H1 size */
    font-weight: normal !important;   /* remove bold */
    color: #FFFFFF !important;        /* white */
    padding-left: 0.75rem !important; /* add left padding */
    padding-top: 0 !important;
    padding-bottom: 0 !important;
    padding-right: 0 !important;
    border: none !important;
    text-align: left;
  }
</style>

<p>
<h1>BerryDunn Holiday Hack Challenge Solution Report</h1>
</p>
<table>
<thead>
<tr>
<th class="hhc-title">SANS 2025<br>Holiday Hack Challenge:<br>Revenge of the Gnome(s)</th>
<th><img src="/HHC_2025/images/HHC.webp" alt="Holiday Hack Challenge Logo"></th>
</tr>
</thead>
<tbody>
</tbody>
</table>
<p>
<h3>About the Holiday Hack Challenge (HHC)</h3>
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
<li>Total participants starting Act 3: 814</li>
<li>Total participants completing the HHC: 191</li>
</ul>
<p>
This year's HHC is structured in 3 Acts. Act 1 is intended to practice and polish skills. Some of these tools are old friends, and some of these tools may be unfamiliar. Act 2 increases the difficulty, in some cases chaining attacks to achieve the objective. Act 3 increases the complexity and difficulty for most of the objectives.  The difficulty of an objective is rated on a 1-5 scale, with 1 being less difficult, and 5 being the most difficult.
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
<li>A high level summary of the solution including a MITRE ATT&CK Mapping</li>
<li>An expandable section with the detailed solution, including screenshots and code snippets</li>
<li>A summary of tools used</li>
<li>A summary of hints for the objective</li>
<li>An acknowledgements summary, thanking other participants for any guidance in solving the objective</li>
</ul>
<p>
A matrix of solution write-ups for each objective that team members completed may be found here:<br><a href="/HHC_2025/allwriteups.html"><b>All Solutions</b></a>
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
<td><a href="/HHC_2025/act2_retro-recovery_srt.html">Retro Recovery</a></td>
<td><a href="/HHC_2025/act3_gnome_tea_mjd.html">Gnome Tea</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_its-all-about-defang_srt.html">Its All About Defang</a></td>
<td><a href="/HHC_2025/act2_mail-detective_srt.html">Mail Detective</a></td>
<td><a href="/HHC_2025/act3_hack-a-gnome_mjd.html">Hack-a-Gnome</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_neighborhood_watch_bypass_mjd.html">Neighborhood Watch Bypass</a></td>
<td><a href="/HHC_2025/act2_idorable-bistro_srt.html">IDORable Bistro </a></td>
<td><a href="/HHC_2025/act3_snowcat_mjd.html">Snowcat RCE and Command Injection</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_santas-gift-tracking_srt.html">Santa’s Gift-Tracking Service Port Mystery</a></td>
<td><a href="/HHC_2025/act2_dosis-network-down_srt.html">Dosis Network Down</a></td>
<td><a href="/HHC_2025/act3_schrodingersscope_mjd.html">Schrodinger's Scope</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_visual_networking_mjd.html">Visual Networking</a></td>
<td><a href="/HHC_2025/act2_rogue-gnome-identity-provider_srt.html">Rogue Gnome Identity Provider</a></td>
<td><a href="/HHC_2025/act3_snowglobe_mjd.html">Find and Shutdown Frosty's Snow Globe</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_visual-firewall_srt.html">Visual Firewall</a></td>
<td><a href="/HHC_2025/act2_quantgnome-leap_srt.html">Quantgnome Leap</a></td>
<td><a href="/HHC_2025/act3_onthewire_mjd.html">On The Wire</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_intro_to_nmap_mjd.html">Into to NMAP</a></td>
<td><a href="/HHC_2025/act2_going-in-reverse_srt.html">Going in Reverse</a></td>
<td><a href="/HHC_2025/act3_free_ski_mjd.html">Free Ski</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_blob-storage_srt.html">Blob Storage Challenge in the Neighborhood </a></td>
<td> </td>
<td><a href="/HHC_2025/act3_snowblindambush_mjd.html">SnowBlind Ambush</a></td>
</tr>
<tr>
<td><a href="/HHC_2025/act1_spare_key_mjd.html">Spare Key </a></td>
<td> </td>
<td> </td>  
</tr>
<tr>
<td><a href="/HHC_2025/act1_the-open-door_srt.html">The Open Door </a></td>
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
Learn more <a href="/HHC_2025/about_berrydunn.html"><b>about BerryDunn</b></a>.
<br>
</p>
<p>
Find out more <a href="/HHC_2025/about_its.html"><b>about BerryDunn's Cybersecurity Team</b></a> and the services offered.
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
</tr>
<tbody>
</tbody>
</table>
<img src="https://raw.githubusercontent.com/mitchdarrow/HHC_2025/main/images/pixel.gif" style="display:none;">


