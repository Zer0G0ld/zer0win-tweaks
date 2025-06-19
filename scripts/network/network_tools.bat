REM Author: Zer0G0ld

@echo off
color 0B
title Zer0G0ld - Network Tools

:menu
cls
echo ============================================
echo         🛰️  NETWORK TOOLS - Zer0Win Tweaks
echo ============================================
echo.
echo 1. Flush DNS Cache
echo 2. Reset Winsock e Stack de IP
echo 3. Liberar conexoes TCP/IP travadas
echo 4. Ver teste de ping (Google)
echo 5. Testar velocidade de internet (via PowerShell)
echo 6. Exibir configuracao de IP (ipconfig /all)
echo 7. Testar rota de conexao (tracert)
echo 8. Limpar ARP Cache
echo 9. Sair
echo.
set /p op="Escolha uma opcao: "

if "%op%"=="1" goto flushdns
if "%op%"=="2" goto netreset
if "%op%"=="3" goto tcpcleanup
if "%op%"=="4" goto pingtest
if "%op%"=="5" goto speedtest
if "%op%"=="6" goto ipconfigfull
if "%op%"=="7" goto tracerttest
if "%op%"=="8" goto arpcache
if "%op%"=="9" exit
goto menu

:flushdns
echo.
echo === Limpando DNS Cache...
ipconfig /flushdns
pause
goto menu

:netreset
echo.
echo === Resetando Winsock e Stack TCP/IP...
netsh winsock reset
netsh int ip reset
pause
goto menu

:tcpcleanup
echo.
echo === Liberando conexoes TCP/IP travadas...
netstat -ano
pause
goto menu

:pingtest
echo.
echo === Testando conexao com Google DNS...
ping 8.8.8.8 -n 10
pause
goto menu

:speedtest
echo.
echo === Testando velocidade de internet (via PowerShell - requires .NET 4.5+)...
powershell -Command "Invoke-WebRequest -Uri 'https://fast.com' -UseBasicParsing"
echo. (Ou acesse: https://fast.com ou https://speedtest.net)
pause
goto menu

:ipconfigfull
echo.
echo === Exibindo configuracoes de IP detalhadas...
ipconfig /all
pause
goto menu

:tracerttest
echo.
echo === Testando rota de conexao ate o Google DNS...
tracert 8.8.8.8
pause
goto menu

:arpcache
echo.
echo === Limpando cache ARP...
arp -d
pause
goto menu
