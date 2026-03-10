# COLMEIA — Adaptive Agent Framework for Claude Code

> Framework de agentes especializados para Claude Code que se adapta ao seu projeto.
> Defina sua stack no `project.yaml` e receba agentes, contexto e regras sob medida.

---

## Quick Install

```bash
# Instalacao remota (sem clonar)
curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init

# Ou clone e instale
git clone https://github.com/GuiRCosta/colmeia.git
cd colmeia
./install.sh --init
```

---

## O que e

COLMEIA e um framework de **subagentes adaptativos para Claude Code** organizados por fase do ciclo de desenvolvimento de software (SDLC). Diferente de repositorios estaticos de agentes, a COLMEIA se **molda ao projeto** via um manifesto `project.yaml`.

**32 agentes | 94 referencias academicas | 7 stacks composiveis**

**Principios:**
- **Adaptativo** — agentes e contexto gerados com base na stack do projeto
- **Modular** — ative apenas as categorias de agentes que precisa
- **Embasado** — arquitetura validada por pesquisa academica (ver [REFERENCES.md](REFERENCES.md))

---

## Diferenciais

A COLMEIA nao e uma colecao de agentes — e um **framework adaptativo com fundamentacao academica**. Comparada aos maiores repositorios de agentes para Claude Code (100-135 agentes), a COLMEIA faz mais com menos:

### 1. Fundamentacao por referencia (unico no mercado)

Cada agente referencia fundamentos especificos do [REFERENCES.md](REFERENCES.md) usando cross-references numeradas. Nenhum outro repositorio de agentes para Claude Code possui sequer uma referencia academica.

```markdown
# Exemplo: dentro de security-reviewer.md
- OWASP ASVS v5.0 — verificacao em 3 niveis (#32)
- Threat Modeling — identificacao de attack surface (#37, #38)
```

94 referencias incluem papers (ACM, ICML, ICLR), livros fundamentais (Clean Code, DDD, DDIA, SRE), padroes (OWASP ASVS, WCAG 2.2, eMAG) e TCCs brasileiros (UFSC, UFMG, UnB, IFRS).

### 2. Arquitetura adaptativa (stack injection)

Repositorios tradicionais criam agentes separados por tecnologia: `react-expert`, `vue-expert`, `angular-expert`, `nextjs-expert`... A COLMEIA injeta contexto via stacks:

```
Um unico frontend-engineer + stack react-vite.yaml = contexto React
O mesmo frontend-engineer + stack vue-nuxt.yaml    = contexto Vue
```

Isso substitui ~40-60 agentes tech-specific de outros repos, mantendo o framework enxuto sem perder cobertura.

### 3. Pipeline de qualidade em 5 dimensoes

Nenhum outro framework integra 5 gates de qualidade com agentes dedicados:

```
code-reviewer        → Codigo limpo, SOLID, refactoring patterns
security-reviewer    → OWASP ASVS v5.0, threat modeling
a11y-reviewer        → WCAG 2.2 AA, eMAG
performance-profiler → Big-O, profiling, Core Web Vitals
ux-reviewer          → Heuristicas de Nielsen, usabilidade
```

### 4. SRE lifecycle completo

Ciclo completo de confiabilidade, da prevencao ao aprendizado:

```
monitoring-setup     → SLOs, SLIs, error budgets (prevencao)
incident-responder   → Diagnostico, mitigacao, postmortem (resposta)
ci-cd-designer       → DORA metrics, deploy strategies (evolucao)
```

### 5. Design-first workflow

Separacao entre design e implementacao — projetar ANTES de codar:

```
api-designer         → Contrato REST/OpenAPI (design)
backend-engineer     → Implementacao dos endpoints (codigo)
ux-reviewer          → Validacao da experiencia (review)
```

---

## Estrutura

