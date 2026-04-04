# AI Stack — Tool Registry
# Complete inventory of every tool in this stack.
# Last updated: 2026-04-04

---

## MCPs — Active & Connected

### Productivity & Workspace
| Name | Purpose |
|------|---------|
| Google Workspace | Docs, Sheets, Slides, Forms, Gmail, Calendar, Drive, Contacts, Tasks, Chat — full suite |
| Gmail (standalone) | Lightweight email read/search/draft — prefer for email-only tasks |
| Google Calendar (standalone) | Lightweight calendar read/write — prefer for calendar-only tasks |
| Google Drive (standalone) | File search and fetch |
| Notion | Create/update/search pages and databases |
| Airtable | Read/write bases, tables, and records |

### Automation
| Name | Purpose |
|------|---------|
| Make.com | Manage scenarios, data stores, webhooks (2-slot limit) |
| Scheduled Tasks | Create/manage Cowork scheduled tasks |

### Development & Data
| Name | Purpose |
|------|---------|
| Supabase | DB queries, migrations, edge functions, project management |
| Firecrawl | Web scraping, crawling, structured extraction |
| HuggingFace | Search ML models, papers, datasets, Spaces |

### Design
| Name | Purpose |
|------|---------|
| Figma | Read design context, screenshots, variable defs, design system |
| Stitch | Generate UI screens from text, apply design systems |

### Research
| Name | Purpose |
|------|---------|
| NotebookLM | Create notebooks, add sources, query, export artifacts |
| Perplexity | Quick web search with citations |

### Browser & Mac Control
| Name | Purpose |
|------|---------|
| Claude in Chrome | Full browser automation in user's Chrome session |
| Control Chrome | Tab management, JS execution, page content reads |
| Puppeteer | Headless browser automation, screenshots |
| Control your Mac | osascript — shell commands, open apps, write files on Mac |

### Creative
| Name | Purpose |
|------|---------|
| Three.js | 3D scene creation and learning |

---

## CLIs — ~/Documents/CLIs/

| Name | Auth | Purpose |
|------|------|---------|
| gh | ✅ tpaulson36 | GitHub repos, PRs, issues, CI/CD |
| vercel | ✅ tyler-1200 | Deploys, env vars, logs |
| supabase | ✅ authenticated | DB migrations, edge functions, type gen |
| gcloud | ✅ tyler@tylerpaulsonpictures.com | Google Cloud + Drive storage |
| aws | ❌ not in stack | Replaced by Google Drive |

---

## Plugins — ~/Documents/Plugins/

| Name | Path | Purpose |
|------|------|---------|
| GSD | `Plugins/General/GSD/` | Meta-prompting, context engineering, spec-driven dev (v1.31.0) |
| Agency Agents | `Plugins/Agency_Agents/` | 60+ specialist agents + NEXUS orchestration |
| God Mode 3 | `Plugins/God_Mode_3/` | Multi-model web UI (50+ models via OpenRouter) |
| Oh My Claude Code | `Plugins/Oh_My_Claude_Code/` | Claude Code enhancement: hooks, missions, skills |
| PaperClip | `Plugins/Agents/PaperClip/` | Context-aware task management |
| claude-mem | `Plugins/claude-mem/` | Persistent memory layer |
| CLI-Anything | `Plugins/CLI_Build/CLI-Anything/` | Meta-CLI builder |
| SuperPowers | `Plugins/General/SuperPowers/` | Claude Code workflow enhancements |
| mem0 | `Plugins/Memory/mem0/` | Memory system |
| Letta (MemGPT) | `Plugins/Memory/MemGPT/` | Persistent memory server |
| Astro | `Plugins/Website_Building/Astro_Web_Builder/` | Static site framework |
| Mastra | `Plugins/Website_Building/Mastra_TypeScript/` | TypeScript AI framework |
| Tailwind + shadcn | `Plugins/Website_Building/Tailwind_CSS/` | CSS + UI components |
| SchemaOrg | `Plugins/Website_Building/SchemaOrg/` | Structured data |
| LLMS.txt | `Plugins/Website_Building/LLMS_Txt/` | AI readability spec |

---

## Automation Stack

| Tool | Location | Status |
|------|----------|--------|
| n8n | `~/Documents/n8n_github/` (Docker) | Self-hosted at localhost:5678 on mini |
| Make.com | cloud | 2-slot limit — AI Potential Map + 1 TBD |

### Start n8n
```bash
cd ~/Documents/n8n_github && docker-compose up -d
```

---

## Machine Configs — ~/ai-stack/configs/

| File | Machine |
|------|---------|
| `claude_desktop_config_travel.json` | Laptop |
| `claude_desktop_config_mini.json` | Mac Mini |
| `claude_desktop_config_alien.json` | Desktop (GPU) |

---

## Claude Desktop — Active MCPs (7)
firecrawl-mcp, google-workspace, notebooklm-mcp, puppeteer, perplexity-mcp, stitch, connect-apps (Composio)

---

## Chatterbox TTS
- Path: `~/Documents/MCPs/Chatterbox/`
- Status: installed, not connected to Claude Desktop
- To activate: run `python gradio_tts_app.py` on mini → exposes MCP at localhost:7860/mcp
