import requests
from bs4 import BeautifulSoup
import argparse

argparser = argparse.ArgumentParser()
argparser.add_argument('username')
argparser.add_argument('password')
args = argparser.parse_args()

api_url = 'http://localhost/hub/signup'
data = {'username':args.username, 'pw':args.password}

r = requests.post(api_url, data = data)
r.raise_for_status()

# Need to capture the error message from the HTTP response,
# since it returns 200 even if signup failed.
s = BeautifulSoup(r.text, 'html.parser')
error = s.find(class_='alert alert-danger')

if error:
  msg = ' '.join(error.contents)
  raise RuntimeError(msg)
