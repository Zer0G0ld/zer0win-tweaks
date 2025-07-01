import platform
import os

from core import limp

def run():
    limp.limpar_tela()
    print("📋 Coletando informações do sistema:\n")
    print(f"Sistema operacional: {platform.system()} {platform.release()}")
    print(f"Versão: {platform.version()}")
    print(f"Arquitetura: {platform.architecture()[0]}")
    print(f"Nome do computador: {os.environ.get('COMPUTERNAME')}")
    print(f"Usuário atual: {os.getlogin()}")