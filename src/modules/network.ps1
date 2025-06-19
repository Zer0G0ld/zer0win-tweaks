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
