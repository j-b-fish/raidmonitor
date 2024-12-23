# filepath: /home/boike/raidmonitor/python/backend/backend.py
import pika
import json
from flask import Flask, jsonify
from flask_cors import CORS
import threading
import time

app = Flask(__name__)
CORS(app)  # Aktiviert CORS für alle Routen

# RabbitMQ-Verbindungsparameter
rabbitmq_host = '192.168.1.21'  # Verwenden Sie den Container-Namen, wenn RabbitMQ in einem Container läuft
rabbitmq_queue = 'raid_status_queue'

# Globale Variable zum Speichern der RAID-Statusdaten
raid_status_data = {}

def callback(ch, method, properties, body):
    global raid_status_data
    message = body.decode()
    print(f" [x] Received {message}")

    try:
        # JSON-Daten im Speicher speichern
        raid_status_data = json.loads(message)
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")

def consume_from_rabbitmq():
    while True:
        try:
            connection = pika.BlockingConnection(pika.ConnectionParameters(host=rabbitmq_host))
            channel = connection.channel()
            channel.queue_declare(queue=rabbitmq_queue)
            channel.basic_consume(queue=rabbitmq_queue, on_message_callback=callback, auto_ack=True)
            print(' [*] Waiting for messages. To exit press CTRL+C')
            channel.start_consuming()
        except pika.exceptions.AMQPConnectionError as e:
            print(f"Connection to RabbitMQ failed: {e}")
            time.sleep(5)  # Warte 5 Sekunden und versuche es erneut

@app.route('/raid_status', methods=['GET'])
def get_raid_status():
    if raid_status_data:
        return jsonify(raid_status_data)
    else:
        return jsonify({"error": "No data available"}), 404

if __name__ == '__main__':
    # Start RabbitMQ consumer in a separate thread
    threading.Thread(target=consume_from_rabbitmq, daemon=True).start()
    # Start Flask server
    app.run(host='0.0.0.0', port=5000)