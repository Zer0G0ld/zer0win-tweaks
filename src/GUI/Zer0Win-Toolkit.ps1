# ===============================
# Zer0Win Toolkit - PowerShell Edition
# Autor: Zer0G0ld
# ===============================Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Criar o Form principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Zer0Win Toolkit"
$form.Size = New-Object System.Drawing.Size(900, 600)
$form.StartPosition = "CenterScreen"

# ===== Área dos botões (lado esquerdo) =====
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Size = New-Object System.Drawing.Size(200, 550)
$buttonPanel.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($buttonPanel)

# ===== Área de Output (lado direito) =====
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.ReadOnly = $true
$outputBox.WordWrap = $true
$outputBox.Size = New-Object System.Drawing.Size(650, 550)
$outputBox.Location = New-Object System.Drawing.Point(220, 10)
$form.Controls.Add($outputBox)

# ===== Campo de entrada para comandos =====
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Size = New-Object System.Drawing.Size(550, 25)
$inputBox.Location = New-Object System.Drawing.Point(220, 570)
$form.Controls.Add($inputBox)

# ===== Botão para executar o comando =====
$executeButton = New-Object System.Windows.Forms.Button
$executeButton.Text = "Executar"
$executeButton.Size = New-Object System.Drawing.Size(80, 25)
$executeButton.Location = New-Object System.Drawing.Point(780, 570)
$form.Controls.Add($executeButton)

# ===== Função para escrever no OutputBox =====
function Write-Log {
    param (
        [string]$Text,
        [string]$ForegroundColor = "Black"  # Cor opcional, mas o TextBox não muda cor linha por linha
    )

    # Por padrão, o TextBox não permite mudar cor linha a linha.
    # Mas podemos adicionar TAGS simuladas, se quiser implementar no futuro.

    $outputBox.AppendText($Text + [Environment]::NewLine)
    $outputBox.SelectionStart = $outputBox.Text.Length
    $outputBox.ScrollToCaret()
}


function LimpezaRapida {
    Write-Log "Executando Limpeza Rápida..."
    Write-Log "========================================" -ForegroundColor Green
    Write-Log "   INICIANDO SUPER OTIMIZAÇÃO DO PC" -ForegroundColor Green
    Write-Log "========================================" -ForegroundColor Green
    Start-Sleep -Seconds 2

    # Limpando arquivos temporários
    Write-Log "Limpando arquivos temporários..."
    Try {
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    } Catch {
        Write-Log "Erro ao limpar arquivos temporários: $_" -ForegroundColor Red
    }
    Write-Log ""

    # Limpando cache do Windows Update (Cleanmgr deve estar configurado com /sageset:1 previamente)
    Write-Log "Limpando cache do Windows Update..."
    Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait
    Write-Log ""

    # Desabilitando hibernação
    Write-Log "Desabilitando hibernação..."
    powercfg -h off
    Write-Log ""

    # Ajustando plano de energia para alto desempenho
    Write-Log "Ajustando plano de energia para ALTO DESEMPENHO..."
    powercfg /setactive SCHEME_MIN
    Write-Log ""

    # Limpando DNS Cache
    Write-Log "Limpando DNS Cache..."
    ipconfig /flushdns
    Write-Log ""

    # Ajustando efeitos visuais para melhor desempenho
    Write-Log "Ajustando efeitos visuais para desempenho..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Performance" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
    Write-Log ""

    # Nota sobre Pagefile
    Write-Log "Configuração do Pagefile pulada (WMIC obsoleto nas versões recentes do Windows)." -ForegroundColor Yellow
    Write-Log ""

    # Desabilitando serviços desnecessários
    Write-Log "Desabilitando serviços desnecessários..."
    $services = @("SysMain", "WSearch", "Spooler", "DiagTrack", "dmwappushservice")
    foreach ($service in $services) {
        Try {
            sc.exe config $service start= disabled | Out-Null
            Write-Log "Serviço $service desabilitado."
        } Catch {
            Write-Log "Erro ao desabilitar serviço ${service}: $_" -ForegroundColor Red
        }
    }
    Write-Log ""

    # Desabilitando tarefas agendadas desnecessárias
    Write-Log "Desabilitando tarefas agendadas desnecessárias..."
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
            Write-Log "Tarefa '$task' desabilitada."
        } else {
            Write-Log "Tarefa '$task' não encontrada, pulando..." -ForegroundColor Yellow
        }
    }
    Write-Log ""

    # Limpando logs do Windows
    Write-Log "Limpando logs do Windows..."
    Try {
        Remove-Item "C:\Windows\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Logs limpos com sucesso."
    } Catch {
        Write-Log "Erro ao limpar logs: $_" -ForegroundColor Red
    }
    Write-Log ""

    # Finalizando
    Write-Log "========================================" -ForegroundColor Green
    Write-Log "Recomendo: Reinicie o computador para aplicar todas as mudanças." -ForegroundColor Yellow
    Write-Log ""
    Write-Log "Pressione Enter para continuar..."
    [void][System.Console]::ReadLine()
}