```
colmeia/
├── project.yaml                     # Manifesto do projeto (voce configura)
├── install.sh                       # Instalador adaptativo
├── install-full.sh                  # Instalador + aliases full permission
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
├── agents/                          # 32 agentes organizados por categoria
│   ├── core/                        # Sempre instalados (9 agentes)
│   │   ├── planner.md
│   │   ├── architect.md
│   │   ├── code-reviewer.md
│   │   ├── tdd-guide.md
│   │   ├── security-reviewer.md
│   │   ├── a11y-reviewer.md
│   │   ├── performance-profiler.md
│   │   ├── build-error-resolver.md
│   │   └── refactor-cleaner.md
│   ├── implementation/              # Backend, frontend, fullstack, migrations, API design
│   ├── devops/                      # Docker, CI/CD, monitoring, incident response
│   ├── ai-agents/                   # Agent design, prompts, MCP
│   ├── documentation/               # Docs, README, changelog
│   ├── research/                    # Exploracao, bibliotecas, debug, UX
│   ├── e2e/                         # Testes end-to-end
│   └── meta/                        # Orquestrador, otimizador, instalador
├── examples/                        # Manifestos de exemplo
│   ├── project-ideva.yaml
│   ├── project-nextjs-supabase.yaml
│   └── project-python-django.yaml
├── TEMPLATE.md                      # Template para criar novos agentes
└── REFERENCES.md                    # Referencias academicas
```

---

## Quickstart

### Instalacao remota (sem clonar)

```bash
curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init
```

Isso clona o repositorio automaticamente para `~/.colmeia/` e inicia o wizard interativo.

### Instalacao local

```bash
git clone https://github.com/GuiRCosta/colmeia.git
cd colmeia

# Opcao 1: Wizard interativo (recomendado)
./install.sh --init

# Opcao 2: Copiar exemplo e editar manualmente
cp examples/project-ideva.yaml project.yaml
./install.sh
```

### Deteccao automatica de stack (via agente)

Se voce ja tem um projeto e quer que a COLMEIA detecte suas tecnologias automaticamente:

```
> Use o agente colmeia-installer para detectar minha stack
```

O agente analisa `package.json`, `pyproject.toml`, `docker-compose.yml`, etc., e gera o `project.yaml` para voce.

---

## project.yaml — O Manifesto

O `project.yaml` e o arquivo central que configura tudo:

```yaml
project:
  name: "meu-saas"
  description: "Plataforma SaaS com Node.js"

# Selecione suas stacks (cada uma mapeia para stacks/{categoria}/{escolha}.yaml)
stacks:
  backend:    "node-fastify"
  frontend:   "react-vite"
  database:   "postgresql-drizzle"
  cache:      "redis"
  infra:      "docker-swarm"
  auth:       "jwt-custom"
  # ai:       "agno-python"           # Descomente se usar IA

# Categorias de agentes opcionais
agents:
  optional:
    - implementation
    - devops
    - documentation
    - research
  disabled: []

# Convencoes de nomenclatura
conventions:
  files_ts:     "kebab-case.ts"
  classes:      "PascalCase"
  functions:    "camelCase"
  constants:    "UPPER_SNAKE_CASE"
  db_tables:    "snake_case (plural)"
  api_routes:   "/kebab-case (plural)"

# Comandos do projeto
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

| Categoria | Opcao | Arquivo |
|-----------|-------|---------|
| backend | `node-fastify` | stacks/backend/node-fastify.yaml |
| frontend | `react-vite` | stacks/frontend/react-vite.yaml |
| database | `postgresql-drizzle` | stacks/database/postgresql-drizzle.yaml |
| cache | `redis` | stacks/cache/redis.yaml |
| infra | `docker-swarm` | stacks/infra/docker-swarm.yaml |
| auth | `jwt-custom` | stacks/auth/jwt-custom.yaml |
| ai | `agno-python` | stacks/ai/agno-python.yaml |

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

### Opcionais (ativados via project.yaml — 23 agentes)

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

## CLI — Comandos do install.sh

### Instalacao e configuracao

```bash
./install.sh                          # Instalacao padrao
./install.sh --init                   # Wizard interativo — gera project.yaml e instala
./install.sh --dry-run                # Mostra o que seria instalado sem alterar nada
./install.sh --project                # Instala em .claude/ local (por projeto)
```

### Multi-IDE

```bash
./install.sh --target claude          # Claude Code (default)
./install.sh --target cursor          # Cursor (.cursor/agents/ + .mdc)
./install.sh --target codex           # Codex (.codex/agents/ + AGENTS.md)
```

### Monitoramento

```bash
./install.sh --status                 # Dashboard: versao, stacks, agentes instalados
./install.sh --health                 # Verificacao de integridade (exit 1 se falhou)
./install.sh --version                # Versao da COLMEIA
```

### Manutencao

```bash
./install.sh --update                 # git pull + reinstala automaticamente
./install.sh --clean                  # Remove todos os symlinks da COLMEIA
```

### Instalacao remota

```bash
curl -fsSL https://raw.githubusercontent.com/GuiRCosta/colmeia/main/install.sh | bash -s -- --init
```

Clona automaticamente para `~/.colmeia/` e inicia o wizard.

---

### install-full.sh — Instalador + Full Permission

```bash
./install-full.sh         # Instala tudo + configura aliases
```

Faz tudo que o `install.sh` faz e adiciona dois **aliases** ao seu shell (`~/.zshrc` ou `~/.bashrc`):

| Alias | Comando completo | O que faz |
|-------|-----------------|-----------|
| `claude-full` | `claude --dangerously-skip-permissions` | Inicia nova sessao sem confirmacoes |
| `claude-full-continue` | `claude --dangerously-skip-permissions --continue` | Continua ultima sessao sem confirmacoes |

Apos instalar, ative com:

```bash
source ~/.zshrc   # ou source ~/.bashrc
```

> **AVISO:** `--dangerously-skip-permissions` desativa **todas** as confirmacoes de seguranca. O Claude pode executar qualquer acao (deletar arquivos, push, bash) sem pedir aprovacao. Use com cuidado.

---

## Pipeline SDLC com Agentes

```
[Voce descreve a feature]
        |
   planner                  -> plano estruturado
        |
   architect                -> valida design
        |
   api-designer             -> contrato de API (se aplicavel)
        |
   +----------------------------------+
   | Parallel (se independente)       |
   |  backend-engineer                |
   |  frontend-engineer               |
   |  migration-writer                |
   +----------------------------------+
        |
   tdd-guide                -> testes (unit + integration)
        |
   +----------------------------------+
   | Quality Gates (parallel)         |
   |  code-reviewer                   |
   |  security-reviewer               |
   |  a11y-reviewer                   |
   |  performance-profiler            |
   +----------------------------------+
        |
   ux-reviewer              -> validacao de UX
        |
   e2e-runner               -> testes E2E (se frontend)
        |
   docker-specialist         -> infra (se mudanca de deploy)
        |
   doc-writer + changelog-writer (parallel)
