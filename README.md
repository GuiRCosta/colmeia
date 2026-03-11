# COLMEIA — Adaptive Agent Framework for Claude Code

> Framework de agentes especializados para Claude Code que se adapta ao seu projeto.
> Descreva sua ideia e receba agentes, contexto e regras sob medida.

---

## Quick Start

```bash
# 1. Instala a COLMEIA
curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init

# 2. Abra o Claude Code no seu projeto e diga:
> Quero fazer um app de delivery com React e Fastify
```

O agente instalador infere suas stacks, gera a configuracao e instala tudo via conversa.

---

## O que e

COLMEIA e um framework de **subagentes adaptativos para Claude Code** organizados por fase do ciclo de desenvolvimento de software (SDLC). Diferente de repositorios estaticos de agentes, a COLMEIA se **molda ao projeto** via um manifesto `project.yaml`.

**33 agentes | 94 referencias academicas | 7 stacks composiveis**

**Principios:**
- **Adaptativo** — agentes e contexto gerados com base na stack do projeto
- **Modular** — ative apenas as categorias de agentes que precisa
- **Embasado** — arquitetura validada por pesquisa academica (ver [REFERENCES.md](REFERENCES.md))

---

## Como Instalar

Existem **3 caminhos** para configurar a COLMEIA, todos levam ao mesmo resultado: um `project.yaml` + agentes instalados.

```
                    ┌─────────────────────┐
                    │    project.yaml     │
                    │   (fonte da verdade) │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
     ┌────────┴───────┐ ┌─────┴──────┐ ┌───────┴────────┐
     │  Conversa IA   │ │   Preset   │ │  Auto-detect   │
     │  (greenfield)  │ │  (rapido)  │ │ (projeto ja    │
     │                │ │            │ │  existe)        │
     └────────────────┘ └────────────┘ └────────────────┘
```

### Caminho 1: Conversa com o agente (recomendado)

Ideal para projetos novos. Descreva sua ideia e o agente configura tudo:

```bash
# Instale a COLMEIA primeiro
curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init

# Depois, no Claude Code:
> Quero construir um SaaS de controle financeiro com dashboard React,
> API em Node com Fastify, banco PostgreSQL e autenticacao JWT
```

O agente:
1. Infere stacks da sua descricao (React → `react-vite`, Fastify → `node-fastify`, etc.)
2. Recomenda categorias de agentes pela natureza do projeto
3. Apresenta um preview para confirmacao
4. Gera `project.yaml` e instala os agentes

Funciona com qualquer nivel de detalhe — de "quero fazer um marketplace" ate descricoes tecnicas completas.

### Caminho 2: Preset (setup instantaneo)

Para quem quer comecar rapido sem tomar decisoes:

```bash
git clone https://github.com/GuiRCosta/colmeia.git ~/.colmeia
cd ~/.colmeia

# Escolha um preset
cp presets/fullstack-node.yaml project.yaml
# Edite o nome do projeto
./install.sh
```

| Preset | Stacks | Agentes | Ideal para |
|--------|--------|---------|------------|
| `fullstack-node` | backend, frontend, database, cache, infra, auth, ai | 33 (todos) | Projetos completos |
| `saas-react` | backend, frontend, database, cache, auth | 23 | SaaS e produtos web |
| `api-python` | cache, infra | 26 | APIs Python + Docker |
| `minimal` | Nenhuma | 9 (core) | Comecar do zero |

### Caminho 3: Auto-deteccao (projeto existente)

Para projetos que ja tem codigo. O agente escaneia seus arquivos:

```bash
# No Claude Code, dentro do diretorio do projeto:
> Use o agente colmeia-installer para detectar minha stack
```

O agente le `package.json`, `pyproject.toml`, `docker-compose.yml` e mapeia automaticamente:

