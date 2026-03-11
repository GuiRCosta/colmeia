#!/bin/bash

# ============================================================
# COLMEIA — Adaptive Agent Installer
# ============================================================
# Le project.yaml e instala agentes + gera CLAUDE.md adaptado
# ============================================================

set -e

COLMEIA_VERSION="1.1.0"
COLMEIA_REPO="https://github.com/GuiRCosta/colmeia.git"
COLMEIA_HOME="$HOME/.colmeia"

COLMEIA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd 2>/dev/null || echo "")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# ── Bootstrap remoto (curl one-liner) ────────────────────────
is_valid_repo() {
  [ -d "$1/agents" ] && [ -d "$1/stacks" ] && [ -f "$1/base/CLAUDE-base.md" ]
}

if [ -z "$COLMEIA_DIR" ] || ! is_valid_repo "$COLMEIA_DIR"; then
  echo ""
  echo -e "${BLUE}COLMEIA — Remote Bootstrap${NC}"
  echo "============================================"
  echo ""

  if [ -d "$COLMEIA_HOME" ] && is_valid_repo "$COLMEIA_HOME"; then
    echo -e "  ${GREEN}+${NC} Usando instalacao existente em $COLMEIA_HOME"
    COLMEIA_DIR="$COLMEIA_HOME"
  else
    echo -e "  Clonando repositorio para $COLMEIA_HOME..."
    if command -v git >/dev/null 2>&1; then
      if git clone --depth 1 "$COLMEIA_REPO" "$COLMEIA_HOME" 2>&1; then
        echo -e "  ${GREEN}+${NC} Repositorio clonado"
        COLMEIA_DIR="$COLMEIA_HOME"
      else
        echo -e "${RED}Erro: falha ao clonar repositorio.${NC}"
        exit 1
      fi
    else
      echo -e "${RED}Erro: git nao encontrado. Instale git e tente novamente.${NC}"
      exit 1
    fi
  fi
  echo ""
fi

# ── Paths derivados ──────────────────────────────────────────
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
PROJECT_YAML="$COLMEIA_DIR/project.yaml"
BASE_MD="$COLMEIA_DIR/base/CLAUDE-base.md"
GENERATED_DIR="$COLMEIA_DIR/generated"
GENERATED_MD="$GENERATED_DIR/CLAUDE.md"

# ── Flags ───────────────────────────────────────────────────
DRY_RUN=false
CLEAN=false
PROJECT_LOCAL=false
INIT=false
STATUS=false
HEALTH=false
UPDATE=false
TARGET="claude"

ORIGINAL_ARGS=("$@")

while [ $# -gt 0 ]; do
  case $1 in
    --dry-run)  DRY_RUN=true ;;
    --clean)    CLEAN=true ;;
    --project)  PROJECT_LOCAL=true ;;
    --init)     INIT=true ;;
    --status)   STATUS=true ;;
    --health)   HEALTH=true ;;
    --update)   UPDATE=true ;;
    --target)
      shift
      if [ -z "$1" ] || [[ "$1" == --* ]]; then
        echo -e "${RED}Erro: --target requer um valor (claude, cursor, codex)${NC}"
        exit 1
      fi
      TARGET="$1"
      ;;
    --target=*) TARGET="${1#*=}" ;;
    --version|-v) echo "COLMEIA v${COLMEIA_VERSION}"; exit 0 ;;
    --help|-h)
      echo "Uso: ./install.sh [opcoes]"
      echo ""
      echo "Opcoes:"
      echo "  --init            Wizard interativo — gera project.yaml e instala"
      echo "  --dry-run         Mostra o que seria instalado sem fazer alteracoes"
      echo "  --clean           Remove todos os symlinks da COLMEIA"
      echo "  --project         Instala em .claude/ local ao inves de ~/.claude/"
      echo "  --status          Mostra status da instalacao atual"
      echo "  --health          Verifica integridade da instalacao (exit 1 se falhou)"
      echo "  --update          Atualiza COLMEIA (git pull + reinstala)"
      echo "  --target <ide>    Instala para IDE especifica (claude, cursor, codex)"
      echo "  --help            Mostra esta ajuda"
      echo ""
      echo "Instalacao remota:"
      echo "  curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init"
      exit 0
      ;;
  esac
  shift
done

