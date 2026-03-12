# Setup Tools

One-command installers for development tools and coding standards, hosted at [swetanksubham.com/setup](https://swetanksubham.com/setup).

## Available Tools

### Claude Code for VS Code

Architecture-first coding standards for Claude Code in VS Code.

```bash
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash
```

**10 Coding Principles enforced:**

1. **SOLID Always** — Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
2. **Immutable by Default** — All variables const/final/readonly unless mutation is justified
3. **Zero Hardcoded Values** — Constants in centralized config files, referenced everywhere
4. **No Raw Nulls** — Optional/Result types everywhere
5. **Standard Library First** — Use platform utilities, don't reimplement
6. **Self-Explanatory Code** — No comments. Descriptive names, clean structure, refactor instead of commenting
7. **Senior Engineer Mindset** — Right abstractions, edge case coverage, design for change
8. **Break Down Before Building** — Decompose into tasks in `.claude/context/tasklist.md` before coding
9. **Testing Is Not Optional** — Unit + integration tests alongside implementation
10. **Follow Up With the User** — Ask when ambiguous, check in at milestones

**Additional features:** Language auto-detection (Python, Java, Rust, TypeScript, Go, C/C++), project memory (`.claude/context/`), existing codebase pattern matching, GitHub Copilot support.

**What gets created:**

```
your-project/
├── CLAUDE.md                  # Main instructions
├── .claude/
│   ├── rules/
│   │   ├── general.md         # Universal standards
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

**Flags:**

| Flag | Description |
|---|---|
| `--copilot` | Also set up GitHub Copilot instructions (`.github/`) |
| `--global` | Install to `~/.claude/` (applies to all projects) |
| `--force` | Overwrite existing files |
| `--no-detect` | Install all language rules |

**Examples:**

```bash
# With Copilot support
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --copilot

# Global install
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --global

# Force + all languages
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash -s -- --force --no-detect
```

## Repo Structure

```
setup/                         (repo root, served at /setup/)
├── index.html                 # Hub page listing all tools
├── 404.html                   # Custom 404
├── .nojekyll                  # Serve extensionless files correctly
├── .github/
│   └── workflows/
│       └── deploy.yml         # Auto-deploy on push to main
└── claude/
    └── vscode/
        ├── index.html         # Landing page for /setup/claude/vscode/
        └── install            # The bash installer script (self-contained)
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
