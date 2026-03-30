# AI Stack

A complete, reproducible AI development environment for Mac.
Installs and configures every tool, MCP server, plugin, and agent in one bootstrap script.

## What's included

- **14 MCP servers** — Firecrawl, Google Workspace, NotebookLM, Blender, Unreal Engine, Premiere Pro, Puppeteer, Stitch, Chatterbox, Remotion, GSD, ADB, WiFi, and more
- **3 CLIs** — Gemini CLI, Google Workspace CLI, Playwright
- **10+ plugins** — Agency Agents (60+ AI specialists), God Mode 3, Oh My Claude Code, SuperPowers, GSD, PaperClip, and more
- **500+ Composio skills** via awesome-claude-skills
- **Claude Code** with pre-configured skills, agents, and commands
- **n8n** workflow automation

## Setup — two commands

```bash
git clone https://github.com/YOUR_USERNAME/ai-stack.git ~/ai-stack
~/ai-stack/bootstrap.sh
```

Then follow the manual steps the script prints at the end.

## Machine configs

Three pre-built Claude Desktop configs in `configs/`:

| File | Use on |
|------|--------|
| `claude_desktop_config_travel.json` | Laptop — research, brainstorm, docs |
| `claude_desktop_config_mini.json` | Mac Mini — always-on, heavy coding |
| `claude_desktop_config_alien.json` | Desktop — Blender, Unreal, Premiere, GPU |

Copy the right one to `~/Library/Application Support/Claude/claude_desktop_config.json`
and replace `YOUR_*` placeholders with your actual keys.

## Secrets

```bash
cp ~/ai-stack/configs/.env.example ~/.claude/.env
nano ~/.claude/.env   # fill in your API keys
```

Keys needed:
- `FIRECRAWL_API_KEY` — firecrawl.dev
- `COMPOSIO_MCP_URL` + `COMPOSIO_API_KEY` — platform.composio.dev
- `GITHUB_TOKEN` — github.com/settings/tokens
- `VERCEL_TOKEN` — vercel.com/account/tokens

## AI config templates

```bash
cp ~/ai-stack/configs/CLAUDE.md.template ~/.claude/CLAUDE.md
cp ~/ai-stack/configs/GEMINI.md.template ~/.gemini/GEMINI.md
```

Edit both to add your name, machine role, and any personal preferences.

## Tool registry

`tool-registry.md` — the full inventory of every tool, its path, and how to activate it.
Import it into your CLAUDE.md with `@~/ai-stack/tool-registry.md` for automatic tool awareness.

## Project templates

Starter files for every new project in `templates/`:
- `HANDOFF.md` — session continuity across machines
- `PLAN.md` — project planning
- `AGENTS.md` — shared AI coding conventions
