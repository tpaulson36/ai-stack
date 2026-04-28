---
name: setup_project
description: >
  Guides the user through a complete, opinionated Claude-optimized project setup from scratch.
  Invoke this skill whenever a user says "new project", "start a project", "set up a repo",
  "initialize a codebase", "scaffold a project", or asks how to structure their workspace
  for Claude Code, AI-assisted development, or any software project. Even if the user just
  says "I'm starting something new", trigger this skill — it's better to offer the setup
  guide than miss it. Covers memory files (CLAUDE.md, AGENTS.md), progressive disclosure
  imports, .claude/ directory infrastructure, security hooks, vault architecture, session
  memory loops, and MCP/CLI tool suggestions.
---

# setup_project Skill

You are a project architect helping the user configure their codebase for maximum effectiveness
with Claude Code and AI-assisted development. Walk through each step interactively — ask
clarifying questions, generate the actual files, and explain the "why" behind every decision.

## How to Use This Skill

Work through **Steps -1 through 7 sequentially**, but adapt to what the user already has.
- If a file already exists, offer to review and improve it rather than overwrite it.
- Keep every CLAUDE.md **under 300 lines** — use `@imports` for anything longer.
- Generate real file content, not just descriptions of what files should contain.

---

## Step -1 — Read Obsidian Before Anything Else

> **Goal:** Pull prior context from the vault before touching a single file.
> This is the FIRST action on every new project or session. Do not skip.

The Obsidian vault at `~/Dropbox/Obsidian/Ty's Thoughts/` is the single source of truth
for past decisions, patterns, and session history across all three machines.

### Always read these before starting:

```bash
# Past decisions (permanent patterns + things to avoid)
cat "~/Dropbox/Obsidian/Ty's Thoughts/Claude/Decisions/decisions.md"

# Recent session logs (last 3, for continuity)
ls -t "~/Dropbox/Obsidian/Ty's Thoughts/Claude/Session Logs/" | head -3
# then read each one
```

### What to extract and apply:

| Source | What to look for |
|--------|-----------------|
| `Decisions/decisions.md` | Architectural choices, anti-patterns, confirmed approaches |
| Recent Session Logs | Open items, next steps, unresolved questions from prior sessions |
| `Research/` | Any prior research on the current domain |

### After reading, surface to the user:
- Any prior decisions that directly apply to this project
- Open items from the most recent session log that should be addressed
- Relevant research notes that can inform the setup

### Rule:
> Never assume this is a blank slate. The vault contains institutional memory.
> A 30-second vault read prevents repeating solved problems or contradicting past decisions.

### Token Economy — Apply Throughout Every Setup

These rules apply to every step of this skill. Save tokens automatically:

- **Match length to complexity** — a one-line answer for a one-line question
- **No preamble or postamble** — don't restate the question, don't summarize what you just did
- **Batch file reads** — read multiple related files in one operation, not sequentially
- **Targeted edits only** — use `str_replace` on specific sections, never rewrite whole files unnecessarily
- **Don't re-read files already in context** unless they may have changed
- **Plan before executing** — think through multi-step tasks first to avoid backtracking
- **Use the right model** — run `/model` before planning (Step 0), then switch back to Sonnet for execution

---

## Step 0 — Model Setup (Run Before Anything Else)

> **Goal:** Ensure the right model is active before planning begins.
> This is the first thing to do at the start of any new project or major feature.

### Install the `/model` command

Generate `.claude/commands/model.md` in the project (or confirm it exists globally).
→ See `commands/model.md` in this skill for the full file content to copy in.

### Run it now

```
/model
```

This switches to **Opus 4.6** for the planning and setup steps ahead.
Once the spec and architecture are agreed upon, switch back:

```
/model claude-sonnet-4-6
```

### Model Rules (baked into every project's CLAUDE.md)

Add this block to the project `CLAUDE.md` during Step 1:

```markdown
## Model Strategy
- Default: claude-sonnet-4-6 — all code writing, file edits, bash, MCP operations
- Planning: claude-opus-4-6 — specs, architecture decisions, complex debugging
- Switch: /model claude-opus-4-6 to plan, /model claude-sonnet-4-6 to execute
- Rule: if Sonnet can solve it, use Sonnet. Opus is for high-stakes decisions only.
```

---

## Step 1 — Core Memory Files (The Foundation)

> **Goal:** Create the four primary instruction files that form Claude's memory hierarchy.

### Questions to ask first:
1. What is this project? (one sentence)
2. What language / stack?
3. What package manager? (npm / pnpm / bun / pip / cargo / etc.)
4. Solo developer or team?

### Files to generate:

#### `AGENTS.md` (project root)
Shared standard — readable by Claude, Cursor, Copilot, and other AI tools.
```markdown
# AGENTS.md
## Build & Test Commands
<fill from user answers>

## Coding Conventions
<fill from user answers>

## Architecture Overview
<fill from user answers>
```

#### `~/.claude/CLAUDE.md` (Global)
Personal preferences + security gatekeeping. Applies to EVERY project.
→ See `references/global-claude-template.md` for the full template.

Key sections:
- Communication style preferences
- NEVER rules (security gatekeeping)
- Tool use defaults

#### `./CLAUDE.md` (Project, ≤300 lines)
Lean project-specific file. Uses `@import` for domain docs.
```markdown
# CLAUDE.md
> <one-sentence project context>

## Stack
- Language: <X>
- Package manager: <Y>
- Framework: <Z>

## Key Decisions
- <architectural decision 1>
- <architectural decision 2>

## Imported Rules
@docs/frontend-rules.md
@docs/api-rules.md
@docs/security.md
```

