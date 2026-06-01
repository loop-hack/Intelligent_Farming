#!/bin/bash

echo "Waiting for Ditto to fully boot (60s)..."
sleep 60

DITTO_BASE="http://localhost:8080"
THING_ID="org.intelligent_farm:soil_sensor_1"

echo ""
echo "Creating Digital Twin Thing..."
THING_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT \
  "$DITTO_BASE/api/2/things/$THING_ID" \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Basic ZGl0dG86ZGl0dG8=' \
  -d '{
    "attributes": {
      "crop": "wheat",
      "field": "field_1",
      "location": "north_block"
    },
    "features": {
      "moisture": {
        "properties": { "level": 50 }
      },
      "temperature": {
        "properties": { "celsius": 25.0 }
      },
      "humidity": {
        "properties": { "percent": 60.0 }
      },
      "ph": {
        "properties": { "value": 6.8 }
      }
    }
  }')

if [ "$THING_RESPONSE" = "201" ] || [ "$THING_RESPONSE" = "204" ]; then
  echo "Thing created successfully (HTTP $THING_RESPONSE)"
else
  echo "Thing creation failed (HTTP $THING_RESPONSE)"
  exit 1
fi

echo ""
echo "Creating MQTT connection..."
CONN_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "$DITTO_BASE/api/2/connections" \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Basic ZGV2b3BzOmZvb2Jhcg==' \
  -d @./infra/ditto/connection_setup.json)

HTTP_CODE=$(echo "$CONN_RESPONSE" | tail -n1)
BODY=$(echo "$CONN_RESPONSE" | head -n-1)

if [ "$HTTP_CODE" = "201" ]; then
  echo "MQTT connection created successfully"
else
  echo "MQTT connection failed (HTTP $HTTP_CODE)"
  echo "$BODY"
  exit 1
fi

echo ""
echo "Verifying Twin exists..."
curl -s \
  "$DITTO_BASE/api/2/things/$THING_ID" \
  -H 'Authorization: Basic ZGl0dG86ZGl0dG8=' | python3 -m json.tool

echo ""
echo "All done. Digital Twin is live."