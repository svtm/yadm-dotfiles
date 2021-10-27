#!/usr/bin/python3

from graphqlclient import GraphQLClient
import json
import dateutil.parser
import pathlib
from datetime import datetime, timedelta
import pathlib
import sys

max_cache_seconds = 120
cache_file_path = "~/.cache/buscache"

dyre_halses_gate = "NSR:StopPlace:60253"
granaasen_gaard = "NSR:StopPlace:44096"

def make_request():
  client = GraphQLClient('https://api.entur.io/journey-planner/v2/graphql')
  client.inject_token("enielsen.tech <eirik.niel(at)gmail.com> - personaldashboard", "ET-Client-Name")

  return client.execute(f'''
  {{
    trip(
      from: {{
        place: "{dyre_halses_gate}"
      }}, 
      to: {{
        place: "{granaasen_gaard}"
      }}, 
      numTripPatterns: 3, 
    ) {{
      tripPatterns {{
        startTime
        duration
        legs {{
          line {{
            id
            publicCode
            authority {{
              name
            }}
          }}
          fromEstimatedCall {{
            realtime
            aimedDepartureTime
            expectedDepartureTime
            actualDepartureTime
          }}
        }}
      }}
    }}
  }}
  ''')

def try_read_cache(json=False):
  path = cache_file_path + ".json" if json else cache_file_path
  cache = pathlib.Path(path).expanduser()
  if not cache.exists():
    return None
  now = datetime.now()
  modified = datetime.fromtimestamp(cache.stat().st_mtime)
  if (now - modified) > timedelta(seconds=max_cache_seconds):
    return None
  
  with cache.open() as f:
    return f.readline()

def save_cache(result, json=False):
  path = cache_file_path + ".json" if json else cache_file_path
  cache = pathlib.Path(path).expanduser()
  with cache.open("w") as f:
    f.write(f"{result}\n")

def extract_trips(res_string):
  trips = json.loads(res_string)["data"]["trip"]["tripPatterns"]
  return trips

def prettify(trips):
  time_strings = []

  for trip in trips:
      expectedTime = trip["legs"][0]["fromEstimatedCall"]["expectedDepartureTime"]
      expectedTime = dateutil.parser.parse(expectedTime)
      realtime = trip["legs"][0]["fromEstimatedCall"]["realtime"]

      aimedTime = trip["legs"][0]["fromEstimatedCall"]["aimedDepartureTime"]
      aimedTime = dateutil.parser.parse(aimedTime)

      if realtime and (expectedTime - aimedTime).total_seconds() > 60:
          time_strings.append(f"{expectedTime.hour}:{expectedTime.minute:02d} ({aimedTime.hour}:{aimedTime.minute:02d})")
      else:
          time_strings.append(f"{expectedTime.hour}:{expectedTime.minute:02d}")

  return " | ".join(time_strings)

def condense_json(trips):
  short_trips = []

  for trip in trips:
      expectedTime = trip["legs"][0]["fromEstimatedCall"]["expectedDepartureTime"]
      expectedTime = dateutil.parser.parse(expectedTime)
      realtime = trip["legs"][0]["fromEstimatedCall"]["realtime"]

      aimedTime = trip["legs"][0]["fromEstimatedCall"]["aimedDepartureTime"]
      aimedTime = dateutil.parser.parse(aimedTime)

      short_trip = {"aimedTime": f"{aimedTime.hour}:{aimedTime.minute:02d}"}
      if realtime and (expectedTime - aimedTime).total_seconds() > 60:
          short_trip["realTime"] = f"{expectedTime.hour}:{expectedTime.minute:02d}"
      else:
          short_trip["realTime"] = ""
      short_trips.append(short_trip)
  return json.dumps(short_trips)

if __name__ == "__main__":
  if len(sys.argv) > 1 and sys.argv[1] == "json":
    json_out = True
  else:
    json_out = False
  if cached_result := try_read_cache(json):
    print(cached_result)
    quit()
  
  res_string = make_request()
  trips = extract_trips(res_string)
  if json_out:
    short = condense_json(trips)
    print(short)
    save_cache(short, json=True)
  else:
    prettified = prettify(trips)
    print(prettified)
    save_cache(prettified, json=False)

