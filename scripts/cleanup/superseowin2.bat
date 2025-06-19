::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFCFRXlS+GGStCLkT6ezo0/CCsB0KXexxcYzUug==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
REM Author: Zer0G0ld

@echo off
color 0A
echo ========================================
echo    INICIANDO SUPER OTIMIZACAO DO PC
echo ========================================
timeout /t 2

echo === Limpando arquivos temporarios...
del /s /f /q %temp%\*
del /s /f /q C:\Windows\Temp\*
del /s /f /q C:\Windows\Prefetch\*
echo.

echo === Limpando cache do Windows Update...
cleanmgr /sagerun:1
echo.

echo === Desabilitando Hibernacao para liberar espaco...
powercfg -h off
echo.

echo === Ajustando plano de energia para ALTO DESEMPENHO...
powercfg /setactive SCHEME_MIN
echo.

echo === Limpando DNS Cache...
ipconfig /flushdns
echo.

echo === Ajustando efeitos visuais para MELHOR DESEMPENHO...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Performance" /v VisualFXSetting /t REG_DWORD /d 2 /f
echo.

echo === Configurando Pagefile (Arquivo de Paginacao)...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" delete
wmic pagefileset create name="C:\\pagefile.sys"
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=8192
echo.

echo === Desabilitando servicos desnecessarios...
sc config "SysMain" start= disabled
sc config "WSearch" start= disabled
sc config "Spooler" start= disabled
sc config "DiagTrack" start= disabled
sc config "dmwappushservice" start= disabled
echo.

echo === Desabilitando tarefas agendadas chatas (OneDrive, Office, etc)...
schtasks /Change /TN "Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-1-5-21" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
echo.

echo === Limpando logs do Windows...
del /f /q C:\Windows\Logs\*
del /f /q C:\Windows\Logs\CBS\*
del /f /q C:\Windows\SoftwareDistribution\Download\*
echo.

echo === Finalizando ajustes...
echo Recomendado: Reiniciar o computador para aplicar todas as mudanças.
pause