function LimpezaCompleta {
    Write-Log "Executando Limpeza Completa..."
    # (Código da superseofull.bat convertido aqui)
    
# Verificar se está sendo executado como administrador
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script precisa ser executado como ADMINISTRADOR. Fechando..."
    Pause
    Exit
}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Write-Log "========================================" -ForegroundColor Cyan
Write-Log "   INICIANDO SUPER OTIMIZAÇÃO DO PC" -ForegroundColor Cyan
Write-Log "========================================" -ForegroundColor Cyan
Start-Sleep -Seconds 2

# Capturar espaço em disco antes
$before = (Get-PSDrive C).Free

# Limpando arquivos temporários
Write-Log "`n=== Limpando arquivos temporários..."
Try {
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
} Catch {
    Write-Log "Erro ao limpar temporários: $_" -ForegroundColor Red
}

# Limpando cache do Windows Update
Write-Log "`n=== Limpando cache do Windows Update..."
Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait

# Desabilitando Hibernação
Write-Log "`n=== Desabilitando Hibernação..."
powercfg -h off

# Ajustando plano de energia
Write-Log "`n=== Ajustando plano de energia para ALTO DESEMPENHO..."
powercfg /setactive SCHEME_MIN

# Limpando DNS Cache
Write-Log "`n=== Limpando DNS Cache..."
ipconfig /flushdns

# Ajustando efeitos visuais
Write-Log "`n=== Ajustando efeitos visuais para MELHOR DESEMPENHO..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Performance" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue

# Configuração do Pagefile (sem WMIC - usando WMI moderno e evitando conflito de range)
Write-Log "`n=== Configurando Pagefile..."
Try {
    # Desativar gerenciamento automático
    $sys = Get-CimInstance -ClassName Win32_ComputerSystem
    $sys.AutomaticManagedPagefile = $false
    Set-CimInstance -InputObject $sys

    # Apagar qualquer configuração de pagefile existente
    Get-CimInstance -ClassName Win32_PageFileSetting | ForEach-Object {
        Write-Log "Removendo configuração antiga de Pagefile: $($_.Name)"
        Remove-CimInstance -InputObject $_
    }

    # Criar nova configuração
    $InitialMB = [uint32]4096
    $MaxMB = [uint32]8192

    $newPagefile = @{
        Name        = "C:\pagefile.sys"
        InitialSize = $InitialMB
        MaximumSize = $MaxMB
    }

    New-CimInstance -ClassName Win32_PageFileSetting -Property $newPagefile | Out-Null

    Write-Log "Pagefile configurado manualmente: Inicial=$InitialMB MB, Máximo=$MaxMB MB" -ForegroundColor Green
} Catch {
    Write-Log "Falha ao configurar o Pagefile (Erro WMI): $_" -ForegroundColor Yellow
}


# Desabilitando serviços desnecessários
Write-Log "`n=== Desabilitando serviços desnecessários..."
$services = @("SysMain", "WSearch", "Spooler", "DiagTrack", "dmwappushservice")
foreach ($service in $services) {
    Try {
        sc.exe config $service start= disabled | Out-Null
        Write-Log "Serviço $service desabilitado."
    } Catch {
        Write-Log "Erro ao desabilitar serviço ${service}: $_" -ForegroundColor Red
    }
}

# Desabilitando tarefas agendadas
Write-Log "`n=== Desabilitando tarefas agendadas chatas..."
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
        Write-Log "Tarefa '$task' desabilitada."
    } else {
        Write-Log "Tarefa '$task' não encontrada, pulando..." -ForegroundColor Yellow
    }
}

