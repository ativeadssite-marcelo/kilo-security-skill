#!/usr/bin/env bash
set -Eeuo pipefail

MODE="audit"
TARGET="."
OUT="security-report.json"
FAIL_ON="blocking"
DRY_RUN="false"
SKILL_CMD="${SKILL_CMD:-kilo run /projeto-seguranca}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)    MODE="$2"; shift 2 ;;
    --target)  TARGET="$2"; shift 2 ;;
    --out)     OUT="$2"; shift 2 ;;
    --fail-on) FAIL_ON="$2"; shift 2 ;;
    --dry-run) DRY_RUN="true"; shift ;;
    *) echo "Arg desconhecido: $1"; exit 2 ;;
  esac
done

command -v jq >/dev/null || { echo "jq não encontrado"; exit 2; }
[[ -d "$TARGET" ]] || { echo "Alvo não existe: $TARGET"; exit 2; }

if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry-run: $SKILL_CMD --mode $MODE --target $TARGET --output $OUT"
  exit 0
fi

command -v kilo >/dev/null || { echo "CLI kilo não encontrado"; exit 2; }
$SKILL_CMD --mode "$MODE" --target "$TARGET" --output "$OUT" || exit 1
[[ -f "$OUT" ]] || { echo "Relatório não gerado"; exit 1; }

CRIT=$(jq -r '.summary.by_severity.critical // 0' "$OUT")
HIGH=$(jq -r '.summary.by_severity.high // 0' "$OUT")
BLOCK=$(jq -r '.summary.blocking_findings | length // 0' "$OUT")

echo "CRIT=$CRIT HIGH=$HIGH BLOCK=$BLOCK"

case "$FAIL_ON" in
  critical) [[ "$CRIT" -gt 0 ]] && exit 1 || exit 0 ;;
  high)     [[ "$CRIT" -gt 0 || "$HIGH" -gt 0 ]] && exit 1 || exit 0 ;;
  blocking) [[ "$BLOCK" -gt 0 ]] && exit 1 || exit 0 ;;
  none)     exit 0 ;;
esac
