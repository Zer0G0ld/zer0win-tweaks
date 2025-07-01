import subprocess
import psutil
from rich.console import Console
from rich.table import Table
from rich.prompt import Prompt, Confirm

console = Console()

def verificar_defender():
    console.print("\n🛡 [bold yellow]Verificando status do Windows Defender...[/bold yellow]")
    try:
        result = subprocess.check_output(
            ["powershell", "-Command", 
             "Get-MpComputerStatus | Select-Object AMServiceEnabled, RealTimeProtectionEnabled, AntivirusEnabled | Format-List"],
            text=True
        )
        table = Table(title="Status do Windows Defender")
        table.add_column("Configuração", style="cyan")
        table.add_column("Status", style="green")
        
        for line in result.strip().splitlines():
            if ":" in line:
                chave, valor = line.split(":", 1)
                table.add_row(chave.strip(), valor.strip())
        
        console.print(table)
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Erro ao obter status do Defender: {e}[/red]")

def ativar_defender():
    console.print("\n✅ [bold yellow]Ativando proteção em tempo real...[/bold yellow]")
    try:
        subprocess.run(
            ["powershell", "-Command", "Set-MpPreference -DisableRealtimeMonitoring $false"],
            check=True
        )
        console.print("[green]✅ Proteção em tempo real ativada com sucesso![/green]")
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Erro ao ativar proteção: {e}[/red]")

def desativar_defender():
    console.print("\n⛔ [bold yellow]Desativando proteção em tempo real...[/bold yellow]")
    try:
        subprocess.run(
            ["powershell", "-Command", "Set-MpPreference -DisableRealtimeMonitoring $true"],
            check=True
        )
        console.print("[green]⚠ Proteção em tempo real desativada.[/green]")
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Erro ao desativar proteção: {e}[/red]")

def iniciar_verificacao_rapida():
    console.print("\n🔍 [bold yellow]Executando verificação rápida com o Windows Defender...[/bold yellow]")
    try:
        subprocess.run(
            ["powershell", "-Command", "Start-MpScan -ScanType QuickScan"],
            check=True
        )
        console.print("[green]✅ Verificação rápida iniciada![/green]")
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Erro ao iniciar verificação: {e}[/red]")

def listar_programas_inicializacao():
    console.print("\n🧬 [bold yellow]Listando programas na inicialização...[/bold yellow]")
    try:
        output = subprocess.check_output(
            ["powershell", "-Command", 
             "Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Name, Command, Location"],
            text=True
        )
        table = Table(title="Programas na Inicialização", show_lines=True)
        table.add_column("Nome", style="cyan")
        table.add_column("Comando", style="magenta")
        table.add_column("Local", style="green")

        linhas = [l.strip() for l in output.strip().splitlines() if l.strip()]
        cabecalho = linhas[0]
        registros = linhas[2:]

        current = {"Name": "", "Command": "", "Location": ""}
        campos = list(current.keys())

        for line in registros:
            for campo in campos:
                if line.startswith(campo):
                    current[campo] = line.split(":", 1)[1].strip()
            if all(current.values()):
                table.add_row(current["Name"], current["Command"], current["Location"])
                current = {k: "" for k in campos}

        console.print(table)
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Erro ao listar programas de inicialização: {e}[/red]")

def encerrar_processo_suspeito():
    console.print("\n❌ [bold yellow]Encerrar processo suspeito manualmente[/bold yellow]")
    pid_input = Prompt.ask("Digite o PID do processo (ou 0 para cancelar)", default="0")
    try:
        pid = int(pid_input)
        if pid == 0:
            return
        proc = psutil.Process(pid)
        nome = proc.name()
        if Confirm.ask(f"Tem certeza que deseja encerrar '{nome}' (PID {pid})?"):
            proc.terminate()
            proc.wait(timeout=3)
            console.print(f"[green]✅ Processo {nome} encerrado com sucesso![/green]")
    except Exception as e:
        console.print(f"[red]❌ Erro ao encerrar processo: {e}[/red]")

def run():
    console.print("\n[bold cyan]Módulo de Segurança[/bold cyan]\n")

    while True:
        console.print("[1] 🛡 Verificar status do Windows Defender")
        console.print("[2] ✅ Ativar proteção em tempo real")
        console.print("[3] ⛔ Desativar proteção em tempo real")
        console.print("[4] 🔍 Iniciar verificação rápida")
        console.print("[5] 🧬 Listar programas na inicialização")
        console.print("[6] ❌ Encerrar processo suspeito manualmente")
        console.print("[0] 🔙 Voltar")

        opc = Prompt.ask("\n[bold yellow]Escolha uma opção[/bold yellow]", choices=["0", "1", "2", "3", "4", "5", "6"])

        if opc == "1":
            verificar_defender()
        elif opc == "2":
            ativar_defender()
        elif opc == "3":
            desativar_defender()
        elif opc == "4":
            iniciar_verificacao_rapida()
        elif opc == "5":
            listar_programas_inicializacao()
        elif opc == "6":
            encerrar_processo_suspeito()
        elif opc == "0":
            break
        else:
            console.print("[red]❌ Opção inválida! Tente novamente.[/red]")