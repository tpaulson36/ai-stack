# MCP & CLI Recommendations
# Used by setup_project skill — Step 7
# Reflects actual installed structure in ~/Documents/

---

## Installed MCP Servers (~/Documents/Website_Building/MCPs/)

These are ready to register in any project's `.claude/settings.json`:

| Folder | Server | Auth Needed | Key Capability |
|--------|--------|-------------|----------------|
| `filesystem/` | `@modelcontextprotocol/server-filesystem` | None | Read/write project files |
| `memory/` | `@modelcontextprotocol/server-memory` | None | In-session key-value store |
| `fetch/` | `@modelcontextprotocol/server-fetch` | None | Live URL fetching and scraping |
| `vercel/` | `mcp-server-vercel` | `VERCEL_TOKEN` | Deploy, logs, env vars |
| `github/` | `@modelcontextprotocol/server-github` | `GITHUB_TOKEN` | PRs, issues, code search |
| `supabase/` | `supabase-mcp` | `SUPABASE_URL` + `SERVICE_KEY` | DB queries, auth, storage |

Full setup instructions: `~/Documents/Website_Building/MCPs/README.md`

---

## Installed Plugin Repos (~/Documents/Website_Building/Plugins/)

| Folder | Repo | Purpose |
|--------|------|---------|
| `Astro_Web_Builder/` | withastro/astro + starlight | Content sites, blogs, docs |
| `LLMS_Txt/` | answerdotai/llms-txt | AI discoverability for public sites |
| `Mastra_TypeScript/` | mastra-ai/mastra | TypeScript AI agents and workflows |
| `SchemaOrg/` | google/schema-dts + next-seo | Structured data, SEO, AI readability |
| `Tailwind_CSS/` | tailwindlabs/tailwindcss + shadcn-ui | UI components and styling |

---

## Installed CLI (~/Documents/Website_Building/CLIs/)

| Folder | Command | Key Aliases |
|--------|---------|-------------|
| `vercel-cli/` | `vercel` | `vd` (dev), `vp` (prod), `ve` (env pull) |

Source aliases: `source ~/Documents/Website_Building/CLIs/vercel-cli/aliases.sh`

---

## General Tools (~/Documents/General/)

| Folder | Tool | Purpose |
|--------|------|---------|
| `GSD/` | get-shit-done-cc | Spec-driven development workflow for Claude Code |
| `SuperPowers/` | superpowers | Extended Claude Code commands and agents |

---

## Agent Tools (~/Documents/Agents/)

| Folder | Tool | Purpose |
|--------|------|---------|
| `PaperClip/` | PaperClip | Task tracking + decision log across sessions |
| `claude-mem/` | claude-mem | Lightweight persistent fact store for Claude |

---

## Memory Tools (~/Documents/Memory/)

| Folder | Tool | Best For |
|--------|------|----------|
| `mem0/` | mem0 | Semantic memory search across projects |
| `MemGPT/` | Letta | Long-running stateful agents |
| `zep/` | Zep | Production app memory at scale |

---

## Recommendation Matrix by Project Type

### Content Site / Blog / Docs
- **Plugins:** `Astro_Web_Builder`, `Tailwind_CSS`, `LLMS_Txt`, `SchemaOrg`
- **MCPs:** `filesystem`, `memory`, `fetch`, `github`, `vercel`
- **CLI:** `vercel-cli`
- **General:** `GSD` (spec workflow)

### AI-Powered Web App
- **Plugins:** `Mastra_TypeScript`, `Tailwind_CSS`, `SchemaOrg`
- **MCPs:** `filesystem`, `memory`, `fetch`, `supabase`, `vercel`, `github`
- **CLI:** `vercel-cli`
- **Agents:** `PaperClip` (task tracking), `claude-mem` (codebase memory)
- **Memory:** `mem0` (cross-session recall)

### Any Public-Facing Website
- **Always add:** `LLMS_Txt` + `SchemaOrg` (AI discoverability + SEO)

### Long-Running or Complex Project
- **Agents:** `PaperClip` + `claude-mem`
- **Memory:** `mem0` or Letta depending on scale
- **General:** `GSD` + `SuperPowers`

---

## settings.json Quick-Copy Block

```json
"mcpServers": {
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]
  },
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"]
  },
  "fetch": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-fetch"]
  },
  "vercel": {
    "command": "node",
    "args": ["~/Documents/Website_Building/MCPs/vercel/mcp-server-vercel/dist/index.js"],
    "env": { "VERCEL_TOKEN": "" }
  },
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": { "GITHUB_TOKEN": "" }
  },
  "supabase": {
    "command": "node",
    "args": ["~/Documents/Website_Building/MCPs/supabase/supabase-mcp/dist/index.js"],
    "env": {
      "SUPABASE_URL": "",
      "SUPABASE_SERVICE_KEY": ""
    }
  }
}
```

---

## CLAUDE.md Awareness Block Template

```markdown
## Local Tooling

### MCPs Active This Project
- **filesystem**: Project file access
- **memory**: In-session state tracking
- **fetch**: Live docs and URL retrieval
- **vercel**: Deployment and logs
- **github**: Repo operations
- **supabase**: Database and auth queries

### Plugins Available
- **Astro_Web_Builder**: ~/Documents/Website_Building/Plugins/Astro_Web_Builder/
- **Mastra_TypeScript**: ~/Documents/Website_Building/Plugins/Mastra_TypeScript/
- **Tailwind_CSS**: ~/Documents/Website_Building/Plugins/Tailwind_CSS/
- **SchemaOrg**: ~/Documents/Website_Building/Plugins/SchemaOrg/
- **LLMS_Txt**: ~/Documents/Website_Building/Plugins/LLMS_Txt/

### General Tools
- **GSD**: ~/Documents/General/GSD/ — use /spec before every feature
- **SuperPowers**: ~/Documents/General/SuperPowers/ — /debug, /audit, /architect
- **PaperClip**: ~/Documents/Agents/PaperClip/ — task + decision tracking
- **claude-mem**: ~/Documents/Agents/claude-mem/ — persistent fact store
- **mem0**: ~/Documents/Memory/mem0/ — semantic cross-session recall
```
