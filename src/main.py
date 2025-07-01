# src/main.py

from core import cleanup, inventory, network, performance, security, limp
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich import box

console = Console()

def exibir_menu():
    console.clear()
    console.print(Panel.fit(
        "[bold cyan]Zer0Win T00lkit[/bold cyan] 💻🛠️",
        border_style="bright_magenta",
        box=box.DOUBLE_EDGE
    ))

    console.print("[1] 🧹 Limpeza", style="bold")
    console.print("[2] 📋 Inventário", style="bold")
    console.print("[3] 🌐 Rede", style="bold")
    console.print("[4] 🚀 Performance", style="bold")
    console.print("[5] 🔐 Segurança", style="bold")
    console.print("[0] ❌ Sair", style="bold red")

def menu():
    while True:
        limp.limpar_tela()
        exibir_menu()
        opc = Prompt.ask("\n[bold yellow]Escolha uma opção[/bold yellow]", choices=["0", "1", "2", "3", "4", "5"])

        console.print()  # quebra de linha bonitinha

        match opc:
            case "1": cleanup.run()
            case "2": inventory.run()
            case "3": network.run()
            case "4": performance.run()
            case "5": security.run()
            case "0":
                console.print("\n[bold green]Obrigado por usar o Zer0Win Toolkit![/bold green] 👋")
                break

        Prompt.ask("\n[gray]Pressione Enter para voltar ao menu[/gray]", default="")

if __name__ == "__main__":
    try:
        menu()
    except KeyboardInterrupt:
        console.print("\n\n[bold red]❌ Execução cancelada pelo usuário.[/bold red] 👋")
