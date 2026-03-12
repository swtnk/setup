#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INSTALLER="${ROOT_DIR}/claude/vscode/install"
SANDBOX="${ROOT_DIR}/local_dev"
SANDBOX_HOME="${SANDBOX}/home"

# Guardrails: ensure SANDBOX is a non-root path under ROOT_DIR ending in /local_dev
if [[ -z "${SANDBOX}" ]]; then
    echo "ERROR: SANDBOX is empty"; exit 1
fi
if [[ "${SANDBOX}" != "${ROOT_DIR}/local_dev" ]]; then
    echo "ERROR: SANDBOX '${SANDBOX}' is not <ROOT_DIR>/local_dev"; exit 1
fi
if [[ "${SANDBOX}" == "/" || "${SANDBOX}" == "${HOME}" ]]; then
    echo "ERROR: SANDBOX resolves to a dangerous path: '${SANDBOX}'"; exit 1
fi

rm -rf "${SANDBOX}"
mkdir -p "${SANDBOX}"
mkdir -p "${SANDBOX_HOME}"

bash -n "${INSTALLER}"

cd "${SANDBOX}"
export HOME="${SANDBOX_HOME}"
bash "${INSTALLER}" "$@"

# ── Post-install assertions ───────────────────────────────────────────────────

PASS=0
FAIL=0

assert_file() {
    if [[ -f "$1" ]]; then
        echo "  ✓ $1"
        PASS=$((PASS + 1))
    else
        echo "  ✗ MISSING: $1" >&2
        FAIL=$((FAIL + 1))
    fi
}

assert_contains() {
    if grep -qF "$2" "$1" 2>/dev/null; then
        echo "  ✓ $1 contains '$2'"
        PASS=$((PASS + 1))
    else
        echo "  ✗ $1 missing '$2'" >&2
        FAIL=$((FAIL + 1))
    fi
}

echo ""
echo "── Post-install validation ──"

# Check if --global was passed
is_global=false
for arg in "$@"; do
    if [[ "${arg}" == "--global" ]]; then
        is_global=true
        break
    fi
done

if [[ "${is_global}" == true ]]; then
    assert_file "${SANDBOX_HOME}/.claude/CLAUDE.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/general.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/python.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/java.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/rust.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/typescript.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/go.md"
    assert_file "${SANDBOX_HOME}/.claude/rules/c_cpp.md"
    rule_count="$(find "${SANDBOX_HOME}/.claude/rules" -name "*.md" -type f | wc -l | tr -d ' ')"
    if [[ "${rule_count}" -eq 7 ]]; then
        echo "  ✓ Rule file count: ${rule_count}"
        PASS=$((PASS + 1))
    else
        echo "  ✗ Expected 7 rule files, found ${rule_count}" >&2
        FAIL=$((FAIL + 1))
    fi
else
    assert_file "${SANDBOX}/CLAUDE.md"
    assert_file "${SANDBOX}/.claude/rules/general.md"
    assert_file "${SANDBOX}/.claude/rules/python.md"
    assert_file "${SANDBOX}/.claude/rules/java.md"
    assert_file "${SANDBOX}/.claude/rules/rust.md"
    assert_file "${SANDBOX}/.claude/rules/typescript.md"
    assert_file "${SANDBOX}/.claude/rules/go.md"
    assert_file "${SANDBOX}/.claude/rules/c_cpp.md"
    rule_count="$(find "${SANDBOX}/.claude/rules" -name "*.md" -type f | wc -l | tr -d ' ')"
    if [[ "${rule_count}" -eq 7 ]]; then
        echo "  ✓ Rule file count: ${rule_count}"
        PASS=$((PASS + 1))
    else
        echo "  ✗ Expected 7 rule files, found ${rule_count}" >&2
        FAIL=$((FAIL + 1))
    fi
    assert_file "${SANDBOX}/.claude/context/README.md"
    assert_contains "${SANDBOX}/.gitignore" ".claude/context/"
fi

# Check --copilot files if flag was passed
is_copilot=false
for arg in "$@"; do
    if [[ "${arg}" == "--copilot" ]]; then
        is_copilot=true
        break
    fi
done

if [[ "${is_copilot}" == true ]] && [[ "${is_global}" == false ]]; then
    assert_file "${SANDBOX}/.github/copilot-instructions.md"
    assert_file "${SANDBOX}/.github/instructions/python.instructions.md"
    assert_file "${SANDBOX}/.github/instructions/java.instructions.md"
    assert_file "${SANDBOX}/.github/instructions/rust.instructions.md"
    assert_file "${SANDBOX}/.github/instructions/typescript.instructions.md"
    assert_file "${SANDBOX}/.github/instructions/go.instructions.md"
    assert_file "${SANDBOX}/.github/instructions/c_cpp.instructions.md"
    assert_contains "${SANDBOX}/.github/instructions/python.instructions.md" 'applyTo: "**/*.py"'
    assert_contains "${SANDBOX}/.github/instructions/typescript.instructions.md" 'applyTo: "**/*.{ts,tsx}"'
    assert_contains "${SANDBOX}/.github/instructions/c_cpp.instructions.md" 'applyTo: "**/*.{c,cpp,h,hpp}"'
    assert_contains "${SANDBOX}/.github/instructions/go.instructions.md" 'applyTo: "**/*.go"'
fi

echo ""
echo "── Results: ${PASS} passed, ${FAIL} failed ──"

if [[ "${FAIL}" -gt 0 ]]; then
    exit 1
fi