| Encontra no projeto | Stack sugerida |
|---------------------|----------------|
| `fastify` em dependencies | `backend: "node-fastify"` |
| `react` + `vite` em dependencies | `frontend: "react-vite"` |
| `drizzle-orm` em dependencies | `database: "postgresql-drizzle"` |
| `ioredis` ou `redis` em dependencies | `cache: "redis"` |
| `docker-compose.yml` com `swarm` | `infra: "docker-swarm"` |
| `jsonwebtoken` em dependencies | `auth: "jwt-custom"` |
| `agno` em pyproject.toml | `ai: "agno-python"` |

---

## Diferenciais

A COLMEIA nao e uma colecao de agentes — e um **framework adaptativo com fundamentacao academica**. Comparada aos maiores repositorios de agentes para Claude Code (100-135 agentes), a COLMEIA faz mais com menos:

### 1. Instalacao por conversa

Nenhum outro framework permite configurar agentes descrevendo sua ideia em linguagem natural. Ao inves de editar YAML manualmente ou responder wizards de 15+ perguntas, voce simplesmente diz o que quer construir.

### 2. Fundamentacao por referencia

Cada agente referencia fundamentos especificos do [REFERENCES.md](REFERENCES.md) usando cross-references numeradas. Nenhum outro repositorio de agentes para Claude Code possui sequer uma referencia academica.

```markdown
# Exemplo: dentro de security-reviewer.md
- OWASP ASVS v5.0 — verificacao em 3 niveis (#32)
- Threat Modeling — identificacao de attack surface (#37, #38)
```

94 referencias incluem papers (ACM, ICML, ICLR), livros fundamentais (Clean Code, DDD, DDIA, SRE), padroes (OWASP ASVS, WCAG 2.2, eMAG) e TCCs brasileiros (UFSC, UFMG, UnB, IFRS).

### 3. Arquitetura adaptativa (stack injection)

Repositorios tradicionais criam agentes separados por tecnologia: `react-expert`, `vue-expert`, `angular-expert`... A COLMEIA injeta contexto via stacks:

```
Um unico frontend-engineer + stack react-vite.yaml = contexto React
O mesmo frontend-engineer + stack vue-nuxt.yaml    = contexto Vue
```

Isso substitui ~40-60 agentes tech-specific de outros repos, mantendo o framework enxuto sem perder cobertura.

### 4. Pipeline de qualidade em 5 dimensoes

```
code-reviewer        → Codigo limpo, SOLID, refactoring patterns
security-reviewer    → OWASP ASVS v5.0, threat modeling
a11y-reviewer        → WCAG 2.2 AA, eMAG
performance-profiler → Big-O, profiling, Core Web Vitals
ux-reviewer          → Heuristicas de Nielsen, usabilidade
```

### 5. SRE lifecycle completo

```
monitoring-setup     → SLOs, SLIs, error budgets (prevencao)
incident-responder   → Diagnostico, mitigacao, postmortem (resposta)
ci-cd-designer       → DORA metrics, deploy strategies (evolucao)
```

---

## Estrutura

```
colmeia/
├── project.yaml                     # Manifesto do projeto (gerado por conversa/preset)
├── install.sh                       # Instalador adaptativo
├── base/
│   └── CLAUDE-base.md               # Regras universais (dispatch, modelos)
├── stacks/                          # Configs por stack (composiveis)
│   ├── backend/node-fastify.yaml
│   ├── frontend/react-vite.yaml
│   ├── database/postgresql-drizzle.yaml
│   ├── cache/redis.yaml
│   ├── infra/docker-swarm.yaml
│   ├── auth/jwt-custom.yaml
│   └── ai/agno-python.yaml
├── agents/                          # 33 agentes organizados por categoria
│   ├── core/                        # Sempre instalados (9 agentes)
│   ├── implementation/              # Backend, frontend, fullstack, migrations, API design
│   ├── devops/                      # Docker, CI/CD, monitoring, incident response
│   ├── ai-agents/                   # Agent design, prompts, MCP
│   ├── documentation/               # Docs, README, changelog
│   ├── research/                    # Exploracao, bibliotecas, debug, UX
│   ├── e2e/                         # Testes end-to-end
│   └── meta/                        # Orquestrador, otimizador, instalador
├── presets/                         # Configuracoes pre-definidas
│   ├── fullstack-node.yaml
│   ├── saas-react.yaml
│   ├── api-python.yaml
│   └── minimal.yaml
├── examples/                        # Manifestos de exemplo detalhados
├── TEMPLATE.md                      # Template para criar novos agentes
└── REFERENCES.md                    # 94 referencias academicas
```

