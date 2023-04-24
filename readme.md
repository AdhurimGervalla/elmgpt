# elmGPT

Dieses Projekt wird im Ramen des `fprod` Moduls umgesetzt. Es handelt sich um eine Elm Webapplikation,
bei der chatGPT Anfragen und Antworten verwaltet werden können.

## Voraussetzungen

- Elm (https://elm-lang.org/)
- elm-live (optional, für Live-Entwicklung: https://github.com/wking-io/elm-live)

## Installation

1. Elm installieren:
   Besuche die offizielle Elm-Website (https://elm-lang.org/) und folge dort den Anweisungen.

2. (Optional) elm-live installieren:
   Wenn elm-live für Live-Entwicklung verwenden werden soll, führe den folgenden Befehl aus:
   `npm install -g elm-live`


## Projekt einrichten

1. Klone das Repository auf deinem lokalen Computer.

2. Navigieren in der Kommandozeile oder dem Terminal zum Projektordner.

3. Führe den folgenden Befehl aus, um die Elm-Abhängigkeiten zu installieren:

`elm install`


## Projekt ausführen

### Option 1: Elm Reactor verwenden

Führe den folgenden Befehl aus, um Elm Reactor zu starten:
`elm reactor`

Öffne deinen Webbrowser und navigiere zu `http://localhost:8000`. Wähle die `src/Main.elm`-Datei aus, um die Anwendung anzuzeigen.

### Option 2: Mit elm-live

Führe den folgenden Befehl aus, um elm-live zu starten:

`elm-live src/HomePage.elm --open -- --output=elm.js`

Elm-live startet einen Webserver und öffnet die Anwendung automatisch in deinem Standard-Webbrowser. Änderungen am Code werden sofort angezeigt, sobald Sie die Datei speichern.