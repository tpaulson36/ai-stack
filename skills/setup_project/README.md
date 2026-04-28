# MCPs — Website Building
`~/Documents/Website_Building/MCPs/`

MCP servers that extend Claude's capabilities for web development.
Each subfolder = one server, either cloned or npm-installed locally.

---

## Installed Servers

```
MCPs/
├── filesystem/     ← Read/write project files
├── memory/         ← In-session key-value store
├── fetch/          ← Web fetch + URL scraping
├── vercel/         ← Deploy, logs, env vars
├── github/         ← PRs, issues, code search
└── supabase/       ← DB queries, auth, storage
```

---

## Setup Per Server

### filesystem
Gives Claude structured access to your project files.
```bash
# No clone needed — npm package
# Register in .claude/settings.json:
{
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
  }
}
```

### memory
Lightweight in-session key-value store. Survives tool calls, not sessions.
Use alongside mem0 or claude-mem for cross-session needs.
```bash
{
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"]
  }
}
```

### fetch
Fetches live URLs, scrapes pages, and pulls documentation into context.
Essential for referencing live docs without copy-pasting.
```bash
{
  "fetch": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-fetch"]
  }
}
```

### vercel
Full Vercel platform access — deploy, inspect, manage env vars, read logs.
```bash
git clone https://github.com/vercel/mcp-server-vercel.git \
  ~/Documents/Website_Building/MCPs/vercel/mcp-server-vercel
cd ~/Documents/Website_Building/MCPs/vercel/mcp-server-vercel
npm install && npm run build
```
```json
{
  "vercel": {
    "command": "node",
    "args": ["~/Documents/Website_Building/MCPs/vercel/mcp-server-vercel/dist/index.js"],
    "env": { "VERCEL_TOKEN": "<from vercel dashboard — never hardcode>" }
  }
}
```

**What it unlocks:**
- `vercel deploy` — trigger deployments from Claude
- `vercel logs` — read deployment logs inline
- `vercel env` — list and pull env vars (never values, only keys)
- `vercel projects` — list and switch projects

### github
GitHub integration — PR management, issue triage, code search, file access.
```bash
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": { "GITHUB_TOKEN": "<from github.com/settings/tokens>" }
  }
}
```

**What it unlocks:**
- Search code across repos
- Read files at any commit/branch
- Create and comment on issues
- Review and merge PRs
- Read GitHub Actions logs

### supabase
Supabase DB queries, auth management, storage, and realtime.
```bash
git clone https://github.com/supabase-community/supabase-mcp.git \
  ~/Documents/Website_Building/MCPs/supabase/supabase-mcp
cd ~/Documents/Website_Building/MCPs/supabase/supabase-mcp
npm install && npm run build
```
```json
{
  "supabase": {
    "command": "node",
    "args": ["~/Documents/Website_Building/MCPs/supabase/supabase-mcp/dist/index.js"],
    "env": {
      "SUPABASE_URL": "<your project URL>",
      "SUPABASE_SERVICE_KEY": "<service role key — server only, never client>"
    }
  }
}
```

**What it unlocks:**
- Run SQL queries against your database
- Inspect table schemas and relationships
- Manage RLS policies
- Query auth users
- List storage buckets and files

---

## Full .claude/settings.json mcpServers Block

Copy this into any web project's `.claude/settings.json` and fill in tokens:

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

⚠️ **Never hardcode token values** — leave them blank here and set via shell env or
a secrets manager. The security hook in `.claude/hooks/block-secrets.sh` enforces this.

---

## CLAUDE.md Awareness Block

Add this to your project `CLAUDE.md` after configuring MCPs:

```markdown
## MCP Tools Available (~/Documents/Website_Building/MCPs/)
- **filesystem**: Read/write project files — use for all file operations
- **memory**: In-session key-value store — use for tracking state mid-task
- **fetch**: Pull live docs and URLs — use instead of asking me to paste content
- **vercel**: Deploy and inspect — use for deployment status and logs
- **github**: Code search, PRs, issues — use for repo operations
- **supabase**: DB queries and schema — use for all database operations

Always prefer these tools over asking me to perform actions manually.
```

---

## Adding More Servers

To add a new MCP:
1. Clone or install it into a new subfolder here
2. Add its entry to `.claude/settings.json`
3. Add a one-liner to the CLAUDE.md awareness block
4. Update this README's installed list

Additional servers worth adding for web projects:
| Server | Purpose |
|--------|---------|
| `@modelcontextprotocol/server-brave-search` | Web search during coding |
| `notion-mcp` | Read/write Notion docs |
| `sanity-mcp` | Sanity CMS content management |
| `cloudflare-mcp` | Cloudflare Pages, Workers, DNS |
| `stripe-mcp` | Payment and subscription management |
