import json
import re
import sys
import urllib.parse
import webbrowser
from jira_request import make_jira_request

def add_to_current_sprint(issue_key):
  # https://community.atlassian.com/t5/Jira-questions/How-do-I-get-the-current-sprint/qaq-p/146507
  path = 'https://deliveroo.atlassian.net/rest/agile/1.0/board/%s/sprint?state=active' % "272"
  sprints = make_jira_request('GET', path)
  sprint_id = sprints['values'][0]['id']
  print("Adding %s to sprint '%s'..." % (issue_key, sprints['values'][0]['name']))

  # https://developer.atlassian.com/cloud/jira/software/rest/api-group-sprint/#api-agile-1-0-sprint-sprintid-issue-post
  path = 'https://deliveroo.atlassian.net/rest/agile/1.0/sprint/%s/issue' % sprint_id
  params = json.dumps({
    "issues": [
      issue_key
    ],
  })
  make_jira_request('POST', path, params)

def create_ticket_and_add_to_current_sprint(title, parent = None):
  path = 'https://deliveroo.atlassian.net/rest/api/2/issue/'
  params = {
    "fields": {
        "project": {
            "key": "CARE"
        },
        "summary": new_issue_title,
        "description": "",
        "issuetype": {
            "name": "Task"
        },
        "assignee":{
          "name": "jacob.lever@deliveroo.co.uk"
        }
    }
  }
  if parent:
    params["fields"]["parent"] = {
      "key": issue_key
    }
  else:
    params["fields"]["labels"] = [
      "Small-items-stream"
    ]

  new_issue = make_jira_request('POST', path, json.dumps(params))
  print("Created %s!" % new_issue['key'])
  add_to_current_sprint(new_issue['key'])
  return new_issue['key']

def assign_if_wanted(issue_key, user_email):
  answer = input("Would you like to assign the issue to yourself? (y/n)\n")
  if answer != "y" and answer != "yes" and answer != "Y":
    return

  # https://community.atlassian.com/t5/Jira-questions/Set-assignee-through-REST-API/qaq-p/1005587
  path = '/rest/api/3/user/search?query=' + user_email
  user_search = make_jira_request('GET', path)
  userAccountId = user_search[0]['accountId']

  path = 'https://deliveroo.atlassian.net/rest/api/2/issue/' + issue_key
  params = json.dumps({
    "fields": {
        "assignee": {"accountId":userAccountId}
    }
  })
  make_jira_request('PUT', path, params, log=True)

  print("Assigned %s to %s (%s)" % (issue_key, user_email, userAccountId))

def open_issue(issue_key):
  webbrowser.open('https://deliveroo.atlassian.net/browse/%s' % issue_key)

# Script start
if re.match(r"[0-9]+", sys.argv[1]):
  issue_key = 'CARE-' + sys.argv[1]
elif re.match(r"CARE-[0-9]+", sys.argv[1]):
  issue_key = sys.argv[1]
else:
  # Just create a new issue with this title and no parent
  new_issue_title = " ".join(sys.argv[1:])
  new_issue_key = create_ticket_and_add_to_current_sprint(new_issue_title)
  assign_if_wanted(new_issue_key, 'jacob.lever@deliveroo.co.uk')
  open_issue(new_issue_key)
  exit()

if len(sys.argv) <= 2:
  add_to_current_sprint(issue_key)
  assign_if_wanted(issue_key, 'jacob.lever@deliveroo.co.uk')
  answer = input("Open issue (y/n)\n")
  if answer != "y" and answer != "yes" and answer != "Y":
    exit()
  open_issue(issue_key)

else:
  new_issue_title = " ".join(sys.argv[2:])
  new_issue_key = create_ticket_and_add_to_current_sprint(new_issue_title, parent=issue_key)
  assign_if_wanted(new_issue_key, 'jacob.lever@deliveroo.co.uk')
  open_issue(new_issue_key)