# ── Resolver paths do target IDE ─────────────────────────────
resolve_target_paths() {
  case "$TARGET" in
    claude)
      # Default — nao muda nada
      ;;
    cursor)
      # Projeto-local: Cursor usa paths relativos ao projeto
      CLAUDE_DIR=".cursor"
      AGENTS_DIR=".cursor/agents"
      ;;
    codex)
      # Projeto-local: Codex usa paths relativos ao projeto
      CLAUDE_DIR=".codex"
      AGENTS_DIR=".codex/agents"
      ;;
    *)
      echo -e "${RED}Erro: target desconhecido '$TARGET'.${NC}"
      echo "Targets disponiveis: claude, cursor, codex"
      exit 1
      ;;
  esac
}

if [ "$TARGET" != "claude" ]; then
  resolve_target_paths
fi

if $PROJECT_LOCAL && [ "$TARGET" = "claude" ]; then
  CLAUDE_DIR=".claude"
  AGENTS_DIR="$CLAUDE_DIR/agents"
fi

# ── Parser YAML simples (sem dependencia externa) ───────────
yaml_get() {
  local file="$1"
  local key="$2"
  grep -E "^[[:space:]]*${key}:" "$file" 2>/dev/null | head -1 | sed "s/.*${key}:[[:space:]]*//" | sed 's/^["\x27]//;s/["\x27]$//' | sed 's/[[:space:]]*#.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
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
        item=$(echo "$item" | sed 's/[[:space:]]*#.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
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
        v=$(echo "$v" | sed "s/[\"']//g" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
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
      if [[ "$target" == *"$COLMEIA_DIR"* ]] || [[ "$target" == *"colmeia"* ]]; then
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

# ── Status mode ──────────────────────────────────────────────
if $STATUS; then
  echo ""
  echo -e "${BLUE}COLMEIA — Status${NC}"
  echo "============================================"
  echo ""

  # Versao
  COLMEIA_COMMIT="unknown"
  if [ -d "$COLMEIA_DIR/.git" ]; then
    COLMEIA_COMMIT=$(git -C "$COLMEIA_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  fi
  echo -e "  Versao:     ${GREEN}v${COLMEIA_VERSION}${NC} (commit ${COLMEIA_COMMIT})"
  echo -e "  Repo:       ${BLUE}${COLMEIA_DIR}${NC}"
  echo -e "  Target:     ${BLUE}${TARGET}${NC}"

  # Projeto
  if [ -f "$PROJECT_YAML" ]; then
    STATUS_NAME=$(yaml_get "$PROJECT_YAML" "name")
    STATUS_DESC=$(yaml_get "$PROJECT_YAML" "description")
    echo -e "  Projeto:    ${GREEN}${STATUS_NAME:-desconhecido}${NC}"
    [ -n "$STATUS_DESC" ] && echo -e "  Descricao:  ${STATUS_DESC}"
  else
    echo -e "  Projeto:    ${YELLOW}project.yaml nao encontrado${NC}"
  fi

  # CLAUDE.md
  CLAUDE_MD_TARGET="$CLAUDE_DIR/CLAUDE.md"
  if [ -f "$CLAUDE_MD_TARGET" ]; then
    if [ -L "$CLAUDE_MD_TARGET" ]; then
      echo -e "  CLAUDE.md:  ${GREEN}$CLAUDE_MD_TARGET${NC} (symlink OK)"
    else
      echo -e "  CLAUDE.md:  ${GREEN}$CLAUDE_MD_TARGET${NC} (arquivo direto)"
    fi
  else
    echo -e "  CLAUDE.md:  ${RED}nao encontrado${NC}"
  fi

  echo ""

  # Stacks ativas
  if [ -f "$PROJECT_YAML" ]; then
    echo -e "${BLUE}Stacks ativas:${NC}"
    stack_count=0
    for pair in $(yaml_get_map "$PROJECT_YAML" "stacks"); do
      category="${pair%%=*}"
      choice="${pair#*=}"
      stack_file="$COLMEIA_DIR/stacks/$category/$choice.yaml"
      if [ -f "$stack_file" ]; then
        stack_name=$(yaml_get "$stack_file" "name")
        echo -e "  ${GREEN}+${NC} $category: $stack_name"
      else
        echo -e "  ${RED}?${NC} $category: $choice (nao encontrado)"
      fi
      stack_count=$((stack_count + 1))
    done
    if [ "$stack_count" -eq 0 ]; then
      echo -e "  ${YELLOW}Nenhuma stack configurada${NC}"
    fi
    echo ""
  fi

  # Agentes instalados
  echo -e "${BLUE}Agentes instalados:${NC}"
  if [ -d "$AGENTS_DIR" ]; then
    total=0
    for agent_link in "$AGENTS_DIR"/*.md; do
      [ -e "$agent_link" ] || continue
      if [ -L "$agent_link" ]; then
        agent_target=$(readlink "$agent_link")
        if [[ "$agent_target" == *"colmeia"* ]] || [[ "$agent_target" == *"$COLMEIA_DIR"* ]]; then
          agent_cat=$(echo "$agent_target" | grep -oE 'agents/[^/]+' | sed 's|agents/||')
          agent_name=$(basename "$agent_link" .md)
          echo -e "  ${GREEN}+${NC} [$agent_cat] $agent_name"
          total=$((total + 1))
        fi
      fi
    done
    echo ""
    echo -e "  Total: ${GREEN}${total}${NC} agentes COLMEIA"
  else
    echo -e "  ${YELLOW}Diretorio de agentes nao encontrado${NC}"
  fi

  # Desabilitados
  if [ -f "$PROJECT_YAML" ]; then
    DISABLED_AGENTS=$(yaml_get_list "$PROJECT_YAML" "disabled")
    if [ -n "$DISABLED_AGENTS" ]; then
      echo ""
      echo -e "${BLUE}Desabilitados:${NC}"
      for disabled in $DISABLED_AGENTS; do
        echo -e "  ${RED}x${NC} $disabled"
      done
    fi
  fi

  echo ""
  exit 0
fi

# ── Health check mode ────────────────────────────────────────
if $HEALTH; then
  echo ""
  echo -e "${BLUE}COLMEIA — Health Check${NC}"
  echo "============================================"
  echo ""

  HEALTH_PASS=0
  HEALTH_FAIL=0

  health_check() {
    local description="$1"
    local result="$2"
    local detail="$3"

    if [ "$result" -eq 0 ]; then
      echo -e "  ${GREEN}PASS${NC} $description"
      [ -n "$detail" ] && echo -e "       $detail"
      HEALTH_PASS=$((HEALTH_PASS + 1))
    else
      echo -e "  ${RED}FAIL${NC} $description"
      [ -n "$detail" ] && echo -e "       $detail"
      HEALTH_FAIL=$((HEALTH_FAIL + 1))
    fi
  }

  # Check 1: Repositorio COLMEIA valido
  if is_valid_repo "$COLMEIA_DIR"; then
    health_check "Repositorio COLMEIA" 0 "$COLMEIA_DIR"
  else
    health_check "Repositorio COLMEIA" 1 "Diretorio invalido: $COLMEIA_DIR"
  fi

  # Check 2: project.yaml existe
  if [ -f "$PROJECT_YAML" ]; then
    health_check "project.yaml" 0 "$PROJECT_YAML"
  else
    health_check "project.yaml" 1 "Nao encontrado. Use --init para criar."
  fi

  # Check 3: CLAUDE.md existe
  CLAUDE_MD_TARGET="$CLAUDE_DIR/CLAUDE.md"
  if [ -f "$CLAUDE_MD_TARGET" ]; then
    health_check "CLAUDE.md" 0 "$CLAUDE_MD_TARGET"
  else
    health_check "CLAUDE.md" 1 "Nao encontrado em $CLAUDE_MD_TARGET"
  fi

  # Check 4: Diretorio de agentes existe
  if [ -d "$AGENTS_DIR" ]; then
    health_check "Diretorio de agentes" 0 "$AGENTS_DIR"
  else
    health_check "Diretorio de agentes" 1 "$AGENTS_DIR nao existe"
  fi

  # Check 5: Symlinks validos (nenhum quebrado)
  BROKEN_LINKS=0
  if [ -d "$AGENTS_DIR" ]; then
    for link in "$AGENTS_DIR"/*.md; do
      [ -L "$link" ] || continue
      if [ ! -e "$link" ]; then
        BROKEN_LINKS=$((BROKEN_LINKS + 1))
        echo -e "    ${RED}!${NC} Quebrado: $(basename "$link") -> $(readlink "$link")"
      fi
    done
  fi
  if [ "$BROKEN_LINKS" -eq 0 ]; then
    health_check "Symlinks de agentes" 0 "Nenhum symlink quebrado"
  else
    health_check "Symlinks de agentes" 1 "$BROKEN_LINKS symlink(s) quebrado(s)"
  fi

  # Check 6: Template base existe
  if [ -f "$BASE_MD" ]; then
    health_check "Template base (CLAUDE-base.md)" 0
  else
    health_check "Template base (CLAUDE-base.md)" 1 "Nao encontrado em $BASE_MD"
  fi

  # Check 7: Stacks referenciadas existem
  if [ -f "$PROJECT_YAML" ]; then
    MISSING_STACKS=0
    for pair in $(yaml_get_map "$PROJECT_YAML" "stacks"); do
      category="${pair%%=*}"
      choice="${pair#*=}"
      stack_file="$COLMEIA_DIR/stacks/$category/$choice.yaml"
      if [ ! -f "$stack_file" ]; then
        MISSING_STACKS=$((MISSING_STACKS + 1))
        echo -e "    ${RED}!${NC} Stack ausente: $category/$choice"
      fi
    done
    if [ "$MISSING_STACKS" -eq 0 ]; then
      health_check "Arquivos de stack" 0 "Todas as stacks referenciadas existem"
    else
      health_check "Arquivos de stack" 1 "$MISSING_STACKS stack(s) nao encontrada(s)"
    fi
  fi

  # Resumo
  echo ""
  HEALTH_TOTAL=$((HEALTH_PASS + HEALTH_FAIL))
  if [ "$HEALTH_FAIL" -eq 0 ]; then
    echo -e "${GREEN}Health check: ALL OK ($HEALTH_PASS/$HEALTH_TOTAL checks passed)${NC}"
    echo ""
    exit 0
  else
    echo -e "${RED}Health check: $HEALTH_FAIL FAILED ($HEALTH_PASS/$HEALTH_TOTAL passed)${NC}"
    echo ""
    exit 1
  fi
fi

# ── Update mode ──────────────────────────────────────────────
if $UPDATE; then
  echo ""
  echo -e "${BLUE}COLMEIA — Update${NC}"
  echo "============================================"
  echo ""

  if [ ! -d "$COLMEIA_DIR/.git" ]; then
    echo -e "${RED}Erro: $COLMEIA_DIR nao e um repositorio git.${NC}"
    echo "  Update so funciona com instalacao via git clone."
    exit 1
  fi

  echo -e "  Atualizando repositorio..."
  CURRENT_BRANCH=$(git -C "$COLMEIA_DIR" branch --show-current 2>/dev/null || echo "main")
  if git -C "$COLMEIA_DIR" pull origin "${CURRENT_BRANCH}" 2>&1; then
    echo -e "  ${GREEN}+${NC} Repositorio atualizado"
  else
    echo -e "${RED}Erro: falha ao atualizar. Verifique conexao e conflitos.${NC}"
    exit 1
  fi

  echo ""
  echo -e "  Reinstalando..."
  echo ""

  # Re-exec install.sh atualizado sem --update (evita loop infinito)
  RERUN_ARGS=()
  for arg in "${ORIGINAL_ARGS[@]}"; do
    [ "$arg" = "--update" ] || RERUN_ARGS+=("$arg")
  done
  exec "$COLMEIA_DIR/install.sh" "${RERUN_ARGS[@]}"
fi

# ── Init mode (wizard interativo) ─────────────────────────
if $INIT; then
  echo ""
  echo -e "${BLUE}COLMEIA — Setup Wizard${NC}"
  echo "============================================"
  echo ""

  if [ -f "$PROJECT_YAML" ]; then
    echo -e "${YELLOW}project.yaml ja existe.${NC}"
    echo -n "Sobrescrever? [s/N] "
    read -r resp
    if [[ ! "$resp" =~ ^[sS]$ ]]; then
      echo -e "${YELLOW}Cancelado. Executando instalacao com project.yaml existente.${NC}"
      echo ""
      INIT=false
    fi
  fi
fi

if $INIT; then
  # ── Funcao de selecao numerada ────────────────────────────
  pick_option() {
    local prompt="$1"
    shift
    local options=("$@")
    local count=${#options[@]}

    echo -e "  ${BLUE}${prompt}${NC}"
    for i in "${!options[@]}"; do
      echo -e "    $((i + 1))) ${options[$i]}"
    done
    echo -e "    0) nenhum"
    echo -n "  > "
    read -r choice

    if [[ "$choice" == "0" ]] || [[ -z "$choice" ]]; then
      echo ""
      return 1
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ]; then
      PICKED="${options[$((choice - 1))]}"
      return 0
    fi

    echo -e "  ${YELLOW}Opcao invalida, pulando.${NC}"
    return 1
  }

  pick_yes_no() {
    local prompt="$1"
    local default="$2"
    echo -n "  $prompt "
    if [[ "$default" == "s" ]]; then
      echo -n "[S/n] "
    else
      echo -n "[s/N] "
    fi
    read -r resp
    if [[ "$default" == "s" ]]; then
      [[ ! "$resp" =~ ^[nN]$ ]]
    else
      [[ "$resp" =~ ^[sS]$ ]]
    fi
  }

  # ── Projeto ──────────────────────────────────────────────
  echo -e "${BLUE}1. Projeto${NC}"
  echo ""
  echo -n "  Nome do projeto: "
  read -r INIT_NAME
  INIT_NAME=$(printf '%s' "$INIT_NAME" | tr -d '"'"'")
  if [ -z "$INIT_NAME" ]; then
    INIT_NAME="meu-projeto"
  fi

  echo -n "  Descricao (opcional): "
  read -r INIT_DESC
  INIT_DESC=$(printf '%s' "$INIT_DESC" | tr -d '"'"'")
  echo ""

  # ── Stacks ───────────────────────────────────────────────
  echo -e "${BLUE}2. Stacks${NC}"
  echo ""

  INIT_STACKS=""

  for category_dir in "$COLMEIA_DIR"/stacks/*/; do
    [ -d "$category_dir" ] || continue
    category=$(basename "$category_dir")

    stack_options=()
    for stack_file in "$category_dir"*.yaml; do
      [ -f "$stack_file" ] || continue
      stack_choice=$(basename "$stack_file" .yaml)
      stack_label=$(grep -E "^[[:space:]]*name:" "$stack_file" 2>/dev/null | head -1 | sed 's/.*name:[[:space:]]*//' | sed 's/^["\x27]//;s/["\x27]$//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      if [ -n "$stack_label" ]; then
        stack_options+=("$stack_choice ($stack_label)")
      else
        stack_options+=("$stack_choice")
      fi
    done

    if [ ${#stack_options[@]} -eq 0 ]; then
      continue
    fi

    if pick_option "$category:" "${stack_options[@]}"; then
      stack_value="${PICKED%% (*}"
      INIT_STACKS+="  ${category}:$(printf '%*s' $((16 - ${#category})) '')\"${stack_value}\""$'\n'
      echo -e "  ${GREEN}+${NC} $category: $stack_value"
    else
      echo -e "  ${YELLOW}-${NC} $category: pulado"
    fi
    echo ""
  done

  # ── Agentes opcionais ────────────────────────────────────
  echo -e "${BLUE}3. Categorias de agentes opcionais${NC}"
  echo ""

  INIT_OPTIONAL=""
  AGENT_CATEGORIES=("implementation" "devops" "ai-agents" "documentation" "research" "e2e" "meta")
  AGENT_DESCS=(
    "backend, frontend, fullstack, migrations, API design"
    "Docker, CI/CD, monitoring, incident response"
    "design de agentes IA, prompts, MCP"
    "docs, README, changelog"
    "exploracao, bibliotecas, debug, UX"
    "testes end-to-end (Playwright)"
    "orquestrador, otimizador"
  )

  for i in "${!AGENT_CATEGORIES[@]}"; do
    cat="${AGENT_CATEGORIES[$i]}"
    desc="${AGENT_DESCS[$i]}"
    agent_count=$(find "$COLMEIA_DIR/agents/$cat" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    if pick_yes_no "$cat ($agent_count agentes — $desc)?" "s"; then
      INIT_OPTIONAL+="    - $cat"$'\n'
      echo -e "  ${GREEN}+${NC} $cat"
    else
      echo -e "  ${YELLOW}-${NC} $cat"
    fi
  done
  echo ""

  # ── Linguagem principal (para convencoes) ────────────────
  echo -e "${BLUE}4. Convencoes${NC}"
  echo ""

  INIT_CONVENTIONS=""
  LANG_OPTIONS=("JavaScript/TypeScript" "Python")
  if pick_option "Linguagem principal:" "${LANG_OPTIONS[@]}"; then
    lang_pick="${PICKED%% (*}"
    if [[ "$lang_pick" == "JavaScript/TypeScript" ]]; then
      INIT_CONVENTIONS='  files_ts:     "kebab-case.ts"
  classes:      "PascalCase"
  functions:    "camelCase"
  constants:    "UPPER_SNAKE_CASE"
  db_tables:    "snake_case (plural)"
  api_routes:   "/kebab-case (plural)"'
      echo -e "  ${GREEN}+${NC} Convencoes JS/TS (kebab-case, camelCase)"
    else
      INIT_CONVENTIONS='  files_py:     "snake_case.py"
  classes:      "PascalCase"
  functions:    "snake_case"
  constants:    "UPPER_SNAKE_CASE"
  db_tables:    "snake_case (plural)"
  api_routes:   "/kebab-case (plural)"'
      echo -e "  ${GREEN}+${NC} Convencoes Python (snake_case)"
    fi
  else
    INIT_CONVENTIONS='  files:        "kebab-case"
  classes:      "PascalCase"
  functions:    "camelCase"
  constants:    "UPPER_SNAKE_CASE"'
    echo -e "  ${GREEN}+${NC} Convencoes padrao"
  fi
  echo ""

  # ── Comandos ─────────────────────────────────────────────
  echo -e "${BLUE}5. Comandos${NC}"
  echo ""

  INIT_COMMANDS=""
  CMD_KEYS=("dev" "build" "test")
  CMD_DEFAULTS=("npm run dev" "npm run build" "npm test")

  for i in "${!CMD_KEYS[@]}"; do
    key="${CMD_KEYS[$i]}"
    default="${CMD_DEFAULTS[$i]}"
    echo -n "  $key [$default]: "
    read -r cmd_val
    if [ -z "$cmd_val" ]; then
      cmd_val="$default"
    fi
    INIT_COMMANDS+="  ${key}:$(printf '%*s' $((12 - ${#key})) '')\"${cmd_val}\""$'\n'
  done
  echo ""

  # ── Gerar project.yaml ──────────────────────────────────
  echo -e "${BLUE}Gerando project.yaml...${NC}"
  echo ""

  {
    echo "# ============================================================"
    echo "# COLMEIA — ${INIT_NAME} (gerado via --init)"
    echo "# ============================================================"
    echo ""
    echo "project:"
    echo "  name: \"${INIT_NAME}\""
    if [ -n "$INIT_DESC" ]; then
      echo "  description: \"${INIT_DESC}\""
    fi
    echo ""
    echo "stacks:"
    if [ -n "$INIT_STACKS" ]; then
      printf '%s' "$INIT_STACKS"
    else
      echo "  # Nenhuma stack selecionada. Adicione manualmente:"
      echo "  # backend:  \"node-fastify\""
    fi
    echo ""
    echo "agents:"
    echo "  optional:"
    if [ -n "$INIT_OPTIONAL" ]; then
      printf '%s' "$INIT_OPTIONAL"
    else
      echo "    # Nenhuma categoria opcional selecionada"
    fi
    echo "  disabled: []"
    echo ""
    echo "conventions:"
    echo "$INIT_CONVENTIONS"
    echo ""
    echo "commands:"
    printf '%s' "$INIT_COMMANDS"
  } > "$PROJECT_YAML"

  echo -e "  ${GREEN}+${NC} project.yaml gerado"
  echo ""
  echo -e "${GREEN}Setup completo! Continuando com a instalacao...${NC}"
  echo ""
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
  echo "Crie um project.yaml ou use o wizard interativo:"
  echo "  ./install.sh --init"
  echo ""
  echo "Ou copie um exemplo:"
  echo "  cp examples/project-ideva.yaml project.yaml"
  echo "  cp examples/project-nextjs-supabase.yaml project.yaml"
  echo "  cp examples/project-python-django.yaml project.yaml"
  echo ""
  exit 1
fi

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

  # Funcao portavel para substituir placeholder no template (macOS + Linux)
  replace_placeholder() {
    local placeholder="$1"
    local replacement="$2"
    local file="$3"
    awk -v pat="$placeholder" -v rep="$replacement" '{gsub(pat, rep); print}' \
      "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
  }

  replace_placeholder "{{PROJECT_NAME}}" "$PROJECT_NAME" "$GENERATED_MD"
  replace_placeholder "{{STACK_SECTIONS}}" "$STACK_SECTIONS" "$GENERATED_MD"
  replace_placeholder "{{CONSTRAINTS}}" "$STACK_CONSTRAINTS" "$GENERATED_MD"
  replace_placeholder "{{CONVENTIONS}}" "$CONVENTIONS" "$GENERATED_MD"
  replace_placeholder "{{COMMANDS}}" "$FINAL_COMMANDS" "$GENERATED_MD"

  echo -e "  ${GREEN}+${NC} CLAUDE.md gerado em generated/CLAUDE.md"
fi

echo ""

# ── Instalar CLAUDE.md ──────────────────────────────────────
echo -e "${BLUE}Instalando CLAUDE.md...${NC}"

CLAUDE_MD_TARGET="$CLAUDE_DIR/CLAUDE.md"

# Para Cursor: converter para .mdc com frontmatter
install_context_file() {
  local source="$1"
  local target_path="$2"

  case "$TARGET" in
    cursor)
      target_path="$CLAUDE_DIR/rules/colmeia-context.mdc"
      mkdir -p "$(dirname "$target_path")"
      {
        echo "---"
        echo "description: COLMEIA adaptive context for this project"
        echo "globs:"
        echo "alwaysApply: true"
        echo "---"
        echo ""
        cat "$source"
      } > "$target_path"
      echo -e "  ${GREEN}+${NC} Contexto instalado em $target_path (.mdc)"
      ;;
    codex)
      local marker="<!-- COLMEIA START -->"
      local marker_end="<!-- COLMEIA END -->"

      if [ -f "$target_path" ]; then
        # Remover bloco COLMEIA existente
        {
          sed "/$marker/,/$marker_end/d" "$target_path"
        } 2>/dev/null > "${target_path}.tmp" && mv "${target_path}.tmp" "$target_path"
      fi

      {
        [ -f "$target_path" ] && cat "$target_path"
        echo ""
        echo "$marker"
        cat "$source"
        echo "$marker_end"
      } > "${target_path}.new"
      mv "${target_path}.new" "$target_path"
      echo -e "  ${GREEN}+${NC} Contexto instalado em $target_path (AGENTS.md)"
      ;;
    *)
      cp "$source" "$target_path"
      echo -e "  ${GREEN}+${NC} CLAUDE.md instalado em $target_path"
      ;;
  esac
}

if ! $DRY_RUN; then
  mkdir -p "$CLAUDE_DIR"

  if [ "$TARGET" = "claude" ]; then
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
  fi

  install_context_file "$GENERATED_MD" "$CLAUDE_MD_TARGET"
else
  echo -e "  ${YELLOW}[dry-run]${NC} Instalaria contexto em $CLAUDE_MD_TARGET"
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

  case "$TARGET" in
    claude)
      # Symlinks para Claude
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
      ;;
    *)
      # Copia para IDEs que nao resolvem symlinks
      cp "$agent_file" "$target"
      echo -e "  ${GREEN}+${NC} $agent_name (copiado)"
      INSTALLED=$((INSTALLED + 1))
      ;;
  esac
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
  if [ -L "$target" ] || [ -f "$target" ]; then
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
echo -e "  Target:     ${BLUE}${TARGET}${NC}"
echo -e "  Agentes em: ${BLUE}$AGENTS_DIR/${NC}"
echo -e "  Contexto:   ${BLUE}$CLAUDE_DIR/${NC}"
echo ""

# ── Verificar instalacao ────────────────────────────────────
if [ -d "$AGENTS_DIR" ]; then
  AGENT_COUNT=$(find "$AGENTS_DIR" -name "*.md" -type l 2>/dev/null | wc -l | tr -d ' ')
  AGENT_COUNT_FILES=$(find "$AGENTS_DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
  TOTAL_AGENTS=$((AGENT_COUNT + AGENT_COUNT_FILES))
  echo -e "  ${TOTAL_AGENTS} agentes disponiveis."
fi

echo ""
echo -e "Comandos uteis:"
echo -e "  ${YELLOW}./install.sh --status${NC}    Ver status da instalacao"
echo -e "  ${YELLOW}./install.sh --health${NC}    Verificar integridade"
echo -e "  ${YELLOW}./install.sh --update${NC}    Atualizar COLMEIA"
echo ""
