# Setup Tools

One-command installers for development tools and coding standards, hosted at [swetanksubham.com/setup](https://swetanksubham.com/setup).

## Available Tools

### Claude Code for VS Code

Architecture-first coding standards for Claude Code in VS Code. v2.0 — zero-duplication design that maximizes context window efficiency.

```bash
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash
```

**Design philosophy:** `CLAUDE.md` defines workflow and project memory only (~40 lines). All coding standards live in `.claude/rules/` where Claude Code loads them per-file-type. Zero content duplication between files = maximum context window for your actual code.

**10 Universal Coding Principles** (enforced via `.claude/rules/general.md`, loaded on every file):

1. **SOLID** — Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
2. **Immutable by Default** — `const`/`final`/`readonly` unless mutation is justified
3. **Zero Hardcoded Values** — Centralized config files, imported everywhere
4. **No Raw Nulls** — `Optional`/`Result`/`Option` types everywhere
5. **Standard Library First** — Use platform utilities, never reimplement
6. **Self-Explanatory Code** — Descriptive names, no comments, refactor instead
7. **Senior Engineer Quality** — Right abstractions, edge cases, clarity over brevity
8. **Match Existing Codebase** — Generated code indistinguishable from the team's own
9. **Testing is Mandatory** — Unit + integration tests alongside implementation, never after
10. **Ask When Uncertain** — Stop and ask when ambiguous, present trade-offs, check in at milestones

**Additional features:** Language auto-detection (Python, Java, Rust, TypeScript, Go, C/C++), deterministic fallback to install all language rules when detection is empty, project memory (`.claude/context/`), task decomposition workflow, GitHub Copilot support.

**What gets created:**

```
your-project/
├── CLAUDE.md                  # Workflow & project memory (~40 lines)
├── .claude/
│   ├── rules/
│   │   ├── general.md         # Universal standards (~28 lines)
│   │   ├── python.md          # Type hints, protocols, typing
│   │   ├── java.md            # Lombok, Optional, null-safety
│   │   ├── rust.md            # Ownership, Result types
│   │   ├── typescript.md      # Strict mode, readonly
│   │   ├── go.md              # Error handling, composition
│   │   └── c_cpp.md           # Smart pointers, RAII, const
│   └── context/               # Project memory (auto-populated by Claude)
│       └── README.md
└── .gitignore                 # Updated with .claude/context/
```

**Context window usage** (lines loaded per conversation):

| Project type | v1.1.0 | v2.0.0 |
|---|---|---|
| Python only | ~252 lines | ~82 lines |
| Python + TypeScript | ~272 lines | ~93 lines |
| All languages | ~380 lines | ~130 lines |

**Flags:**

| Flag | Description |
|---|---|
| `--copilot` | Also set up GitHub Copilot instructions (`.github/`) |
| `--global` | Install to `~/.claude/` (applies to all projects) |
| `--force` | Overwrite existing files (use to upgrade from v1) |
| `--no-detect` | Install all language rules |
| `--verify` | Download and verify installer checksum |

**Examples:**

```bash
# With Copilot support
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --copilot

# Global install
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --global

# Force + all languages
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --force --no-detect

# Upgrade from v1 to v2
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --force
```

## Repo Structure

```
setup/                         (repo root, served at /setup/)
├── index.html                 # Hub page listing all tools
├── 404.html                   # Custom 404
├── .nojekyll                  # Serve extensionless files correctly
├── .github/
│   └── workflows/
│       └── deploy.yml         # Validate + auto-deploy on push to main
└── claude/
    ├── vscode/
    │   ├── install            # Self-contained bash installer
    │   ├── test.sh            # Sandbox test runner
    │   └── index.html         # Landing page
    └── skills/
        ├── SKILL.md           # Project Architect skill definition
        └── index.html         # Skills directory page
```

## How the URL Routing Works

The custom domain `swetanksubham.com` points to `swtnk.github.io` (the user pages repo). GitHub Pages automatically routes project repos as subpaths:

- `swetanksubham.com` → portfolio (`swtnk/swtnk.github.io` repo)
- `swetanksubham.com/setup/` → this repo (`swtnk/setup`)

So `swetanksubham.com/setup/claude/vscode/install` maps to `claude/vscode/install` in this repo.

## Adding New Tools

To add a new setup tool:

1. Create a directory under the appropriate path (e.g., `node/prettier/`)
2. Add an `install` script (self-contained bash, no external dependencies)
3. Add an `index.html` landing page
4. Update the root `index.html` hub page with a card for the new tool
5. Push to `main`

## License

MIT