#### `./CLAUDE.local.md` (gitignored)
Personal sandbox overrides — never committed.
```markdown
# CLAUDE.local.md (gitignored)
## Local URLs
- Dev server: http://localhost:3000
- API: http://localhost:8080

## Preferred Test Data
<fill>

## Personal Workflow Notes
<fill>
```

⚠️ Add `CLAUDE.local.md` to `.gitignore` immediately.

---

## Step 2 — Progressive Disclosure

> **Goal:** Keep root files lean by linking out to domain-specific docs.

### Ask the user:
- What domains does this project cover? (frontend / backend / infra / security / DB / mobile)

### Generate a `docs/` folder with domain files:

```
docs/
├── frontend-rules.md     # React/Vue/CSS conventions
├── api-rules.md          # REST/GraphQL patterns
├── security.md           # Auth, secrets, RBAC rules
├── database.md           # Query patterns, migrations
└── testing.md            # Test strategy, coverage targets
```

Each file should start with a `# Title` and a one-line scope statement.
Then add `@docs/<file>.md` lines in `./CLAUDE.md` for each relevant domain.

**Rule:** Only import a domain file if the agent is likely to touch that domain.
This keeps the active context budget focused.

---

## Step 3 — `.claude/` Directory Infrastructure

> **Goal:** Give Claude Code its full toolkit: settings, commands, skills, agents, and rules.

### Generate this full tree:

```
.claude/
├── settings.json          # Tool permissions, env vars, hooks
├── commands/
│   ├── model.md           # /model — switch Opus/Sonnet per phase ⭐
│   ├── fix-types.md       # Re-usable slash command
│   ├── compress.md        # Session compression command
│   └── preserve.md        # Permanent learning extraction
├── skills/
│   └── README.md          # Registry of installed skills
├── agents/
│   └── reviewer.md        # Code review sub-agent
└── rules/
    ├── security.md        # Automatically-loaded security rules
    └── style.md           # Code style rules
```

#### `.claude/settings.json`
→ See `references/settings-template.json` for the annotated full template.

Minimum viable config:
```json
{
  "permissions": {
    "allow": ["Read", "Write", "Bash"],
    "deny": ["Read:.env", "Write:.env", "Read:*.secret"]
  },
  "env": {},
  "hooks": {
    "PreToolUse": [".claude/hooks/block-secrets.sh"]
  }
}
```

#### `.claude/commands/compress.md`
```markdown
# /compress
Save a structured session log at the end of every completed session.

Include:
- Date and session goal
- Key decisions made
- Files created or modified
- Open questions / next steps
- Any new patterns discovered

Save to BOTH:
1. Project: /Session Logs/YYYY-MM-DD-<topic>.md (if folder exists)
2. Obsidian vault: ~/Dropbox/Obsidian/Ty's Thoughts/Claude/Session Logs/YYYY-MM-DD-<topic>.md (always)

Format:
---
# YYYY-MM-DD — Topic
**Project:** <name>
**Session Goal:** <one line>
## Accomplished
- ...
## Files Modified
- ...
## Open Items
- [ ] ...
---
```

#### `.claude/commands/preserve.md`
```markdown
# /preserve
Extract a permanent decision from this session and lock it in two places.

Only preserve:
- New architectural decisions
- Mistakes to avoid repeating
- Confirmed patterns that work well

Do NOT preserve: temporary task notes, file lists, or session summaries.

Write to BOTH:
1. Project CLAUDE.md — under a ## Preserved Decisions section
2. Obsidian vault: ~/Dropbox/Obsidian/Ty's Thoughts/Claude/Decisions/decisions.md

Format for each entry:
## YYYY-MM-DD — Decision Title
**Context:** Why this came up
**Decision:** What was decided
**Reason:** Why this approach
**Alternatives considered:** What else was on the table
```

#### `.claude/agents/reviewer.md`
→ See `references/reviewer-agent-template.md` for a full example.

---

## Step 4 — Security and Hooks

> **Goal:** Defense in depth — behavioral rules + deterministic file-system blocks.

### Two-layer security model:

**Layer 1 — Behavioral (Global CLAUDE.md):**
```markdown
## NEVER Rules
- NEVER read, write, or reference `.env`, `.env.*`, or `*.secret` files
- NEVER commit secrets, tokens, or credentials to git
- NEVER run `rm -rf` without explicit confirmation
- NEVER push to `main` or `master` directly
- NEVER install packages without showing the command first
```

**Layer 2 — Deterministic (Hook script):**
Generate `.claude/hooks/block-secrets.sh`:
```bash
#!/usr/bin/env bash
# Blocks Claude from touching secret files regardless of LLM reasoning
BLOCKED_PATTERNS=(".env" "*.secret" "*.pem" "id_rsa" "*.key")
TARGET="${1:-}"
for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$TARGET" == $pattern ]]; then
    echo "BLOCKED: Access to $TARGET is not permitted." >&2
    exit 1
  fi
done
```

Then wire it in `.claude/settings.json` under `hooks.PreToolUse`.

---

## Step 5 — Church & State Vault Architecture

> **Goal:** Separate human creative work from AI operational output.

### Tyler's vault (already configured — skip the question):
Obsidian vault is at `~/Dropbox/Obsidian/Ty's Thoughts/` (Dropbox-synced, not local Documents).

```
Claude/
  Session Logs/    ← /compress writes here after every session
  Decisions/
    decisions.md   ← /preserve writes here for permanent decisions
  Research/        ← reference notes
```

