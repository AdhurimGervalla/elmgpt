# elmGPT

Dieses Projekt wird im Ramen des `fprod` Moduls umgesetzt. Es handelt sich um eine Elm Webapplikation,
bei der chatGPT Anfragen und Antworten verwaltet werden können.

## Voraussetzungen

- Elm (https://elm-lang.org/)
- elm-live (https://github.com/wking-io/elm-live)

## Installation

1. Elm und elm-live müssen installiert sein.

## Projekt einrichten

1. Klone das Repository auf deinem lokalen Computer.
```
git clone https://github.com/MFJonesX/elmgpt.git
```

2. Navigieren in der Kommandozeile oder dem Terminal zum Projektordner.

## Pocketbase Server
1. Wechsle in das Verzeichnis `server`.
   ```bash
   cd server
   ```
2. Entpacke das passende zip-File. Achtung bei Mac User die richitge CPU Architektur anwenden.
3. Nunn sollte es eine Datei `pocketbase` im Verzeichnis `Server` geben. Achtung je nach dem muss die `pocketbase` aus dem erzeugten Ordner in das `Server` Verzeichnis reingeschoben werden.

## Projekt starten
### Mac
Führe das start.sh Sctipt aus:
```bash
./start.sh
```
### Windows
```bat
./start.bat
```
### Login
Beim ersten Startup, muss ein Admin Login erstellt werden. Die DB Architektur würde über die `pb_migrations` Dateien gehandelt.
1. Rufen sie dafür folgende URL auf: `127.0.0.1:8090/_/`
2. Geben Sie irgendwelche Login Daten ein (Sie erstellen einen Admin Account)

### App testen
Sie können nun `localhost:8000` aufrufen um die Elm Applikation zu testen.  
Den API-Key erhalten sie per Mail.