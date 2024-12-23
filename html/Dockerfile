# filepath: /home/boike/raidmonitor/Dockerfile
FROM nginx:alpine

# Kopiere die HTML-Datei in das Nginx-Standardverzeichnis
COPY . /usr/share/nginx/html

# Exponiere Port 8443
EXPOSE 8443

# Starte Nginx und höre auf Port 8443
CMD ["nginx", "-g", "daemon off;"]