**Rule:** Always write to Dropbox vault, never to `~/Documents/TysThoughts/` (stale local copy).

### For other users — ask:
- Do you use Obsidian or maintain a knowledge vault?
- Do you want AI session logs tracked in this repo or separately?

### Recommended structure for new setups:
```
/Human/
  meeting-notes/
  research/
  rough-ideas/
/AI/
  Session Logs/
  status-reports/
  working-memory/
```

Set a rule in `CLAUDE.md`:
```markdown
## Vault Rules
- Read from /Human freely for context
- Write ONLY to /AI or /Session Logs unless explicitly told otherwise
- Never modify files in /Human without explicit per-file approval
```

---

## Step 6 — Continuous Memory Loop

> **Goal:** Prevent session amnesia by building workflows that update Claude's memory.

### Three mechanisms:

**1. `/compress` slash command** (see Step 3)
Run at the end of every session. Saves a structured digest to `/Session Logs/`.

**2. `/preserve` slash command** (see Step 3)
Run when a permanent learning emerges. Appends to `./CLAUDE.md`.

**3. Auto-memory system** (if Claude Code ≥ 1.x)
Claude automatically writes to `~/.claude/projects/<hash>/memory/`.
To boost this, add to your Global `~/.claude/CLAUDE.md`:
```markdown
## Memory Behavior
- After completing any non-trivial task, summarize what you learned about
  this codebase and save it to the project memory directory.
- Before starting a new task, check the project memory directory for
  relevant prior context.
```

### At the end of every completed session — always prompt:
> "Session complete. Run `/compress` to save today's log to Obsidian + project folder.
> If any permanent decisions were made, also run `/preserve` to lock them into CLAUDE.md and Obsidian."

This is **not optional** — `/compress` must run at the end of every session to maintain continuity across the three-machine ecosystem (Travel → Mini → Alien). The Obsidian vault at `~/Dropbox/Obsidian/Ty's Thoughts/` is the single source of truth for session history.

---

## Step 7 — MCP, CLI & Plugin Suggestions

> **Goal:** Recommend the right integrations and local plugin repos based on the project type.
> All tooling lives in `~/Documents/Website_Building/` (for web projects) or a parallel
> `~/Documents/<Category>/` folder for other project types.

→ See `references/mcp-recommendations.md` for the full MCP catalog.

### Ask the user:
1. What does this project connect to? (DB / APIs / cloud / CMS / etc.)
2. Do you use any of: GitHub, Linear, Notion, Slack, Supabase, Vercel, AWS?
3. Do you need browser automation, file processing, or search capabilities?
4. Is this a website project? (triggers Plugin recommendations below)

---

### Local Folder Structure

All tooling lives under `~/Documents/`, organized by category:

```
~/Documents/
├── CLIs/                          ← CLI tools with install.sh + aliases.sh
│   ├── Gemini_CLI/                ← Google Gemini CLI (google-gemini/gemini-cli)
│   ├── Nanobanana_CLI/            ← AI image generation Gemini extension (gemini-cli-extensions/nanobanana)
│   ├── GoogleWorkspace_CLI/       ← Google Workspace CLI tools
│   └── PlayWright_CLI/            ← Playwright browser automation CLI
├── MCPs/                          ← MCP servers (all projects)
│   ├── Blender_MCP/               ← Blender ↔ Claude 3D modeling/scene control
├── Firecrawl_MCP/                 ← Web scraping & crawling MCP (firecrawl/firecrawl-mcp-server)
│   ├── Chatterbox/                ← Multilingual text-to-speech TTS
│   ├── Get_Shit_Done_MCP/         ← GSD meta-prompting MCP server
│   ├── GoogleWorkspace_MCP/       ← Gmail, Calendar, Drive MCP
│   ├── NotebookLM_MCP/            ← Google NotebookLM MCP
│   ├── Premiere_Pro/              ← Adobe Premiere Pro MCP
│   ├── Pupeteer_MCP/              ← Puppeteer browser automation MCP
│   ├── Remotion_MCP/              ← Remotion video rendering MCP
│   ├── Stitch_MCP/                ← Stitch MCP
│   ├── Unreal_Engine_MCP/         ← Unreal Engine ↔ Claude game dev control
│   ├── adb-mcp/                   ← Android Debug Bridge MCP
│   └── wifi_RuView/               ← WiFi/RuView MCP
├── Plugins/                       ← Cloned GitHub repos, organized by category
│   ├── Agents/
│   │   ├── Agency_Agents/         ← The Agency: 60+ specialized AI agents + NEXUS orchestration
│   │   └── PaperClip/             ← Context-aware task management agent
│   ├── God_Mode_3/                ← Advanced Claude Code power-user interface (elder-plinius/G0DM0D3)
│   ├── Oh_My_Claude_Code/         ← Claude Code enhancement framework: hooks, missions, skills
│   ├── CLI_Build/
│   │   └── CLI-Anything/          ← Meta-CLI builder framework
│   ├── General/
│   │   ├── GSD/                   ← Get Shit Done meta-prompting system
│   │   └── SuperPowers/           ← Claude Code workflow enhancements
│   ├── Memory/                    ← Memory systems (mem0, MemGPT, zep)
│   ├── Website_Building/          ← Web development plugin repos
│   │   ├── Astro_Web_Builder/     ← withastro/astro + starlight
│   │   ├── LLMS_Txt/              ← llms-txt spec + integrations
│   │   ├── Mastra_TypeScript/     ← mastra-ai/mastra (TypeScript AI framework)
│   │   ├── SchemaOrg/             ← schema-dts + next-seo + astro-seo
│   │   └── Tailwind_CSS/          ← tailwindcss + shadcn-ui + headlessui + daisyui
│   └── claude-mem/                ← Persistent memory layer for Claude
├── Claude_Skills/                 ← Installed Claude skill packs
│   └── awesome-claude-skills/     ← ComposioHQ skill collection (500+ app automations)
│       ├── composio-skills/       ← Per-service automation skills (Slack, GitHub, etc.)
│       ├── document-skills/       ← docx, pdf, pptx, xlsx
│       └── connect-apps-plugin/   ← Plugin for 500+ app connections via Composio
└── Skills_Personal/               ← Personal/custom skills
```

