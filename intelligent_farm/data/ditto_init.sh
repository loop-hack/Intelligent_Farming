#!/bin/bash

echo "Waiting for Ditto to be ready..."
sleep 30

echo "Creating Digital Twin Thing..."
curl -X PUT \
  'http://localhost:8080/api/2/things/org.intelligent_farm:soil_sensor_1' \
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
        "properties": {
          "level": 50
        }
      },
      "temperature": {
        "properties": {
          "celsius": 25.0
        }
      },
      "humidity": {
        "properties": {
          "percent": 60.0
        }
      },
      "ph": {
        "properties": {
          "value": 6.8
        }
      }
    }
  }'

echo ""
echo "Creating MQTT connection..."
curl -X POST \
  'http://localhost:8080/api/2/connections' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Basic ZGV2b3BzOmZvb2Jhcg==' \
  -d @./infra/ditto/connection_setup.json

echo ""
echo "Done."