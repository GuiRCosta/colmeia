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
