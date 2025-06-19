# ===============================
# Zer0Win Toolkit - PowerShell Edition
# Autor: Zer0G0ld
# ===============================

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# ==== Funções ====

# ===============================
# Função: Limpeza Rápida
# Realiza otimizações básicas no sistema, limpeza de arquivos temporários, desabilitação de serviços e tarefas, etc.
# ===============================
function LimpezaRapida {
    Write-Host "Executando Limpeza Rápida..."
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   INICIANDO SUPER OTIMIZAÇÃO DO PC" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Start-Sleep -Seconds 2

    # Limpando arquivos temporários
    Write-Host "Limpando arquivos temporários..."
    Try {
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    } Catch {
        Write-Host "Erro ao limpar arquivos temporários: $_" -ForegroundColor Red
    }
    Write-Host ""

    # Limpando cache do Windows Update (Cleanmgr deve estar configurado com /sageset:1 previamente)
    Write-Host "Limpando cache do Windows Update..."
    Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait
    Write-Host ""

    # Desabilitando hibernação
    Write-Host "Desabilitando hibernação..."
    powercfg -h off
    Write-Host ""

    # Ajustando plano de energia para alto desempenho
    Write-Host "Ajustando plano de energia para ALTO DESEMPENHO..."
    powercfg /setactive SCHEME_MIN
    Write-Host ""

    # Limpando DNS Cache
    Write-Host "Limpando DNS Cache..."
    ipconfig /flushdns
    Write-Host ""

    # Ajustando efeitos visuais para melhor desempenho
    Write-Host "Ajustando efeitos visuais para desempenho..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Performance" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
    Write-Host ""

    # Nota sobre Pagefile
    Write-Host "Configuração do Pagefile pulada (WMIC obsoleto nas versões recentes do Windows)." -ForegroundColor Yellow
    Write-Host ""

    # Desabilitando serviços desnecessários
    Write-Host "Desabilitando serviços desnecessários..."
    $services = @("SysMain", "WSearch", "Spooler", "DiagTrack", "dmwappushservice")
    foreach ($service in $services) {
        Try {
            sc.exe config $service start= disabled | Out-Null
            Write-Host "Serviço $service desabilitado."
        } Catch {
            Write-Host "Erro ao desabilitar serviço ${service}: $_" -ForegroundColor Red
        }
    }
    Write-Host ""

    # Desabilitando tarefas agendadas desnecessárias
    Write-Host "Desabilitando tarefas agendadas desnecessárias..."
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
    Write-Host ""

    # Limpando logs do Windows
    Write-Host "Limpando logs do Windows..."
    Try {
        Remove-Item "C:\Windows\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Logs limpos com sucesso."
    } Catch {
        Write-Host "Erro ao limpar logs: $_" -ForegroundColor Red
    }
    Write-Host ""

    # Finalizando
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Recomendo: Reinicie o computador para aplicar todas as mudanças." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Pressione Enter para continuar..."
    [void][System.Console]::ReadLine()
}


function LimpezaCompleta {
    Write-Host "Executando Limpeza Completa..."
    # (Código da superseofull.bat convertido aqui)
}

function InventarioCompleto {
    Write-Host "Gerando Inventário Completo..."
    # (Código do info.bat convertido aqui)
}

function InventarioRapido {
    Write-Host "Gerando Inventário Rápido..."
    # (Código do info2.bat convertido aqui)
}

function NetworkTools {
    Write-Host "Executando configurações de rede..."
    # (Aqui você vai escrever o conteúdo do network_settings.bat)
    # Zer0G0ld - Network Tools - PowerShell Edition

    function Show-Menu {
        Clear-Host
        Write-Host "============================================" -ForegroundColor Cyan
        Write-Host "       🛰️  NETWORK TOOLS - Zer0Win Tweaks" -ForegroundColor Cyan
        Write-Host "============================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Flush DNS Cache"
        Write-Host "2. Reset Winsock e Stack de IP"
        Write-Host "3. Liberar conexões TCP/IP travadas"
        Write-Host "4. Teste de Ping (Google DNS)"
        Write-Host "5. Testar velocidade de internet"
        Write-Host "6. Exibir configuração de IP (ipconfig /all)"
        Write-Host "7. Testar rota de conexão (tracert)"
        Write-Host "8. Limpar ARP Cache"
        Write-Host "9. Sair"
        Write-Host ""
    }

    function Flush-DNS {
        Write-Host "`n=== Limpando DNS Cache... ===" -ForegroundColor Green
        ipconfig /flushdns
        Pause
    }

    function Reset-NetworkStack {
        Write-Host "`n=== Resetando Winsock e Stack TCP/IP... ===" -ForegroundColor Green
        netsh winsock reset
        netsh int ip reset
        Pause
    }

    function TCP-Cleanup {
        Write-Host "`n=== Exibindo conexões TCP/IP abertas... ===" -ForegroundColor Green
        netstat -ano
        Pause
    }

    function Ping-Test {
        Write-Host "`n=== Testando conexão com Google DNS (8.8.8.8)... ===" -ForegroundColor Green
        ping 8.8.8.8 -n 10
        Pause
    }

    function Speed-Test {
        Write-Host "`n=== Testando velocidade de internet... ===" -ForegroundColor Green
        Write-Host "Abrindo site de teste de velocidade no navegador padrão..."
        Start-Process "https://fast.com"
        Write-Host "Ou acesse manualmente: https://fast.com ou https://speedtest.net"
        Pause
    }

    function Show-IPConfig {
        Write-Host "`n=== Exibindo configuração detalhada de IP... ===" -ForegroundColor Green
        ipconfig /all
        Pause
    }

    function Tracert-Test {
        Write-Host "`n=== Testando rota até o Google DNS (8.8.8.8)... ===" -ForegroundColor Green
        tracert 8.8.8.8
        Pause
    }

    function Clear-ARP {
        Write-Host "`n=== Limpando cache ARP... ===" -ForegroundColor Green
        arp -d
        Pause
    }

    function Pause {
        Write-Host "`nPressione qualquer tecla para continuar..." -ForegroundColor DarkGray
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
            "9" { Write-Host "`nSaindo..."; break }
            Default { Write-Host "`nOpção inválida. Tente novamente." -ForegroundColor Red; Pause }
        }
    } while ($true)

}

