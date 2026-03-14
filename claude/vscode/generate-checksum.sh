#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
install_file="${script_dir}/install"
checksum_file="${script_dir}/install.sha256"

if [[ ! -f "${install_file}" ]]; then
    echo "Error: install file not found at ${install_file}" >&2
    exit 1
fi

if command -v sha256sum > /dev/null 2>&1; then
    hash_value="$(sha256sum "${install_file}" | awk '{print $1}')"
elif command -v shasum > /dev/null 2>&1; then
    hash_value="$(shasum -a 256 "${install_file}" | awk '{print $1}')"
else
    echo "Error: need sha256sum or shasum to generate checksum" >&2
    exit 1
fi

printf '%s  %s\n' "${hash_value}" "claude/vscode/install" > "${checksum_file}"
echo "Wrote ${checksum_file}"
