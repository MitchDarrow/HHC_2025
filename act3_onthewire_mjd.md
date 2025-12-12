---
nav: |
  <table>
  <thead><tr><th><a href="/act3_snowglobe_mjd.html">Previous Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act3_free_ski_mjd.html">Next Objective: Act3 Free Ski</a></th></table>
  
---

<table>
<thead><tr><th>Objective: On The Wire</th> <th>Difficulty Level: 4</th><tr><td>Help Evan next to city hall hack this gnome and retrieve the temperature value reported by the IÂ²C device at address 0x3C. The temperature data is XOR-encrypted, so youâ€™ll need to work through each communication stage to uncover the necessary keys. Start with the unencrypted data being transmitted over the 1-wire protocol.</td> <td>Location: City Hall</td></table>


## Solution Overview

Using browser developer tools, the data for each signal is captured. The data is analyzed using powershell and python scripts and decoded, leveraging the signal descriptions contained in the hints. Decoding each signal enables the decoding of the next signal. The protocols are dq, SPI, and I2C, which are board-level or device-level buses.

<table>
<thead><tr><th>Activity</th> <th>Primary Tactic</th> <th>MITRE ATT&CK Technique ID</th> <th>MITRE ATT&CK Technique Name</th><tr><td>Decode hidden payload</td> <td>Defense Evasion</td> <td>T1140</td> <td>Deobfuscate/Decode Files or Information</td></table>



## Detailed Solution
<details>
<summary>Click to expand</summary>
<h3>Part One: 1-Wire</h3>
<p>The following python script connects to the web socket and collects the data into a csv file:</p>
<pre><code>
import websocket
import csv

# Open CSV file once at the start
f = open(&quot;onthewire_1wire_data.csv&quot;, &quot;w&quot;, newline=&quot;&quot;, encoding=&quot;utf-8&quot;)
writer = csv.writer(f)

def on_message(ws, message):
    print(&quot;Received:&quot;, message)  # See messages in console
    writer.writerow([message])
    f.flush()  # Ensure data is written immediately

def on_error(ws, error):
    print(&quot;Error:&quot;, error)

def on_close(ws, close_status_code, close_msg):
    print(&quot;Connection closed&quot;)
    f.close()

def on_open(ws):
    print(&quot;Connection opened&quot;)

url = &quot;wss://signals.holidayhackchallenge.com/wire/dq&quot;
ws = websocket.WebSocketApp(url,                             on_open=on_open,                             on_message=on_message,                             on_error=on_error,                             on_close=on_close)

