# COLMEIA — Referencias e Fundamentos

Arquitetura e decisoes de design da COLMEIA embasadas nas seguintes referencias.

---

## Papers Academicos

### Sistemas Multi-Agente para Engenharia de Software

1. **LLM-Based Multi-Agent Systems for Software Engineering: Literature Review, Vision, and the Road Ahead**
   - Publicacao: ACM Transactions on Software Engineering and Methodology (TOSEM), 2025
   - Link: https://dl.acm.org/doi/full/10.1145/3712003
   - Contribuicao: Survey definitivo que documenta o shift de workflows estaticos para sistemas adaptativos. Confirma que perfis de agentes podem ser gerados dinamicamente e que o numero de agentes deve escalar conforme a complexidade da tarefa.
   - Relevancia para COLMEIA: Valida a abordagem de categorias opcionais de agentes e configuracao por projeto.

2. **MetaAgent: Automatically Constructing Multi-Agent Systems Based on Finite State Machines**
   - Conferencia: ICML 2025
   - Link: https://arxiv.org/abs/2507.22606
   - Repositorio: https://github.com/SaFo-Lab/MetaAgent
   - Contribuicao: Framework que recebe uma descricao de tarefa e gera automaticamente os agentes necessarios, suas roles, instrucoes e transicoes de estado via FSM. Supera tanto sistemas auto-gerados quanto a maioria dos sistemas desenhados por humanos.
   - Relevancia para COLMEIA: Inspira o conceito de project.yaml como "descricao de tarefa" que configura quais agentes sao ativados.

3. **ALMAS: an Autonomous LLM-based Multi-Agent Software Engineering Framework**
   - Instituicao: J.P. Morgan AI Research, 2025
   - Link: https://arxiv.org/abs/2510.03463
   - Contribuicao: Framework que alinha agentes com papeis ageis reais (product manager, sprint planner, developer, tester, peer reviewer). Introduz "tiered architecture" — agentes leves para tarefas simples, avancados para complexas. Dual mode: execucao autonoma ou colaboracao interativa.
   - Relevancia para COLMEIA: Valida a categorizacao core/optional e a alocacao de modelos (haiku/sonnet/opus) por complexidade.

4. **AgentFlow: A Context Aware Multi-Agent Framework for Dynamic Role Switching**
   - Conferencia: ICAART 2025 (International Conference on Agents and Artificial Intelligence)
   - Link: https://www.scitepress.org/Papers/2025/133757/133757.pdf
   - Contribuicao: Agentes trocam de role dinamicamente com base no contexto da tarefa. Usa "perception loop" para decisoes informadas por contexto. Superou sistemas single-agent e multi-agent fixos em benchmarks.
   - Relevancia para COLMEIA: Suporta a ideia de agentes que se adaptam ao projeto via CLAUDE.md gerado.

5. **Think-on-Process: Dynamic Process Generation for Collaborative Development of Multi-Agent System**
   - Publicacao: arXiv, 2024
   - Link: https://arxiv.org/html/2409.06568
   - Contribuicao: Gera processos de desenvolvimento dinamicos com base no requisito do usuario. Usa process mining (BPMN) para aprender padroes de sucesso e reutilizar conhecimento de projetos anteriores.
   - Relevancia para COLMEIA: Inspira a geracao dinamica de workflows SDLC adaptados ao projeto.

6. **ChatDev: Communicative Agents for Software Development**
   - Conferencia: ACL 2024
   - Link: https://arxiv.org/html/2307.07924v5
   - Repositorio: https://github.com/OpenBMB/ChatDev
   - Contribuicao: Framework pioneiro onde agentes LLM assumem papeis como CEO, CTO, Programmer, Tester e Reviewer, comunicando-se via "chat chain".
   - Relevancia para COLMEIA: Valida o modelo de agentes com roles fixos por fase do SDLC.

7. **MetaGPT: Meta Programming for a Multi-Agent Collaborative Framework**
   - Conferencia: ICLR 2024
   - Link: https://arxiv.org/html/2308.00352v6
   - Contribuicao: Agentes se comunicam via documentos estruturados (SOPs) em vez de dialogo. Formata de output padronizado para cada role.
   - Relevancia para COLMEIA: Inspira o Output Format padronizado dos agentes (O QUE FEZ / O QUE ENCONTROU / PROXIMOS PASSOS).

8. **AgentMesh: A Cooperative Multi-Agent Generative AI Framework for Software Development Automation**
   - Publicacao: arXiv, 2025
   - Link: https://arxiv.org/abs/2507.19902
   - Contribuicao: Framework com 4 agentes core: Planner, Coder, Debugger, Reviewer. Mapeamento direto com fases do SDLC.
   - Relevancia para COLMEIA: Valida a estrutura de agentes core (planner, architect, code-reviewer, tdd-guide).

9. **Designing LLM-based Multi-Agent Systems for Software Engineering Tasks: Quality Attributes, Design Patterns and Rationale**
   - Publicacao: arXiv, 2025
   - Link: https://arxiv.org/html/2511.08475v1
   - Contribuicao: Cataloga design patterns para sistemas multi-agente em SE, incluindo especializacao por responsabilidade e comunicacao estruturada.
   - Relevancia para COLMEIA: Fornece patterns de referencia para a arquitetura de dispatch e comunicacao entre agentes.

10. **The Rise of AI Teammates in Software Engineering (SE) 3.0**
    - Publicacao: arXiv, 2025
    - Link: https://arxiv.org/abs/2507.15003
    - Contribuicao: Estudo com 456.000+ PRs de 5 agentes (Claude Code, Devin, Copilot, etc.). Mostra que o papel do dev humano migra para orquestracao.
    - Relevancia para COLMEIA: Valida o papel do orchestrator.md como meta-agente de coordenacao.

