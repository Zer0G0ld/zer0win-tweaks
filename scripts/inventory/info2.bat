REM Author: Zer0G0ld

@echo off
set OUTPUT=C:\mini_inventario_pc.txt

echo ============================= >> %OUTPUT%
echo     MINI INVENTARIO DE HARDWARE >> %OUTPUT%
echo ============================= >> %OUTPUT%

echo. >> %OUTPUT%
echo ===== CPU ===== >> %OUTPUT%
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed /format:list >> %OUTPUT%

echo. >> %OUTPUT%
echo ===== MEMORIA RAM ===== >> %OUTPUT%
wmic memorychip get capacity, speed, manufacturer >> %OUTPUT%

echo. >> %OUTPUT%
echo ===== PLACA MAE ===== >> %OUTPUT%
wmic baseboard get Manufacturer,Product,SerialNumber >> %OUTPUT%

echo. >> %OUTPUT%
echo ===== DISCO ===== >> %OUTPUT%
wmic diskdrive get Model,Size,MediaType >> %OUTPUT%

echo. >> %OUTPUT%
echo ===== PLACA DE VIDEO ===== >> %OUTPUT%
wmic path win32_videocontroller get Name,AdapterRAM >> %OUTPUT%

echo. >> %OUTPUT%
echo ===== SISTEMA OPERACIONAL ===== >> %OUTPUT%
wmic os get Caption,OSArchitecture,Version >> %OUTPUT%

echo. >> %OUTPUT%
echo ============================= >> %OUTPUT%
echo INVENTARIO SALVO EM: %OUTPUT%
echo =============================
pause