ws.run_forever()
</code></pre>
<p>The data file collected: <a href="HHC_2025_Template/resources/OntheWire_1wire_data.csv</p> <p>The data contains the following markers:</p> <p>- "reset" at t=1 (reset pulse">1-wire data</a></p>
<p>- "presence" at t=551 (presence pulse response)</p>
<p> - "idle" at t=0 (bus idle high)</p>
<p>1-Wire Decoding</p>
<p>In 1-Wire, data is encoded using pulse width modulation:</p>
<p>- Write/Read 0: Long low pulse (~60Âµs)</p>
<p>- Write/Read 1: Short low pulse (~6Âµs)</p>
<p>Decode the signal after the presence pulse by measuring the low-pulse widths:</p>
<p>Time slot analysis (from t=701 onwards):</p>
<p>701â†’941: 240Âµs LOW â†’ 0</p>
<p>1001â†’1011: 10Âµs LOW â†’ 1</p>
<p>1071â†’1081: 10Âµs LOW â†’ 1</p>
<p>1087â†’1151: 64Âµs LOW â†’ 0</p>
<p>1157â†’1221: 64Âµs LOW â†’ 0</p>
<p>1281â†’1291: 10Âµs LOW â†’ 1</p>
<p>1351â†’1361: 10Âµs LOW â†’ 1</p>
<p>1367â†’1431: 64Âµs LOW â†’ 0</p>
<p>Continuing this analysis through the entire sequence and assembling bits LSB-first (1-Wire standard):</p>
<p>Decoded bits (grouped by byte, LSB first):</p>
<p>1. 01100011 â†’ 0x63 â†’ 'c'</p>
<p>2. 01101000 â†’ 0x68 â†’ 'h'</p>
<p>3. 01110010 â†’ 0x72 â†’ 'r'</p>
<p>4. 01101001 â†’ 0x69 â†’ 'i</p>
<p>5. 01110011 â†’ 0x73 â†’ 's'</p>
<p>6. 01110100 â†’ 0x74 â†’ 't'</p>
<p>7.  01101101 â†’ 0x6D â†’ 'm'</p>
<p>8. 01100001 â†’ 0x61 â†’ 'a'</p>
<p>9. 01110011 â†’ 0x73 â†’ 's'</p>
<p>Decoded Message</p>
<p>XOR key: christmas</p>
<p>The data is not encoded with the key Christmas, the bites translate to the following message:</p>
<p><strong>read and decrypt the SPI bus data using the XOR key: icy</strong></p>
<h3>Part 2: Get the SPI bus data stream and decode.</h3>
<p>SPI has the following characteristics:</p>
<p>- Multiple wires: sck (clock), mosi (data), sometimes miso </p>
<p>- Clock-driven: You sample the data line when the clock transitions </p>
<p>- Data is valid on clock edges (rising or falling)</p>
<p>Using Firefox developer tools, the SPI data signal is captrued and exported to the following json file: <a href="HHC_2025_Template/resources/onthewire_spidata.xml"">SPI Data</a></p>
<p>The following decoder was written in Powershell: <a href="HHC_2025_Template/resources/onthewire_spidecoder.ps1.txt"">SPI Decoder</a></p>
<p>Running the decoder:</p>
<pre><code>

Found 14019 WebSocket messages

Extracted 14016 signal frames

Clock frames: 7110, Data frames: 3234

Decoded 800 bits

Assembled 100 bytes

Raw bytes (hex): 1b 06 18 0d 43 18 07 07 59 0d 06 1a 1b 1a 09 1d 43 0d 01 06 59 20 51 3a 49 01 0c 1a 43 1d 08 17 18 49 16 0a 00 0d 1e 49 17 11 0c 43 21 26 31 59 02 06 00 53 43 1b 08 0d 18 07 19 18 47 43 0d 01 06 59 1d 06 14 19 06 0b 08 17 0c 1b 06 59 1a 06 17 1a 0c 0b 49 02 1d 0d 11 1c 1a 10 59 00 10 59 59 1b 4a 2a

=== DECRYPTED DATA ===

read and decrypt the I2C bus data using the XOR key: bananza. the temperature sensor address is 0x3C

</code></pre>
<p><strong>read and decrypt the I2C bus data using the XOR key: bananza. the temperature sensor address is 0x3C</strong></p>
<h3>Part 3: I2C Decoding</h3>
<p>The following data file was collected using Edge's Developer Tools:  <a href="HHC_2025_Template/resources/onthewire_i2cdataV2.json"">I2C Data</a></p>
<p>The data file contains markers, but due to the volume of data, a script was used to identify the unique markers in the data structure. </p>
<p><a href="HHC_2025_Template/resources/onthewire_i2cuniquemarkers.ps1.txt"">I2C Unique Markers</a></p>
<p>These are the unigue markers:</p>
<pre><code>
=== UNIQUE MARKERS ===

SCL markers: bus-idle, clock-low, address-sample, address-hold, ack-sample, ack-hold, data-sample, data-hold, stop-setup, gap-start

SDA markers: bus-idle, start, address-bit, ack-bit, ack-release, data-bit, stop, gap-start

