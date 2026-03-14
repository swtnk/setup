# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Fixed
- Installer interactive option toggle UI now uses a terminal-capability guard and fallback redraw path, preventing broken rendering in some macOS terminal environments
- Removed timeout-based escape discard reads in interactive prompts to avoid shell portability issues across terminal/bash variants

### Changed
- When language auto-detection returns empty, installer now consistently installs all language rules without prompting for manual language selection
- Removed redundant `Continue? [Y/n]` confirmation after option selection; installer proceeds immediately with visible selected options
- Added checksum verification as a selectable installer option (default ON); installer now verifies before setup and aborts on verification failure
- Added `--no-verify` (skip pre-install verification) and `--verify-only` (verify and exit) flags

## [2.0.1] - 2026-03-12

### Fixed
- `convert_rule_to_copilot`: hardened extension regex to handle non-standard glob prefixes (e.g. `src/**/*.py`)
- `run_with_spinner`: explicit exit on failure instead of relying on `set -e` through `wait`
- `interactive_select_options`: show "(skipped with --global)" note when both `--copilot` and `--global` active
- CSS: added `color` fallback before `background-clip: text` for unsupported renderers

### Added
- Interactive language selection prompt when no languages detected in empty projects
- `assert_contains` checks for Copilot `applyTo:` frontmatter in test.sh (TypeScript, C/C++, Python, Go)
- Rule file count assertion in test.sh for both project and global modes
- OpenGraph meta tags on all landing pages
- `<meta name="description">` on skills index page

## [2.0.0] - 2026-03-12

### Fixed
- `append_line`: prevent double blank lines when appending to files
- `convert_rule_to_copilot`: hardened awk frontmatter stripping with state machine
- `test.sh`: replaced `exec bash` with `bash` to allow post-install assertions
- `404.html`: replaced hardcoded `/setup/` path with relative `./`
- README: corrected principle count from 8 to 10

### Added
- Post-install assertion framework in `test.sh` (file existence, content checks)
- `--verify` flag documented in README and landing page
- CI test scenarios for `--copilot` and `--global` flags
- Shared CSS (`shared.css`) extracted from all HTML pages
- Inline SVG favicon on all pages
- Principles 9 (Testing is Mandatory) and 10 (Ask When Uncertain) in README

### Changed
- Replaced inline `onclick` handlers with `addEventListener` in VS Code landing page
- All HTML pages now reference `shared.css` instead of duplicating styles

## [1.0.0] - 2025-06-01

### Added
- Interactive bash installer with TUI toggles and ANSI styling
- Zero-duplication architecture: CLAUDE.md + `.claude/rules/` coding standards
- Language auto-detection for Python, Java, Rust, TypeScript, Go, C++
- `--global`, `--copilot`, `--force`, `--no-detect`, `--verify` flags
- GitHub Pages site with landing pages for VS Code installer and skills
- CI/CD pipeline: ShellCheck, syntax check, sandbox test, deploy with SHA-256 checksum
- Skills index page with project-architect skill
