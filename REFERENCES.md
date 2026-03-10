# COLMEIA — Referencias e Fundamentos

Arquitetura, decisoes de design e fundamentos teoricos da COLMEIA embasados nas seguintes referencias.

> **Indice**: [Papers Academicos](#papers-academicos) | [Codigo Limpo & Boas Praticas](#codigo-limpo--boas-praticas) | [Seguranca](#seguranca) | [Otimizacao & Performance](#otimizacao--performance) | [Design System](#design-system) | [Acessibilidade (a11y)](#acessibilidade-a11y) | [Arquitetura de Software](#arquitetura-de-software) | [API Design](#api-design) | [UX & Usabilidade](#ux--usabilidade) | [Incident Management](#incident-management) | [Testing Methodology](#testing-methodology) | [Technical Writing & Documentacao](#technical-writing--documentacao) | [Prompt Engineering](#prompt-engineering) | [Debugging](#debugging) | [Code Review](#code-review) | [Container Security](#container-security) | [Event-Driven Architecture](#event-driven-architecture) | [Technical Debt](#technical-debt) | [Developer Experience (DX)](#developer-experience-dx) | [Sistemas Distribuidos & Dados](#sistemas-distribuidos--dados) | [SRE, Observabilidade & DevOps](#sre-observabilidade--devops) | [Padroes da Industria](#padroes-da-industria) | [Frameworks de Referencia](#frameworks-de-referencia) | [Padroes Arquiteturais](#padroes-arquiteturais) | [AI-led SDLC](#ai-led-sdlc)

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

## Codigo Limpo & Boas Praticas

> **Lacuna identificada**: As regras da COLMEIA cobrem imutabilidade, funcoes < 50 linhas, arquivos < 800 linhas e no deep nesting. Faltavam principios SOLID, naming conventions, complexidade ciclomatica, refactoring patterns e design patterns.

### Livros Fundamentais

25. **Clean Code: A Handbook of Agile Software Craftsmanship**
    - Autor: Robert C. Martin ("Uncle Bob")
    - Link: https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882
    - Contribuicao: Referencia definitiva em codigo limpo. Define principios como nomes significativos, funcoes pequenas com responsabilidade unica, formatacao consistente, tratamento de erros, e eliminacao de duplicacao. Introduz a "Boy Scout Rule" — deixe o codigo mais limpo do que encontrou.
    - Relevancia para COLMEIA: Fundamenta as regras de coding-style.md (funcoes < 50 linhas, arquivos < 800 linhas, no deep nesting). Base teorica do code-reviewer agent.

26. **Refactoring: Improving the Design of Existing Code (2nd Edition)**
    - Autor: Martin Fowler
    - Link: https://www.amazon.com/Refactoring-Improving-Existing-Addison-Wesley-Signature/dp/0134757599
    - Contribuicao: Catalogo de 60+ refatoracoes com exemplos em JavaScript. Ensina a identificar code smells e aplicar transformacoes seguras. Segunda edicao atualizada com exemplos funcionais.
    - Relevancia para COLMEIA: Base para o refactor-cleaner agent e para deteccao de code smells no code-reviewer.

27. **The Pragmatic Programmer: Your Journey to Mastery (20th Anniversary Edition)**
    - Autores: David Thomas, Andrew Hunt
    - Link: https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/
    - Contribuicao: Filosofia de craft em software — DRY, ortogonalidade, tracer bullets, programacao por coincidencia vs. programacao deliberada. 100 dicas praticas para produtividade e qualidade.
    - Relevancia para COLMEIA: Fundamenta a filosofia geral de qualidade de codigo aplicada em todos os agentes.

28. **Design Patterns: Elements of Reusable Object-Oriented Software (GoF)**
    - Autores: Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides
    - Link: https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612
    - Contribuicao: 23 design patterns classicos categorizados em Creational, Structural e Behavioral. Fundamento da engenharia de software orientada a objetos.
    - Relevancia para COLMEIA: Referencia para o architect agent ao propor solucoes e para o code-reviewer ao avaliar uso adequado de patterns.

### Artigos Academicos e TCCs

29. **Codigo Limpo: padroes e tecnicas no desenvolvimento de software**
    - Publicacao: Revista Interface Tecnologica (FATEC Taquaritinga)
    - Link: https://revista.fatectq.edu.br/interfacetecnologica/en/article/view/597
    - Contribuicao: Artigo academico que analisa padroes e conceitos de codigo limpo para garantir boas praticas, considerando manutencao de aplicacoes ao longo de sua vida util.

30. **Principios SOLID e boas praticas de programacao**
    - Instituicao: UNIFACVEST (Curso de Ciencia da Computacao)
    - Link: https://www.unifacvest.edu.br/assets/uploads/files/arquivos/5f08f-padilha-junior,-e.-principios-solid-e-boas-praticas-de...-unifacvest,-2012..pdf
    - Contribuicao: TCC que aplica questionarios em empresas para avaliar o uso dos principios SOLID (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion) na pratica.

31. **Clean Code Principles Summary**
    - Fonte: GitHub Community
    - Link: https://gist.github.com/wojteklu/73c6914cc446146b8b533c0988cf8d29
    - Contribuicao: Resumo consolidado dos principios do livro Clean Code. Referencia rapida para revisao de codigo.

---

## Seguranca

> **Lacuna identificada**: As regras da COLMEIA tinham checklist OWASP Top 10 basico, validacao de input e gestao de secrets. Faltavam OWASP ASVS, threat modeling, secure SDLC e niveis de verificacao.

### Padroes e Frameworks

32. **OWASP Application Security Verification Standard (ASVS) v5.0**
    - Fonte: OWASP Foundation
    - Link: https://owasp.org/www-project-application-security-verification-standard/
    - Repositorio: https://github.com/OWASP/ASVS
    - Contribuicao: Padrao aberto com 14 secoes cobrindo desde arquitetura e threat modeling ate verificacao de APIs e web services. Define 3 niveis de seguranca: Level 1 (basico — toda aplicacao web), Level 2 (padrao — dados sensiveis), Level 3 (avancado — infraestrutura critica). Versao 5.0 lancada em maio de 2025.
    - Relevancia para COLMEIA: Evolui o security-reviewer agent de um checklist basico para verificacao em niveis. Complementa o OWASP Top 10 ja utilizado.

33. **OWASP Cheat Sheet Series (Index ASVS)**
    - Fonte: OWASP Foundation
    - Link: https://cheatsheetseries.owasp.org/IndexASVS.html
    - Contribuicao: Colecao de cheat sheets organizadas pelos requisitos do ASVS. Guias praticos para implementacao de cada controle de seguranca.
    - Relevancia para COLMEIA: Referencia rapida para o security-reviewer agent aplicar controles especificos.

34. **OWASP Top 10 (2025)**
    - Fonte: Clavis Seguranca da Informacao
    - Link: https://clavis.com.br/blog/owasp-top-10-2025/
    - Contribuicao: Analise atualizada das novas prioridades de seguranca de aplicacoes, refletindo mudancas no cenario de ameacas desde a versao 2021.
    - Relevancia para COLMEIA: Atualiza o checklist do security-reviewer agent com as ameacas mais recentes.

### TCCs e Artigos Academicos

35. **Metodologia para o incremento da seguranca no desenvolvimento de software**
    - Instituicao: IFRS Campus Veranopolis
    - Link: https://ifrs.edu.br/veranopolis/wp-content/uploads/sites/10/2023/03/Artigo-TCC-Elias-Spanhol-Versao-final.pdf
    - Contribuicao: TCC que desenvolve uma metodologia de incremento de seguranca baseada em problemas recomendados pela OWASP, aplicavel ao ciclo de desenvolvimento.

36. **Seguranca em desenvolvimento web — OWASP Top Ten**
    - Instituicao: Universidade de Brasilia (UnB) — Engenharia de Software
    - Link: https://bdm.unb.br/bitstream/10483/39332/1/2023_AlvaroLelesGuimaraes_tcc.pdf
    - Contribuicao: TCC que aborda seguranca em desenvolvimento web com foco no OWASP Top Ten, incluindo exemplos praticos de vulnerabilidades e mitigacoes.

37. **Desenvolvimento seguro de software — OWASP SAMM**
    - Instituicao: UNINOVE (Universidade Nove de Julho)
    - Link: https://bibliotecatede.uninove.br/bitstream/tede/3507/2/Dacyr%20Dante%20de%20Oliveira%20Gatto.pdf
    - Contribuicao: Dissertacao que aborda o Software Assurance Maturity Model (SAMM) da OWASP para maturidade em desenvolvimento seguro, incluindo revisao sistematica da literatura sobre secure SDLC.

### Guias Tecnicos

38. **Guia para Desenvolvimento de Software Seguro**
    - Fonte: TRT4 (Tribunal Regional do Trabalho — 4a Regiao)
    - Link: https://www.trt4.jus.br/portais/media/1730466/230309-guia-desenvolvimento_seguranca-sem_links_internos.pdf
    - Contribuicao: Guia baseado no OWASP Secure Coding Practices Quick Reference Guide, adaptado para o contexto brasileiro. Cobre aspectos de desenvolvimento seguro para solucoes e servicos web.

39. **Primeiros passos para Desenvolvimento Seguro de Aplicacoes Web**
    - Fonte: SBC (Sociedade Brasileira de Computacao) — SBSeg
    - Link: https://sol.sbc.org.br/index.php/sbseg_estendido/article/download/4162/4091/
    - Contribuicao: Artigo publicado no Simposio Brasileiro de Seguranca da Informacao (SBSeg), abordando primeiros passos para desenvolvimento seguro de aplicacoes web.

---

## Otimizacao & Performance

> **Lacuna identificada**: As regras da COLMEIA cobriam apenas selecao de modelos de IA — nao otimizacao de codigo. Faltavam analise de complexidade Big-O, profiling, caching, lazy loading e otimizacao de queries.

### Livros Fundamentais

40. **High-Performance Python: Practical Performant Programming for Humans**
    - Autores: Micha Gorelick, Ian Ozsvald
    - Link: https://www.oreilly.com/library/view/high-performance-python/9781492055013/
    - Contribuicao: Guia abrangente cobrindo profiling, tecnicas de otimizacao, paralelizacao, e uso eficiente de memoria. Aplicavel a qualquer linguagem como referencia conceitual de profiling e benchmarking.

41. **Optimized C++: Proven Techniques for Heightened Performance**
    - Autor: Kurt Guntheroth
    - Link: https://www.amazon.com/Optimized-Proven-Techniques-Heightened-Performance/dp/1491922060
    - Contribuicao: Principios de performance tuning aplicaveis a qualquer linguagem: localizacao de hot spots com profiler, otimizacao de alocacao de memoria, storage optimization (cache, memoria, I/O).

42. **Java Performance: The Definitive Guide**
    - Autor: Scott Oaks
    - Contribuicao: Profiling avancado com Flight Recorder e Mission Control. Capitulos sobre garbage collection, JIT compilation e otimizacao de memoria aplicaveis conceitualmente a qualquer runtime.

### Conceitos-Chave para Agentes

43. **Analise de Complexidade Algoritmica (Big-O)**
    - Fonte: Referencia consolidada da industria
    - Contribuicao: Escolher algoritmos eficientes (ex: substituir O(n²) por O(n log n)) melhora significativamente a performance em aplicacoes data-intensive. Avaliar complexidade de tempo e espaco para cada decisao de implementacao.
    - Relevancia para COLMEIA: O code-reviewer e architect agents devem avaliar complexidade algoritmica ao revisar codigo e propor solucoes.

44. **Software Performance Optimization: Expert Guide**
    - Fonte: Sedai, 2025
    - Link: https://sedai.io/blog/software-performance-optimization-expert-guide
    - Contribuicao: Guia abrangente cobrindo code profiling (CPU, memoria, tempo de execucao), caching strategies, lazy loading, database query optimization, e parallel processing.
    - Relevancia para COLMEIA: Referencia pratica para performance review nos agentes code-reviewer e architect.

---

## Design System

> **Lacuna identificada**: A COLMEIA nao possuia nenhuma cobertura de Design System. O frontend-engineer menciona Tailwind CSS e componentes React, mas nao abordava Atomic Design, Design Tokens, Component Libraries ou Style Guides.

### Livros e Metodologias

45. **Atomic Design**
    - Autor: Brad Frost
    - Link: https://atomicdesign.bradfrost.com/ (gratuito online)
    - Contribuicao: Metodologia que organiza interfaces em 5 niveis hierarquicos: Atoms (elementos HTML basicos) → Molecules (grupos funcionais) → Organisms (secoes de interface) → Templates (layouts) → Pages (instancias reais). Cria vocabulario compartilhado entre design e desenvolvimento.
    - Relevancia para COLMEIA: Fundamenta a organizacao de componentes React no frontend-engineer agent. Padrao para estrutura de component libraries.

46. **Design Tokens: The Complete Guide**
    - Autores: Brad Frost, Ian Frost
    - Link: https://designtokenscourse.com
    - Contribuicao: Curso sobre sistemas de tokens escalaveis para lidar com complexidade multi-brand e multi-product. Tokens definem cores, espacamentos, tipografia e sombras como variaveis centralizadas.
    - Relevancia para COLMEIA: Complementa Tailwind CSS com gerenciamento de tokens para projetos de maior escala.

47. **Front-End Style Guides**
    - Autora: Anna Debenham
    - Contribuicao: Vantagens de criar style guides, incluindo educacao da equipe, consistencia visual, e reducao de retrabalho. Aborda ferramentas como Storybook para documentacao de componentes.

### TCCs e Artigos Academicos

48. **Desenvolvimento e teste de componentes de interface acessiveis para um Design System**
    - Instituicao: UFSC (Universidade Federal de Santa Catarina)
    - Link: https://repositorio.ufsc.br/handle/123456789/197794
    - Contribuicao: TCC que combina Design System com acessibilidade, desenvolvendo e testando componentes de interface que seguem diretrizes WCAG.
    - Relevancia para COLMEIA: Referencia que une Design System + a11y, duas lacunas identificadas na COLMEIA.

---

## Acessibilidade (a11y)

> **Lacuna identificada**: A COLMEIA mencionava ARIA labels e HTML semantico em constraints superficiais, sem agente dedicado ou referencia a WCAG/eMAG.

### Padroes Oficiais

49. **WCAG 2.2 — Web Content Accessibility Guidelines**
    - Fonte: W3C / Web Accessibility Initiative (WAI)
    - Link: https://www.w3.org/WAI/standards-guidelines/wcag/
    - Contribuicao: Diretrizes organizadas em 4 principios fundamentais — POUR: Perceivable (perceptivel), Operable (operavel), Understandable (compreensivel), Robust (robusto). Tres niveis de conformidade: A (minimo), AA (padrao legal), AAA (maximo). WCAG 2.2 e padrao ISO/IEC 40500:2025.
    - Relevancia para COLMEIA: Nivel AA deve ser o alvo padrao do frontend-engineer agent. Base para futuro agente de acessibilidade.

50. **WCAG 2.2 em Portugues (Traducao Oficial W3C Brasil)**
    - Fonte: W3C Brasil
    - Link: https://www.w3c.br/traducoes/wcag/wcag22-pt-BR/
    - Contribuicao: Versao brasileira oficial das diretrizes de acessibilidade, facilitando adocao em projetos nacionais.

51. **eMAG — Modelo de Acessibilidade em Governo Eletronico**
    - Fonte: Governo Federal do Brasil
    - Link: https://guia-wcag.com/
    - Contribuicao: Adaptacao brasileira da WCAG para o governo. Inclui checklists de acessibilidade e recomendacoes especificas para o contexto nacional. Obrigatorio para sites governamentais (Lei 13.146/2015 — Lei Brasileira de Inclusao).
    - Relevancia para COLMEIA: Referencia essencial para projetos que atendem orgaos publicos brasileiros.

### Artigos Academicos

52. **Analise de acessibilidade dos principais sites de e-commerce brasileiro**
    - Publicacao: EnGeTec 2021 (FATEC ZL)
    - Link: https://www.fateczl.edu.br/engetec/engetec_2021/4_EnGeTec_paper_75.pdf
    - Contribuicao: Estudo que verifica se os principais sites de e-commerce brasileiro seguem WCAG e eMAG. Demonstra lacunas reais de acessibilidade no mercado.

---

## Arquitetura de Software

> **Lacuna identificada**: O agente architect existe, mas sem referencias teoricas solidas a DDD, Clean Architecture ou System Design.

### Livros Fundamentais

53. **Clean Architecture: A Craftsman's Guide to Software Structure and Design**
    - Autor: Robert C. Martin
    - Link: https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164
    - Contribuicao: Aplica principios SOLID ao nivel de sistema. Define a "Dependency Rule" — dependencias apontam para dentro (dominio), nunca para frameworks ou infraestrutura. Organiza codigo em camadas: Entities → Use Cases → Interface Adapters → Frameworks.
    - Relevancia para COLMEIA: Fundamenta as decisoes do architect agent. Complementa a Hexagonal Architecture ja referenciada.

54. **Domain-Driven Design: Tackling Complexity in the Heart of Software**
    - Autor: Eric Evans (o "Blue Book")
    - Link: https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215
    - Contribuicao: Abordagem que modela software a partir do dominio de negocio. Conceitos-chave: Bounded Contexts, Aggregates, Entities, Value Objects, Repositories, Domain Events, Ubiquitous Language.
    - Relevancia para COLMEIA: Referencia para o architect agent ao modelar dominios complexos. Base teorica para o padrao Repository ja usado nas stacks de backend.

55. **Software Architecture: The Hard Parts — Modern Trade-Off Analyses for Distributed Architectures**
    - Autores: Neal Ford, Mark Richards, Pramod Sadalage, Zhamak Dehghani
    - Link: https://www.oreilly.com/library/view/software-architecture-the/9781492086888/
    - Contribuicao: Ensina a pensar criticamente sobre trade-offs em arquiteturas distribuidas: decomposicao de servicos, integracao, dados distribuidos, transacoes.
    - Relevancia para COLMEIA: Referencia para decisoes arquiteturais em projetos que escalam alem do monolito.

56. **Software Architecture in Practice (4th Edition)**
    - Autores: Len Bass, Paul Clements, Rick Kazman
    - Link: https://www.amazon.com/Software-Architecture-Practice-4th/dp/0136886094
    - Contribuicao: Referencia academica sobre o que e arquitetura de software e por que ela importa. Ensina a projetar, instanciar, analisar, evoluir e gerenciar arquitetura de forma disciplinada.
    - Relevancia para COLMEIA: Base academica para o architect agent, especialmente para Quality Attribute Scenarios e Architecture Decision Records (ADRs).

---

## API Design

> **Lacuna identificada**: O backend-engineer implementa endpoints mas nao havia agente dedicado a design de API — contratos, versionamento, paginacao e padroes REST.

### Livros e Padroes

65. **RESTful Web APIs: Services for a Changing World**
    - Autores: Leonard Richardson, Mike Amundsen, Sam Ruby
    - Link: https://www.oreilly.com/library/view/restful-web-apis/9781449359713/
    - Contribuicao: Referencia definitiva em design de APIs RESTful. Cobre Richardson Maturity Model (Level 0-3), hypermedia, media types e collection patterns. Ensina a projetar APIs que evoluem sem quebrar clientes.
    - Relevancia para COLMEIA: Fundamenta o api-designer agent com principios de REST maturity e evolucao de contratos.

66. **API Design Patterns**
    - Autor: JJ Geewax (Google)
    - Link: https://www.manning.com/books/api-design-patterns
    - Contribuicao: 30+ patterns para design de APIs baseados na experiencia do Google. Cobre naming conventions, paginacao (cursor vs offset), filtering, versionamento, long-running operations e error handling (RFC 7807).
    - Relevancia para COLMEIA: Catalogo de patterns para o api-designer agent aplicar em design de contratos.

67. **OpenAPI Specification 3.1**
    - Fonte: OpenAPI Initiative (Linux Foundation)
    - Link: https://spec.openapis.org/oas/v3.1.0
    - Contribuicao: Padrao aberto para descricao de APIs RESTful. Permite contract-first development, geracao automatica de SDKs, documentacao interativa (Swagger UI) e validacao de schemas.
    - Relevancia para COLMEIA: Formato padrao para documentacao de API gerada pelo api-designer agent.

---

## UX & Usabilidade

> **Lacuna identificada**: A COLMEIA nao possuia nenhum agente dedicado a avaliacao de experiencia do usuario, heuristicas de usabilidade ou analise de fluxos.

### Livros e Metodologias

68. **10 Usability Heuristics for User Interface Design**
    - Autor: Jakob Nielsen (Nielsen Norman Group)
    - Link: https://www.nngroup.com/articles/ten-usability-heuristics/
    - Contribuicao: As 10 heuristicas de usabilidade mais influentes da industria: visibilidade do status, correspondencia sistema-mundo real, controle do usuario, consistencia, prevencao de erros, reconhecimento vs memorizacao, flexibilidade, design minimalista, recuperacao de erros, ajuda.
    - Relevancia para COLMEIA: Framework primario de avaliacao do ux-reviewer agent.

69. **Don't Make Me Think, Revisited**
    - Autor: Steve Krug
    - Link: https://www.amazon.com/Dont-Make-Think-Revisited-Usability/dp/0321965515
    - Contribuicao: Principios de usabilidade web intuitiva. "Se algo requer instrucoes para ser usado, esta mal projetado." Ensina testes de usabilidade rapidos (guerrilla testing) e design auto-evidente.
    - Relevancia para COLMEIA: Filosofia de simplicidade para o ux-reviewer agent — interfaces devem ser auto-explicativas.

70. **The Design of Everyday Things**
    - Autor: Don Norman
    - Link: https://www.amazon.com/Design-Everyday-Things-Revised-Expanded/dp/0465050654
    - Contribuicao: Fundamentos de design centrado no usuario: affordances, signifiers, mapping, feedback, conceptual models. Explica por que produtos mal projetados frustram usuarios e como evitar isso.
    - Relevancia para COLMEIA: Base teorica para analise de interacao e feedback no ux-reviewer agent.

### Artigos Academicos

71. **Avaliacao Heuristica de Usabilidade em Interfaces de Aplicacoes para Dispositivos Moveis**
    - Publicacao: UFMG (Universidade Federal de Minas Gerais)
    - Link: https://repositorio.ufmg.br/handle/1843/ESBF-9NVFVK
    - Contribuicao: TCC que aplica heuristicas de Nielsen adaptadas para mobile, com checklist de avaliacao sistematica.
    - Relevancia para COLMEIA: Referencia academica para avaliacao de UX mobile no ux-reviewer agent.

---

## Incident Management

> **Lacuna identificada**: A COLMEIA tinha agente de monitoring-setup mas nenhum agente dedicado a resposta a incidentes, classificacao de severidade, postmortems ou gestao de error budget em tempo real.

### Guias e Frameworks

72. **PagerDuty Incident Response Guide**
    - Fonte: PagerDuty
    - Link: https://response.pagerduty.com/
    - Contribuicao: Guia open-source de resposta a incidentes. Cobre roles (Incident Commander, Subject Matter Expert, Scribe), severidades (SEV1-SEV5), escalacao, comunicacao durante crise e postmortem blameless.
    - Relevancia para COLMEIA: Framework operacional para o incident-responder agent.

73. **Postmortem Culture: Learning from Failure (Google SRE)**
    - Fonte: Google SRE Book, Chapter 15
    - Link: https://sre.google/sre-book/postmortem-culture/
    - Contribuicao: Capitulo dedicado a postmortems blameless: como conduzir, template, acoes corretivas, e como criar cultura de aprendizado com falhas. Enfatiza que postmortems sao para SISTEMAS, nao para pessoas.
    - Relevancia para COLMEIA: Template e filosofia de postmortem para o incident-responder agent.

74. **Managing Incidents (Google SRE Workbook)**
    - Fonte: Google SRE Workbook, Chapter 9
    - Link: https://sre.google/workbook/incident-response/
    - Contribuicao: Guia pratico de gestao de incidentes: declaracao, coordenacao, comunicacao, resolucao e handoff. Inclui exemplos reais e checklists operacionais.
    - Relevancia para COLMEIA: Processo de resposta estruturado para o incident-responder agent.

---

## Testing Methodology

> **Lacuna identificada**: O agente tdd-guide cobria TDD basico (RED-GREEN-REFACTOR) mas sem referencias a test patterns, test smells, testing pyramid, contract testing ou mutation testing.

### Livros Fundamentais

75. **xUnit Test Patterns: Refactoring Test Code**
    - Autor: Gerard Meszaros
    - Link: https://martinfowler.com/books/meszaros.html
    - Contribuicao: Guia definitivo com 68 patterns para automacao de testes e 18 "test smells" com troubleshooting. Cobre fixture management, result verification e test doubles (mocks, stubs, fakes, spies).
    - Relevancia para COLMEIA: Catalogo de patterns para o tdd-guide agent. Base para deteccao de test smells no code-reviewer.

76. **Growing Object-Oriented Software, Guided by Tests**
    - Autores: Steve Freeman, Nat Pryce
    - Link: https://growing-object-oriented-software.com/
    - Contribuicao: Mostra como TDD funciona em multiplos niveis (unitario, integracao, aceitacao) com exemplos completos. Usa Mock Objects para descobrir relacoes entre objetos. Vencedores do Agile Alliance Gordon Pask Award.
    - Relevancia para COLMEIA: Complementa o workflow RED-GREEN-REFACTOR do tdd-guide com TDD em escala real.

77. **Working Effectively with Legacy Code**
    - Autor: Michael Feathers
    - Link: https://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052
    - Contribuicao: Define legacy code como "codigo sem testes". Fornece 24 tecnicas de dependency-breaking e o modelo de "seams" para modificar codigo legado com seguranca. Complementa Refactoring (Fowler).
    - Relevancia para COLMEIA: Referencia para refactor-cleaner e tdd-guide ao lidar com codigo existente sem cobertura de testes.

### Artigos e Conceitos

78. **Testing Pyramid vs Testing Trophy**
    - Fontes: Martin Fowler (Test Shapes), Kent C. Dodds (Testing Trophy)
    - Links: https://martinfowler.com/articles/2021-test-shapes.html | https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications
    - Contribuicao: Perspectivas modernas sobre distribuicao de testes. A Testing Trophy enfatiza testes de integracao sobre unitarios, com analise estatica como fundacao. Orienta onde investir esforco de teste.
    - Relevancia para COLMEIA: Guia estrategico para o tdd-guide agent na distribuicao de esforco de teste.

79. **Consumer-Driven Contract Testing (Pact)**
    - Fonte: Pact Foundation
    - Link: https://docs.pact.io/
    - Contribuicao: Padrao de facto para testar compatibilidade entre microservicos de forma isolada. Consumidor define contratos, permitindo desenvolvimento independente e prevenindo quebras de integracao.
    - Relevancia para COLMEIA: Referencia para tdd-guide e backend-engineer em arquiteturas de microservicos.

---

## Technical Writing & Documentacao

> **Lacuna identificada**: A COLMEIA tinha 4 agentes de documentacao (doc-writer, readme-generator, changelog-writer, doc-updater) mas NENHUM com referencia a padroes de escrita tecnica.

### Guias e Frameworks

80. **Google Technical Writing Guide**
    - Fonte: Google Developers
    - Link: https://developers.google.com/tech-writing
    - Contribuicao: Curso oficial que engenheiros do Google seguem. Cobre sentencas curtas, voz ativa, tempo presente, listas e tabelas efetivas, escolha de palavras precisas. Inclui Style Guide completo.
    - Relevancia para COLMEIA: Padrao de qualidade para todos os agentes de documentacao.

81. **Diataxis Documentation Framework**
    - Fonte: Daniele Procida
    - Link: https://diataxis.fr/
    - Contribuicao: Framework sistematico que organiza documentacao em 4 tipos: Tutorials (aprendizado), How-To Guides (tarefas), Reference (informacao), Explanation (entendimento). Adotado por Canonical, Django e outros.
    - Relevancia para COLMEIA: Estrutura para o doc-writer e doc-updater organizarem documentacao por proposito.

82. **Docs as Code + Keep a Changelog + Conventional Commits**
    - Fontes: Anne Gentle (Docs as Code), Keep a Changelog, Conventional Commits
    - Links: https://www.docslikecode.com/ | https://keepachangelog.com/ | https://www.conventionalcommits.org/
    - Contribuicao: Docs as Code trata documentacao como codigo (versionamento, CI/CD, reviews). Keep a Changelog padroniza formato de changelogs. Conventional Commits padroniza mensagens de commit para geracao automatica.
    - Relevancia para COLMEIA: Base para changelog-writer (Keep a Changelog) e readme-generator (Docs as Code).

---

## Prompt Engineering

> **Lacuna identificada**: Os agentes ai-agents/ (agent-designer, prompt-engineer, mcp-integrator) e meta/ (claude-md-optimizer) nao possuiam NENHUMA referencia a tecnicas de prompt engineering.

### Papers e Guias Oficiais

83. **Chain-of-Thought Prompting Elicits Reasoning in Large Language Models**
    - Autores: Jason Wei, Xuezhi Wang, et al. (Google Research)
    - Link: https://arxiv.org/abs/2201.11903
    - Contribuicao: Paper seminal demonstrando que gerar passos intermediarios de raciocinio melhora significativamente a performance de LLMs em tarefas complexas. Fundamento de tecnicas modernas de prompting.
    - Relevancia para COLMEIA: Base teorica para o prompt-engineer e para o design de system prompts dos agentes.

84. **Anthropic Claude Prompt Engineering — Best Practices**
    - Fonte: Anthropic
    - Link: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices
    - Contribuicao: Guia oficial para Claude incluindo estruturacao com XML, otimizacao de contexto longo (documentos primeiro), thinking patterns e tool use. Tutorial interativo de 9 capitulos.
    - Relevancia para COLMEIA: Referencia direta para todos os agentes (framework e construido sobre Claude) e para o claude-md-optimizer.

85. **Model Context Protocol (MCP) Specification**
    - Fonte: Anthropic
    - Link: https://modelcontextprotocol.io/
    - Contribuicao: Protocolo aberto para conectar LLMs a fontes de dados e ferramentas externas. Define transports (stdio, HTTP+SSE), capabilities (tools, resources, prompts) e lifecycle de sessao.
    - Relevancia para COLMEIA: Especificacao tecnica para o mcp-integrator agent.

---

## Debugging

> **Lacuna identificada**: O agente debug-investigator existia sem referencia a metodologias sistematicas de debugging.

### Livro Fundamental

86. **Debugging: The 9 Indispensable Rules for Finding Even the Most Elusive Software and Hardware Problems**
    - Autor: David J. Agans
    - Link: https://www.amazon.com/Debugging-Indispensable-Software-Hardware-Problems/dp/0814474578
    - Contribuicao: 9 regras sistematicas: Understand the System, Make It Fail, Quit Thinking and Look, Divide and Conquer, Change One Thing at a Time, Keep an Audit Trail, Check the Plug, Get a Fresh View, If You Didn't Fix It It Ain't Fixed.
    - Relevancia para COLMEIA: Framework metodologico para o debug-investigator e build-error-resolver agents.

---

## Code Review

> **Lacuna identificada**: O agente code-reviewer era embasado em Clean Code e Refactoring mas sem referencias a praticas de code review em si (processo, metricas, limites).

### Guias da Industria

87. **Google Engineering Practices — Code Review Guide**
    - Fonte: Google
    - Link: https://google.github.io/eng-practices/review/
    - Contribuicao: Guia oficial focando em design, funcionalidade, complexidade, testes e naming. Principio-chave: "Nao existe codigo perfeito — apenas codigo melhor." Melhoria continua sobre perfeicao.
    - Relevancia para COLMEIA: Processo e filosofia de review para o code-reviewer agent.

88. **SmartBear Code Review Study (Cisco)**
    - Fonte: SmartBear / Cisco Systems
    - Link: https://static0.smartbear.co/support/media/resources/cc/book/code-review-cisco-case-study.pdf
    - Contribuicao: Maior estudo de code review (10 meses, 2.500 reviews, 3.2M LOC). Descobertas: tamanho ideal de review e 200-400 LOC, eficacia cai apos 60-90 minutos ou 500 LOC/hora. Fundamenta limites praticos.
    - Relevancia para COLMEIA: Metricas e limites para o code-reviewer agent (scope de review otimo).

---

## Container Security

> **Lacuna identificada**: O agente docker-specialist cobria Dockerfiles e Docker Swarm mas sem referencias a seguranca de containers.

### Padroes e Benchmarks

89. **CIS Docker Benchmark**
    - Fonte: Center for Internet Security (CIS)
    - Link: https://www.cisecurity.org/benchmark/docker
    - Ferramenta: https://github.com/docker/docker-bench-security
    - Contribuicao: Configuracoes seguras reconhecidas globalmente para Docker host, daemon, imagens e runtime. Ferramenta automatizada de avaliacao disponivel. Requerido para compliance NIST SP 800-190.
    - Relevancia para COLMEIA: Benchmark de seguranca para o docker-specialist e security-reviewer agents.

90. **NIST SP 800-190 — Application Container Security Guide**
    - Fonte: National Institute of Standards and Technology (NIST)
    - Link: https://csrc.nist.gov/pubs/sp/800/190/final
    - Contribuicao: Diretrizes oficiais de seguranca de containers cobrindo image security, registry security, orchestrator security e runtime security. Padrao de referencia para compliance.
    - Relevancia para COLMEIA: Base normativa para validacao de seguranca no docker-specialist agent.

---

## Event-Driven Architecture

> **Lacuna identificada**: O agente architect mencionava Event-Driven como padrao mas sem referencias a patterns de EDA, CQRS ou Event Sourcing.

### Livros e Artigos

91. **Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions**
    - Autores: Gregor Hohpe, Bobby Woolf
    - Link: https://www.enterpriseintegrationpatterns.com/
    - Contribuicao: "Biblia" de arquitetura orientada a mensagens — 65 patterns para messaging assincrono e integracao de servicos. Notacao visual de referencia. 90.000+ copias vendidas, relevante para cloud e IoT.
    - Relevancia para COLMEIA: Catalogo de patterns para o architect e backend-engineer ao projetar sistemas event-driven.

92. **Event-Driven Architecture: Event Sourcing, CQRS**
    - Autor: Martin Fowler
    - Links: https://martinfowler.com/articles/201701-event-driven.html | https://martinfowler.com/eaaDev/EventSourcing.html | https://martinfowler.com/bliki/CQRS.html
    - Contribuicao: Artigos definitivos sobre Event Notification, Event-Carried State Transfer, Event Sourcing e CQRS. Clarifica os muitos significados de "event-driven" e quando usar cada pattern.
    - Relevancia para COLMEIA: Referencia para decisoes arquiteturais de EDA no architect agent.

---

## Technical Debt

> **Lacuna identificada**: O agente refactor-cleaner trabalhava com code smells mas sem referencia ao conceito de divida tecnica e sua gestao.

### Conceitos e Livros

93. **Technical Debt — Ward Cunningham's Metaphor**
    - Fontes: Martin Fowler (bliki), Agile Alliance
    - Links: https://martinfowler.com/bliki/TechnicalDebt.html | https://www.agilealliance.org/wp-content/uploads/2016/05/IntroductiontotheTechnicalDebtConcept-V-02.pdf
    - Contribuicao: Metafora original de 1992: "Entregar codigo pela primeira vez e como contrair uma divida." Decisoes arquiteturais sao a principal fonte, com pressao de prazo como causa mais citada. Fowler categoriza em 4 quadrantes: prudente/imprudente × deliberada/inadvertida.
    - Relevancia para COLMEIA: Framework conceitual para o refactor-cleaner e architect avaliarem e priorizarem divida tecnica.

---

## Developer Experience (DX)

> **Lacuna identificada**: Os agentes planner e orchestrator coordenavam trabalho mas sem referencias a produtividade de desenvolvedor ou metricas de experiencia.

### Frameworks e Pesquisa

94. **SPACE Framework for Developer Productivity**
    - Autores: Nicole Forsgren (GitHub), Margaret-Anne Storey (U. Victoria), Chandra Maddila, Thomas Zimmermann, Brian Houck, Jenna Butler (Microsoft Research)
    - Link: https://queue.acm.org/detail.cfm?id=3454124
    - Contribuicao: Framework medindo 5 dimensoes: Satisfaction (satisfacao), Performance (resultado), Activity (atividade), Communication (colaboracao), Efficiency (eficiencia). Times melhoram 20-30% ao medir todas as dimensoes. Publicado no ACM Queue.
    - Relevancia para COLMEIA: Metricas de produtividade para o planner e orchestrator agents.

---

## Sistemas Distribuidos & Dados

> **Lacuna identificada**: A COLMEIA nao cobria explicitamente sistemas distribuidos, replicacao, consistencia eventual ou design de sistemas data-intensive.

### Livros Fundamentais

57. **Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems**
    - Autor: Martin Kleppmann
    - Link: https://www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable/dp/1449373321
    - Contribuicao: Considerada a "biblia" de sistemas de dados. Cobre modelos de dados, storage engines, replicacao, particionamento, transacoes, consistencia, batch/stream processing. Segunda edicao revisada para refletir mudancas da ultima decada.
    - Relevancia para COLMEIA: Referencia para o architect agent ao projetar sistemas que envolvem PostgreSQL, Redis, filas e cache. Fundamenta decisoes de consistencia e escalabilidade.

58. **Database Reliability Engineering: Designing and Operating Resilient Database Systems**
    - Autoras: Laine Campbell, Charity Majors
    - Link: https://www.amazon.com/Database-Reliability-Engineering-Designing-Operating/dp/1491925949
    - Contribuicao: Aplica principios de SRE especificamente a sistemas de banco de dados. Cobre failover, replicacao, backup, monitoramento e operacao de bancos em producao.
    - Relevancia para COLMEIA: Complementa a stack de PostgreSQL com praticas operacionais de resiliencia.

---

## SRE, Observabilidade & DevOps

> **Lacuna identificada**: O agente monitoring-setup existia mas com profundidade limitada. Faltavam referencias a SRE, os 3 pilares da observabilidade, e cultura DevOps.

### Livros Fundamentais

59. **Site Reliability Engineering: How Google Runs Production Systems**
    - Autores: Betsy Beyer, Chris Jones, Jennifer Petoff, Niall Richard Murphy
    - Link: https://www.amazon.com/Site-Reliability-Engineering-Production-Systems/dp/149192912X
    - Disponivel gratuitamente: https://sre.google/sre-book/
    - Contribuicao: Define a disciplina de SRE — como o Google gerencia sistemas em producao. Conceitos-chave: SLOs, SLIs, SLAs, error budgets, toil reduction, incident management, postmortems.
    - Relevancia para COLMEIA: Fundamenta o monitoring-setup agent com metricas e praticas de producao.

60. **The Site Reliability Workbook: Practical Ways to Implement SRE**
    - Autores: Betsy Beyer, Niall Richard Murphy, David K. Rensin
    - Link: https://www.amazon.com/Site-Reliability-Workbook-Practical-Implement/dp/1492029505
    - Contribuicao: Guia pratico para implementacao de SRE — complementa o livro teorico com exemplos concretos e exercicios.

61. **The Phoenix Project: A Novel About IT, DevOps, and Helping Your Business Win**
    - Autores: Gene Kim, Kevin Behr, George Spafford
    - Link: https://www.amazon.com/Phoenix-Project-DevOps-Helping-Business/dp/1942788290
    - Contribuicao: Romance que ilustra a transformacao DevOps. Introduz os Three Ways: flow, feedback, e aprendizado continuo.

62. **Accelerate: The Science of Lean Software and DevOps**
    - Autores: Nicole Forsgren, Jez Humble, Gene Kim
    - Link: https://www.amazon.com/Accelerate-Software-Performing-Technology-Organizations/dp/1942788339
    - Contribuicao: Pesquisa com dados de 23.000+ profissionais. Define as 4 metricas DORA: deployment frequency, lead time for changes, change failure rate, mean time to recovery. Prova estatistica de que praticas DevOps melhoram performance organizacional.
    - Relevancia para COLMEIA: Referencia para metricas de sucesso do ci-cd-designer agent.

63. **Team Topologies: Organizing Business and Technology Teams for Fast Flow**
    - Autores: Matthew Skelton, Manuel Pais
    - Link: https://www.amazon.com/Team-Topologies-Organizing-Business-Technology/dp/1942788819
    - Contribuicao: Define 4 tipos de time (Stream-aligned, Platform, Enabling, Complicated Subsystem) e 3 modos de interacao (Collaboration, X-as-a-Service, Facilitating). Alinha estrutura organizacional com arquitetura de software (Lei de Conway).
    - Relevancia para COLMEIA: Referencia para organizacao de times em projetos maiores. Inspira a categorizacao dos agentes por responsabilidade.

### Artigos e Recursos

64. **Observabilidade em Sistemas de Software: Praticas, Tecnicas e Ferramentas**
    - Fonte: WoMakersCode / DEV Community
    - Link: https://dev.to/womakerscode/observabilidade-em-sistemas-de-software-praticas-tecnicas-e-ferramentas-2g5n
    - Contribuicao: Artigo em portugues sobre os 3 pilares da observabilidade (metricas, logs, traces — o "Triangulo Dourado"). Cobre ferramentas como ELK Stack, Prometheus, Grafana e Jaeger.
    - Relevancia para COLMEIA: Referencia pratica em portugues para o monitoring-setup agent.

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

22. **OWASP Top 10 (2021/2025)**
    - Fonte: OWASP Foundation
    - Link: https://owasp.org/www-project-top-ten/
    - Contribuicao: Lista das 10 vulnerabilidades mais criticas em aplicacoes web. Versao 2025 disponivel em https://clavis.com.br/blog/owasp-top-10-2025/
    - Relevancia para COLMEIA: Checklist do security-reviewer agent. Complementado pelo OWASP ASVS (#32) e guias de secure SDLC (#35–#39) na secao Seguranca.

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

---

## Resumo de Cobertura

| Area | Referencias | Status |
|------|-------------|--------|
| Sistemas Multi-Agente para Eng. de Software | #1–#11 | Original |
| Sistemas Adaptativos e Configuracao por Contexto | #12–#14 | Original |
| Padroes da Industria | #15–#17 | Original |
| Frameworks de Referencia | #18–#20 | Original |
| Padroes Arquiteturais | #21–#22 | Original |
| AI-led SDLC | #23–#24 | Original |
| **Codigo Limpo & Boas Praticas** | **#25–#31** | **Novo** |
| **Seguranca (ASVS, SAMM, Secure SDLC)** | **#32–#39** | **Novo** |
| **Otimizacao & Performance** | **#40–#44** | **Novo** |
| **Design System** | **#45–#48** | **Novo** |
| **Acessibilidade (a11y)** | **#49–#52** | **Novo** |
| **Arquitetura de Software (DDD, Clean Arch)** | **#53–#56** | **Novo** |
| **API Design** | **#65–#67** | **Novo** |
| **UX & Usabilidade** | **#68–#71** | **Novo** |
| **Incident Management** | **#72–#74** | **Novo** |
| **Testing Methodology** | **#75–#79** | **Novo** |
| **Technical Writing & Documentacao** | **#80–#82** | **Novo** |
| **Prompt Engineering** | **#83–#85** | **Novo** |
| **Debugging** | **#86** | **Novo** |
| **Code Review** | **#87–#88** | **Novo** |
| **Container Security** | **#89–#90** | **Novo** |
| **Event-Driven Architecture** | **#91–#92** | **Novo** |
| **Technical Debt** | **#93** | **Novo** |
| **Developer Experience (DX)** | **#94** | **Novo** |
| **Sistemas Distribuidos & Dados** | **#57–#58** | **Novo** |
| **SRE, Observabilidade & DevOps** | **#59–#64** | **Novo** |

**Total: 94 referencias** (24 originais + 70 novas)

*Ultima atualizacao: Marco 2026*
