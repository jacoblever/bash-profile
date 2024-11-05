import sys
import webbrowser

location = sys.argv[1]
segments = location.split('/')

webbrowser.open('https://github.com/deliveroo/' + segments[-1])
