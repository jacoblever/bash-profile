from http.client import HTTPSConnection
from base64 import b64encode
import json
import sys

file_path = sys.argv[1]
key = sys.argv[2]
as_json = json.loads(file_path.read())
print(as_json[key])
