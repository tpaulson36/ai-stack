# Tool Registry
# Single source of truth for all AI tools across all machines.
# Imported by ~/.claude/CLAUDE.md and ~/.gemini/GEMINI.md
# Last updated: 2026-03-31

---

## MCPs — ~/Documents/MCPs/

| Name | Folder | Purpose | Machines |
|------|--------|---------|---------|
| Firecrawl | `~/Documents/Firecrawl_MCP/` | Web scraping, crawling, search | Travel, Mini |
| Google Workspace | `GoogleWorkspace_MCP/` | Gmail, Calendar, Drive | Travel, Mini |
| NotebookLM | `NotebookLM_MCP/` | Google NotebookLM queries | Travel, Mini |
| Puppeteer | via npx | Browser automation | All |
| Stitch | via npx | Google Stitch design-to-code | Travel, Mini |
| Perplexity | via uvx | AI-powered web search | Travel, Mini |
| Composio connect-apps | via HTTP | 500+ app actions | Travel, Mini |
| Get Shit Done | `Get_Shit_Done_MCP/` | GSD meta-prompting | All |
| Chatterbox | `Chatterbox/` | Multilingual TTS | All |
| Blender | `Blender_MCP/` | Blender 3D control | Alien |
| Unreal Engine | `Unreal_Engine_MCP/` | Unreal Engine control | Alien |
| Premiere Pro | `Premiere_Pro/` | Adobe Premiere automation | Alien |
| Remotion | `Remotion_MCP/` | Programmatic video rendering | Mini, Alien |
| ADB | `adb-mcp/` | Android Debug Bridge | Mini |
| WiFi/RuView | `wifi_RuView/` | WiFi signal analysis | Mini |

### Activate a MCP in Claude Desktop:
Config lives at `~/Library/Application Support/Claude/claude_desktop_config.json`
Source of truth: `~/dotfiles/machines/<machine>/claude_desktop_config.json`
Symlinked during bootstrap — never edit the live config directly.

---

## Claude Code MCPs — user-scope (~/.claude.json)

Added via `claude mcp add -s user`. Active in all Claude Code sessions on this machine.

| Name | Purpose | Notes |
|------|---------|-------|
| Google Calendar | Create, read, update, delete calendar events | Standalone gcal MCP |
| Gmail | Search, read, draft Gmail messages | Standalone gmail MCP |
| Google Drive | Search and fetch Drive files | Standalone drive MCP |
| Notion | Full Notion workspace — pages, databases, search | Notion MCP |
| Airtable | Read/write Airtable bases, tables, records | Airtable MCP |
| Make.com | Build and run Make scenarios, webhooks, data stores | Full Make platform API |
| Supabase | SQL, migrations, edge functions, projects | Supabase MCP |
| Three.js | 3D scene rendering and learning | Three.js MCP |
| HuggingFace | Search models, papers, spaces, Hub repos | HuggingFace MCP |
| Figma | Design context, code connect, file creation, diagrams | Extended Figma MCP |
| Stitch | Google Stitch design-to-code via HTTP | Added via `claude mcp add stitch` |

### Re-add Stitch token (expires hourly):
```bash
claude mcp add stitch \
  --transport http https://stitch.googleapis.com/mcp \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --header "X-Goog-User-Project: personal-workshop-487222" \
  -s user
```

---

## CLIs — ~/Documents/CLIs/

| Name | Folder | Purpose | Auth required |
|------|--------|---------|--------------|
| Gemini CLI | `Gemini_CLI/gemini-cli/` | Google Gemini AI | Google OAuth (done on first run) |
| Nanobanana CLI | `Nanobanana_CLI/` | AI image generation via Gemini (Gemini CLI extension) | Gemini auth (inherited) |
| Google Workspace CLI | `GoogleWorkspace_CLI/` | Google Workspace automation | Google OAuth (`npm run auth`) |
| Playwright CLI | `PlayWright_CLI/playwright/` | Browser automation | None |

