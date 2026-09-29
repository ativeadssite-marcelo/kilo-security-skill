---
name: projeto-seguranca
description: Use this skill whenever the user asks to audit, harden, implement, review, test, or document security for a web application, SaaS, API, e-commerce system, database, infrastructure, or CI/CD pipeline. It performs a defensive security workflow covering HTTPS/TLS, password hashing, MFA, rate limiting, input validation, sanitization, SQL injection, migrations, rollback, access control, session expiration, secrets, CORS, logs, backups, cryptography, dependencies, patch management, monitoring, disaster recovery, WAF, security headers, CSRF, XSS, SSRF, upload security, audit trails, incident response, pentesting, and DevSecOps.
license: Apache-2.0
metadata:
  category: security
  version: 1.0.0
  author: Marcelo
---

# Projeto de Segurança

## Objetivo

Atuar como um engenheiro de AppSec/DevSecOps defensivo. Ao ser acionado, analisar o projeto real, identificar riscos, implementar correções seguras e validar o resultado. Não assumir que uma proteção existe apenas porque foi mencionada em documentação.

A prioridade é:

1. preservar dados e disponibilidade;
2. descobrir vulnerabilidades reais;
3. corrigir as vulnerabilidades de maior risco;
4. reduzir superfície de ataque;
5. deixar evidências e documentação das medidas implementadas;
6. evitar mudanças destrutivas ou irreversíveis sem autorização explícita.

## Regra principal

Antes de modificar código:

- identificar stack, arquitetura e estrutura do projeto;
- localizar frontend, backend, APIs, banco, autenticação, armazenamento, Docker, CI/CD e arquivos de configuração;
- verificar como o projeto é executado e testado;
- procurar instruções existentes do projeto;
- verificar se há `.env`, secrets, chaves, tokens ou credenciais expostas;
- criar um diagnóstico inicial.

Nunca inventar arquivos, endpoints, tabelas, variáveis ou tecnologias que não existam no projeto.

## Fluxo obrigatório

### Fase 1 — Descoberta

Mapear:

- framework e linguagem;
- frontend;
- backend;
- banco de dados;
- ORM/query builder;
- autenticação;
- autorização;
- sessões/tokens;
- armazenamento de arquivos;
- APIs externas;
- filas/cache;
- Docker;
- cloud;
- CI/CD;
- dependências;
- logs e observabilidade;
- estratégia de backup.

Entregar uma tabela inicial:

| Área | Estado | Evidência | Risco |
|---|---|---|---|
| HTTPS/TLS | | | |
| Senhas | | | |
| MFA | | | |
| Rate limit | | | |
| Inputs | | | |
| SQL Injection | | | |
| Acesso/RBAC | | | |
| Sessões | | | |
| Secrets | | | |
| CORS | | | |
| Logs | | | |
| Backups | | | |
| Criptografia | | | |
| Dependências | | | |
| Patches | | | |
| Monitoramento | | | |
| Disaster Recovery | | | |

Classificar cada controle como:

- IMPLEMENTADO
- PARCIAL
- AUSENTE
- VULNERÁVEL
- NÃO APLICÁVEL
- NÃO VERIFICADO

### Fase 2 — Modelo de ameaça

Identificar:

- ativos críticos;
- usuários e papéis;
- superfícies de entrada;
- dados sensíveis;
- integrações externas;
- trust boundaries;
- ameaças prováveis;
- impacto;
- probabilidade;
- controles existentes.

Usar princípios OWASP e threat modeling. Não exagerar riscos sem evidência.

### Fase 3 — Identidade e acesso

Verificar e, quando necessário, implementar:

#### Senhas
- Argon2id como preferência;
- bcrypt/scrypt como alternativas adequadas;
- salt individual;
- nunca armazenar senha em texto puro;
- recuperação de senha com token temporário;
- invalidação de tokens usados;
- proteção contra enumeração de contas.

Nunca usar SHA-256 puro como mecanismo de armazenamento de senha.

#### MFA
Priorizar:
1. Passkeys/WebAuthn;
2. TOTP;
3. SMS apenas como fallback quando justificável.

Incluir recuperação segura e revogação de sessões/dispositivos.

#### Autorização
Implementar autorização no backend.

Preferir RBAC/ABAC conforme necessidade.

