|[Previous Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine](HHC_2025_Template/act3_snowglobe_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective: Act3 Free Ski](HHC_2025_Template/act3_free_ski_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |

| Objective: On The Wire   | Difficulty Level: 4 |
| :-----------------------: | :--------------------------: |
| Help Evan next to city hall hack this gnome and retrieve the temperature value reported by the I²C device at address 0x3C. The temperature data is XOR-encrypted, so you’ll need to work through each communication stage to uncover the necessary keys. Start with the unencrypted data being transmitted over the 1-wire protocol. | Location: City Hall  |

## Solution Overview

High level executive summary of how the objective was solved. Details belong in the detail section.

| Activity           | Primary Tactic | MITRE ATT&CK Technique ID             | MITRE ATT&CK Technique Name |
| :-----------------------: | :--------------------------------: | :-----------------------: | :--------------------------------: |
| Decode hidden payload | Defense Evasion | T1140 | Deobfuscate/Decode Files or Information |


## Detailed Solution
<details>
<summary>Click to expand</summary>

# Part One: 1-Wire

The following python script connects to the web socket and collects the data into a csv file:

```python
import websocket
import csv

# Open CSV file once at the start
f = open("onthewire_1wire_data.csv", "w", newline="", encoding="utf-8")
writer = csv.writer(f)

def on_message(ws, message):
    print("Received:", message)  # See messages in console
    writer.writerow([message])
    f.flush()  # Ensure data is written immediately

def on_error(ws, error):
    print("Error:", error)

def on_close(ws, close_status_code, close_msg):
    print("Connection closed")
    f.close()

def on_open(ws):
    print("Connection opened")

url = "wss://signals.holidayhackchallenge.com/wire/dq"
ws = websocket.WebSocketApp(url,
                            on_open=on_open,
                            on_message=on_message,
                            on_error=on_error,
                            on_close=on_close)

ws.run_forever()
```

The data file collected: [1-wire data](HHC_2025_Template/resources/OntheWire_1wire_data.csv

The data contains the following markers:

- "reset" at t=1 (reset pulse)
 
- "presence" at t=551 (presence pulse response)

 - "idle" at t=0 (bus idle high)
   
1-Wire Decoding

In 1-Wire, data is encoded using pulse width modulation:

- Write/Read 0: Long low pulse (~60µs)

- Write/Read 1: Short low pulse (~6µs)

Decode the signal after the presence pulse by measuring the low-pulse widths:

Time slot analysis (from t=701 onwards):

701→941: 240µs LOW → 0

1001→1011: 10µs LOW → 1

1071→1081: 10µs LOW → 1

1087→1151: 64µs LOW → 0

1157→1221: 64µs LOW → 0

1281→1291: 10µs LOW → 1

1351→1361: 10µs LOW → 1

1367→1431: 64µs LOW → 0

Continuing this analysis through the entire sequence and assembling bits LSB-first (1-Wire standard):

Decoded bits (grouped by byte, LSB first):

1. 01100011 → 0x63 → 'c'

2. 01101000 → 0x68 → 'h'
   
3. 01110010 → 0x72 → 'r'
   
4. 01101001 → 0x69 → 'i
   
5. 01110011 → 0x73 → 's'
   
6. 01110100 → 0x74 → 't'
    
7.  01101101 → 0x6D → 'm'

8. 01100001 → 0x61 → 'a'

9. 01110011 → 0x73 → 's'

Decoded Message

XOR key: christmas

The data is not encoded with the key Christmas, the bites translate to the following message:

**read and decrypt the SPI bus data using the XOR key: icy**


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
| claude.ai | 4.5 | 

## Hints Reference
| Provided By         | Hint |
| :-----------------------: | :-------------------------------- |
| Santa |Protocols<br>Key concept - Clock vs. Data signals:<br>-Some protocols have separate clock and data lines (like SPI and I2C)<br>-For clocked protocols, you need to sample the data line at specific moments defined by the clock<br>-The clock signal tells you when to read the data signal<br>For 1-Wire (no separate clock):<br>-Information is encoded in pulse widths (how long the signal stays low or high)<br>-Different pulse widths represent different bit values<br>-Look for patterns in the timing between transitions<br>For SPI and I2C:<br>-Identify which line is the clock (SCL for I2C, SCK for SPI)<br>-Data is typically valid/stable when the clock is in a specific state (high or low)<br>-You need to detect clock edges (transitions) and sample data at those moments<br>Technical approach:<br>-Sort frames by timestamp<br>-Detect rising edges (0→1) and falling edges (1→0) on the clock line<br>-Sample the data line's value at each clock edge |
| Santa | Structure<br>What you're dealing with:<br>-You have access to WebSocket endpoints that stream digital signal data<br>-Each endpoint represents a physical wire in a hardware communication system<br>-The data comes as JSON frames with three properties: line (wire name), t (timestamp), and v (value: 0 or 1)<br>-The server continuously broadcasts signal data in a loop - you can connect at any time<br>-This is a multi-stage challenge where solving one stage reveals information needed for the next<br>Where to start:<br>-Connect to a WebSocket endpoint and observe the data format<br>-The server automatically sends data every few seconds - just wait and collect<br>-Look for documentation on the protocol types mentioned (1-Wire, SPI, I2C)<br>-Consider that hardware protocols encode information in the timing and sequence of signal transitions, not just the values themselves<br>-Consider capturing the WebSocket frames to a file so you can work offlineclock edge|
| Santa | On Rails<br>Stage-by-stage approach<br>1. Connect to the captured wire files or endpoints for the relevant wires.<br>2. Collect all frames for the transmission (buffer until inactivity or loop boundary).<br>3. Identify protocol from wire names (e.g., dq → 1-Wire; mosi/sck → SPI; sda/scl → I²C).<br>4. Decode the raw signal:<br>- Pulse-width protocols: locate falling→rising transitions and measure low-pulse width.<br>- Clocked protocols: detect clock edges and sample the data line at the specified sampling phase.<br>5. Assemble bits into bytes taking the correct bit order (LSB vs MSB).<br>6. Convert bytes to text (printable ASCII or hex as appropriate).<br>7. Extract information from the decoded output — it contains the XOR key or other hints for the next stage.<br>1. Repeat Stage 1 decoding to recover raw bytes (they will appear random).<br>2. Apply XOR decryption using the key obtained from the previous stage.<br>3. Inspect decrypted output for next-stage keys or target device information.<br>- Multiple 7-bit device addresses share the same SDA/SCL lines.<br>- START condition: SDA falls while SCL is high. STOP: SDA rises while SCL is high.<br>- First byte of a transaction = (7-bit address << 1) | R/W. Extract address with address = first_byte >> 1.<br>- Identify and decode every device’s transactions; decrypt only the target device’s payload.<br>- Print bytes in hex and as ASCII (if printable) — hex patterns reveal structure.<br>- Check printable ASCII range (0x20–0x7E) to spot valid text.<br>- Verify endianness: swapping LSB/MSB will quickly break readable text.<br>- For XOR keys, test short candidate keys and look for common English words.<br>- If you connect mid-broadcast, wait for the next loop or detect a reset/loop marker before decoding.<br>- Buffering heuristic: treat the stream complete after a short inactivity window (e.g., 500 ms) or after a full broadcast loop.<br>- Sort frames by timestamp per wire and collapse consecutive identical levels before decoding to align with the physical waveform.<br> |
| Santa  | Garbage<br>If your decoded data looks like gibberish:<br>- The data may be encrypted with XOR cipher<br>- XOR is a simple encryption: encrypted_byte XOR key_byte = plaintext_byte<br>- The same operation both encrypts and decrypts: plaintext XOR key = encrypted, encrypted XOR key = plaintext<br>How XOR cipher works:<br>function xorDecrypt(encrypted, key) {<br>  let result = "";<br>  for (let i = 0; i < encrypted.length; i++) {<br>    const encryptedChar = encrypted.charCodeAt(i);<br>    const keyChar = key.charCodeAt(i % key.length);  // Key repeats<br>   result += String.fromCharCode(encryptedChar ^ keyChar);<br>  }<br>  return result;<br>}<br>Key characteristics:<br>- The key is typically short and repeats for the length of the message<br>- You need the correct key to decrypt (look for keys in previous stage messages)<br>- If you see readable words mixed with garbage, you might have the wrong key or bit order<br>Testing your decryption:<br>- Encrypted data will have random-looking byte values |
| Evan | So here's the deal - there are some seriously bizarre signals floating around this area. Not your typical radio chatter or WiFi noise, but something... different. I've been trying to make sense of the patterns, but it's like trying to build a robot hand out of a coffee maker - you need the right approach. Think you can help me decode whatever weirdness is being transmitted out there? |

## Acknowledgements
| Provided By         | Notes |
| :-----------------------: | :--------------------------------: |
| none | none |


|[Previous Objective: Act3 Find and Shutdown Frosty's Snowglobe Machine](HHC_2025_Template/act3_snowglobe_mjd.html)  |   [Table of Contents](HHC_2025_Template/index.html) | [Next Objective: Act3 Free Ski](HHC_2025_Template/act3_free_ski_mjd.html)
| :----------------------- | :--------------------------------: | --------------------------------: |
