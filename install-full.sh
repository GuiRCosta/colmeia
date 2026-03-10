#!/bin/bash

# ============================================================
# COLMEIA — Full Permission Installer
# ============================================================
# Faz tudo que o install.sh faz + configura atalhos para
# iniciar o Claude Code com permissoes completas.
#
# AVISO: --dangerously-skip-permissions desativa TODAS as
# confirmacoes de seguranca. O Claude executa qualquer acao
# (deletar arquivos, push, bash) sem pedir aprovacao.
# Use apenas se souber o que esta fazendo.
# ============================================================

set -e

COLMEIA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# ── Executar install.sh padrao primeiro ─────────────────────
echo ""
echo -e "${BLUE}COLMEIA — Full Permission Installer${NC}"
echo "============================================"
echo ""
echo -e "${YELLOW}AVISO: Este instalador configura o Claude Code${NC}"
echo -e "${YELLOW}com --dangerously-skip-permissions (sem confirmacoes).${NC}"
echo ""
echo -n "Continuar? [s/N] "
read -r resp
if [[ ! "$resp" =~ ^[sS]$ ]]; then
  echo -e "${YELLOW}Cancelado.${NC}"
  exit 0
fi

echo ""

# Executar instalacao padrao
bash "$COLMEIA_DIR/install.sh" "$@"

echo ""
echo -e "${BLUE}Configurando atalhos de permissao completa...${NC}"
echo ""

# ── Detectar shell do usuario ───────────────────────────────
USER_SHELL=$(basename "$SHELL")
case "$USER_SHELL" in
  zsh)  SHELL_RC="$HOME/.zshrc" ;;
  bash) SHELL_RC="$HOME/.bashrc" ;;
  *)    SHELL_RC="$HOME/.${USER_SHELL}rc" ;;
esac

# ── Marcador para identificar bloco COLMEIA ─────────────────
MARKER_START="# >>> COLMEIA aliases >>>"
MARKER_END="# <<< COLMEIA aliases <<<"

ALIASES_BLOCK="$MARKER_START
# Claude Code com permissoes completas (sem confirmacoes)
# AVISO: Desativa TODAS as confirmacoes de seguranca
alias claude-full='claude --dangerously-skip-permissions'
alias claude-full-continue='claude --dangerously-skip-permissions --continue'
$MARKER_END"

# ── Verificar se aliases ja existem ─────────────────────────
if [ -f "$SHELL_RC" ] && grep -q "$MARKER_START" "$SHELL_RC"; then
  # Remover bloco antigo e substituir
  # Usa sed para remover do marcador inicio ate o fim
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "/$MARKER_START/,/$MARKER_END/d" "$SHELL_RC"
  else
    sed -i "/$MARKER_START/,/$MARKER_END/d" "$SHELL_RC"
  fi
  echo -e "  ${GREEN}~${NC} Aliases atualizados em $SHELL_RC"
else
  echo -e "  ${GREEN}+${NC} Aliases adicionados em $SHELL_RC"
fi

# Adicionar bloco
echo "" >> "$SHELL_RC"
echo "$ALIASES_BLOCK" >> "$SHELL_RC"

echo ""
echo "============================================"
echo -e "${GREEN}Aliases configurados!${NC}"
echo ""
echo -e "  Comandos disponiveis (apos recarregar o shell):"
echo ""
echo -e "  ${BLUE}claude-full${NC}"
echo -e "    Inicia nova sessao com permissoes completas"
echo -e "    Equivale a: claude --dangerously-skip-permissions"
echo ""
echo -e "  ${BLUE}claude-full-continue${NC}"
echo -e "    Continua a ultima sessao com permissoes completas"
echo -e "    Equivale a: claude --dangerously-skip-permissions --continue"
echo ""
echo -e "${YELLOW}AVISO: Estes comandos desativam TODAS as confirmacoes.${NC}"
echo -e "${YELLOW}O Claude pode executar qualquer acao sem pedir aprovacao.${NC}"
echo -e "${YELLOW}Use com cuidado em repositorios importantes.${NC}"
echo ""
echo -e "Para ativar agora: ${GREEN}source $SHELL_RC${NC}"
echo ""