Each subfolder has its own `README.md` with clone commands, key integrations,
and pre-written Claude prompts for using that plugin locally.

---

### MCP Recommendations by Stack

**Tier 1 — Always useful:**
- `filesystem` — structured file reads across the project
- `memory` — persistent key/value store across sessions
- `fetch` / `brave-search` — web lookup during coding

**Installed MCPs (live in `~/Documents/MCPs/`):**
| MCP | Purpose |
|-----|---------|
| `Blender_MCP` | Blender 3D modeling & scene control (ahujasid/blender-mcp) |
| `Firecrawl_MCP` | Web scraping, crawling & search (firecrawl/firecrawl-mcp-server) — lives at `~/Documents/Firecrawl_MCP/` |
| `Get_Shit_Done_MCP` | GSD meta-prompting server |
| `GoogleWorkspace_MCP` | Gmail, Calendar, Drive integration |
| `NotebookLM_MCP` | Google NotebookLM queries |
| `Pupeteer_MCP` | Browser automation via Puppeteer |
| `Remotion_MCP` | Programmatic video rendering |
| `Chatterbox` | Multilingual text-to-speech |
| `Premiere_Pro` | Adobe Premiere Pro automation |
| `Stitch_MCP` | Google Stitch design-to-code (via npx + proxy transport) |
| `Unreal_Engine_MCP` | Unreal Engine game dev control (flopperam/unreal-engine-mcp) |
| `adb-mcp` | Android Debug Bridge |
| `wifi_RuView` | WiFi/network inspection |
| Perplexity | AI-powered web search with citations (via uvx perplexity-mcp) |

**Tier 2 — Stack-specific (npx / install as needed):**
| Stack | Recommended MCPs |
|-------|-----------------|
| Astro / Next.js | `vercel`, `github`, `supabase` |
| WordPress | `wordpress`, `contentful` |
| Webflow | `webflow` (Data API), `notion` |
| Shopify | `shopify`, `github` |
| Python/data | `postgres`, `sqlite`, `jupyter` |
| DevOps | `aws`, `terraform`, `kubernetes` |
| General content | `notion`, `sanity`, `contentful` |

---

### Plugin Recommendations (Website Projects)

When the project is website-related, recommend cloning into `~/Documents/Website_Building/Plugins/`:

| If building... | Use Plugin folder |
|----------------|-------------------|
| Content site / blog / docs | `Astro_Web_Builder/` — withastro/astro + starlight |
| Any AI-powered web feature | `Mastra_TypeScript/` — mastra-ai/mastra |
| Any modern UI / component work | `Tailwind_CSS/` — tailwindcss + shadcn-ui + headlessui |
| SEO / AI discoverability | `SchemaOrg/` — schema-dts + next-seo + astro-seo |
| Any public-facing site | `LLMS_Txt/` — llms-txt spec for AI readability |

**Also recommend from other categories based on project type:**

| Project type | Recommend from |
|--------------|----------------|
| Any project | `General/GSD/` — meta-prompting setup |
| Needs persistent memory | `Memory/` + `Agents/claude-mem/` |
| Building agents/automations | `Agents/PaperClip/` |
| Building CLI tools | `CLI_Build/CLI-Anything/` |

---

### CLIs (installed in `~/Documents/CLIs/`)

| CLI | Path | Purpose |
|-----|------|---------|
| `Gemini_CLI` | `~/Documents/CLIs/Gemini_CLI/` | Google Gemini AI CLI (google-gemini/gemini-cli) |
| `Nanobanana_CLI` | `~/Documents/CLIs/Nanobanana_CLI/` | AI image generation via Gemini (Gemini extension — generate, edit, style transfer, diagrams) |
| `GoogleWorkspace_CLI` | `~/Documents/CLIs/GoogleWorkspace_CLI/` | Google Workspace automation |
| `PlayWright_CLI` | `~/Documents/CLIs/PlayWright_CLI/` | Browser automation via Playwright |

For Vercel, use the globally installed `vercel` CLI:
```bash
vercel dev       # local dev server
vercel --prod    # deploy to production
vercel env pull .env.local
```

---

### Plugin Activation — Always Include These When Suggesting a Tool

> **Rule:** Whenever any plugin, MCP, CLI, or agent is suggested during a session,
> always output its full activation instructions inline. Never assume the user
> remembers the commands. Copy-paste ready, every time.

---

#### Oh-My-ClaudeCode — Multi-agent orchestration for Claude Code
**First-time install (once):**
```bash
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
```
**First-time setup (once):**
```
/setup
/omc-setup
```
**After install:** loads automatically on every Claude Code session.
**Use it:** just type naturally — `autopilot: build a REST API for managing tasks`
Or for vague ideas: `/deep-interview "describe your idea"`

---

#### God Mode 3 — Multi-model web UI (50+ models via OpenRouter)
**Launch it:**
```bash
~/Documents/Plugins/God_Mode_3/launch.sh
```
Opens at `http://localhost:8000` in your browser.
**Requires:** OpenRouter API key — get one free at `openrouter.ai/keys`
**Not a Claude Code plugin** — runs as a standalone web app.

