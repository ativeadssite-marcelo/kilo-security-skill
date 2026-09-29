# Exemplo de Auditoria — Kilo Security Skill v1.1.0

Este documento demonstra, de ponta a ponta, como a skill `projeto-seguranca` se comporta
em uma auditoria real. O exemplo é fictício, mas segue o fluxo real da skill.

---

## 🎬 Cenário

**Usuário:**
```
/ projeto-seguranca
modo: audit
alvo: API Node.js/Express + Prisma + PostgreSQL
repo: https://github.com/exemplo/minha-api
branch: main
ambiente: staging
```

**Modo detectado:** `AUDIT` → não altera código, apenas diagnóstico.

---

## 🧭 Fase 1 — Descoberta

A skill mapeia o projeto antes de qualquer ação.

**Comandos executados (exemplo):**
```bash
cat package.json
cat tsconfig.json
ls -la src/
find . -name "*.env*" -not -path "./node_modules/*"
cat docker-compose.yml 2>/dev/null || true
ls .github/workflows/
```

**Estrutura identificada:**

| Área | Estado | Evidência |
|---|---|---|
| Stack | Node.js 20 + Express + TypeScript | `package.json` |
| ORM | Prisma | `prisma/schema.prisma` |
| Banco | PostgreSQL 15 | `docker-compose.yml` |
| Auth | JWT (jsonwebtoken) | `src/auth/*.ts` |
| Hash de senha | Argon2id | `package.json: argon2@0.31` |
| CI | GitHub Actions | `.github/workflows/ci.yml` |
| Frontend | Não aplicável | API-only |

---

## 🛡️ Fase 2 — Modelo de ameaça (STRIDE)

| Ativo | Ameaça | Impacto | Probabilidade |
|---|---|---|---|
| Tokens JWT | Spoofing | Alto | Média |
| Endpoint `/orders/:id` | Tampering / Info Disclosure | Alto | Alta |
| Senhas de usuário | Info Disclosure | Alto | Baixa |
| `JWT_SECRET` no código | Elevation of Privilege | Crítico | Alta |

**Trust boundaries:**
- Cliente → API (HTTPS)
- API → Banco (rede interna)
- API → Serviços externos (pagamento)

---

## 🔍 Fases 3 a 18 — Verificação

### Fase 3 — Identidade e acesso

**Achados:**
- ✅ Argon2id em uso
- ❌ Sem MFA
- ⚠️ Autorização feita por middleware, mas **não cobre `/orders/:id`**

### Fase 4 — Sessões

**Achados:**
- ⚠️ Cookie com `SameSite=Lax`, sem `Secure` em staging
- ✅ Expiração absoluta de 15 min para access token
- ❌ Sem rotação de refresh token

### Fase 5 — Entradas

**Achados:**
- ✅ Zod nas rotas novas
- ❌ Rotas legadas (`/orders`, `/users`) sem validação
- ❌ Sem limite de tamanho em `/upload`

### Fase 6 — Banco

**Achados:**
- ✅ Prisma ORM (queries parametrizadas)
- ✅ Migrations versionadas
- ⚠️ Credenciais compartilhadas entre staging/prod

### Fase 7 — Secrets

**Achados:**
- 🚨 `JWT_SECRET` hardcoded em `src/config/auth.ts:7`
- 🚨 Presente no histórico Git desde o commit inicial

### Fase 8 — CORS e headers

**Achados:**
- ✅ CORS com allowlist
- ❌ CSP ausente
- ✅ HSTS presente

### Fase 9 — Rate limit

**Achados:**
- ✅ Aplicado em `/login`
- ❌ Ausente em `/reset-password`

### Fase 10 — Uploads

**Achados:**
- ⚠️ Multer sem validação de MIME e magic bytes

### Fase 11 — Logs

**Achados:**
- ✅ Winston configurado
- ⚠️ Loga `req.headers.authorization` em DEBUG (vaza JWT)

### Fase 12 — Backup

**Não verificado** — sem acesso ao provedor de cloud.

### Fase 13 — Dependências

**Achados:**
- 🚨 3 pacotes com CVE conhecida

### Fase 14 — Supply chain

**Não aplicável** neste escopo.

