# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/).
Versionamento segue [SemVer](https://semver.org/lang/pt-BR/).

## [1.1.0] - 2026-09-29

### Adicionado
- Frontmatter com `triggers`, `allowed-tools`, `modes`, `frameworks`, `compliance`
- Seção de Modos de Operação (AUDIT / REVIEW / HARDEN / IMPLEMENT)
- Definition of Done (DoD) por controle
- Critérios objetivos de severidade (CVSS)
- Seção "Fora de escopo"
- Seção "Quando não for possível verificar"
- Fases 14 (Supply Chain), 16 (Monitoramento), 17 (DR), 18 (Privacidade e Compliance)
- Saída estruturada `security-report.json`
- Exemplos de uso
- Mapeamento OWASP/ASVS/NIST/CIS
- Tratamento de prompt injection para apps com IA
- Script `scripts/run-security.sh` e `Makefile`
- Schema `schemas/security-report.schema.json`
- Exemplo de auditoria em `examples/audit-example.md`

### Alterado
- Fases renumeradas e reorganizadas
- Tabela inicial expandida (Supply Chain, Privacidade)
- Autorização agora exige confirmação explícita antes de editar

## [1.0.0] - 2026-09-29

### Adicionado
- Versão inicial da skill
- Fluxo em 16 fases
- Cobertura OWASP, secrets, auth, sessões, uploads, logs, backups, DR
- Relatório final estruturado
