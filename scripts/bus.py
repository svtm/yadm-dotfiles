#!/usr/bin/python3

from graphqlclient import GraphQLClient
import json
import dateutil.parser
from datetime import datetime

client = GraphQLClient('https://api.entur.io/journey-planner/v2/graphql')
client.inject_token("enielsen - personaldashboard", "ET-Client-Name")

res_string = client.execute('''
{
  trip(
    from: {
      place: "NSR:StopPlace:59977"
    }, 
    to: {
      place: "NSR:StopPlace:44096"
    }, 
    numTripPatterns: 3, 
  ) {
    tripPatterns {
      startTime
      duration
      legs {
        line {
          id
          publicCode
          authority {
            name
          }
        }
        fromEstimatedCall {
          realtime
          aimedDepartureTime
          expectedDepartureTime
          actualDepartureTime
        }
      }
    }
  }
}
''')

trips = json.loads(res_string)["data"]["trip"]["tripPatterns"]

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

print(" | ".join(time_strings))