```

### Em producao

```
monitoring-setup      -> SLOs, alertas, dashboards
        |
   [alerta de incidente]
        |
incident-responder    -> diagnostico, mitigacao, postmortem
        |
ci-cd-designer        -> melhorias no pipeline de deploy
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
3. Teste com `./install.sh`

---

## Referencias

Arquitetura embasada em 94 referencias academicas e da industria. Ver [REFERENCES.md](REFERENCES.md) para a lista completa.

| Area | Refs | Exemplos |
|------|------|----------|
| Sistemas Multi-Agente | #1–#14 | ACM TOSEM, ICML, ICLR, ACL |
| Codigo Limpo | #25–#31 | Clean Code, Refactoring (Fowler), GoF |
| Seguranca | #32–#39 | OWASP ASVS v5.0, SAMM, Secure SDLC |
| Performance | #40–#44 | Big-O, Profiling, Core Web Vitals |
| Design System | #45–#48 | Atomic Design (Frost), Design Tokens |
| Acessibilidade | #49–#52 | WCAG 2.2, eMAG, TCC UFSC |
| Arquitetura | #53–#56 | Clean Architecture, DDD (Evans) |
| Dados | #57–#58 | DDIA (Kleppmann) |
| SRE & Incidents | #59–#64, #72–#74 | Google SRE, PagerDuty, DORA |
| API Design | #65–#67 | REST Maturity, API Patterns, OpenAPI |
| UX & Usabilidade | #68–#71 | Nielsen Heuristics, Don Norman |
| Testing | #75–#79 | xUnit Patterns, GOOS, Pact CDC |
| Technical Writing | #80–#82 | Google Tech Writing, Diataxis |
| Prompt Engineering | #83–#85 | Chain-of-Thought, Claude Best Practices |
| Debugging | #86 | 9 Indispensable Rules (Agans) |
| Code Review | #87–#88 | Google Eng Practices, SmartBear Study |
| Container Security | #89–#90 | CIS Docker Benchmark, NIST SP 800-190 |
| Event-Driven | #91–#92 | Enterprise Integration Patterns, Fowler |
| Technical Debt | #93 | Cunningham Metaphor, Fowler Quadrants |
| Developer Experience | #94 | SPACE Framework |

---

*COLMEIA v1.0.0 — Adaptive Agent Framework (c) 2026*
