import os
import webbrowser
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path


class Handler(SimpleHTTPRequestHandler):
    def do_POST(self):
        Path(self.translate_path(self.path)).write_bytes(self.rfile.read(int(self.headers['Content-Length'])))
        self.send_response(204)
        self.end_headers()


os.chdir(Path(__file__).parent)
server = HTTPServer(('127.0.0.1', 8765), Handler)
webbrowser.open('http://127.0.0.1:8765/label.html')
server.serve_forever()
