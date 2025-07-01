# 🛠️ Zer0G0ld - Windows Optimization & Inventory Pack

Um conjunto de scripts Batch para otimização extrema de desempenho e coleta de inventário de máquinas Windows.  

---

Versão Atual: 0.1 Beta


Estrutura:
```bash
zer0win-tweaks/
├─ docs/              → documentação e planejamento
├─ img/               → ícones e logos
├─ scripts/           → legado .bat (pode manter pra referência ou uso direto)
├─ src/
│  ├─ gui/            → futura interface em Python (Tkinter ou PySimpleGUI)
│  ├─ core/           → módulos em Python que replicam os `.bat` e `.ps1`
│  └─ main.py         → orquestrador do menu, GUI ou CLI
├─ dist/              → onde vai gerar os `.exe` com PyInstaller
└─ README.md
```

## 📂 Scripts incluídos:

| Script | Função |
|---|---|
| superseowin.bat | Otimização rápida de desempenho |
| superseofull.bat | Otimização completa + manutenção (sfc, dism, trim) |
| info.bat | Inventário completo de hardware/software |
| info2.bat | Inventário rápido (foco em upgrade de hardware) |

---

## 📌 Avisos:
- Requer execução como **Administrador**
- **Uso por conta e risco** (ações como desativação de serviços, limpeza de logs, alteração de efeitos visuais)
- Testado em Windows 10 Pro, pode variar em outras versões

---

## ✅ Autor:
Matheus Torres (Zer0G0ld)

# Mapeamento de Categorias

[Roadmap](docs/Roadmap.md)
[Changelog](docs/Changelog.md)
[Docs](docs/Projeto.md)


