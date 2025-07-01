import subprocess
import socket
from rich.console import Console
from rich.table import Table
from rich.prompt import Prompt

from core import limp

console = Console()

def exibir_ipconfig():
    console.print("[bold cyan]Informações de rede (ipconfig /all):[/bold cyan]\n")
    resultado = subprocess.run("ipconfig /all", shell=True, capture_output=True, text=True)
    console.print(resultado.stdout)

def testar_ping(destino=None):
    if not destino:
        destino = Prompt.ask("Digite o IP ou domínio para ping", default="8.8.8.8")
    console.print(f"[bold cyan]Testando ping para {destino}...[/bold cyan]")
    resultado = subprocess.run(f"ping {destino} -n 4", shell=True, capture_output=True, text=True)
    console.print(resultado.stdout)

def listar_conexoes():
    console.print("[bold cyan]Conexões de rede ativas (netstat -ano):[/bold cyan]\n")
    resultado = subprocess.run("netstat -ano", shell=True, capture_output=True, text=True)
    console.print(resultado.stdout)

def liberar_renovar_ip():
    console.print("[bold yellow]Liberando IP...[/bold yellow]")
    subprocess.run("ipconfig /release", shell=True)
    console.print("[bold yellow]Renovando IP...[/bold yellow]")
    subprocess.run("ipconfig /renew", shell=True)
    console.print("[bold green]IP renovado![/bold green]")

def traceroute(destino=None):
    if not destino:
        destino = Prompt.ask("Digite o IP ou domínio para traceroute", default="8.8.8.8")
    console.print(f"[bold cyan]Executando traceroute para {destino}...[/bold cyan]\n")
    resultado = subprocess.run(f"tracert {destino}", shell=True, capture_output=True, text=True)
    console.print(resultado.stdout)

def testar_porta(host=None, porta=None):
    if not host:
        host = Prompt.ask("Digite o IP ou domínio para testar porta", default="8.8.8.8")
    if not porta:
        porta = Prompt.ask("Digite a porta TCP para testar", default="80")
    porta = int(porta)

    console.print(f"[bold cyan]Testando conexão TCP em {host}:{porta}...[/bold cyan]")
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(3)
    try:
        sock.connect((host, porta))
    except Exception as e:
        console.print(f"[red]Falha na conexão: {e}[/red]")
    else:
        console.print(f"[green]Porta {porta} está aberta em {host}![/green]")
    finally:
        sock.close()

def resetar_adaptador():
    console.print("[bold yellow]Adaptadores de rede disponíveis:[/bold yellow]")
    # Lista os nomes dos adaptadores com netsh
    resultado = subprocess.run("netsh interface show interface", shell=True, capture_output=True, text=True)
    console.print(resultado.stdout)

    nome = Prompt.ask("Digite o nome exato do adaptador para reiniciar")
    console.print(f"[bold yellow]Desabilitando adaptador '{nome}'...[/bold yellow]")
    subprocess.run(f'netsh interface set interface "{nome}" disable', shell=True)
    console.print(f"[bold yellow]Habilitando adaptador '{nome}'...[/bold yellow]")
    subprocess.run(f'netsh interface set interface "{nome}" enable', shell=True)
    console.print("[bold green]Adaptador reiniciado![/bold green]")

def status_wifi():
    console.print("[bold cyan]Status da conexão Wi-Fi:[/bold cyan]")
    resultado = subprocess.run("netsh wlan show interfaces", shell=True, capture_output=True, text=True)
    console.print(resultado.stdout)

def run():
    limp.limpar_tela()
    while True:
        #limp.limpar_tela()
        #console.clear()
        console.print("[bold magenta]Zer0Win Toolkit - Módulo Rede[/bold magenta]\n")

        table = Table(show_header=True, header_style="bold blue")
        table.add_column("Opção", justify="center")
        table.add_column("Descrição")

        table.add_row("1", "Exibir configurações de rede (ipconfig)")
        table.add_row("2", "Testar ping")
        table.add_row("3", "Listar conexões ativas (netstat)")
        table.add_row("4", "Liberar e renovar IP")
        table.add_row("5", "Executar traceroute")
        table.add_row("6", "Testar porta TCP")
        table.add_row("7", "Resetar adaptador de rede")
        table.add_row("8", "Mostrar status Wi-Fi")
        table.add_row("0", "Voltar ao menu principal")

        console.print(table)
        escolha = Prompt.ask("\nEscolha uma opção", choices=[str(i) for i in range(9)])

        if escolha == "1":
            exibir_ipconfig()
        elif escolha == "2":
            testar_ping()
        elif escolha == "3":
            listar_conexoes()
        elif escolha == "4":
            liberar_renovar_ip()
        elif escolha == "5":
            traceroute()
        elif escolha == "6":
            testar_porta()
        elif escolha == "7":
            resetar_adaptador()
        elif escolha == "8":
            status_wifi()
        elif escolha == "0":
            break

        input("\nPressione Enter para continuar...")

if __name__ == "__main__":
    run()