---

## project.yaml — O Manifesto

O `project.yaml` e o arquivo central que configura tudo. Voce nao precisa escrever manualmente — o agente gera por voce. Mas se quiser editar:

```yaml
project:
  name: "meu-saas"
  description: "Plataforma SaaS com Node.js"

stacks:
  backend:    "node-fastify"
  frontend:   "react-vite"
  database:   "postgresql-drizzle"
  cache:      "redis"
  auth:       "jwt-custom"

agents:
  optional:
    - implementation
    - devops
    - documentation
    - research
  disabled: []

conventions:
  files_ts:     "kebab-case.ts"
  classes:      "PascalCase"
  functions:    "camelCase"
  constants:    "UPPER_SNAKE_CASE"
  db_tables:    "snake_case (plural)"
  api_routes:   "/kebab-case (plural)"

commands:
  dev:      "npm run dev"
  build:    "npm run build"
  test:     "npm test"
```

### O que acontece ao rodar `./install.sh`:

1. Le `project.yaml`
2. Gera um `CLAUDE.md` combinando regras universais + contexto das stacks selecionadas
3. Instala agentes **core** (sempre) + categorias **opcionais** listadas
4. Copia o CLAUDE.md gerado para `~/.claude/CLAUDE.md`
5. Cria symlinks dos agentes em `~/.claude/agents/`

---

## Stacks Disponiveis

| Categoria | Opcao | Descricao |
|-----------|-------|-----------|
| backend | `node-fastify` | Fastify + Node.js + TypeScript |
| frontend | `react-vite` | React + Vite + TypeScript |
| database | `postgresql-drizzle` | PostgreSQL + Drizzle ORM |
| cache | `redis` | Redis para cache e sessoes |
| infra | `docker-swarm` | Docker Swarm para deploy |
| auth | `jwt-custom` | JWT com implementacao propria |
| ai | `agno-python` | Framework Agno para agentes IA |

### Criando uma nova stack

1. Crie o arquivo em `stacks/{categoria}/{nome}.yaml`
2. Siga o formato:

```yaml
name: "Nome da Stack"
description: "Descricao curta"
category: backend

context: |
  ### Backend
  - Framework: Express.js
  - Runtime: Node.js

commands:
  dev: "npm run dev"

constraints: |
  - Sempre usar middleware de error handling
```

3. Referencie no `project.yaml`: `backend: "nome"`

---

## Agentes

### Core (sempre instalados — 9 agentes)

| Agente | Modelo | Funcao |
|--------|--------|--------|
| planner | opus | Planejamento e decomposicao de tarefas |
| architect | opus | Decisoes de arquitetura e design |
| code-reviewer | sonnet | Revisao de qualidade de codigo |
| tdd-guide | sonnet | Test-driven development |
| security-reviewer | sonnet | Auditoria de seguranca (OWASP ASVS) |
| a11y-reviewer | sonnet | Auditoria de acessibilidade (WCAG 2.2 AA) |
| performance-profiler | sonnet | Analise de performance (Big-O, profiling) |
| build-error-resolver | sonnet | Resolucao de erros de build |
| refactor-cleaner | sonnet | Limpeza de codigo morto |

### Opcionais (ativados via project.yaml — 24 agentes)

| Categoria | Agentes | Quando usar |
|-----------|---------|-------------|
| `implementation` | backend-engineer, frontend-engineer, fullstack-feature, migration-writer, api-designer | Maioria dos projetos |
| `devops` | docker-specialist, ci-cd-designer, monitoring-setup, incident-responder | Projetos com infra propria |
| `ai-agents` | agent-designer, prompt-engineer, mcp-integrator | Projetos com IA |
| `documentation` | doc-writer, readme-generator, changelog-writer, doc-updater | Maioria dos projetos |
| `research` | code-explorer, library-researcher, debug-investigator, ux-reviewer | Maioria dos projetos |
| `e2e` | e2e-runner | Projetos com frontend |
| `meta` | orchestrator, claude-md-optimizer, colmeia-installer | Power users |

