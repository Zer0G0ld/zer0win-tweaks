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
