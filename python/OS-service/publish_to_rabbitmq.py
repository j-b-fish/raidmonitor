# filepath: /home/boike/raidmonitor/publish_to_rabbitmq.py
import pika
import json

# Pfad zur JSON-Datei
json_file_path = '/var/log/raid_status.json'

# RabbitMQ-Verbindungsparameter
rabbitmq_host = 'localhost'
rabbitmq_queue = 'raid_status_queue'

# JSON-Datei lesen
with open(json_file_path, 'r') as file:
    message = file.read()

# Verbindung zu RabbitMQ herstellen
connection = pika.BlockingConnection(pika.ConnectionParameters(host=rabbitmq_host))
channel = connection.channel()

# Warteschlange deklarieren
channel.queue_declare(queue=rabbitmq_queue)

# Nachricht an die Warteschlange senden
channel.basic_publish(exchange='',
                      routing_key=rabbitmq_queue,
                      body=message)

print(f" [x] Sent {message}")

# Verbindung schließen
connection.close()