</code></pre>
<p>The following decoder was written in Powershell: <a href="HHC_2025_Template/resources/onthewire_i2cdecoderV3.ps1.txt"">I2C Decoder</a></p>
<p>Script Workflow</p>
<p>Load and parse the capture file</p>
<p>- Reads the JSON file containing WebSocket messages.</p>
<p>- Extracts frames with line, time (t), value (v), and marker.</p>
<p>Use markers instead of raw edge detection</p>
<p>- SDA frames are annotated with markers like start, stop, address-bit, data-bit, ack-bit.</p>
<p>- These markers tell us exactly what each bit represents, so we donâ€™t need to reconstruct timing from SCL edges.</p>
<p>Group transactions</p>
<p>- A start marker begins a new transaction.</p>
<p>- A stop marker ends the transaction.</p>
<p>- Between start/stop, collect only address-bit and data-bit values.</p>
<p>- Ignore ack-bit and ack-release markers (ACKs are not part of data).</p>
<p>Decode transaction contents</p>
<p>- First 8 bits â†’ device address (7 bits) + R/W bit.</p>
<p>    - Address = upper 7 bits.</p>
<p>    - R/W = lowest bit (0 = write, 1 = read).</p>
<p>- Remaining bits grouped into 8 bit chunks â†’ data bytes (MSB first).</p>
<p>Report transactions</p>
<p>- Prints each transaction with address, R/W flag, and decoded data bytes in hex.</p>
<p>Iteration analysis</p>
<p>- Counts how many transactions involve the target address (default 0x3C).</p>
<p>- Uses the start timestamps to calculate intervals between successive transactions.</p>
<p>- Confirms whether the device is broadcasting on a ~2000â€¯ms loop.</p>
<p>Separate READ vs WRITE</p>
<p>- Filters decoded transactions by R/W bit.</p>
<p>- Aggregates all READ data and all WRITE data separately.</p>
<p>- Prints totals, raw hex, and XOR decrypted values using the provided key.</p>
<p>The raw data repeats every 5 bytes, so the XOR key needs to be shortened to 5 characters â€œbanazâ€</p>
<p>!<a href="/images/onthewire_i2cdecoded.jpg">I2C Device 0x3C</a> </p>
<p>33 32 2E 38 34 converts to ASCII 32.84</p>
<p><strong>Answer: 32.84</strong></p>
</details>

## Tools Reference

<table>
<thead><tr><th>Tools Used</th> <th>Tool Version</th><tr><td>claude.ai</td> <td>4.5</td> <td></td><tr><td>Edge Developer Tools</td> <td>Version 142.0.3595.94</td> <td></td><tr><td>Firefox Developer Tools</td> <td>Version 145.0.2</td> <td></td><tr><td>Powershell</td> <td>5.1.26100.6899</td> <td></td><tr><td>Python</td> <td>3.12.8</td> <td></td></table>


