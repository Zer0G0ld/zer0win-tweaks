REM Author: Zer0G0ld

@echo off
color 0E
set OUTPUT=C:\relatorio_pc.txt

echo ======================================== >> %OUTPUT%
echo         RELATORIO DE CONFIGURACAO DO PC >> %OUTPUT%
echo ======================================== >> %OUTPUT%
echo.

echo ===== INFORMACOES DO SISTEMA ===== >> %OUTPUT%
systeminfo >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== INFORMACOES DA CPU ===== >> %OUTPUT%
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed /format:list >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== MEMORIA RAM INSTALADA ===== >> %OUTPUT%
wmic memorychip get capacity, manufacturer, speed, partnumber >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== INFORMACOES DE DISCO ===== >> %OUTPUT%
wmic diskdrive get Model,Size,InterfaceType,MediaType >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== ESPACO EM DISCO ===== >> %OUTPUT%
wmic logicaldisk get DeviceID, VolumeName, Size, FreeSpace >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== PLACA DE VIDEO ===== >> %OUTPUT%
wmic path win32_videocontroller get name,AdapterRAM >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== PLACA MAE ===== >> %OUTPUT%
wmic baseboard get Manufacturer,Product,SerialNumber >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== INFORMACOES DE REDE ===== >> %OUTPUT%
ipconfig /all >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== PROGRAMAS INSTALADOS ===== >> %OUTPUT%
wmic product get name,version >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== ITENS DE INICIALIZACAO ===== >> %OUTPUT%
wmic startup get Caption, Command >> %OUTPUT%
echo. >> %OUTPUT%

echo ===== SERVICOS ATIVOS ===== >> %OUTPUT%
sc query type= service state= all >> %OUTPUT%
echo. >> %OUTPUT%

echo ======================================== >> %OUTPUT%
echo RELATORIO SALVO EM: %OUTPUT%
echo ========================================
pause
