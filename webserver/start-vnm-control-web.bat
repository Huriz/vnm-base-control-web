@echo off
cd /d "%~dp0backend"

for /f "tokens=*" %%i in ('powershell -NoProfile -Command "[Environment]::GetEnvironmentVariable(\"PATH\",\"Machine\")"') do set "PATH=%%i;%PATH%"

where node >nul 2>&1 || (
  echo.
  echo  Node.js no encontrado. Instalando via winget...
  winget install --id OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements
  echo.
  echo  Instalacion completada. Reiniciando...
  timeout /t 3 /nobreak >nul
  start "" "%~f0"
  exit
)

for /f "tokens=*" %%a in ('powershell -NoProfile -Command "((gc server.cfg) -match '^PORT=') -replace '^PORT='"') do set PORT=%%a
if "%PORT%"=="" set PORT=3001

for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
  taskkill /PID %%p /F >nul 2>&1
)

for /f "tokens=*" %%r in ('powershell -NoProfile -Command "Get-NetFirewallRule -DisplayName 'VNM Control Web' -ErrorAction SilentlyContinue | Get-NetFirewallPortFilter | Select-Object -ExpandProperty LocalPort"') do set RULE_PORT=%%r
if not "%RULE_PORT%"=="%PORT%" (
  echo  Configurando regla de firewall para puerto %PORT%...
  powershell -NoProfile -Command "Remove-NetFirewallRule -DisplayName 'VNM Control Web' -ErrorAction SilentlyContinue; New-NetFirewallRule -DisplayName 'VNM Control Web' -Direction Inbound -Protocol TCP -LocalPort %PORT% -Action Allow" >nul 2>&1
)

echo.
echo  Installing dependencies...
call npm install --silent
echo.

for /f %%i in ('powershell -NoProfile -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.*'} | Select-Object -First 1).IPAddress"') do set LOCAL_IP=%%i

echo  VNM Control Web
echo  ================================
echo  Local:   http://localhost:%PORT%
echo  Network: http://%LOCAL_IP%:%PORT%
echo  Host:    http://%COMPUTERNAME%:%PORT%
echo  ================================
echo.
start "" http://localhost:%PORT%
node server.js
pause
