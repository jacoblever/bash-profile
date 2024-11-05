import json
import os
from http.client import HTTPSConnection
from base64 import b64encode

def make_jira_request(method, path, params=None, log=False):
    jira_login = os.getenv('JIRALOGIN')
    if jira_login == "" or jira_login is None:
      print("Set the JIRALOGIN env var to your jira 'email:token' to use this script")
      print("Create a token here %s" % "https://id.atlassian.com/manage-profile/security/api-tokens")
      exit()

    c = HTTPSConnection('deliveroo.atlassian.net')
    userAndPass = b64encode(jira_login.encode('UTF-8')).decode("ascii")
    headers = {'Authorization': 'Basic %s' % userAndPass, 'Content-Type': 'application/json', 'Accept': 'application/json'}
    c.request(method, path, params, headers=headers)
    response = c.getresponse()
    body = response.read()
    if log:
      print("Status: %d, %s" % (response.status, body))

    try:
      as_json = json.loads(body)
      #print(json.dumps(as_json, sort_keys=True, indent=2))
      return as_json
    except:
      return None
