from http.client import HTTPSConnection
from base64 import b64encode
import json
import sys
from jira_request import make_jira_request


issue_key = sys.argv[1]
if issue_key[0].isdigit():
    issue_key = 'CARE-' + issue_key

path = 'https://deliveroo.atlassian.net/rest/api/latest/issue/' + issue_key
as_json = make_jira_request('GET', path)

summary = as_json['fields']['summary']
key = as_json['key']

branch_name = summary \
    .lower() \
    .replace(' ', '-') \
    .replace('\'', '') \
    .replace('"', '') \
    .replace("'", '') \
    .replace('[', '') \
    .replace(']', '') \
    .replace('(', '') \
    .replace(')', '') \
    .replace(',', '') \
    .replace('--', '-') \
    .replace('`', '')

print(key + '/' + branch_name)
