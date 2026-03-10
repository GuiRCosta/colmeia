---
name: nome-do-agente
description: >
  Invoque quando: {descreva os triggers semanticos com palavras-chave}.
  NAO invoque quando: {anti-triggers — evita invocacao errada}.
tools: Read, Glob, Grep
model: sonnet
category: core
---

# Nome do Agente

## Role
{1-2 linhas descrevendo o papel e responsabilidade principal deste agente.}

## Expertise
- {Dominio 1: descricao}
- {Dominio 2: descricao}
- {Tecnologia ou padrao especifico}

## Workflow

1. **Leia antes de agir** — sempre inspecione os arquivos relevantes antes de qualquer modificacao
2. {Passo especifico do workflow deste agente}
3. {Passo de validacao ou verificacao}
4. **Reporte no formato padrao** (ver Output Format)

## Constraints

- Nunca modifique arquivos fora de `{escopo permitido}`
- Nunca assuma contexto que nao leu — sempre leia primeiro
- Em caso de duvida sobre escopo, pergunte antes de implementar
- {Constraint especifico do agente}

## Output Format

Ao finalizar, reporte sempre com:

```
O QUE FEZ:
   - {acao 1}
   - {acao 2}

O QUE ENCONTROU:
   - {descoberta ou problema relevante}

PROXIMOS PASSOS SUGERIDOS:
   - {sugestao 1}
```

## Exemplos de Invocacao

```
# Automatica (Claude detecta pelo description)
> {exemplo de prompt que dispara este agente}

# Explicita
> Use o agente {nome} para {tarefa especifica}
```

---

### Campos do Frontmatter

| Campo | Obrigatorio | Descricao |
|-------|-------------|-----------|
| `name` | Sim | Nome unico do agente (kebab-case) |
| `description` | Sim | Triggers e anti-triggers para invocacao |
| `tools` | Sim | Ferramentas permitidas (Read, Write, Edit, Bash, Glob, Grep, WebSearch, WebFetch) |
| `model` | Sim | Modelo recomendado (opus, sonnet, haiku) |
| `category` | Sim | Categoria do agente (core, implementation, devops, ai-agents, documentation, research, e2e, meta) |

### Categorias Validas

| Categoria | Diretorio | Instalacao |
|-----------|-----------|------------|
| `core` | agents/core/ | Sempre instalado |
| `implementation` | agents/implementation/ | Opcional |
| `devops` | agents/devops/ | Opcional |
| `ai-agents` | agents/ai-agents/ | Opcional |
| `documentation` | agents/documentation/ | Opcional |
| `research` | agents/research/ | Opcional |
| `e2e` | agents/e2e/ | Opcional |
| `meta` | agents/meta/ | Opcional |