---

## Pipeline SDLC com Agentes

```
[Voce descreve a feature]
        |
   planner                  → plano estruturado
        |
   architect                → valida design
        |
   api-designer             → contrato de API (se aplicavel)
        |
   +----------------------------------+
   | Parallel (se independente)       |
   |  backend-engineer                |
   |  frontend-engineer               |
   |  migration-writer                |
   +----------------------------------+
        |
   tdd-guide                → testes (unit + integration)
        |
   +----------------------------------+
   | Quality Gates (parallel)         |
   |  code-reviewer                   |
   |  security-reviewer               |
   |  a11y-reviewer                   |
   |  performance-profiler            |
   +----------------------------------+
        |
   ux-reviewer              → validacao de UX
        |
   e2e-runner               → testes E2E (se frontend)
        |
   doc-writer + changelog-writer (parallel)
```

### Em producao

```
monitoring-setup      → SLOs, alertas, dashboards
        |
   [alerta de incidente]
        |
incident-responder    → diagnostico, mitigacao, postmortem
        |
ci-cd-designer        → melhorias no pipeline de deploy
```

---

## CLI — Comandos do install.sh

```bash
# Instalacao
./install.sh                          # Instala a partir do project.yaml
./install.sh --init                   # Wizard interativo (gera project.yaml)
./install.sh --dry-run                # Preview sem alterar nada
./install.sh --project                # Instala em .claude/ local (por projeto)

# Multi-IDE
./install.sh --target claude          # Claude Code (default)
./install.sh --target cursor          # Cursor (.cursor/agents/ + .mdc)
./install.sh --target codex           # Codex (.codex/agents/ + AGENTS.md)

# Manutencao
./install.sh --status                 # Dashboard da instalacao
./install.sh --health                 # Verificacao de integridade
./install.sh --update                 # git pull + reinstala
./install.sh --clean                  # Remove todos os symlinks

# Instalacao remota
curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init
```

---

## Modelos por agente

| Modelo | Usado para |
|--------|-----------|
| `opus` | Decisoes arquiteturais, debugging complexo, design de sistema |
| `sonnet` | Implementacao, review, docs, tasks bem definidas |
| `haiku` | Exploracao de codebase, buscas, analises leves |

---

## Criando novos agentes

1. Crie o arquivo em `agents/{categoria}/nome-do-agente.md`
2. Siga o template em [TEMPLATE.md](TEMPLATE.md)
3. Rode `./install.sh` para instalar

---

## Referencias

Arquitetura embasada em 94 referencias academicas e da industria. Ver [REFERENCES.md](REFERENCES.md) para a lista completa.

| Area | Refs | Exemplos |
|------|------|----------|
| Sistemas Multi-Agente | #1-#14 | ACM TOSEM, ICML, ICLR, ACL |
| Codigo Limpo | #25-#31 | Clean Code, Refactoring (Fowler), GoF |
| Seguranca | #32-#39 | OWASP ASVS v5.0, SAMM, Secure SDLC |
| Performance | #40-#44 | Big-O, Profiling, Core Web Vitals |
| Acessibilidade | #49-#52 | WCAG 2.2, eMAG, TCC UFSC |
| Arquitetura | #53-#56 | Clean Architecture, DDD (Evans) |
| SRE & Incidents | #59-#64, #72-#74 | Google SRE, PagerDuty, DORA |
| API Design | #65-#67 | REST Maturity, API Patterns, OpenAPI |
| UX & Usabilidade | #68-#71 | Nielsen Heuristics, Don Norman |
| Testing | #75-#79 | xUnit Patterns, GOOS, Pact CDC |
| Prompt Engineering | #83-#85 | Chain-of-Thought, Claude Best Practices |

---

*COLMEIA v1.1.0 — Adaptive Agent Framework*
