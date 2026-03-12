# Setup Tools

One-command installers for development tools and coding standards, hosted at [swetanksubham.com/setup](https://swetanksubham.com/setup).

## Available Tools

### Claude Code for VS Code

Architecture-first coding standards for Claude Code in VS Code.

```bash
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | bash
```

**Features:** SOLID principles, immutability by default, zero hardcoded values, null-safety, project memory (`.claude/context/`), language auto-detection (Python, Java, Rust, TypeScript, Go, C/C++), GitHub Copilot support.

**Flags:**

| Flag | Description |
|---|---|
| `--copilot` | Also set up GitHub Copilot instructions |
| `--global` | Install to `~/.claude/` for all projects |
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
        └── install            # The bash installer script
```

## How the URL Routing Works

The custom domain `swetanksubham.com` points to `swtnk.github.io` (the user pages repo). GitHub Pages automatically routes project repos as subpaths:

- `swtnk.github.io` / `swetanksubham.com` → portfolio (`swtnk/swtnk.github.io` repo)
- `swtnk.github.io/setup/` / `swetanksubham.com/setup/` → this repo (`swtnk/setup`)

So `swetanksubham.com/setup/claude/vscode/install` maps to `claude/vscode/install` in this repo.

## Deployment

### First-Time Setup

1. Create the repo as `swtnk/setup` on GitHub
2. Push this code to the `main` branch
3. Go to repo **Settings** > **Pages**
4. Under **Source**, select **GitHub Actions**
5. The workflow runs automatically on push and deploys the site

**Do NOT** add a `CNAME` file to this repo. The custom domain is configured only on the main `swtnk.github.io` repo, and project pages inherit it automatically.

### Updating

Just push to `main`. The GitHub Actions workflow handles deployment automatically.

### Verifying

After the first deployment, test with:

```bash
# Should return the install script content
curl -fsSL https://swetanksubham.com/setup/claude/vscode/install | head -5

# Should show the landing page
curl -sI https://swetanksubham.com/setup/claude/vscode/ | head -5
```

## Adding New Tools

To add a new setup tool:

1. Create a directory under the appropriate path (e.g., `node/prettier/`)
2. Add an `install` script (self-contained bash, no external dependencies)
3. Add an `index.html` landing page
4. Update the root `index.html` hub page with a card for the new tool
5. Push to `main`

## License

MIT
