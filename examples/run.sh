#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_task_manager info
PYTHONPATH=src python -m gbt_task_manager check --payload '{}'
PYTHONPATH=src python -m gbt_task_manager run   --payload '{}'
