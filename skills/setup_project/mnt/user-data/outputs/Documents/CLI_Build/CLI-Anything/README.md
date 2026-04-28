# CLI-Anything
`~/Documents/CLI_Build/CLI-Anything/`

CLI-Anything is a meta-framework for rapidly building your own CLI tools.
Give it a description of what your CLI should do and it scaffolds the full
command structure, argument parsing, help text, and entry point.

---

## Clone

```bash
git clone https://github.com/guypeer8/cli-anything.git \
  ~/Documents/CLI_Build/CLI-Anything/cli-anything
```

---

## What It Does

| Feature | Description |
|---------|-------------|
| **AI-generated CLIs** | Describe your tool → get a working CLI scaffold |
| **Argument parsing** | Auto-generates flags, options, and positional args |
| **Help generation** | Produces `--help` output automatically |
| **Subcommands** | Supports nested command trees (like `git branch`, `git commit`) |
| **TypeScript-first** | Outputs typed, modern Node.js CLI code |

---

## Quick Start

```bash
cd ~/Documents/CLI_Build/CLI-Anything/cli-anything
npm install
npm run build

# Generate a new CLI
node dist/index.js "A CLI that watches a folder and compresses new images automatically"
```

---

## Output Structure

For every generated CLI:
```
my-cli/
├── src/
│   ├── index.ts        ← Entry point + command registration
│   ├── commands/
│   │   ├── run.ts      ← Main command logic
│   │   └── config.ts   ← Config subcommand
│   └── utils/
│       └── helpers.ts  ← Shared utilities
├── package.json
├── tsconfig.json
└── README.md
```

---

## Building Your Own CLI with Claude

```
"Read ~/Documents/CLI_Build/CLI-Anything/cli-anything/README.md,
 then build me a CLI called deploy-kit that has three commands:
 'deploy-kit push' (run git push + vercel --prod),
 'deploy-kit env' (sync .env.local to Vercel), and
 'deploy-kit status' (show last 5 deployments)."
```

---

## Installing Generated CLIs Globally

```bash
cd my-cli
npm install
npm run build
npm link         # Makes 'my-cli' available globally
my-cli --help    # Test it
```

---

## Key Docs
- https://github.com/guypeer8/cli-anything