11. **Agentic Software Engineering: Foundational Pillars and a Research Roadmap**
    - Publicacao: arXiv, 2025
    - Link: https://arxiv.org/html/2509.06216v1
    - Contribuicao: Define os pilares de "SE 3.0" — agentes autonomos que leem codebases, planejam mudancas, executam ferramentas, rodam testes e submetem PRs.
    - Relevancia para COLMEIA: Confirma que o pipeline SDLC com agentes e a direcao correta para engenharia de software moderna.

---

### Sistemas Adaptativos e Configuracao por Contexto

12. **SALLMA: A Software Architecture for LLM-Based Multi-Agent Systems**
    - Publicacao: 2025
    - Link: https://robertoverdecchia.github.io/papers/SATrends_2025.pdf
    - Contribuicao: Arquitetura de referencia para sistemas multi-agente baseados em LLM.

13. **Adaptive Agent Model: Software Adaptivity using an Agent-oriented Model-Driven Architecture**
    - Publicacao: ScienceDirect / Information and Software Technology
    - Link: https://www.sciencedirect.com/science/article/abs/pii/S0950584908000335
    - Contribuicao: Framework onde agentes usam knowledge models hierarquicos com configuracao externalizada e facilmente modificavel por humanos.
    - Relevancia para COLMEIA: Precursor teorico do project.yaml como configuracao externalizada.

14. **A Comprehensive Survey on Context-Aware Multi-Agent Systems**
    - Publicacao: arXiv, 2024
    - Link: https://arxiv.org/html/2402.01968v2
    - Contribuicao: Survey sobre context-awareness em sistemas multi-agente. Apresenta taxonomia unificada para CA-MAS.

---

## Padroes da Industria

15. **AGENTS.md — Open Format for Guiding Coding Agents**
    - Criadores: Google, OpenAI, Factory, Sourcegraph, Cursor
    - Link: https://agents.md/
    - Repositorio: https://github.com/agentsmd/agents.md
    - Contribuicao: Padrao aberto usado por 60.000+ projetos. Define como um arquivo por projeto configura o comportamento de agentes de codigo.
    - Relevancia para COLMEIA: Inspiracao direta para o conceito de project.yaml como manifesto de projeto.

16. **How to Write a Great AGENTS.md: Lessons from Over 2,500 Repositories**
    - Publicacao: GitHub Blog, 2026
    - Link: https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/
    - Contribuicao: Melhores praticas de AGENTS.md devem cobrir 6 areas: commands, testing, project structure, code style, git workflow, boundaries.
    - Relevancia para COLMEIA: Informa a estrutura do project.yaml (stacks, conventions, commands).

17. **Claude Code Sub-Agents Documentation**
    - Fonte: Anthropic
    - Link: https://code.claude.com/docs/en/sub-agents
    - Contribuicao: Documentacao oficial sobre criacao de subagentes customizados com prompts, restricoes de tools e hooks.
    - Relevancia para COLMEIA: Base tecnica para o formato dos agentes .md com YAML frontmatter.

---

## Frameworks de Referencia

18. **Agent Scaffolding Architecture**
    - Fonte: ZBrain, 2025
    - Link: https://zbrain.ai/agent-scaffolding/
    - Contribuicao: Conceito de "scaffolding" como a estrutura ao redor do LLM que define capacidades (prompt templates, retrieval systems, tool access, structured workflows).

19. **Awesome Claude Code Subagents**
    - Fonte: VoltAgent
    - Repositorio: https://github.com/VoltAgent/awesome-claude-code-subagents
    - Contribuicao: Colecao de 100+ subagentes organizados por categoria com instalador. Estrutura de categorias numeradas similar a COLMEIA.

20. **Intelligent Automation and Multi-Agent Orchestration for Claude Code**
    - Fonte: wshobson/agents
    - Repositorio: https://github.com/wshobson/agents
    - Contribuicao: 112 agentes especializados com 16 orchestrators e plugin system.

---

## Padroes Arquiteturais

21. **Hexagonal Architecture (Ports & Adapters)**
    - Autor: Alistair Cockburn, 2005
    - Contribuicao: Padrao de isolamento de logica de negocio via portas e adaptadores.
    - Relevancia para COLMEIA: Base para o padrao Route -> Controller -> Service -> Repository nas stacks de backend.

22. **OWASP Top 10 (2021)**
    - Fonte: OWASP Foundation
    - Link: https://owasp.org/www-project-top-ten/
    - Contribuicao: Lista das 10 vulnerabilidades mais criticas em aplicacoes web.
    - Relevancia para COLMEIA: Checklist do security-reviewer agent.

---

## AI-led SDLC

23. **An AI-led SDLC: Building an End-to-End Agentic Software Development Lifecycle**
    - Fonte: Microsoft, 2025
    - Link: https://techcommunity.microsoft.com/blog/appsonazureblog/an-ai-led-sdlc-building-an-end-to-end-agentic-software-development-lifecycle-wit/4491896
    - Contribuicao: SDLC end-to-end com 12 agentes LLM colaborando em fases usando Azure + GitHub.
    - Relevancia para COLMEIA: Valida o pipeline SDLC de agentes especializados por fase.

24. **Agent Development Lifecycle (ADLC)**
    - Fonte: Salesforce Architects
    - Link: https://architect.salesforce.com/fundamentals/agent-development-lifecycle
    - Contribuicao: Framework ADLC que formaliza design, desenvolvimento, teste e deploy de agentes autonomos.

---

*Ultima atualizacao: Marco 2026*