# Limpando logs
Write-Log "`n=== Limpando logs do Windows..."
Try {
    Remove-Item "C:\Windows\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
} Catch {
    Write-Log "Erro ao limpar logs: $_" -ForegroundColor Red
}

# Executando otimização de SSD (TRIM)
Write-Log "`n=== Executando otimização de SSD (TRIM)..."
defrag C: /L

# Verificando integridade de arquivos
Write-Log "`n=== Verificando integridade de arquivos (sfc)..."
sfc /scannow

# Reparando imagem do Windows
Write-Log "`n=== Reparando imagem do Windows (DISM)..."
DISM /Online /Cleanup-Image /RestoreHealth

# Capturar espaço em disco depois
$after = (Get-PSDrive C).Free

# Exibir comparação de espaço livre
Write-Log "`n========================================"
Write-Log " ESPAÇO LIVRE ANTES: $before bytes"
Write-Log " ESPAÇO LIVRE DEPOIS: $after bytes"
Write-Log "========================================"

Write-Log "`n=== FINALIZADO! Recomendo REINICIAR o computador." -ForegroundColor Green
Write-Log "`nPressione qualquer tecla para sair..."
[void][System.Console]::ReadKey($true)
}

function InventarioCompleto {
    Write-Log "Gerando Inventário Completo..."
    # (Código do info.bat convertido aqui)
}

function InventarioRapido {
    Write-Log "Gerando Inventário Rápido..."
    # (Código do info2.bat convertido aqui)
}

function NetworkTools {
    Write-Log "Executando configurações de rede..."
    # (Aqui você vai escrever o conteúdo do network_settings.bat)
    # Zer0G0ld - Network Tools - PowerShell Edition

    function Show-Menu {
        Clear-Host
        Write-Log "============================================" -ForegroundColor Cyan
        Write-Log "       🛰️  NETWORK TOOLS - Zer0Win Tweaks" -ForegroundColor Cyan
        Write-Log "============================================" -ForegroundColor Cyan
        Write-Log ""
        Write-Log "1. Flush DNS Cache"
        Write-Log "2. Reset Winsock e Stack de IP"
        Write-Log "3. Liberar conexões TCP/IP travadas"
        Write-Log "4. Teste de Ping (Google DNS)"
        Write-Log "5. Testar velocidade de internet"
        Write-Log "6. Exibir configuração de IP (ipconfig /all)"
        Write-Log "7. Testar rota de conexão (tracert)"
        Write-Log "8. Limpar ARP Cache"
        Write-Log "9. Sair"
        Write-Log ""
    }

    function Flush-DNS {
        Write-Log "`n=== Limpando DNS Cache... ===" -ForegroundColor Green
        ipconfig /flushdns
        Pause
    }

    function Reset-NetworkStack {
        Write-Log "`n=== Resetando Winsock e Stack TCP/IP... ===" -ForegroundColor Green
        netsh winsock reset
        netsh int ip reset
        Pause
    }

    function TCP-Cleanup {
        Write-Log "`n=== Exibindo conexões TCP/IP abertas... ===" -ForegroundColor Green
        netstat -ano
        Pause
    }

    function Ping-Test {
        Write-Log "`n=== Testando conexão com Google DNS (8.8.8.8)... ===" -ForegroundColor Green
        ping 8.8.8.8 -n 10
        Pause
    }

    function Speed-Test {
        Write-Log "`n=== Testando velocidade de internet... ===" -ForegroundColor Green
        Write-Log "Abrindo site de teste de velocidade no navegador padrão..."
        Start-Process "https://fast.com"
        Write-Log "Ou acesse manualmente: https://fast.com ou https://speedtest.net"
        Pause
    }

    function Show-IPConfig {
        Write-Log "`n=== Exibindo configuração detalhada de IP... ===" -ForegroundColor Green
        ipconfig /all
        Pause
    }

    function Tracert-Test {
        Write-Log "`n=== Testando rota até o Google DNS (8.8.8.8)... ===" -ForegroundColor Green
        tracert 8.8.8.8
        Pause
    }

    function Clear-ARP {
        Write-Log "`n=== Limpando cache ARP... ===" -ForegroundColor Green
        arp -d
        Pause
    }

    function Pause {
        Write-Log "`nPressione qualquer tecla para continuar..." -ForegroundColor DarkGray
        [void][System.Console]::ReadKey($true)
    }

    do {
        Show-Menu
        $choice = Read-Host "Escolha uma opção"

        switch ($choice) {
            "1" { Flush-DNS }
            "2" { Reset-NetworkStack }
            "3" { TCP-Cleanup }
            "4" { Ping-Test }
            "5" { Speed-Test }
            "6" { Show-IPConfig }
            "7" { Tracert-Test }
            "8" { Clear-ARP }
            "9" { Write-Log "`nSaindo..."; break }
            Default { Write-Log "`nOpção inválida. Tente novamente." -ForegroundColor Red; Pause }
        }
    } while ($true)

}

