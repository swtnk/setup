#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INSTALLER="${ROOT_DIR}/claude/vscode/install"
SANDBOX="${ROOT_DIR}/local_dev"
SANDBOX_HOME="${SANDBOX}/home"

rm -rf "${SANDBOX}"
mkdir -p "${SANDBOX}"
mkdir -p "${SANDBOX_HOME}"

bash -n "${INSTALLER}"

cd "${SANDBOX}"
export HOME="${SANDBOX_HOME}"
exec bash "${INSTALLER}" "$@"