---

## Plugins — ~/Documents/Plugins/

| Name | Path | Purpose |
|------|------|---------|
| Agency Agents | `Plugins/Agency_Agents/` | 60+ specialist agents + NEXUS orchestration |
| God_Mode_3 | `Plugins/God_Mode_3/` | Advanced Claude Code power-user interface (elder-plinius/G0DM0D3) |
| Oh_My_Claude_Code | `Plugins/Oh_My_Claude_Code/` | Claude Code enhancement framework with hooks, missions, skills (Yeachan-Heo/oh-my-claudecode) |
| PaperClip | `Plugins/Agents/PaperClip/` | Context-aware task management |
| claude-mem | `Plugins/Agents/claude-mem/` | Persistent memory layer |
| CLI-Anything | `Plugins/CLI_Build/CLI-Anything/` | Meta-CLI builder |
| GSD | `Plugins/General/GSD/` | Get Shit Done meta-prompting |
| SuperPowers | `Plugins/General/SuperPowers/` | Claude Code workflow enhancements |
| mem0 | `Plugins/Memory/mem0/` | Memory system |
| Letta (MemGPT) | `Plugins/Memory/MemGPT/` | Persistent memory server |
| Zep | `Plugins/Memory/zep/` | Memory layer |
| Astro | `Plugins/Website_Building/Astro_Web_Builder/` | Static site framework |
| Mastra | `Plugins/Website_Building/Mastra_TypeScript/` | TypeScript AI framework |
| Tailwind | `Plugins/Website_Building/Tailwind_CSS/` | CSS + UI components |
| SchemaOrg | `Plugins/Website_Building/SchemaOrg/` | Structured data |
| LLMS.txt | `Plugins/Website_Building/LLMS_Txt/` | AI readability spec |

---

## Claude Skills — ~/Documents/Claude_Skills/

| Name | Path | Purpose |
|------|------|---------|
| awesome-claude-skills | `Claude_Skills/awesome-claude-skills/` | ComposioHQ skill collection |
| composio-skills | `Claude_Skills/awesome-claude-skills/composio-skills/` | 500+ per-service automation skills |
| connect-apps-plugin | `Claude_Skills/awesome-claude-skills/connect-apps-plugin/` | Composio plugin for Claude |
| document-skills | `Claude_Skills/awesome-claude-skills/document-skills/` | docx, pdf, pptx, xlsx |

### Activate connect-apps plugin:
```bash
claude --plugin-dir ~/Documents/Claude_Skills/awesome-claude-skills/connect-apps-plugin
# then: /connect-apps:setup
```

---

## Other Tools

| Name | Path | Purpose |
|------|------|---------|
| n8n | `~/Documents/n8n_github/` | Workflow automation (Docker) |
| Firecrawl MCP | `~/Documents/Firecrawl_MCP/` | Web scraping (note: root of Documents, not MCPs/) |

---

## Agent Selection — Quick Reference

**Single agent tasks** → Activate by name: "Activate [Agent Name] and [task]"
**Multi-domain tasks** → NEXUS-Micro (2-5 agents)
**Feature build** → NEXUS-Sprint (15-25 agents)
**Full product** → NEXUS-Full (all phases)

Full guide: `~/.claude/skills/setup_project/SKILL.md` → Agent Selection Guide section

---

## Machine Roles

| Machine | Role | Active MCPs |
|---------|------|------------|
| Astrid Consulting Air (travel) | Brainstorm · research · new tool eval · docs/specs | Firecrawl, Google Workspace, NotebookLM, Puppeteer, Stitch, Composio |
| Mac Mini | Always-on agent · dispatch · heavy coding · remote tasks | All except GPU tools |
| Alien Desktop | Blender · Unreal · Premiere · GPU (4070) | Blender, Unreal, Premiere, Remotion |
