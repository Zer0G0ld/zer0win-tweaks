import os
import subprocess
import psutil
from rich.console import Console
from rich.table import Table
from rich.prompt import Prompt, Confirm
from rich.live import Live
from time import sleep
import platform

console = Console()

def detectar_disco_sistema():
    for part in psutil.disk_partitions():
        if part.mountpoint == "/" or "C:" in part.device:
            return part.mountpoint
    return "/"

def monitorar_sistema():
    disco = detectar_disco_sistema()

    def gerar_tabela():
        table = Table(title="📊 Monitoramento do Sistema", show_lines=True)
        table.add_column("Recurso", style="bold")
        table.add_column("Uso")

        cpu = psutil.cpu_percent()
        ram = psutil.virtual_memory()
        disco_uso = psutil.disk_usage(disco)

        table.add_row("CPU", f"{cpu:.1f}%")
        table.add_row("RAM", f"{ram.used / 1e9:.2f} GB / {ram.total / 1e9:.2f} GB")
        table.add_row(f"Disco ({disco})", f"{disco_uso.used / 1e9:.2f} GB / {disco_uso.total / 1e9:.2f} GB")

        return table

    with Live(gerar_tabela(), refresh_per_second=1) as live:
        for _ in range(10):
            sleep(1)
            live.update(gerar_tabela())

def listar_processos_pesados(limit=10):
    console.print("\n📊 [bold yellow]Top processos por uso de memória (RAM):[/bold yellow]")
    processos = []

    for p in psutil.process_iter(['pid', 'name', 'memory_info']):
        try:
            mem_mb = p.info['memory_info'].rss / 1024 / 1024
            processos.append((p.info["pid"], p.info["name"], mem_mb))
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue

    processos.sort(key=lambda x: x[2], reverse=True)
    tabela = Table(title="Top processos", show_lines=True)
    tabela.add_column("PID", justify="right")
    tabela.add_column("Nome")
    tabela.add_column("Memória (MB)", justify="right")

    for pid, nome, mem in processos[:limit]:
        tabela.add_row(str(pid), nome or "Desconhecido", f"{mem:.2f}")

    console.print(tabela)

    if Confirm.ask("Deseja encerrar algum processo?"):
        pid_input = Prompt.ask("Digite o PID do processo a encerrar")
        try:
            pid = int(pid_input)
            proc = psutil.Process(pid)
            proc_name = proc.name()
            if Confirm.ask(f"Tem certeza que deseja encerrar '{proc_name}' (PID {pid})?"):
                proc.terminate()
                proc.wait(timeout=3)
                console.print(f"[green]✅ Processo {proc_name} encerrado com sucesso![/green]")
        except Exception as e:
            console.print(f"[red]Erro ao encerrar processo: {e}[/red]")

def mudar_plano_energia():
    console.print("\n⚡ [bold yellow]Ativando plano de energia Alto Desempenho...[/bold yellow]")
    try:
        subprocess.run("powercfg /setactive SCHEME_MIN", shell=True)
        console.print("[green]✅ Plano de energia alterado.[/green]")
    except Exception as e:
        console.print(f"[red]Erro: {e}[/red]")

def limpar_prefetch():
    console.print("\n🧹 [bold yellow]Limpando arquivos do Prefetch...[/bold yellow]")
    try:
        subprocess.run("del /q/f/s %SystemRoot%\\Prefetch\\*", shell=True)
        console.print("[green]✅ Prefetch limpo com sucesso.[/green]")
    except Exception as e:
        console.print(f"[red]Erro ao limpar Prefetch: {e}[/red]")

def abrir_taskmgr():
    console.print("\n🧠 [bold yellow]Abrindo o Gerenciador de Tarefas...[/bold yellow]")
    subprocess.run("start taskmgr", shell=True)

def run():
    console.print("\n[bold cyan]Módulo de Performance[/bold cyan]\n")

    while True:
        console.print("[1] 📈 Monitorar uso de CPU/RAM/Disco")
        console.print("[2] 📊 Ver processos e encerrar")
        console.print("[3] ⚡ Ativar plano Alto Desempenho")
        console.print("[4] 🧹 Limpar Prefetch")
        console.print("[5] 🧠 Abrir Gerenciador de Tarefas")
        console.print("[0] 🔙 Voltar")

        opc = Prompt.ask("\n[bold yellow]Escolha uma opção[/bold yellow]", choices=["0", "1", "2", "3", "4", "5"])

        if opc == "1":
            monitorar_sistema()
        elif opc == "2":
            listar_processos_pesados()
        elif opc == "3":
            mudar_plano_energia()
        elif opc == "4":
            limpar_prefetch()
        elif opc == "5":
            abrir_taskmgr()
        elif opc == "0":
            break
