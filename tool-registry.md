# AI Stack — Tool Registry
# Complete inventory of every tool in this stack.
# Import this into your CLAUDE.md and GEMINI.md for automatic tool awareness.
# Last updated: 2026-03-29

---

## MCPs — ~/Documents/MCPs/

| Name | Folder | Purpose | Recommended Machines |
|------|--------|---------|---------------------|
| Firecrawl | `~/Documents/Firecrawl_MCP/` | Web scraping, crawling, search | All |
| Google Workspace | `GoogleWorkspace_MCP/` | Gmail, Calendar, Drive | All |
| NotebookLM | `NotebookLM_MCP/` | Google NotebookLM queries | All |
| Puppeteer | via npx | Browser automation | All |
| Stitch | via npx | Google Stitch design-to-code | All |
| Composio connect-apps | via HTTP | 500+ app actions | All |
| Get Shit Done | `Get_Shit_Done_MCP/` | GSD meta-prompting | All |
| Chatterbox | `Chatterbox/` | Multilingual TTS | All |
| Blender | `Blender_MCP/` | Blender 3D control | GPU machine |
| Unreal Engine | `Unreal_Engine_MCP/` | Unreal Engine control | GPU machine |
| Premiere Pro | `Premiere_Pro/` | Adobe Premiere automation | GPU machine |
| Remotion | via npx `@remotion/mcp@latest` | Programmatic video rendering | Rendering machine |
| ADB | `adb-mcp/` | Android Debug Bridge | Dev machine |
| WiFi/RuView | `wifi_RuView/` | WiFi signal analysis | Any |

### Claude Desktop config location:
`~/Library/Application Support/Claude/claude_desktop_config.json`
Templates in `~/ai-stack/configs/` — copy the one matching your machine role.

---

## CLIs — ~/Documents/CLIs/

| Name | Folder | Purpose | Auth |
|------|--------|---------|------|
| Gemini CLI | `Gemini_CLI/gemini-cli/` | Google Gemini AI | Google OAuth on first run |
| Google Workspace CLI | `GoogleWorkspace_CLI/` | Google Workspace automation | `npm run auth` |
| Playwright CLI | `PlayWright_CLI/playwright/` | Browser automation | None |

---

## Plugins — ~/Documents/Plugins/

| Name | Path | Purpose |
|------|------|---------|
| Agency Agents | `Plugins/Agency_Agents/` | 60+ specialist agents + NEXUS orchestration |
| God Mode 3 | `Plugins/God_Mode_3/` | Multi-model web UI (50+ models via OpenRouter) |
| Oh My Claude Code | `Plugins/Oh_My_Claude_Code/` | Claude Code enhancement: hooks, missions, skills |
| PaperClip | `Plugins/Agents/PaperClip/` | Context-aware task management |
| claude-mem | `Plugins/claude-mem/` | Persistent memory layer |
| CLI-Anything | `Plugins/CLI_Build/CLI-Anything/` | Meta-CLI builder |
| GSD | `Plugins/General/GSD/` | Get Shit Done meta-prompting |
| SuperPowers | `Plugins/General/SuperPowers/` | Claude Code workflow enhancements |
| mem0 | `Plugins/Memory/mem0/` | Memory system |
| Letta (MemGPT) | `Plugins/Memory/MemGPT/` | Persistent memory server |
| Astro | `Plugins/Website_Building/Astro_Web_Builder/` | Static site framework |
| Mastra | `Plugins/Website_Building/Mastra_TypeScript/` | TypeScript AI framework |
| Tailwind + shadcn | `Plugins/Website_Building/Tailwind_CSS/` | CSS + UI components |
| SchemaOrg | `Plugins/Website_Building/SchemaOrg/` | Structured data |
| LLMS.txt | `Plugins/Website_Building/LLMS_Txt/` | AI readability spec |

---

## Claude Skills — ~/Documents/Claude_Skills/

| Name | Path | Purpose |
|------|------|---------|
| awesome-claude-skills | `Claude_Skills/awesome-claude-skills/` | ComposioHQ skill collection |
| composio-skills | `Claude_Skills/awesome-claude-skills/composio-skills/` | 500+ per-service automation skills |
| connect-apps-plugin | `Claude_Skills/awesome-claude-skills/connect-apps-plugin/` | Composio plugin for Claude Code |
| document-skills | `Claude_Skills/awesome-claude-skills/document-skills/` | docx, pdf, pptx, xlsx |

### Activate connect-apps:
```bash
claude --plugin-dir ~/Documents/Claude_Skills/awesome-claude-skills/connect-apps-plugin
# then: /connect-apps:setup
```

---

## Other Tools

| Name | Path | Purpose |
|------|------|---------|
| n8n | `~/Documents/n8n_github/` | Workflow automation (Docker) |
| Firecrawl MCP | `~/Documents/Firecrawl_MCP/` | Web scraping — lives at Documents root |

---

## Agent Selection — Quick Reference

**Single task** → "Activate [Agent Name] and [task]"
**Multi-domain** → NEXUS-Micro (2-5 agents, 1-5 days)
**Feature build** → NEXUS-Sprint (15-25 agents, 2-6 weeks)
**Full product** → NEXUS-Full (all phases, 12-24 weeks)

Full activation prompts: `~/Documents/Plugins/Agency_Agents/strategy/QUICKSTART.md`

---

## Activation — Copy-Paste Commands

### Oh My Claude Code
```bash
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
# then: /omc-setup
```

### God Mode 3
```bash
~/Documents/Plugins/God_Mode_3/launch.sh
# opens http://localhost:8000 — bring your OpenRouter API key
```

### Agency Agents
```bash
mkdir -p ~/.claude/agents
cp -r ~/Documents/Plugins/Agency_Agents/* ~/.claude/agents/
# then: "Activate [Agent Name] and [task]"
```

### n8n
```bash
cd ~/Documents/n8n_github && docker-compose up -d
# opens http://localhost:5678
```

### Letta memory server
```bash
letta server
# runs at http://localhost:8283
```
