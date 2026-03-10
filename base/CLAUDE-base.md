# COLMEIA — {{PROJECT_NAME}}

## Regras de Roteamento de Sub-Agentes

### Parallel dispatch — TODAS as condicoes devem ser atendidas:
- 3+ tarefas sem dependencia entre si
- Sem estado compartilhado entre elas
- Fronteiras de arquivo claras e sem sobreposicao

### Sequential dispatch — QUALQUER condicao dispara:
- Tarefa B depende do output da tarefa A
- Arquivos ou estado compartilhados (risco de merge conflict)
- Escopo ainda nao esta claro — clarificar ANTES de implementar

### Background dispatch:
- Pesquisa, exploracao de codebase, analises sem modificacao de arquivo
- Resultado nao bloqueia o trabalho atual

---

## Quando Usar Cada Modelo

| Modelo | Usar para |
|--------|-----------|
| `opus` | Arquitetura, debugging critico, decisoes de design complexas |
| `sonnet` | Implementacao de features, code review, documentacao |
| `haiku` | Exploracao de codebase, grep semantico, analises leves |

---

## Stack de Referencia

{{STACK_SECTIONS}}

---

## Constraints

{{CONSTRAINTS}}

---

## Convencoes de Nomenclatura

{{CONVENTIONS}}

---

## Comandos de Desenvolvimento

```bash
{{COMMANDS}}
```

---

## Frameworks de Referencia

Os agentes da COLMEIA sao fundamentados nas seguintes referencias (ver REFERENCES.md para detalhes):

| Area | Referencia Principal | Agentes Impactados |
|------|---------------------|-------------------|
| Codigo Limpo | Clean Code (R. Martin), Refactoring (Fowler) | code-reviewer, refactor-cleaner |
| Arquitetura | Clean Architecture, DDD (Evans) | architect, backend-engineer |
| Seguranca | OWASP ASVS v5.0, OWASP Top 10 | security-reviewer |
| Performance | Big-O, Profiling, Core Web Vitals | performance-profiler, code-reviewer |
| Acessibilidade | WCAG 2.2 AA, eMAG | a11y-reviewer, frontend-engineer, e2e-runner |
| Design System | Atomic Design (Frost), Design Tokens | frontend-engineer |
| API Design | REST Maturity, API Patterns, OpenAPI 3.1 | api-designer, backend-engineer |
| UX & Usabilidade | Heuristicas de Nielsen, Don Norman | ux-reviewer |
| SRE | Google SRE Book, DORA Metrics | monitoring-setup, ci-cd-designer |
| Incident Management | PagerDuty Guide, Google SRE Ch.15 | incident-responder |
| Dados | DDIA (Kleppmann) | architect, migration-writer |
| Testing | xUnit Patterns, GOOS, Testing Pyramid | tdd-guide, e2e-runner |
| Technical Writing | Google Tech Writing, Diataxis, Docs as Code | doc-writer, readme-generator, doc-updater |
| Prompt Engineering | Chain-of-Thought, Anthropic Best Practices | agent-designer, prompt-engineer |
| Debugging | 9 Indispensable Rules (Agans) | debug-investigator, build-error-resolver |
| Code Review | Google Eng Practices, SmartBear Study | code-reviewer |
| Container Security | CIS Docker Benchmark, NIST SP 800-190 | docker-specialist |
| Event-Driven | Enterprise Integration Patterns, Fowler EDA | architect, backend-engineer |
| Technical Debt | Cunningham Metaphor, Fowler Quadrants | refactor-cleaner |
| Developer Experience | SPACE Framework | planner, orchestrator, library-researcher |
