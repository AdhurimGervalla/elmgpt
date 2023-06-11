@echo off

cd server && start pocketbase serve
cd ../client && elm-live src/Main.elm --pushstate -- --output=main.js