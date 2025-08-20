@echo off
color 0A
setlocal enabledelayedexpansion

echo ========================================
echo    INICIANDO SUPER OTIMIZACAO DO PC
echo ========================================
timeout /t 2 >nul

:: ===== Capturar espaço em disco antes =====
for /f "tokens=3" %%a in ('fsutil volume diskfree C: ^| find "Total # of free bytes"') do set before=%%a

:: ===== Limpeza de arquivos temporarios =====
echo === Limpando arquivos temporarios...
for %%i in (%temp% C:\Windows\Temp C:\Windows\Prefetch) do (
    if exist "%%i\*" (
        del /s /f /q "%%i\*" >nul 2>&1
    )
)
echo OK.
echo.

:: ===== Windows Update =====
echo === Limpando cache do Windows Update...
cleanmgr /sagerun:1
echo OK.
echo.

:: ===== Hibernacao =====
echo === Desabilitando Hibernacao para liberar espaco...
powercfg -h off
echo OK.
echo.

:: ===== Plano de energia =====
echo === Ajustando plano de energia para ALTO DESEMPENHO...
powercfg /setactive SCHEME_MIN
echo OK.
echo.

:: ===== DNS =====
echo === Limpando DNS Cache...
ipconfig /flushdns >nul
echo OK.
echo.

:: ===== Efeitos visuais =====
echo === Ajustando efeitos visuais para MELHOR DESEMPENHO...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Performance" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
echo OK.
echo.

:: ===== Pagefile =====
echo === Configurando Pagefile (Arquivo de Paginacao)...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul
wmic pagefileset where name="C:\\pagefile.sys" delete >nul 2>&1
wmic pagefileset create name="C:\\pagefile.sys" >nul
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=8192 >nul
echo OK.
echo.

:: ===== Servicos =====
echo === Desabilitando servicos desnecessarios...
for %%s in (SysMain WSearch Spooler DiagTrack dmwappushservice) do (
    sc config "%%s" start= disabled >nul 2>&1
)
echo OK.
echo.

:: ===== Tarefas agendadas =====
echo === Desabilitando tarefas agendadas chatas...
for %%t in (
    "Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-1-5-21"
    "Microsoft\Office\OfficeTelemetryAgentLogOn"
    "Microsoft\Office\OfficeTelemetryAgentFallBack"
    "Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
) do (
    schtasks /Change /TN "%%t" /Disable 2>nul
)
echo OK.
echo.

:: ===== Limpando logs =====
echo === Limpando logs do Windows...
for %%l in (
    C:\Windows\Logs\*
    C:\Windows\Logs\CBS\*
    C:\Windows\SoftwareDistribution\Download\*
) do (
    if exist "%%l" del /f /q "%%l" >nul 2>&1
)
echo OK.
echo.

:: ===== SSD / TRIM =====
echo === Executando otimizacao de SSD (TRIM)...
defrag C: /L >nul
echo OK.
echo.

:: ===== SFC / DISM =====
echo === Verificando integridade de arquivos (sfc)...
sfc /scannow
echo.

echo === Reparando imagem do Windows (DISM)...
DISM /Online /Cleanup-Image /RestoreHealth
echo.

:: ===== Diagnosticos =====
echo === Verificando conexoes de rede ESTABELECIDAS...
netstat -ano | findstr ESTABLISHED
echo.

echo === Salvando tarefas agendadas em Desktop...
schtasks /query /fo LIST /v > "%USERPROFILE%\Desktop\tarefas_agendadas.txt"
echo.

echo === Listando conexões com IP externo por PID:
for /f "tokens=5" %%a in ('netstat -n -o ^| findstr ESTABLISHED') do (
  tasklist /FI "PID eq %%a"
)
echo.

:: ===== Espaço em disco depois =====
for /f "tokens=3" %%a in ('fsutil volume diskfree C: ^| find "Total # of free bytes"') do set after=%%a

echo ========================================
echo   ESPACO LIVRE ANTES: !before! bytes
echo   ESPACO LIVRE DEPOIS: !after! bytes
echo ========================================
echo.

echo === FINALIZADO! Recomendo REINICIAR o computador.
pause
endlocal