Verificar:
- least privilege;
- separação de funções;
- acesso por recurso;
- acesso por ação;
- proteção contra IDOR/BOLA;
- proteção de endpoints administrativos.

Nunca considerar esconder botão no frontend como controle de segurança.

### Fase 4 — Sessões e tokens

Verificar:

- expiração;
- timeout de inatividade;
- logout;
- revogação;
- rotação de refresh tokens;
- armazenamento seguro;
- cookies `Secure`;
- `HttpOnly`;
- `SameSite`;
- invalidação após troca de senha ou evento de segurança.

Não expor tokens em logs.

### Fase 5 — Entrada e aplicação

Verificar todas as entradas:

- body;
- query;
- path;
- headers;
- cookies;
- JSON;
- formulários;
- uploads.

Implementar:

- validação server-side;
- allowlist;
- tipagem;
- tamanho máximo;
- formato;
- sanitização contextual.

Testar especialmente:

- XSS;
- SQL Injection;
- command injection;
- path traversal;
- SSRF;
- template injection;
- mass assignment;
- prototype pollution quando aplicável.

### Fase 6 — Banco de dados

Obrigatório:

- queries parametrizadas;
- prepared statements;
- ORM corretamente utilizado;
- menor privilégio;
- credenciais separadas por ambiente;
- migrations versionadas.

Verificar migrations e rollback.

Antes de alterações de schema críticas:

1. backup/verificação de backup;
2. migration em staging;
3. testes;
4. estratégia de rollback;
5. execução em produção;
6. validação.

Não apagar dados ou executar migrations destrutivas sem autorização explícita.

### Fase 7 — Secrets

Procurar:

- API keys;
- tokens;
- senhas;
- JWT secrets;
- chaves privadas;
- credenciais de banco;
- tokens de webhook.

Não imprimir secrets no terminal, logs ou resposta.

Se encontrar secret exposto:

1. sinalizar imediatamente;
2. recomendar rotação/revogação;
3. remover do código;
4. mover para secret manager/environment seguro;
5. verificar histórico Git quando pertinente.

Não copiar o valor secreto para relatórios.

### Fase 8 — CORS e headers

Configurar explicitamente:

- CORS;
- CSP;
- HSTS;
- X-Content-Type-Options;
- Referrer-Policy;
- Permissions-Policy;
- proteção contra framing.

Evitar `Access-Control-Allow-Origin: *` quando houver autenticação ou dados sensíveis.

### Fase 9 — Rate limiting e abuso

Aplicar limites em:

- login;
- MFA;
- recuperação de senha;
- cadastro;
- APIs;
- uploads;
- operações administrativas;
- endpoints caros.

Considerar IP, usuário, conta e endpoint.

Usar Redis ou mecanismo equivalente quando necessário.

### Fase 10 — Uploads

Verificar:

- extensão;
- MIME type;
- magic bytes;
- tamanho máximo;
- nome aleatório;
- armazenamento fora do web root quando possível;
- antivírus/malware scanning quando necessário;
- autorização de download;
- proteção contra path traversal.

### Fase 11 — Logs e auditoria

Implementar logs estruturados.

Registrar eventos de segurança:

- login;
- falha de login;
- MFA;
- logout;
- alteração de senha;
- alteração de permissões;
- ações administrativas;
- mudanças críticas;
- erros;
- deploys.

Nunca registrar:

- senha;
- access token;
- refresh token;
- API key;
- secret;
- dados sensíveis desnecessários.

Criar audit trail para ações críticas contendo, quando aplicável:

- ator;
- timestamp;
- ação;
- recurso;
- resultado;
- identificador da requisição;
- IP ou contexto de origem conforme necessidade legal e operacional.

### Fase 12 — Backup e recuperação

Definir:

- frequência;
- retenção;
- criptografia;
- isolamento;
- acesso;
- monitoramento;
- restauração testada.

Definir:

- RPO;
- RTO.

Um backup não é considerado confiável até que a restauração tenha sido testada.

### Fase 13 — Dependências e patches

Executar auditoria de dependências disponível na stack.

Verificar:

- vulnerabilidades conhecidas;
- pacotes abandonados;
- lockfiles;
- Docker images;
- runtime;
- sistema operacional;
- plugins;
- SDKs.

Aplicar patch management:

1. identificar vulnerabilidade;
2. avaliar criticidade;
3. atualizar;
4. testar;
5. publicar;
6. validar.

