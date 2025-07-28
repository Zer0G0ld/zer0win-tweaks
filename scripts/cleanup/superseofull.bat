REM Author: Zer0G0ld

@echo off
color 0A
setlocal enabledelayedexpansion

echo ========================================
echo    INICIANDO SUPER OTIMIZACAO DO PC
echo ========================================
timeout /t 2

:: Capturar espaço em disco antes
for /f "tokens=3" %%a in ('fsutil volume diskfree C: ^| find "Total # of free bytes"') do set before=%%a

echo === Limpando arquivos temporarios...
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\* >nul 2>&1
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
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Performance" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
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

echo === Desabilitando tarefas agendadas chatas...
:: Tente desativar mesmo se algumas não existirem
schtasks /Change /TN "Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-1-5-21" /Disable 2>nul
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable 2>nul
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable 2>nul
echo.

echo === Limpando logs do Windows...
del /f /q C:\Windows\Logs\* >nul 2>&1
del /f /q C:\Windows\Logs\CBS\* >nul 2>&1
del /f /q C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
echo.

echo === Executando otimizacao de SSD (TRIM)...
defrag C: /L
echo.

echo === Verificando integridade de arquivos (sfc)...
sfc /scannow
echo.

echo === Reparando imagem do Windows (DISM)...
DISM /Online /Cleanup-Image /RestoreHealth
echo.

:: Diagnósticos adicionais

echo === Verificando conexoes de rede ESTABELECIDAS...
netstat -ano | findstr ESTABLISHED

echo === Salvando tarefas agendadas em Desktop...
schtasks /query /fo LIST /v > "%USERPROFILE%\Desktop\tarefas_agendadas.txt"

echo === Listando conexões com IP externo por PID:
for /f "tokens=5" %%a in ('netstat -n -o ^| findstr ESTABLISHED') do (
  tasklist /FI "PID eq %%a"
)
echo.

:: Capturar espaço em disco depois
for /f "tokens=3" %%a in ('fsutil volume diskfree C: ^| find "Total # of free bytes"') do set after=%%a

echo ========================================
echo   ESPACO LIVRE ANTES: !before! bytes
echo   ESPACO LIVRE DEPOIS: !after! bytes
echo ========================================
echo.

echo === FINALIZADO! Recomendo REINICIAR o computador.
pause
endlocal
