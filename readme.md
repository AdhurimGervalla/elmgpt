# elmGPT

Dieses Projekt wird im Ramen des `fprod` Moduls umgesetzt. Es handelt sich um eine Elm Webapplikation,
bei der chatGPT Anfragen und Antworten verwaltet werden können.

## Voraussetzungen

- Elm (https://elm-lang.org/)
- elm-live (optional, für Live-Entwicklung: https://github.com/wking-io/elm-live)

## Installation

1. Elm installieren:
   Besuche die offizielle Elm-Website (https://elm-lang.org/) und folge dort den Anweisungen.

## Projekt einrichten

1. Klone das Repository auf deinem lokalen Computer.

2. Navigieren in der Kommandozeile oder dem Terminal zum Projektordner.

## Pocketbase Server
1. Wechsle in das Verzeichnis `server`.
   ```bash
   cd server
   ```
2. Entpacke das passende zip-File. Achtung bei Mac User die richitge CPU Architektur anwenden.
3. Nunn sollte es eine Datei `pocketbase` im Verzeichnis `Server` geben.

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