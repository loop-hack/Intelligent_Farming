import json
import random
import time
import paho.mqtt.client as mqtt

def run_sensor():
    
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "Virtual_Sensor")
    client.connect("localhost", 1883)
    
    print("Virtual sensor active. Press Ctrl+C to stop.")

    try:
        while True:
            moisture = random.randint(30, 80)
            
            payload = {
                "topic": "smart_farm/sensors/soil_1",
                "path": "/features/moisture/properties/level",
                "value": moisture
            }
            
            client.publish("smart_farm/sensors/soil_1", json.dumps(payload))
            print(f"Sent moisture: {moisture}%")
            
            time.sleep(5)
            
    except KeyboardInterrupt:
        print("\nDisconnecting sensor.")
        client.disconnect()

if __name__ == "__main__":
    run_sensor()