---

#### The Agency / NEXUS — 60+ specialist agents
**One-time install into Claude Code:**
```bash
mkdir -p ~/.claude/agents
cp -r ~/Documents/Plugins/Agency_Agents/* ~/.claude/agents/
```
**Activate any agent:**
```
Activate [Agent Name] and [task]
```
**NEXUS-Micro (2-5 agents):**
```
Activate Agents Orchestrator in NEXUS-Micro mode. Task: [describe task]
```
**Full prompt templates:** `~/Documents/Plugins/Agency_Agents/strategy/QUICKSTART.md`

---

#### Composio Connect-Apps — Live actions in 500+ apps
**Launch:**
```bash
claude --plugin-dir ~/Documents/Claude_Skills/awesome-claude-skills/connect-apps-plugin
```
**Inside Claude, run:**
```
/connect-apps:setup
```
Paste your Composio API key when asked (free at `platform.composio.dev`).

---

#### Blender MCP — Claude controls Blender directly
**One-time Blender setup:**
1. Open Blender → Edit → Preferences → Add-ons → Install from Disk
2. Select: `~/Documents/MCPs/Blender_MCP/addon.py`
3. Enable the addon checkbox
4. In the addon panel: click **Start MCP Server**

Then restart Claude Desktop — the `blender` MCP will connect automatically.

---

#### Nanobanana CLI — AI image generation via Gemini
**Use inside Gemini CLI:**
```bash
gemini
# then type: /nanobanana generate a photo of [description]
# or:        /nanobanana edit [image path] to [change]
```
**Extension is already installed** at `~/.gemini/extensions/nanobanana/`.
**Auth:** inherited from your existing `gcloud auth application-default login` — no separate setup.
**Capabilities:** generate images, edit existing images, style transfer, technical diagrams, mockups.

---

#### NotebookLM MCP — Query Google NotebookLM from Claude
**If auth has expired:**
```bash
nlm login
```
Opens browser for Google account login. Run this before using NotebookLM tools.

---

#### Perplexity MCP — AI-powered web search
**Already wired in Claude Desktop.** Use it directly in conversation:
```
Search the web for [topic]
```
Claude will automatically use Perplexity for live web queries.
**If it fails**, check your API key at `perplexity.ai` and update `claude_desktop_config.json`.
**Model:** `sonar` (default) — fast, real-time web search with citations.

---

#### Firecrawl MCP — Web scraping and crawling
**Already wired in Claude Desktop.** If it fails, check your API key:
```bash
nano ~/.claude/.env
# ensure FIRECRAWL_API_KEY is set
source ~/.claude/inject-secrets.sh
```

---

#### Claude Code MCPs (user-scope) — Always active in Claude Code sessions
These are added to `~/.claude.json` and load automatically. No activation needed.

| MCP | What it does |
|-----|-------------|
| Google Calendar | Manage calendar events, find free time, schedule meetings |
| Gmail | Search, read, draft emails (standalone, separate from Google Workspace MCP) |
| Google Drive | Search and fetch Drive file contents |
| Notion | Full workspace — pages, databases, comments, search |
| Airtable | Read/write bases, tables, records |
| Make.com | Build automations, run scenarios, manage webhooks and data stores |
| Supabase | SQL queries, migrations, edge functions, project management |
| Three.js | 3D scene rendering and Three.js learning |
| HuggingFace | Search models, papers, Spaces, Hub repos |
| Figma | Design context, code connect, file creation, diagram generation |
| Stitch | Google Stitch design-to-code (HTTP transport — token expires hourly) |

**Stitch token refresh** (run when Stitch stops working):
```bash
claude mcp add stitch --transport http https://stitch.googleapis.com/mcp --header "Authorization: Bearer $(gcloud auth print-access-token)" --header "X-Goog-User-Project: personal-workshop-487222" -s user
```

---

#### GSD (Get Shit Done) — Structured project execution
**Already active** via Claude Code hooks. Use slash commands:
```
/gsd:new-project    ← start a new project
/gsd:plan-phase     ← plan the next phase
/gsd:execute-phase  ← execute a phase
/gsd:progress       ← check status
/gsd:help           ← full command list
```

---

#### SuperPowers — Claude Code workflow enhancements
**Already active** via `enabledPlugins` in settings.json.
Use slash commands:
```
/superpowers:write-plan
/superpowers:execute-plan
/superpowers:brainstorm
```

---

#### PaperClip — Context-aware task management
**Install dependencies (once):**
```bash
cd ~/Documents/Plugins/Agents/PaperClip/paperclip
pnpm install && pnpm build
```
Then follow `README.md` for configuration.

---

#### n8n — Workflow automation
**Start the server:**
```bash
cd ~/Documents/n8n_github
docker-compose up -d
```
Opens at `http://localhost:5678`
**Stop it:**
```bash
docker-compose down
```

---

#### Letta (MemGPT) — Persistent memory server
**Start:**
```bash
letta server
```
Runs at `http://localhost:8283` — keep terminal open while using memory tools.

---

### After Recommendations, Offer To:
1. Generate the MCP config JSON for `.claude/settings.json`
2. Create `install.sh` and `aliases.sh` in the relevant `CLIs/` folder
3. Output the `git clone` commands for selected Plugin repos
4. Add an MCP + Plugin awareness block to `CLAUDE.md`:

