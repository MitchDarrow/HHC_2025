|[Previous Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine](HHC_2025_Template/act3_snowglobe_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective: Act3 Free Ski](HHC_2025_Template/act3_free_ski_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: On The Wire   | Difficulty Level: 4 |
| :-----------------------: | :--------------------------: |
| Help Evan next to city hall hack this gnome and retrieve the temperature value reported by the I²C device at address 0x3C. The temperature data is XOR-encrypted, so you’ll need to work through each communication stage to uncover the necessary keys. Start with the unencrypted data being transmitted over the 1-wire protocol. | Location: City Hall  |

## Solution Overview

High level executive summary of how the objective was solved. Details belong in the detail section.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |


## Detailed Solution
<details>
<summary>Click to expand</summary>

Step by step solution complete with any code used
  
![Sample image alt text](/images/objectivename_purpose.jpg) 


```sh
bash script code block
```

Ordered list:
1. Item 1
2. Item 2
3. Item 3

Unordered list:

- Item
- Item
- Item
/usr/local/weather/temperature

**Answer: Flag or Answer**

</details>

## Tools Reference

| Tools Used           | Tool Version |
| :-----------------------: | :--------------------------------: |
|  |  | 
|  |  |
|  |  | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :--------------------------------: |
| Santa |Protocols<br>Key concept - Clock vs. Data signals:<br>-Some protocols have separate clock and data lines (like SPI and I2C)<br>-For clocked protocols, you need to sample the data line at specific moments defined by the clock<br>-The clock signal tells you when to read the data signal<br>For 1-Wire (no separate clock):<br>-Information is encoded in pulse widths (how long the signal stays low or high)<br>-Different pulse widths represent different bit values<br>-Look for patterns in the timing between transitions<br>For SPI and I2C:<br>-Identify which line is the clock (SCL for I2C, SCK for SPI)<br>-Data is typically valid/stable when the clock is in a specific state (high or low)<br>-You need to detect clock edges (transitions) and sample data at those moments<br>Technical approach:<br>-Sort frames by timestamp<br>-Detect rising edges (0→1) and falling edges (1→0) on the clock line<br>-Sample the data line's value at each clock edge |
| Santa | Structure
What you're dealing with:
•	You have access to WebSocket endpoints that stream digital signal data
•	Each endpoint represents a physical wire in a hardware communication system
•	The data comes as JSON frames with three properties: line (wire name), t (timestamp), and v (value: 0 or 1)
•	The server continuously broadcasts signal data in a loop - you can connect at any time
•	This is a multi-stage challenge where solving one stage reveals information needed for the next
Where to start:
•	Connect to a WebSocket endpoint and observe the data format
•	The server automatically sends data every few seconds - just wait and collect
•	Look for documentation on the protocol types mentioned (1-Wire, SPI, I2C)
•	Consider that hardware protocols encode information in the timing and sequence of signal transitions, not just the values themselves
•	Consider capturing the WebSocket frames to a file so you can work offline
|
| Santa | On Rails
Stage-by-stage approach
1.	Connect to the captured wire files or endpoints for the relevant wires.
2.	Collect all frames for the transmission (buffer until inactivity or loop boundary).
3.	Identify protocol from wire names (e.g., dq → 1-Wire; mosi/sck → SPI; sda/scl → I²C).
4.	Decode the raw signal:
o	Pulse-width protocols: locate falling→rising transitions and measure low-pulse width.
o	Clocked protocols: detect clock edges and sample the data line at the specified sampling phase.
5.	Assemble bits into bytes taking the correct bit order (LSB vs MSB).
6.	Convert bytes to text (printable ASCII or hex as appropriate).
7.	Extract information from the decoded output — it contains the XOR key or other hints for the next stage.
1.	Repeat Stage 1 decoding to recover raw bytes (they will appear random).
2.	Apply XOR decryption using the key obtained from the previous stage.
3.	Inspect decrypted output for next-stage keys or target device information.
•	Multiple 7-bit device addresses share the same SDA/SCL lines.
•	START condition: SDA falls while SCL is high. STOP: SDA rises while SCL is high.
•	First byte of a transaction = (7-bit address << 1) | R/W. Extract address with address = first_byte >> 1.
•	Identify and decode every device’s transactions; decrypt only the target device’s payload.
•	Print bytes in hex and as ASCII (if printable) — hex patterns reveal structure.
•	Check printable ASCII range (0x20–0x7E) to spot valid text.
•	Verify endianness: swapping LSB/MSB will quickly break readable text.
•	For XOR keys, test short candidate keys and look for common English words.
•	If you connect mid-broadcast, wait for the next loop or detect a reset/loop marker before decoding.
•	Buffering heuristic: treat the stream complete after a short inactivity window (e.g., 500 ms) or after a full broadcast loop.
•	Sort frames by timestamp per wire and collapse consecutive identical levels before decoding to align with the physical waveform.

If your decoded data looks like gibberish:
•	The data may be encrypted with XOR cipher
•	XOR is a simple encryption: encrypted_byte XOR key_byte = plaintext_byte
•	The same operation both encrypts and decrypts: plaintext XOR key = encrypted, encrypted XOR key = plaintext
How XOR cipher works:
function xorDecrypt(encrypted, key) {
  let result = "";
  for (let i = 0; i < encrypted.length; i++) {
    const encryptedChar = encrypted.charCodeAt(i);
    const keyChar = key.charCodeAt(i % key.length);  // Key repeats
    result += String.fromCharCode(encryptedChar ^ keyChar);
  }
  return result;
}
Key characteristics:
•	The key is typically short and repeats for the length of the message
•	You need the correct key to decrypt (look for keys in previous stage messages)
•	If you see readable words mixed with garbage, you might have the wrong key or bit order
Testing your decryption:
•	Encrypted data will have random-looking byte values
•	Decrypted data should be readable ASCII text
•	Try different keys from messages you've already decoded
|
| Santa  | Garbage
If your decoded data looks like gibberish:
•	The data may be encrypted with XOR cipher
•	XOR is a simple encryption: encrypted_byte XOR key_byte = plaintext_byte
•	The same operation both encrypts and decrypts: plaintext XOR key = encrypted, encrypted XOR key = plaintext
How XOR cipher works:
function xorDecrypt(encrypted, key) {
  let result = "";
  for (let i = 0; i < encrypted.length; i++) {
    const encryptedChar = encrypted.charCodeAt(i);
    const keyChar = key.charCodeAt(i % key.length);  // Key repeats
    result += String.fromCharCode(encryptedChar ^ keyChar);
  }
  return result;
}
Key characteristics:
•	The key is typically short and repeats for the length of the message
•	You need the correct key to decrypt (look for keys in previous stage messages)
•	If you see readable words mixed with garbage, you might have the wrong key or bit order
Testing your decryption:
•	Encrypted data will have random-looking byte values
|

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
|  |  |
|  |  |


|[Previous Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine](HHC_2025_Template/act3_snowglobe_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective: Act3 Free Ski](HHC_2025_Template/act3_free_ski_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
