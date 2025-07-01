import os
import shutil
import subprocess
from rich.console import Console
from rich.progress import track

from core import limp

console = Console()

TEMP_DIRS = [
    os.environ.get("TEMP"),
    os.path.join(os.environ.get("SystemRoot"), "Temp"),
    os.path.join(os.environ.get("USERPROFILE"), "AppData", "Local", "Temp"),
]

def limpar_temp():
    console.print("🧹 Limpando arquivos temporários...", style="bold yellow")
    for path in TEMP_DIRS:
        if os.path.exists(path):
            try:
                items = os.listdir(path)
            except PermissionError:
                console.print(f"[red]⚠ Acesso negado a: {path}[/red]")
                continue

            for item in track(items, description=f"Limpando {path}..."):
                item_path = os.path.join(path, item)
                try:
                    if os.path.isfile(item_path) or os.path.islink(item_path):
                        os.unlink(item_path)
                    elif os.path.isdir(item_path):
                        shutil.rmtree(item_path)
                except PermissionError:
                    console.print(f"[yellow]⚠ Em uso (ignorado): {item}[/yellow]")
                except OSError as e:
                    # Ignora erros como "arquivo em uso" (WinError 32)
                    if "being used by another process" in str(e) or "used by another process" in str(e) or "WinError 32" in str(e):
                        console.print(f"[yellow]⚠ Arquivo em uso (ignorado): {item}[/yellow]")
                    else:
                        console.print(f"[red]Erro ao remover {item_path}: {e}[/red]")
                except Exception as e:
                    console.print(f"[red]❌ Erro inesperado: {item_path} → {e}[/red]")

def limpar_lixeira():
    console.print("🗑 Limpando lixeira...", style="bold yellow")
    try:
        subprocess.run(
            ["powershell", "-Command", "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"],
            check=True
        )
    except subprocess.CalledProcessError:
        console.print("[yellow]⚠ Lixeira já vazia ou inacessível.[/yellow]")

def limpar_update():
    console.print("🔧 Limpando arquivos do Windows Update...", style="bold yellow")
    subprocess.run("cleanmgr /sagerun:1", shell=True)

def otimizar_disco():
    console.print("💽 Otimizando disco C:...", style="bold yellow")
    subprocess.run("defrag C: /O", shell=True)

def run():
    limp.limpar_tela()
    console.print("[bold green]Iniciando limpeza e otimização...[/bold green]\n")
    limpar_temp()
    limpar_lixeira()
    limpar_update()
    otimizar_disco()
    console.print("\n[bold green]✅ Finalizado! Sistema mais limpo e otimizado.[/bold green]")