```markdown
## Local Tooling
### MCP Servers (~/Documents/MCPs/)
- **Blender_MCP**: Blender 3D modeling & scene control via Claude
- **Get_Shit_Done_MCP**: GSD meta-prompting
- **GoogleWorkspace_MCP**: Gmail, Calendar, Drive
- **NotebookLM_MCP**: Google NotebookLM
- **Pupeteer_MCP**: Browser automation
- **Remotion_MCP**: Video rendering
- **Chatterbox**: Text-to-speech
- **Premiere_Pro**: Adobe Premiere automation
- **Unreal_Engine_MCP**: Unreal Engine game dev control via Claude
- <add others as needed>

### CLIs (~/Documents/CLIs/)
- **Gemini_CLI**: Google Gemini AI CLI
- **GoogleWorkspace_CLI**: Google Workspace automation
- **PlayWright_CLI**: Browser automation

### Plugin Repos (~/Documents/Plugins/)
- **Website_Building/Astro_Web_Builder**: ~/Documents/Plugins/Website_Building/Astro_Web_Builder/
- **Website_Building/Mastra_TypeScript**: ~/Documents/Plugins/Website_Building/Mastra_TypeScript/
- **Website_Building/Tailwind_CSS**: ~/Documents/Plugins/Website_Building/Tailwind_CSS/
- **Website_Building/SchemaOrg**: ~/Documents/Plugins/Website_Building/SchemaOrg/
- **Website_Building/LLMS_Txt**: ~/Documents/Plugins/Website_Building/LLMS_Txt/
- **claude-mem**: ~/Documents/Plugins/claude-mem/
- **Agents/PaperClip**: ~/Documents/Plugins/Agents/PaperClip/

### General Tools
- **GSD**: ~/Documents/Plugins/General/GSD/
- **SuperPowers**: ~/Documents/Plugins/General/SuperPowers/

### The Agency (AI Agent Specialists)
- **Repo**: ~/Documents/Plugins/Agency_Agents/
- **Install agents**: `cp -r ~/Documents/Plugins/Agency_Agents/* ~/.claude/agents/`
- **60+ agents** organized by: engineering, design, marketing, product, project-management, testing, specialized, spatial-computing, game-development
- **NEXUS orchestration**: Coordinate multiple agents in a pipeline — see `strategy/QUICKSTART.md`
- **Activate any agent**: "Activate [Agent Name] and [task]" — e.g., "Activate Backend Architect and review this API design"
→ See full Agent Selection Guide below in this skill

### Composio / Awesome Claude Skills
- **Repo**: ~/Documents/Claude_Skills/awesome-claude-skills/
- **composio-skills**: 500+ per-service automation skills (Slack, Gmail, GitHub, Notion, etc.)
  - Reference: "Read ~/Documents/Claude_Skills/awesome-claude-skills/composio-skills/<service>-automation/SKILL.md"
- **connect-apps-plugin**: Activate with `claude --plugin-dir ~/Documents/Claude_Skills/awesome-claude-skills/connect-apps-plugin`
  - Then run `/connect-apps:setup` and paste your Composio API key (free at platform.composio.dev)
  - Writes MCP config to `~/.mcp.json` — enables Claude to take real actions in 500+ apps

Reference locally: "Read ~/Documents/Plugins/Website_Building/Mastra_TypeScript/README.md"
```

---

## Final Checklist

After completing all steps, verify with the user:

- [ ] `/model` command installed at `.claude/commands/model.md`
- [ ] Model strategy block added to project `CLAUDE.md`
- [ ] Token economy rules in Global `~/.claude/CLAUDE.md`
- [ ] `AGENTS.md` created at project root
- [ ] Global `~/.claude/CLAUDE.md` reviewed/created (includes token + model sections)
- [ ] Project `./CLAUDE.md` is ≤300 lines with `@imports`
- [ ] `CLAUDE.local.md` created and gitignored
- [ ] `docs/` folder populated with domain files
- [ ] `.claude/` directory fully scaffolded
- [ ] `settings.json` with permissions and hooks
- [ ] `/compress` and `/preserve` commands installed
- [ ] Security hooks script created and wired
- [ ] Vault architecture agreed upon
- [ ] Memory loop workflow explained
- [ ] MCP tools selected and configured (live in `~/Documents/MCPs/`)
- [ ] CLI tools identified with install.sh (live in `~/Documents/CLIs/`)
- [ ] Plugin repos identified and clone commands provided (live in `~/Documents/Plugins/`)
- [ ] CLAUDE.md updated with local tooling awareness block
- [ ] `~/Documents/` backup strategy confirmed (see below)

→ Generate a `PROJECT-SETUP-SUMMARY.md` at the root that logs what was created
  and any decisions made during this setup session.

---

## Environment Backup & Portability

> Ask the user: "Do you want to set up backup so this environment is portable to another machine?"

The `~/Documents/` folder uses a three-file backup system:

| File | Purpose |
|------|---------|
| `bootstrap.sh` | Reinstalls all CLIs, MCPs, and clones all Plugin repos on any new Mac |
| `.gitignore` | Excludes cloned repos and secrets — only tracks READMEs and configs |
| `sync.md` | Full instructions for git repo, iCloud, and manual sync options |

### Recommended: Private Git Repo
```bash
cd ~/Documents
git init && git add . && git commit -m "Initial Documents setup"
gh repo create documents-hub --private --source=. --push
```

### On any new machine (two commands):
```bash
git clone https://github.com/YOUR_USERNAME/documents-hub.git ~/Documents
~/Documents/bootstrap.sh
```

### Also back up `~/.claude/CLAUDE.md` separately:
```bash
cp ~/.claude/CLAUDE.md ~/Documents/claude-config/CLAUDE.md
git add . && git commit -m "Update global CLAUDE.md"
```

**Tokens are never synced** — re-enter `VERCEL_TOKEN`, `GITHUB_TOKEN`,
and `SUPABASE_*` manually in `.claude/settings.json` on each new machine.

→ Full sync guide: `~/Documents/sync.md`

---

## Agent Selection Guide — The Agency

> **Location**: `~/Documents/Plugins/Agency_Agents/`
> **Install**: `cp -r ~/Documents/Plugins/Agency_Agents/* ~/.claude/agents/`
> **Activate**: "Activate [Agent Name] and [task description]"

The Agency is a collection of 60+ specialist agent personas. Each agent has a focused identity,
workflow, and deliverable style. Use them to get domain-expert output instead of generalist output.

---

### NEXUS Modes — When to Orchestrate Multiple Agents

| Mode | Use When | Scale | Example |
|------|----------|-------|---------|
| **NEXUS-Full** | Building an entire product from scratch | All agents, 12-24 weeks | "Build a SaaS from spec to launch" |
| **NEXUS-Sprint** | Building a feature or MVP | 15-25 agents, 2-6 weeks | "Build and ship this feature" |
| **NEXUS-Micro** | A single bounded task | 2-5 agents, 1-5 days | "Fix this bug and verify the fix" |

**Activate with**: "Activate Agents Orchestrator in NEXUS-[Full/Sprint/Micro] mode."
→ Full prompts in `~/Documents/Plugins/Agency_Agents/strategy/QUICKSTART.md`

---

### Task → Agent Quick Reference

#### Building & Engineering

| Task | Agent | Why This Agent |
|------|-------|----------------|
| New feature or component | `Frontend Developer` | React/Vue/CSS specialist — outputs real production code, not pseudocode |
| API design or server logic | `Backend Architect` | Focused on scalable patterns, auth, and data contracts — not just "write a function" |
| Proof of concept quickly | `Rapid Prototyper` | Optimized for speed-over-perfection; avoids over-engineering |
| System architecture decision | `Software Architect` | Big-picture tradeoffs: monolith vs. micro, DB choices, scaling concerns |
| CI/CD, infra, deployment | `DevOps Automator` | Specializes in pipelines, containers, and deploy workflows |
| AI feature / LLM integration | `AI Engineer` | Prompt engineering, RAG, model selection, embeddings — not generic coding |
| Mobile app (iOS/Android) | `Mobile App Builder` | Native + cross-platform patterns; knows when to use Expo vs. native |
| Smart contracts / Web3 | `Solidity Smart Contract Engineer` | Solidity-specific: gas optimization, security patterns, audits |
| Production incident | `Incident Response Commander` | Keeps you structured under pressure: triage → mitigation → postmortem |
| Code review | `Code Reviewer` | Systematic review: correctness, security, performance, style — not just nitpicking |
| Security audit | `Security Engineer` | OWASP, threat modeling, vuln scanning — proactive rather than reactive |
| Database performance | `Database Optimizer` | Query tuning, index strategy, schema normalization — not just "add an index" |
| Git workflow / branching | `Git Workflow Master` | Branch strategy, rebase vs. merge, conflict resolution, release tagging |
| Docs / technical writing | `Technical Writer` | API docs, READMEs, architecture decision records — audience-aware output |

#### Design & UX

| Task | Agent | Why This Agent |
|------|-------|----------------|
| User flows, wireframes | `UX Architect` | Information architecture + interaction patterns — starts from user goals |
| User research / usability | `UX Researcher` | Interview guides, usability tests, insight synthesis — evidence-driven |
| UI component design | `UI Designer` | Visual hierarchy, spacing, color, component states — Figma-thinking in text |
| Brand consistency | `Brand Guardian` | Enforces tone, color, logo usage, copy voice — gatekeeper role |
| Generating image prompts | `Image Prompt Engineer` | Writes precise prompts for Midjourney/DALL-E — knows how models interpret language |
| Accessibility | `Inclusive Visuals Specialist` | WCAG compliance, contrast, screen reader patterns, keyboard nav |
| Adding personality/delight | `Whimsy Injector` | Micro-interactions, copy tone, Easter eggs — makes products feel alive |

#### Marketing & Growth

| Task | Agent | Why This Agent |
|------|-------|----------------|
| Growth strategy | `Growth Hacker` | Acquisition loops, viral mechanics, funnel optimization — metrics-first |
| Content creation | `Content Creator` | Blog posts, landing copy, emails — audience-aware, SEO-informed |
| SEO strategy | `SEO Specialist` | Keyword research, on-page optimization, link-building — not just "add meta tags" |
| Twitter/X presence | `Twitter Engager` | Knows the algorithm, thread formats, engagement hooks |
| TikTok / short video | `TikTok Strategist` | Hook writing, trend surfing, video structure for TikTok's feed |
| Instagram | `Instagram Curator` | Grid aesthetics, caption style, story vs. feed strategy |
| App store optimization | `App Store Optimizer` | Title, subtitle, keywords, screenshots, ratings — ASO-specific |
| Podcast strategy | `Podcast Strategist` | Episode structure, guest strategy, distribution, show notes |
| Reddit community | `Reddit Community Builder` | Knows subreddit culture, when to post vs. comment, how not to get banned |

#### Product & Strategy

| Task | Agent | Why This Agent |
|------|-------|----------------|
| Feature prioritization | `Sprint Prioritizer` | ICE/RICE scoring, backlog grooming, effort vs. impact — cuts through opinion |
| Market research | `Trend Researcher` | Competitive landscape, market sizing, trend forecasting — structured output |
| User feedback synthesis | `Feedback Synthesizer` | Clusters themes from raw feedback, surfaces signal from noise |
| Product roadmap | `Product Manager` | Connects business goals to feature specs; balances stakeholder needs |

#### Project Management

| Task | Agent | Why This Agent |
|------|-------|----------------|
| Running a sprint | `Senior Project Manager` | Sprint ceremonies, blockers, velocity tracking — keeps the team moving |
| Shepherding a project | `Project Shepherd` | Watches for scope creep, dependencies, timeline drift |
| Studio / creative ops | `Studio Producer` | Coordinates creative + technical work across disciplines |
| Jira workflows | `Jira Workflow Steward` | Epic/story/task structure, workflow states, field hygiene |

#### Testing & Quality

| Task | Agent | Why This Agent |
|------|-------|----------------|
| Final quality check | `Reality Checker` | Hardest gatekeeper — defaults to "NEEDS WORK"; requires evidence not assertions |
| Collecting visual proof | `Evidence Collector` | Screenshots, test outputs, before/after — documents that work was actually done |
| Performance diagnosis | `Performance Benchmarker` | Latency, throughput, DB query time — finds the real bottleneck |
| API testing | `API Tester` | Contract testing, edge cases, error codes, auth flows |
| Workflow analysis | `Workflow Optimizer` | Spots inefficiencies in process, not just code |
| Tool evaluation | `Tool Evaluator` | Structured comparison of libraries/services — cuts through marketing noise |

#### Game Development

| Task | Agent | Why This Agent |
|------|-------|----------------|
| Unreal Engine systems | `Unreal Systems Engineer` | Blueprints, C++ gameplay code, UE-specific patterns |
| Unreal multiplayer | `Unreal Multiplayer Architect` | Netcode, replication, server authority — online-specific expertise |
| Unreal world building | `Unreal World Builder` | Landscape, foliage, lighting, level streaming — environment-focused |
| Unreal technical art | `Unreal Technical Artist` | Materials, shaders, VFX, performance budgets — bridge between art and code |
| Blender addon/scripting | `Blender Addon Engineer` | Python bpy API, addon architecture, Blender-specific scripting |
| Game design | `Game Designer` | Core loops, economy, progression systems, balance |
| Narrative design | `Narrative Designer` | Branching dialogue, lore, character arcs, story integration |
| Level design | `Level Designer` | Flow, pacing, encounter design, spatial storytelling |
| Game audio | `Game Audio Engineer` | Sound design, music systems, FMOD/Wwise integration |
| Unity development | See `game-development/unity/` | Unity-specific agents in subfolder |
| Godot development | See `game-development/godot/` | Godot-specific agents in subfolder |

#### Spatial Computing

| Task | Agent | Why This Agent |
|------|-------|----------------|
| visionOS / Apple Vision Pro | `visionOS Spatial Engineer` | RealityKit, SwiftUI scenes, spatial UX patterns |
| XR interface design | `XR Interface Architect` | Spatial UI/UX — different rules from flat-screen design |
| XR development (broad) | `XR Immersive Developer` | Cross-platform XR: WebXR, Unity, Unreal |
| macOS Metal / GPU | `macOS Spatial Metal Engineer` | Metal API, compute shaders, GPU performance |
| Cockpit / industrial XR | `XR Cockpit Interaction Specialist` | Mission-critical spatial interfaces |

#### Specialized

| Task | Agent | Why This Agent |
|------|-------|----------------|
| Orchestrating many agents | `Agents Orchestrator` | Coordinates the full NEXUS pipeline; tracks handoffs and quality gates |
| Building an MCP server | `MCP Builder` | Knows the MCP spec, tool schema design, server patterns |
| Workflow architecture | `Workflow Architect` | Designs automation pipelines, event-driven systems, integration patterns |
| Compliance audit | `Compliance Auditor` | GDPR, CCPA, HIPAA — structured audit with evidence requirements |
| Data consolidation | `Data Consolidation Agent` | ETL patterns, deduplication, source-of-truth design |

---

### Decision Framework — Solo vs. Agent vs. NEXUS

```
Task takes < 30 min and I know exactly what to do?
  → Just do it yourself with Claude

Task requires specialist depth I don't have?
  → Activate a single specialist agent

Task spans multiple domains (design + engineering + QA)?
  → NEXUS-Micro (2-5 agents, handoff between them)

Task is a full feature with design, build, and verification?
  → NEXUS-Sprint (15-25 agents, phased pipeline)

Starting a product from zero?
  → NEXUS-Full (complete pipeline, all phases)
```

### Pairing Agents With Your Existing Tools

| Scenario | Agent(s) | Supporting Tool |
|----------|----------|-----------------|
| Build + test a new API endpoint | Backend Architect → API Tester | Playwright MCP for browser testing |
| Redesign a UI component | UX Architect → UI Designer → Evidence Collector | Claude Preview MCP for screenshots |
| SEO audit and fix | SEO Specialist → Technical Writer | Firecrawl MCP to crawl the site |
| Blender 3D scene from prompt | Blender Addon Engineer | Blender MCP (direct Blender control) |
| Unreal game mechanic | Unreal Systems Engineer → Unreal Technical Artist | Unreal Engine MCP |
| Production incident | Incident Response Commander → DevOps Automator | NotebookLM MCP to log the postmortem |
| Content campaign | Content Creator → Brand Guardian → Growth Hacker | Composio connect-apps (post to channels) |
