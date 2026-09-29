# Kilo Security Skill

Skill defensiva de AppSec/DevSecOps para o **Kilo Code**.

Audita, endurece, implementa, revisa, testa e documenta segurança em aplicações web, APIs, SaaS, e-commerce, bancos de dados, infraestrutura e pipelines CI/CD.

---

## ✨ O que faz

- Auditoria baseada em evidências (OWASP Top 10, API Top 10, ASVS 5.0)
- Modelagem de ameaça (STRIDE/PASTA)
- Verificação de autenticação, autorização, sessões, secrets, CORS, uploads, logs, backups, dependências e supply chain
- Correções seguras com Definition of Done por controle
- Testes não destrutivos
- Relatório final com matriz de segurança, severidade objetiva (CVSS) e próximos passos
- Suporte a LGPD/GDPR/SOC2/ISO 27001
- Saída estruturada em JSON para integração com CI

---

## 🎯 Modos de operação

| Modo | Altera código? | Uso |
|---|---|---|
| AUDIT | Não | Diagnóstico |
| REVIEW | Não | Revisar PR/diff |
| HARDEN | Sim (com autorização) | Corrigir problemas |
| IMPLEMENT | Sim (com autorização) | Implementar do zero |

Se o modo não for explícito, a skill assume **AUDIT**.

---

## 🚀 Como ativar

Ou frases como:

- "faça a segurança do projeto"
- "audite a segurança"
- "aplique a skill de segurança"
- "proteja meu SaaS"
- "faça hardening"
- "security audit"
- "verifique vulnerabilidades"

---

## 📁 Estrutura do repositório

---

## 🧩 Compatibilidade

Projetada para o **Kilo Code**. Também compatível com outros agentes que leem `SKILL.md`.

---

## 🔒 Princípios

- Defensiva, nunca ofensiva contra terceiros
- Baseada em evidência, nunca em suposição
- Não destrutiva por padrão
- Autorização explícita para alterações
- Nunca declara "100% seguro"

---

## 📜 Licença

Apache-2.0 — veja [LICENSE](LICENSE).
