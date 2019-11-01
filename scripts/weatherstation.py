#!/usr/bin/env python3

from requests_oauthlib import OAuth2Session
from oauthlib.oauth2 import LegacyApplicationClient

client_id = "5d43e481359833000d1346f4"
client_secret = "eXBDScowC354mGhOjLKnyddVGRMThjX"
username = "eirik.niel@gmail.com"
password = "5d@ACD18S6X4"

token_url = "https://api.netatmo.com/oauth2/token"


extra = {
    "client_id": client_id,
    "client_secret": client_secret
}

def token_saver(new_token):
    print(new_token)
    global token
    token = new_token

oauth = OAuth2Session(client=LegacyApplicationClient(client_id=client_id))
token = oauth.fetch_token(
    token_url=token_url,
    username=username,
    password=password,
    client_id=client_id,
    client_secret=client_secret
)

client = OAuth2Session(
    client_id, 
    token=token,
    auto_refresh_url=token_url,
    auto_refresh_kwargs=extra,
    token_updater=token_saver)

data = client.get("https://api.netatmo.com/api/getstationsdata").json()

data = data["body"]["devices"][0]["modules"]

signature = next(filter(lambda d: "Signature" in d["module_name"], data))
temp = signature["dashboard_data"]["Temperature"]
humidity = signature["dashboard_data"]["Humidity"]
co2 = signature["dashboard_data"]["CO2"]

print(f"{temp}C, {humidity}%, {co2}ppm")