# COLMEIA — Adaptive Agent Framework for Claude Code

> Repositorio de agentes especializados para Claude Code que se adapta ao seu projeto.
> Defina sua stack no `project.yaml` e receba agentes, contexto e regras sob medida.

---

## O que e

COLMEIA e um framework de **subagentes adaptativos para Claude Code** organizados por fase do ciclo de desenvolvimento de software (SDLC). Diferente de repositorios estaticos, a COLMEIA se **molda ao projeto** via um manifesto `project.yaml`.

**Principios:**
- **Adaptativo** — agentes e contexto gerados com base na stack do projeto
- **Modular** — ative apenas as categorias de agentes que precisa
- **Embasado** — arquitetura validada por pesquisa academica (ver [REFERENCES.md](REFERENCES.md))

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
├── agents/                          # Agentes organizados por categoria
│   ├── core/                        # Sempre instalados (7 agentes)
│   │   ├── planner.md
│   │   ├── architect.md
│   │   ├── code-reviewer.md
│   │   ├── tdd-guide.md
│   │   ├── security-reviewer.md
│   │   ├── build-error-resolver.md
│   │   └── refactor-cleaner.md
│   ├── implementation/              # Backend, frontend, fullstack, migrations
│   ├── devops/                      # Docker, CI/CD, monitoring
│   ├── ai-agents/                   # Agent design, prompts, MCP
│   ├── documentation/               # Docs, README, changelog
│   ├── research/                    # Exploracao, bibliotecas, debug
│   ├── e2e/                         # Testes end-to-end
│   └── meta/                        # Orquestrador, otimizador
├── examples/                        # Manifestos de exemplo
│   ├── project-ideva.yaml
│   ├── project-nextjs-supabase.yaml
│   └── project-python-django.yaml
├── TEMPLATE.md                      # Template para criar novos agentes
└── REFERENCES.md                    # Referencias academicas
```

---

## Quickstart

```bash
git clone https://github.com/seu-usuario/colmeia.git
cd colmeia

# Copie um exemplo ou crie seu project.yaml
cp examples/project-ideva.yaml project.yaml

# Edite conforme seu projeto
# vim project.yaml

# Instale
chmod +x install.sh
./install.sh
```

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

### Core (sempre instalados)

| Agente | Modelo | Funcao |
|--------|--------|--------|
| planner | opus | Planejamento e decomposicao de tarefas |
| architect | opus | Decisoes de arquitetura e design |
| code-reviewer | sonnet | Revisao de qualidade de codigo |
| tdd-guide | sonnet | Test-driven development |
| security-reviewer | sonnet | Auditoria de seguranca |
| build-error-resolver | sonnet | Resolucao de erros de build |
| refactor-cleaner | sonnet | Limpeza de codigo morto |

### Opcionais (ativados via project.yaml)

| Categoria | Agentes | Quando usar |
|-----------|---------|-------------|
| `implementation` | backend-engineer, frontend-engineer, fullstack-feature, migration-writer | Maioria dos projetos |
| `devops` | docker-specialist, ci-cd-designer, monitoring-setup | Projetos com infra propria |
| `ai-agents` | agent-designer, prompt-engineer, mcp-integrator | Projetos com IA |
| `documentation` | doc-writer, readme-generator, changelog-writer, doc-updater | Maioria dos projetos |
| `research` | code-explorer, library-researcher, debug-investigator | Maioria dos projetos |
| `e2e` | e2e-runner | Projetos com frontend |
| `meta` | orchestrator, claude-md-optimizer | Power users |

---

## Pipeline SDLC com Agentes

```
[Voce descreve a feature]
        |
   planner             -> gera plano estruturado
        |
   architect           -> valida design
        |
   +------------------------------+
   | Parallel (se independente)   |
   |  backend-engineer            |
   |  frontend-engineer           |
   |  migration-writer            |
   +------------------------------+
        |
   tdd-guide           -> testes
        |
   code-reviewer + security-reviewer (parallel)
        |
   docker-specialist (se mudanca de infra)
        |
   doc-writer + changelog-writer (parallel)
```

---

## Modelos por agente

| Modelo | Usado para |
|--------|-----------|
| `opus` | Decisoes arquiteturais, debugging complexo, design de sistema |
| `sonnet` | Implementacao, review, docs, tasks bem definidas |
| `haiku` | Exploracao de codebase, buscas, analises leves |

---

## Instaladores

### install.sh — Instalador padrao

```bash
./install.sh              # Instalacao padrao
./install.sh --dry-run    # Mostra o que seria instalado
./install.sh --clean      # Remove todos os symlinks da COLMEIA
./install.sh --project    # Instala em .claude/ local (por projeto)
```

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

## Criando novos agentes

1. Crie o arquivo em `agents/{categoria}/nome-do-agente.md`
2. Siga o template em [TEMPLATE.md](TEMPLATE.md)
3. Teste com `./install.sh`

---

## Referencias

Arquitetura embasada em pesquisa academica. Ver [REFERENCES.md](REFERENCES.md) para a lista completa.

---

*COLMEIA — Adaptive Agent Framework (c) 2026*
