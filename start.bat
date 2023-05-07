@echo off

if not exist server\pocketbase (
  echo Bitte entpacken Sie das passende Zip File im Ordner Server
  exit /b 1
)

cd server && start pocketbase serve
cd client && elm reactor