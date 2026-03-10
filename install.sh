#!/bin/bash

# ============================================================
# COLMEIA — Adaptive Agent Installer
# ============================================================
# Le project.yaml e instala agentes + gera CLAUDE.md adaptado
# ============================================================

set -e

COLMEIA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
PROJECT_YAML="$COLMEIA_DIR/project.yaml"
BASE_MD="$COLMEIA_DIR/base/CLAUDE-base.md"
GENERATED_DIR="$COLMEIA_DIR/generated"
GENERATED_MD="$GENERATED_DIR/CLAUDE.md"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# ── Flags ───────────────────────────────────────────────────
DRY_RUN=false
CLEAN=false
PROJECT_LOCAL=false

for arg in "$@"; do
  case $arg in
    --dry-run)  DRY_RUN=true ;;
    --clean)    CLEAN=true ;;
    --project)  PROJECT_LOCAL=true ;;
    --help|-h)
      echo "Uso: ./install.sh [opcoes]"
      echo ""
      echo "Opcoes:"
      echo "  --dry-run   Mostra o que seria instalado sem fazer alteracoes"
      echo "  --clean     Remove todos os symlinks da COLMEIA"
      echo "  --project   Instala em .claude/ local ao inves de ~/.claude/"
      echo "  --help      Mostra esta ajuda"
      exit 0
      ;;
  esac
done

if $PROJECT_LOCAL; then
  CLAUDE_DIR=".claude"
  AGENTS_DIR="$CLAUDE_DIR/agents"
fi

# ── Clean mode ──────────────────────────────────────────────
if $CLEAN; then
  echo ""
  echo -e "${BLUE}COLMEIA — Limpeza${NC}"
  echo "============================================"
  echo ""

  removed=0
  if [ -d "$AGENTS_DIR" ]; then
    for link in "$AGENTS_DIR"/*.md; do
      [ -L "$link" ] || continue
      target=$(readlink "$link")
      if [[ "$target" == *"$COLMEIA_DIR"* ]]; then
        if $DRY_RUN; then
          echo -e "  ${YELLOW}[dry-run]${NC} Removeria $(basename "$link")"
        else
          rm "$link"
          echo -e "  ${RED}x${NC} $(basename "$link")"
        fi
        removed=$((removed + 1))
      fi
    done
  fi

  claude_md_target="$CLAUDE_DIR/CLAUDE.md"
  if [ -L "$claude_md_target" ]; then
    target=$(readlink "$claude_md_target")
    if [[ "$target" == *"$COLMEIA_DIR"* ]] || [[ "$target" == *"generated"* ]]; then
      if $DRY_RUN; then
        echo -e "  ${YELLOW}[dry-run]${NC} Removeria CLAUDE.md"
      else
        rm "$claude_md_target"
        echo -e "  ${RED}x${NC} CLAUDE.md"
      fi
      removed=$((removed + 1))
    fi
  fi

  echo ""
  echo -e "${GREEN}$removed items removidos.${NC}"
  echo ""
  exit 0
fi

# ── Banner ──────────────────────────────────────────────────
echo ""
echo -e "${BLUE}COLMEIA — Adaptive Agent Installer${NC}"
echo "============================================"
echo ""

# ── Verificar project.yaml ──────────────────────────────────
if [ ! -f "$PROJECT_YAML" ]; then
  echo -e "${RED}Erro: project.yaml nao encontrado.${NC}"
  echo ""
  echo "Crie um project.yaml ou copie um exemplo:"
  echo "  cp examples/project-ideva.yaml project.yaml"
  echo "  cp examples/project-nextjs-supabase.yaml project.yaml"
  echo "  cp examples/project-python-django.yaml project.yaml"
  echo ""
  exit 1
fi

# ── Parser YAML simples (sem dependencia externa) ───────────
# Funcoes utilitarias para ler YAML plano
yaml_get() {
  local file="$1"
  local key="$2"
  grep -E "^\s*${key}:" "$file" 2>/dev/null | head -1 | sed "s/.*${key}:\s*//" | sed 's/^"//' | sed 's/"$//' | sed "s/^'//" | sed "s/'$//" | sed 's/\s*#.*//' | xargs
}