## Hints Reference
<table>
<thead><tr><th>Provided By</th> <th>Hint</th><tr><td>Santa</td> <td>Protocols<br>Key concept - Clock vs. Data signals:<br>-Some protocols have separate clock and data lines (like SPI and I2C)<br>-For clocked protocols, you need to sample the data line at specific moments defined by the clock<br>-The clock signal tells you when to read the data signal<br>For 1-Wire (no separate clock):<br>-Information is encoded in pulse widths (how long the signal stays low or high)<br>-Different pulse widths represent different bit values<br>-Look for patterns in the timing between transitions<br>For SPI and I2C:<br>-Identify which line is the clock (SCL for I2C, SCK for SPI)<br>-Data is typically valid/stable when the clock is in a specific state (high or low)<br>-You need to detect clock edges (transitions) and sample data at those moments<br>Technical approach:<br>-Sort frames by timestamp<br>-Detect rising edges (0â†’1) and falling edges (1â†’0) on the clock line<br>-Sample the data line's value at each clock edge</td><tr><td>Santa</td> <td>Structure<br>What you're dealing with:<br>-You have access to WebSocket endpoints that stream digital signal data<br>-Each endpoint represents a physical wire in a hardware communication system<br>-The data comes as JSON frames with three properties: line (wire name), t (timestamp), and v (value: 0 or 1)<br>-The server continuously broadcasts signal data in a loop - you can connect at any time<br>-This is a multi-stage challenge where solving one stage reveals information needed for the next<br>Where to start:<br>-Connect to a WebSocket endpoint and observe the data format<br>-The server automatically sends data every few seconds - just wait and collect<br>-Look for documentation on the protocol types mentioned (1-Wire, SPI, I2C)<br>-Consider that hardware protocols encode information in the timing and sequence of signal transitions, not just the values themselves<br>-Consider capturing the WebSocket frames to a file so you can work offlineclock edge</td><tr><td>Santa</td> <td>On Rails<br>Stage-by-stage approach<br>1. Connect to the captured wire files or endpoints for the relevant wires.<br>2. Collect all frames for the transmission (buffer until inactivity or loop boundary).<br>3. Identify protocol from wire names (e.g., dq â†’ 1-Wire; mosi/sck â†’ SPI; sda/scl â†’ IÂ²C).<br>4. Decode the raw signal:<br>- Pulse-width protocols: locate fallingâ†’rising transitions and measure low-pulse width.<br>- Clocked protocols: detect clock edges and sample the data line at the specified sampling phase.<br>5. Assemble bits into bytes taking the correct bit order (LSB vs MSB).<br>6. Convert bytes to text (printable ASCII or hex as appropriate).<br>7. Extract information from the decoded output â€” it contains the XOR key or other hints for the next stage.<br>1. Repeat Stage 1 decoding to recover raw bytes (they will appear random).<br>2. Apply XOR decryption using the key obtained from the previous stage.<br>3. Inspect decrypted output for next-stage keys or target device information.<br>- Multiple 7-bit device addresses share the same SDA/SCL lines.<br>- START condition: SDA falls while SCL is high. STOP: SDA rises while SCL is high.<br>- First byte of a transaction = (7-bit address << 1)</td> <td>R/W. Extract address with address = first_byte >> 1.<br>- Identify and decode every deviceâ€™s transactions; decrypt only the target deviceâ€™s payload.<br>- Print bytes in hex and as ASCII (if printable) â€” hex patterns reveal structure.<br>- Check printable ASCII range (0x20â€“0x7E) to spot valid text.<br>- Verify endianness: swapping LSB/MSB will quickly break readable text.<br>- For XOR keys, test short candidate keys and look for common English words.<br>- If you connect mid-broadcast, wait for the next loop or detect a reset/loop marker before decoding.<br>- Buffering heuristic: treat the stream complete after a short inactivity window (e.g., 500 ms) or after a full broadcast loop.<br>- Sort frames by timestamp per wire and collapse consecutive identical levels before decoding to align with the physical waveform.<br></td><tr><td>Santa</td> <td>Garbage<br>If your decoded data looks like gibberish:<br>- The data may be encrypted with XOR cipher<br>- XOR is a simple encryption: encrypted_byte XOR key_byte = plaintext_byte<br>- The same operation both encrypts and decrypts: plaintext XOR key = encrypted, encrypted XOR key = plaintext<br>How XOR cipher works:<br>function xorDecrypt(encrypted, key) {<br>  let result = "";<br>  for (let i = 0; i < encrypted.length; i++) {<br>    const encryptedChar = encrypted.charCodeAt(i);<br>    const keyChar = key.charCodeAt(i % key.length);  // Key repeats<br>   result += String.fromCharCode(encryptedChar ^ keyChar);<br>  }<br>  return result;<br>}<br>Key characteristics:<br>- The key is typically short and repeats for the length of the message<br>- You need the correct key to decrypt (look for keys in previous stage messages)<br>- If you see readable words mixed with garbage, you might have the wrong key or bit order<br>Testing your decryption:<br>- Encrypted data will have random-looking byte values</td><tr><td>Evan</td> <td>So here's the deal - there are some seriously bizarre signals floating around this area. Not your typical radio chatter or WiFi noise, but something... different. I've been trying to make sense of the patterns, but it's like trying to build a robot hand out of a coffee maker - you need the right approach. Think you can help me decode whatever weirdness is being transmitted out there?</td></table>


## Acknowledgements
<table>
<thead><tr><th>Provided By</th> <th>Notes</th><tr><td>none</td> <td>none</td></table>



<table>
<thead><tr><th><a href="/act3_snowglobe_mjd.html">Previous Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine</a></th> <th><a href="/index.html">Table of Contents</a></th> <th><a href="/act3_free_ski_mjd.html">Next Objective: Act3 Free Ski</a></th></table>






