SHELL := /bin/bash
SCRIPT := scripts/run-security.sh
OUT    := security-report.json
SCHEMA := schemas/security-report.schema.json

.PHONY: help audit review harden implement ci validate clean

help:
	@grep -E '^#   ' $(MAKEFILE_LIST) | sed 's/^#   //'

audit:
	@$(SCRIPT) --mode audit --out $(OUT) --fail-on blocking

review:
	@$(SCRIPT) --mode review --out $(OUT) --fail-on none

harden:
	@$(SCRIPT) --mode harden --out $(OUT) --fail-on none

implement:
	@$(SCRIPT) --mode implement --out $(OUT) --fail-on none

ci:
	@$(SCRIPT) --mode audit --out $(OUT) --fail-on critical

validate:
	@npx --yes ajv-cli validate -s $(SCHEMA) -d $(OUT) \
		&& echo "OK" || { echo "FALHOU"; exit 1; }

clean:
	@rm -f $(OUT) gitleaks.json semgrep.json
	@echo "OK"