yaml_get_list() {
  local file="$1"
  local key="$2"
  local in_section=false
  local items=()

  while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*${key}: ]]; then
      in_section=true
      continue
    fi
    if $in_section; then
      if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+(.*) ]]; then
        local item="${BASH_REMATCH[1]}"
        item=$(echo "$item" | sed 's/\s*#.*//' | xargs)
        if [ -n "$item" ]; then
          items+=("$item")
        fi
      elif [[ "$line" =~ ^[[:space:]]*[a-zA-Z] ]] && [[ ! "$line" =~ ^[[:space:]]*- ]]; then
        break
      fi
    fi
  done < "$file"

  echo "${items[@]}"
}

yaml_get_multiline() {
  local file="$1"
  local key="$2"
  local in_section=false
  local indent=""
  local content=""

  while IFS= read -r line; do
    if [[ "$line" =~ ^([[:space:]]*)${key}:[[:space:]]*\|[[:space:]]*$ ]]; then
      in_section=true
      indent="${BASH_REMATCH[1]}  "
      continue
    fi
    if $in_section; then
      if [[ "$line" =~ ^${indent} ]] || [ -z "$line" ]; then
        local stripped="${line#$indent}"
        content+="${stripped}"$'\n'
      elif [ -n "$line" ] && [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
        break
      fi
    fi
  done < "$file"

  echo "$content"
}

yaml_get_map() {
  local file="$1"
  local section="$2"
  local in_section=false
  local results=()

  while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*${section}: ]]; then
      in_section=true
      continue
    fi
    if $in_section; then
      if [[ "$line" =~ ^[[:space:]]+([a-zA-Z_]+):[[:space:]]+[\"\']?([^\"\'#]+) ]]; then
        local k="${BASH_REMATCH[1]}"
        local v="${BASH_REMATCH[2]}"
        v=$(echo "$v" | sed "s/[\"']//g" | xargs)
        if [ -n "$v" ]; then
          results+=("$k=$v")
        fi
      elif [[ "$line" =~ ^[[:space:]]*[a-zA-Z] ]] && [[ ! "$line" =~ ^[[:space:]]{4,} ]]; then
        break
      fi
    fi
  done < "$file"

  echo "${results[@]}"
}

# ── Ler project.yaml ────────────────────────────────────────
PROJECT_NAME=$(yaml_get "$PROJECT_YAML" "name")
PROJECT_DESC=$(yaml_get "$PROJECT_YAML" "description")

if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME="Projeto"
fi

echo -e "  Projeto: ${GREEN}${PROJECT_NAME}${NC}"
[ -n "$PROJECT_DESC" ] && echo -e "  Descricao: ${PROJECT_DESC}"
echo ""

# ── Ler stacks selecionadas ─────────────────────────────────
echo -e "${BLUE}Stacks selecionadas:${NC}"

STACK_SECTIONS=""
STACK_CONSTRAINTS=""
STACK_COMMANDS=""

for pair in $(yaml_get_map "$PROJECT_YAML" "stacks"); do
  category="${pair%%=*}"
  choice="${pair#*=}"

  stack_file="$COLMEIA_DIR/stacks/$category/$choice.yaml"

  if [ -f "$stack_file" ]; then
    stack_name=$(yaml_get "$stack_file" "name")
    echo -e "  ${GREEN}+${NC} $category: $stack_name"

    context=$(yaml_get_multiline "$stack_file" "context")
    if [ -n "$context" ]; then
      STACK_SECTIONS+="$context"$'\n'
    fi

    constraints=$(yaml_get_multiline "$stack_file" "constraints")
    if [ -n "$constraints" ]; then
      STACK_CONSTRAINTS+="$constraints"$'\n'
    fi

    for cmd_pair in $(yaml_get_map "$stack_file" "commands"); do
      cmd_key="${cmd_pair%%=*}"
      cmd_val="${cmd_pair#*=}"
      STACK_COMMANDS+="$cmd_key: $cmd_val"$'\n'
    done
  else
    echo -e "  ${YELLOW}?${NC} $category: $choice (stack file nao encontrado)"
  fi
done

echo ""

# ── Ler convencoes do project.yaml ──────────────────────────
CONVENTIONS=""
for conv_pair in $(yaml_get_map "$PROJECT_YAML" "conventions"); do
  conv_key="${conv_pair%%=*}"
  conv_val="${conv_pair#*=}"
  CONVENTIONS+="- $conv_key: \`$conv_val\`"$'\n'
done

# ── Ler comandos do project.yaml ────────────────────────────
PROJECT_COMMANDS=""
for cmd_pair in $(yaml_get_map "$PROJECT_YAML" "commands"); do
  cmd_key="${cmd_pair%%=*}"
  cmd_val="${cmd_pair#*=}"
  PROJECT_COMMANDS+="$cmd_key: $cmd_val"$'\n'
done

# Merge: project commands sobrescrevem stack commands
if [ -n "$PROJECT_COMMANDS" ]; then
  FINAL_COMMANDS="$PROJECT_COMMANDS"
else
  FINAL_COMMANDS="$STACK_COMMANDS"
fi

# ── Gerar CLAUDE.md ─────────────────────────────────────────
echo -e "${BLUE}Gerando CLAUDE.md...${NC}"

if ! $DRY_RUN; then
  mkdir -p "$GENERATED_DIR"

  if [ ! -f "$BASE_MD" ]; then
    echo -e "${RED}Erro: base/CLAUDE-base.md nao encontrado.${NC}"
    exit 1
  fi

  cp "$BASE_MD" "$GENERATED_MD"

  # Substituir placeholders
  {
    sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/" "$GENERATED_MD"
  } 2>/dev/null || {
    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/" "$GENERATED_MD"
  }

  # Substituir {{STACK_SECTIONS}}
  STACK_SECTIONS_ESCAPED=$(echo "$STACK_SECTIONS" | sed 's/[&/\]/\\&/g' | sed ':a;N;$!ba;s/\n/\\n/g')
  {
    sed -i '' "s|{{STACK_SECTIONS}}|${STACK_SECTIONS_ESCAPED}|" "$GENERATED_MD"
  } 2>/dev/null || {
    sed -i "s|{{STACK_SECTIONS}}|${STACK_SECTIONS_ESCAPED}|" "$GENERATED_MD"
  }

  # Substituir {{CONSTRAINTS}}
  CONSTRAINTS_ESCAPED=$(echo "$STACK_CONSTRAINTS" | sed 's/[&/\]/\\&/g' | sed ':a;N;$!ba;s/\n/\\n/g')
  {
    sed -i '' "s|{{CONSTRAINTS}}|${CONSTRAINTS_ESCAPED}|" "$GENERATED_MD"
  } 2>/dev/null || {
    sed -i "s|{{CONSTRAINTS}}|${CONSTRAINTS_ESCAPED}|" "$GENERATED_MD"
  }

  # Substituir {{CONVENTIONS}}
  CONVENTIONS_ESCAPED=$(echo "$CONVENTIONS" | sed 's/[&/\]/\\&/g' | sed ':a;N;$!ba;s/\n/\\n/g')
  {
    sed -i '' "s|{{CONVENTIONS}}|${CONVENTIONS_ESCAPED}|" "$GENERATED_MD"
  } 2>/dev/null || {
    sed -i "s|{{CONVENTIONS}}|${CONVENTIONS_ESCAPED}|" "$GENERATED_MD"
  }

  # Substituir {{COMMANDS}}
  COMMANDS_ESCAPED=$(echo "$FINAL_COMMANDS" | sed 's/[&/\]/\\&/g' | sed ':a;N;$!ba;s/\n/\\n/g')
  {
    sed -i '' "s|{{COMMANDS}}|${COMMANDS_ESCAPED}|" "$GENERATED_MD"
  } 2>/dev/null || {
    sed -i "s|{{COMMANDS}}|${COMMANDS_ESCAPED}|" "$GENERATED_MD"
  }

  echo -e "  ${GREEN}+${NC} CLAUDE.md gerado em generated/CLAUDE.md"
fi

echo ""

# ── Instalar CLAUDE.md ──────────────────────────────────────
echo -e "${BLUE}Instalando CLAUDE.md...${NC}"

CLAUDE_MD_TARGET="$CLAUDE_DIR/CLAUDE.md"

if ! $DRY_RUN; then
  mkdir -p "$CLAUDE_DIR"

  if [ -f "$CLAUDE_MD_TARGET" ] && [ ! -L "$CLAUDE_MD_TARGET" ]; then
    echo -e "${YELLOW}  CLAUDE.md existente encontrado (nao e symlink).${NC}"
    echo -n "  Fazer backup e substituir? [s/N] "
    read -r resp
    if [[ "$resp" =~ ^[sS]$ ]]; then
      cp "$CLAUDE_MD_TARGET" "$CLAUDE_MD_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
      echo -e "${GREEN}  Backup salvo.${NC}"
    else
      echo -e "${YELLOW}  CLAUDE.md mantido. Voce pode mesclar manualmente.${NC}"
      echo ""
    fi
  fi

  cp "$GENERATED_MD" "$CLAUDE_MD_TARGET"
  echo -e "  ${GREEN}+${NC} CLAUDE.md instalado em $CLAUDE_DIR/CLAUDE.md"
else
  echo -e "  ${YELLOW}[dry-run]${NC} Instalaria CLAUDE.md em $CLAUDE_DIR/CLAUDE.md"
fi

echo ""

# ── Instalar agentes ────────────────────────────────────────
echo -e "${BLUE}Instalando agentes...${NC}"
echo ""

if ! $DRY_RUN; then
  mkdir -p "$AGENTS_DIR"
fi

INSTALLED=0
UPDATED=0
SKIPPED=0

install_agent() {
  local agent_file="$1"
  local agent_name
  agent_name=$(basename "$agent_file")
  local target="$AGENTS_DIR/$agent_name"

  if $DRY_RUN; then
    echo -e "  ${YELLOW}[dry-run]${NC} $agent_name"
    INSTALLED=$((INSTALLED + 1))
    return
  fi

  if [ -L "$target" ]; then
    ln -sf "$agent_file" "$target"
    echo -e "  ${GREEN}~${NC} $agent_name"
    UPDATED=$((UPDATED + 1))
  elif [ -f "$target" ]; then
    echo -e "  ${YELLOW}!${NC} $agent_name (arquivo manual — pulando)"
    SKIPPED=$((SKIPPED + 1))
  else
    ln -sf "$agent_file" "$target"
    echo -e "  ${GREEN}+${NC} $agent_name"
    INSTALLED=$((INSTALLED + 1))
  fi
}

# Sempre instalar core
echo -e "  ${BLUE}[core]${NC}"
for agent_file in "$COLMEIA_DIR/agents/core"/*.md; do
  [ -f "$agent_file" ] || continue
  install_agent "$agent_file"
done

# Ler categorias opcionais habilitadas
OPTIONAL_CATEGORIES=$(yaml_get_list "$PROJECT_YAML" "optional")

for category in $OPTIONAL_CATEGORIES; do
  category_dir="$COLMEIA_DIR/agents/$category"
  if [ -d "$category_dir" ]; then
    echo -e "  ${BLUE}[$category]${NC}"
    for agent_file in "$category_dir"/*.md; do
      [ -f "$agent_file" ] || continue
      install_agent "$agent_file"
    done
  else
    echo -e "  ${YELLOW}?${NC} [$category] (diretorio nao encontrado)"
  fi
done

# Ler agentes desabilitados e remover symlinks se existirem
DISABLED_AGENTS=$(yaml_get_list "$PROJECT_YAML" "disabled")
for disabled in $DISABLED_AGENTS; do
  target="$AGENTS_DIR/${disabled}.md"
  if [ -L "$target" ]; then
    if ! $DRY_RUN; then
      rm "$target"
    fi
    echo -e "  ${RED}x${NC} ${disabled}.md (desabilitado)"
  fi
done

echo ""
echo "============================================"
echo -e "${GREEN}COLMEIA instalado com sucesso!${NC}"
echo ""
echo -e "  Projeto:    ${GREEN}${PROJECT_NAME}${NC}"
echo -e "  Agentes em: ${BLUE}$AGENTS_DIR/${NC}"
echo -e "  CLAUDE.md:  ${BLUE}$CLAUDE_DIR/CLAUDE.md${NC}"
echo ""

# ── Verificar instalacao ────────────────────────────────────
if [ -d "$AGENTS_DIR" ]; then
  AGENT_COUNT=$(find "$AGENTS_DIR" -name "*.md" -type l 2>/dev/null | wc -l | tr -d ' ')
  echo -e "  ${AGENT_COUNT} agentes disponiveis no Claude Code."
fi

echo ""
echo -e "Para atualizar: ${YELLOW}cd $(basename "$COLMEIA_DIR") && git pull && ./install.sh${NC}"
echo ""
