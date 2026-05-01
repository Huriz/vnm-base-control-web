@echo off
cd /d "%~dp0"

for /f %%i in ('powershell -NoProfile -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.*'} | Select-Object -First 1).IPAddress"') do set LOCAL_IP=%%i

echo.
echo  VNM Base Control Web
echo  http://%LOCAL_IP%:3000
echo.
start "" http://%LOCAL_IP%:3000
node backend/server.js
pause
