# COLMEIA — Contexto Global

Este arquivo e um placeholder. O CLAUDE.md real e **gerado automaticamente** pelo `install.sh` com base no seu `project.yaml`.

## Como funciona

1. Edite `project.yaml` com suas stacks e configuracoes
2. Execute `./install.sh`
3. O CLAUDE.md gerado sera instalado em `~/.claude/CLAUDE.md`

O arquivo gerado combina:
- `base/CLAUDE-base.md` (regras universais)
- Contexto das stacks selecionadas em `stacks/`
- Convencoes e comandos do `project.yaml`

## Quickstart

```bash
cp examples/project-ideva.yaml project.yaml
./install.sh
```

Ver [README.md](README.md) para documentacao completa.