# ===============================
# Função: Detalhes Visuais - Menu interativo no console
# ===============================
function DetalhesVisuais {
    Write-Host "Executando detalhes visuais..." -ForegroundColor Cyan
    Write-Host ""

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
        Write-Host $menu -ForegroundColor Yellow
        $opcao = Read-Host "Digite o número da opção desejada"

        switch ($opcao) {
            "1" {
                Write-Host "== Limpando Temp... ==" -ForegroundColor Green
                Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue -Verbose
                Write-Host "`nTemp limpo!" -ForegroundColor Green
            }
            "2" {
                Write-Host "== Limpando DNS Cache... ==" -ForegroundColor Green
                ipconfig /flushdns
                Write-Host "`nDNS Cache limpo!" -ForegroundColor Green
            }
            "3" {
                Write-Host "== Listando serviços ativos... ==" -ForegroundColor Green
                Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object DisplayName, Status | Format-Table -AutoSize
            }
            "4" {
                Write-Host "Saindo de Detalhes Visuais..." -ForegroundColor Red
            }
            Default {
                Write-Host "Opção inválida. Tente novamente." -ForegroundColor Red
            }
        }

        if ($opcao -ne "4") {
            Write-Host "`nPressione qualquer tecla para continuar..." -ForegroundColor DarkGray
            [void][System.Console]::ReadKey($true)
            Clear-Host
        }
    } while ($opcao -ne "4")
}


# ===============================
# Função: Barra de progresso simples
# ===============================
function Progresso {
    Write-Host "Progresso:"
    for ($i = 1; $i -le 10; $i++) {
        $barra = ("#" * $i).PadRight(10, ".")
        Write-Host ("[" + $barra + "] $($i * 10)%") -NoNewline
        Start-Sleep -Milliseconds 300
        Write-Host "`r" -NoNewline
    }
    Write-Host "`nConcluído!" -ForegroundColor Green
}


# ===============================
# Interface Gráfica Simples com Windows Forms
# ===============================

$form = New-Object System.Windows.Forms.Form
$form.Text = "Zer0Win Toolkit"
$form.Size = New-Object System.Drawing.Size(400, 400)
$form.StartPosition = "CenterScreen"

# Função para criar botão para evitar repetição
function CriarBotao ($texto, $x, $y, $largura, $altura, $acao) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $texto
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.Size = New-Object System.Drawing.Size($largura, $altura)
    $btn.Add_Click($acao)
    $form.Controls.Add($btn)
}

# Criando botões
CriarBotao "Limpeza Rápida" 30 30 150 40 { LimpezaRapida }
CriarBotao "Detalhes Visuais" 30 80 150 40 { DetalhesVisuais }
CriarBotao "Limpeza Completa" 30 130 150 40 { Write-Host "Função Limpeza Completa ainda não implementada." -ForegroundColor Yellow }
CriarBotao "Inventário Rápido" 30 180 150 40 { Write-Host "Função Inventário Rápido ainda não implementada." -ForegroundColor Yellow }
CriarBotao "Inventário Completo" 30 230 150 40 { Write-Host "Função Inventário Completo ainda não implementada." -ForegroundColor Yellow }
CriarBotao "Ferramentas de Rede" 30 280 150 40 { NetworkTools }

# Botão para sair do app
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Location = New-Object System.Drawing.Point(30, 330)
$btnExit.Size = New-Object System.Drawing.Size(150, 40)
$btnExit.Text = "Sair"
$btnExit.Add_Click({ $form.Close() })
$form.Controls.Add($btnExit)

# Mostrar formulário
[void]$form.ShowDialog()