# ===============================
# Função: Detalhes Visuais - Menu interativo no console
# ===============================
function DetalhesVisuais {
    Write-Log "Executando detalhes visuais..." -ForegroundColor Cyan
    Write-Log ""

    $menu = @"
================ Detalhes Visuais ==================
Escolha uma opção:

[1] Limpar Temp
[2] Flush DNS
[3] Ver Serviços Ativos
[4] Sair
====================================================
"@

    do {
        Write-Log $menu -ForegroundColor Yellow
        $opcao = Read-Host "Digite o número da opção desejada"

        switch ($opcao) {
            "1" {
                Write-Log "== Limpando Temp... ==" -ForegroundColor Green
                Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue -Verbose
                Write-Log "`nTemp limpo!" -ForegroundColor Green
            }
            "2" {
                Write-Log "== Limpando DNS Cache... ==" -ForegroundColor Green
                ipconfig /flushdns
                Write-Log "`nDNS Cache limpo!" -ForegroundColor Green
            }
            "3" {
                Write-Log "== Listando serviços ativos... ==" -ForegroundColor Green
                Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object DisplayName, Status | Format-Table -AutoSize
            }
            "4" {
                Write-Log "Saindo de Detalhes Visuais..." -ForegroundColor Red
            }
            Default {
                Write-Log "Opção inválida. Tente novamente." -ForegroundColor Red
            }
        }

        if ($opcao -ne "4") {
            Write-Log "`nPressione qualquer tecla para continuar..." -ForegroundColor DarkGray
            [void][System.Console]::ReadKey($true)
            Clear-Host
        }
    } while ($opcao -ne "4")
}


# ===============================
# Função: Barra de progresso simples
# ===============================
function Progresso {
    Write-Log "Progresso:"
    for ($i = 1; $i -le 10; $i++) {
        $barra = ("#" * $i).PadRight(10, ".")
        Write-Log ("[" + $barra + "] $($i * 10)%") -NoNewline
        Start-Sleep -Milliseconds 300
        Write-Log "`r" -NoNewline
    }
    Write-Log "`nConcluído!" -ForegroundColor Green
}


# Função para criar botões
function CriarBotao ($texto, $y, $acao) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $texto
    $btn.Size = New-Object System.Drawing.Size(180, 40)
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.Add_Click($acao)
    $buttonPanel.Controls.Add($btn)
}

# Criando os botões
CriarBotao "Limpeza Rápida" 10 { LimpezaRapida }
CriarBotao "Limpeza Completa" 60 { LimpezaCompleta }
CriarBotao "Inventário Rápido" 110 { InventarioRapido }
CriarBotao "Ferramentas de Rede" 160 { NetworkTools }
CriarBotao "Sair" 210 { $form.Close() }

# Evento: Ao pressionar Enter no inputBox
$inputBox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        $executeButton.PerformClick()
        $_.SuppressKeyPress = $true
    }
})

# Evento: Ao clicar no botão Executar
$executeButton.Add_Click({
    $userCommand = $inputBox.Text
    if (![string]::IsNullOrWhiteSpace($userCommand)) {
        Write-Log ">>> Comando do usuário: $userCommand"

        try {
            # Executa o comando do usuário
            $result = Invoke-Expression $userCommand
            if ($result) {
                Write-Log ($result | Out-String)
            }
        } catch {
            Write-Log "Erro ao executar comando: $_" -ForegroundColor Red
        }

        # Limpa a entrada
        $inputBox.Clear()
    }
})

$job = Start-Job -ScriptBlock { LimpezaRapida }
Register-ObjectEvent -InputObject $job -EventName StateChanged -Action {
    if ($job.State -eq 'Completed') {
        Receive-Job $job | ForEach-Object { Write-Log $_ }
        Remove-Job $job
    }
}
$userCommand = $inputBox.Text.Trim()


# Exibir o form
[void]$form.ShowDialog()
