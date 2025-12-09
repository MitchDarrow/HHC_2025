#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer

class RawHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get('Content-Length', 0))
        data = self.rfile.read(length)  # raw bytes
        with open("upload.bin", "wb") as f:
            f.write(data)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"OK")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8000), RawHandler)
    print("Listening on port 8000...")
    server.serve_forever()