### Fase 15 — CI/CD

**Achados:**
- ✅ Lint + testes
- ❌ Sem SAST, SCA ou secret scanning

### Fase 16 — Monitoramento

- ✅ Uptime + logs centralizados
- ⚠️ Sem alerta para falhas de autenticação

### Fase 17 — Disaster Recovery

- ❌ Sem plano documentado

### Fase 18 — Privacidade (LGPD)

- ⚠️ Sem política de retenção definida
- ⚠️ Sem endpoint de exclusão de dados

---

## 📊 Matriz de segurança final

| Área | Status |
|---|---|
| HTTPS/TLS | IMPLEMENTADO |
| Senhas | IMPLEMENTADO |
| MFA | AUSENTE |
| Rate limit | PARCIAL |
| Inputs | PARCIAL |
| SQL Injection | IMPLEMENTADO |
| Acesso/RBAC | VULNERÁVEL |
| Sessões | PARCIAL |
| Secrets | VULNERÁVEL |
| CORS | IMPLEMENTADO |
| Logs | IMPLEMENTADO |
| Backups | NÃO VERIFICADO |
| Criptografia | IMPLEMENTADO |
| Dependências | PARCIAL |
| Patches | IMPLEMENTADO |
| Monitoramento | IMPLEMENTADO |
| Disaster Recovery | AUSENTE |
| Supply Chain | NÃO APLICÁVEL |
| Privacidade (LGPD) | PARCIAL |

---

## 🚨 Vulnerabilidades encontradas

### SEC-001 — IDOR em GET /api/orders/:id
- **Severidade:** HIGH (CVSS 8.1)
- **OWASP:** A01:2021 | **CWE:** CWE-639
- **Local:** `src/routes/orders.ts:42`
- **Correção:** Adicionar checagem `order.userId === req.user.id`.
- **Status:** OPEN — bloqueante

### SEC-002 — JWT_SECRET hardcoded
- **Severidade:** HIGH (CVSS 7.5)
- **OWASP:** A02:2021 | **CWE:** CWE-798
- **Local:** `src/config/auth.ts:7`
- **Correção:** Rotacionar, mover para env, limpar histórico Git.
- **Status:** OPEN — bloqueante

### SEC-003 — Rate limit ausente em /reset-password
- **Severidade:** MEDIUM (CVSS 6.1)
- **OWASP:** A07:2021 | **CWE:** CWE-307
- **Status:** OPEN

### SEC-004 — Cookie sem SameSite=Strict
- **Severidade:** MEDIUM (CVSS 5.3)
- **CWE:** CWE-1275
- **Status:** OPEN

### SEC-005 — 3 dependências com CVE
- **Severidade:** MEDIUM (CVSS 5.0)
- **OWASP:** A06:2021
- **Status:** OPEN

### SEC-006 — CSP ausente
- **Severidade:** LOW (CVSS 3.1)
- **OWASP:** A05:2021
- **Status:** OPEN

---

## 🧪 Testes executados

| Comando | Resultado |
|---|---|
| `npm test` | PASS (42s) |
| `npm audit --production` | FAIL (3 CVEs) |
| `gitleaks detect --no-git` | FAIL (1 secret) |
| `npx semgrep --config=auto src/` | PASS |

---

## 📌 Pendências

- **PEND-001:** Não foi possível verificar backup (sem acesso ao provedor).
- **PEND-002:** Testes de IDOR não foram executados em produção.

---

## 🎯 Próximos passos (ordenados por risco)

| Ordem | Prioridade | Ação |
|---|---|---|
| 1 | HIGH | Corrigir SEC-001 (IDOR) |
| 2 | HIGH | Rotacionar JWT_SECRET (SEC-002) |
| 3 | MEDIUM | Rate limit em /reset-password (SEC-003) |
| 4 | MEDIUM | Ajustar cookies (SEC-004) |
| 5 | MEDIUM | Atualizar dependências (SEC-005) |
| 6 | LOW | CSP em report-only (SEC-006) |

---

## 🗒️ Nota final

> Segurança é redução de risco, não garantia absoluta.
> Este relatório reflete o estado observado na data da auditoria.

**Saída estruturada:** `examples/security-report.json`
