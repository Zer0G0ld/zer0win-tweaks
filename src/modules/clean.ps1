# ========================================
# Zer0SuperOptimize.ps1 - Super Otimização do PC
# Autor: Zer0G0ld
# ========================================

# Verificar se está sendo executado como administrador
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script precisa ser executado como ADMINISTRADOR. Fechando..."
    Pause
    Exit
}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   INICIANDO SUPER OTIMIZAÇÃO DO PC" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Start-Sleep -Seconds 2

# Capturar espaço em disco antes
$before = (Get-PSDrive C).Free

# Limpando arquivos temporários
Write-Host "`n=== Limpando arquivos temporários..."
Try {
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
} Catch {
    Write-Host "Erro ao limpar temporários: $_" -ForegroundColor Red
}

# Limpando cache do Windows Update
Write-Host "`n=== Limpando cache do Windows Update..."
Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait

# Desabilitando Hibernação
Write-Host "`n=== Desabilitando Hibernação..."
powercfg -h off

# Ajustando plano de energia
Write-Host "`n=== Ajustando plano de energia para ALTO DESEMPENHO..."
powercfg /setactive SCHEME_MIN

# Limpando DNS Cache
Write-Host "`n=== Limpando DNS Cache..."
ipconfig /flushdns

# Ajustando efeitos visuais
Write-Host "`n=== Ajustando efeitos visuais para MELHOR DESEMPENHO..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Performance" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue

# Configuração do Pagefile (sem WMIC - usando WMI moderno)
Write-Host "`n=== Configurando Pagefile..."
Try {
    $sys = Get-CimInstance -ClassName Win32_ComputerSystem
    $sys.AutomaticManagedPagefile = $false
    Set-CimInstance -InputObject $sys

    Get-CimInstance -ClassName Win32_PageFileSetting | Remove-CimInstance -ErrorAction SilentlyContinue
    New-CimInstance -ClassName Win32_PageFileSetting -Property @{ Name = "C:\pagefile.sys"; InitialSize = 4096; MaximumSize = 8192 } | Out-Null

    Write-Host "Pagefile configurado manualmente: Inicial=4096MB, Máximo=8192MB" -ForegroundColor Green
} Catch {
    Write-Host "Falha ao configurar o Pagefile (Erro WMI): $_" -ForegroundColor Yellow
}

# Desabilitando serviços desnecessários
Write-Host "`n=== Desabilitando serviços desnecessários..."
$services = @("SysMain", "WSearch", "Spooler", "DiagTrack", "dmwappushservice")
foreach ($service in $services) {
    Try {
        sc.exe config $service start= disabled | Out-Null
        Write-Host "Serviço $service desabilitado."
    } Catch {
        Write-Host "Erro ao desabilitar serviço ${service}: $_" -ForegroundColor Red
    }
}

# Desabilitando tarefas agendadas
Write-Host "`n=== Desabilitando tarefas agendadas chatas..."
$tasks = @(
    "Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-1-5-21",
    "Microsoft\Office\OfficeTelemetryAgentLogOn",
    "Microsoft\Office\OfficeTelemetryAgentFallBack",
    "Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask",
    "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
)
foreach ($task in $tasks) {
    if (schtasks.exe /Query /TN $task 2>$null) {
        schtasks.exe /Change /TN $task /Disable | Out-Null
        Write-Host "Tarefa '$task' desabilitada."
    } else {
        Write-Host "Tarefa '$task' não encontrada, pulando..." -ForegroundColor Yellow
    }
}

# Limpando logs
Write-Host "`n=== Limpando logs do Windows..."
Try {
    Remove-Item "C:\Windows\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
} Catch {
    Write-Host "Erro ao limpar logs: $_" -ForegroundColor Red
}

# Executando otimização de SSD (TRIM)
Write-Host "`n=== Executando otimização de SSD (TRIM)..."
defrag C: /L

# Verificando integridade de arquivos
Write-Host "`n=== Verificando integridade de arquivos (sfc)..."
sfc /scannow

# Reparando imagem do Windows
Write-Host "`n=== Reparando imagem do Windows (DISM)..."
DISM /Online /Cleanup-Image /RestoreHealth

# Capturar espaço em disco depois
$after = (Get-PSDrive C).Free

# Exibir comparação de espaço livre
Write-Host "`n========================================"
Write-Host " ESPAÇO LIVRE ANTES: $before bytes"
Write-Host " ESPAÇO LIVRE DEPOIS: $after bytes"
Write-Host "========================================"

Write-Host "`n=== FINALIZADO! Recomendo REINICIAR o computador." -ForegroundColor Green
Write-Host "`nPressione qualquer tecla para sair..."
[void][System.Console]::ReadKey($true)
