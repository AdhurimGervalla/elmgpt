#!/bin/bash

if [ ! -f server/pocketbase ]; then
  echo "Bitte entpacken Sie das passende Zip File im Ordner Server"
  exit 1
fi

cd server && ./pocketbase serve &
cd client && elm-live src/Main.elm --pushstate -- --output=main.js