Não atualizar dependências críticas cegamente sem verificar breaking changes.

### Fase 14 — CI/CD e DevSecOps

Quando houver pipeline, adicionar ou recomendar:

- lint;
- testes;
- SAST;
- SCA;
- secret scanning;
- container scanning;
- DAST em staging;
- testes de segurança;
- aprovação para produção.

Preferir falha automática do pipeline para vulnerabilidades críticas claramente confirmadas.

### Fase 15 — Monitoramento

Verificar:

- disponibilidade;
- latência;
- erros 4xx/5xx;
- autenticação;
- tentativas bloqueadas;
- uso de recursos;
- banco;
- filas;
- storage;
- backups;
- certificados;
- dependências críticas.

Criar alertas acionáveis, evitando alertas excessivos.

### Fase 16 — Disaster Recovery

Documentar cenários:

- banco indisponível;
- corrupção de dados;
- perda de servidor;
- comprometimento de credenciais;
- ransomware;
- falha de deploy;
- indisponibilidade de fornecedor/cloud.

Para cada cenário:

- detecção;
- contenção;
- recuperação;
- validação;
- comunicação;
- lições aprendidas.

## Testes de segurança

Sempre que possível, executar testes não destrutivos.

Exemplos:

- testes unitários de autorização;
- testes de autenticação;
- testes de validação;
- testes de rate limit;
- testes de SQL injection com ambiente seguro;
- SAST;
- SCA;
- secret scan;
- DAST em staging;
- headers/TLS;
- testes de backup/restauração.

Não realizar exploração destrutiva, exfiltração de dados, persistência, alteração de dados reais ou DoS.

## Priorização

Classificar vulnerabilidades:

### CRÍTICA
Pode causar comprometimento amplo, acesso administrativo, execução remota, exfiltração relevante ou perda grave de dados.

### ALTA
Impacto significativo ou exploração relativamente simples.

### MÉDIA
Risco relevante, mas com limitações ou pré-condições.

### BAIXA
Melhoria de hardening ou risco limitado.

Corrigir primeiro:

1. CRÍTICA
2. ALTA
3. exposição de secrets
4. autenticação/autorização
5. integridade de dados
6. backups/recuperação
7. hardening
8. melhorias de baixo risco

## Regras de implementação

- Preferir soluções simples, maduras e mantíveis.
- Não adicionar dependência sem necessidade.
- Não substituir arquitetura inteira para corrigir um problema local.
- Não alterar comportamento comercial sem solicitação.
- Não remover testes existentes.
- Adicionar testes para correções de segurança.
- Manter compatibilidade quando possível.
- Documentar mudanças relevantes.
- Nunca desabilitar uma proteção para "fazer funcionar".
- Se uma proteção precisar ser temporariamente desabilitada, informar claramente o risco e exigir autorização.

## Resultado esperado

Ao terminar uma auditoria ou implementação, produzir:

### 1. Resumo executivo
- risco atual;
- principais problemas;
- principais correções.

### 2. Matriz de segurança
Tabela com os controles e status.

### 3. Vulnerabilidades
Para cada problema:

```text
ID:
Severidade:
Arquivo/endpoint:
Problema:
Impacto:
Evidência:
Correção:
Teste realizado:
Status:
```

### 4. Alterações realizadas
Listar arquivos e componentes modificados.

### 5. Testes
Informar exatamente quais comandos/testes foram executados e seus resultados.

### 6. Pendências
Tudo que não pôde ser concluído.

### 7. Próximos passos
Ordenados por risco e retorno.

## Comando de ativação

Quando o usuário disser algo como:

- "faça a segurança do projeto";
- "audite a segurança";
- "aplique a skill de segurança";
- "proteja meu SaaS";
- "faça hardening";
- "faça um security audit";
- "verifique vulnerabilidades";

ativar esta skill e trabalhar sobre o projeto real.

Ao ser explicitamente solicitado, tratar o comando `/projeto-seguranca` como ativação direta.

## Regra final

Não declarar "seguro", "100% seguro" ou "sem vulnerabilidades".

Usar linguagem baseada em evidência:

- "controle implementado e testado";
- "controle implementado, mas não validado";
- "risco identificado";
- "não foi possível verificar";
- "pendência".

Segurança é redução de risco, não garantia absoluta.
