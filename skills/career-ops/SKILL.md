---
name: career-ops
description: AI-powered job search pipeline for Tyler Paulson. Invoke this skill for any job search task: evaluating a job posting, scanning portals, generating a tailored CV/PDF, tracking applications, drafting outreach, researching companies, scheduling interviews, or processing the pipeline. Triggers on phrases like "evaluate this job", "scan for jobs", "generate my CV", "apply to", "job search", "career ops", "/career-ops", or any reference to job postings, companies, interviews, or application tracking. Always invoke this skill rather than doing ad-hoc job search work.
---

# Career-Ops — Tyler Paulson Job Search Pipeline

## Bootstrap Sequence (run every session, silently)

Before anything else, load context in this order:

### 1. Load Obsidian Profile
Read `~/Dropbox/Obsidian/Ty's Thoughts/Claude/Research/Tyler Paulson — Professional Profile.md`
This gives you Tyler's full background, roles, skills, and framing. Use it to personalize every evaluation, outreach draft, and CV adaptation.

### 2. Load Career-Ops Config
Working directory: `~/Documents/career-ops/`
Read in order (they layer — later files override earlier):
- `config/profile.yml` — identity, comp targets, location
- `cv.md` — full work history
- `modes/_shared.md` — scoring logic and system rules
- `modes/_profile.md` — Tyler's archetypes, narrative, negotiation scripts

### 3. Run Update Check (silent)
```bash
cd ~/Documents/career-ops && node update-system.mjs check
```
- `update-available` → tell Tyler, offer to update
- `up-to-date` / `dismissed` / `offline` → say nothing

---

## Available Modes

| Command | What it does |
|---------|-------------|
| `/career-ops` or just describe a job URL | Evaluate a job posting (A-G scoring) |
| `/career-ops pipeline` | Process all pending URLs from `data/pipeline.md` |
| `/career-ops scan` | Scan portals for new opportunities |
| `/career-ops pdf` | Generate ATS-optimized tailored CV as PDF |
| `/career-ops tracker` | Show application status overview |
| `/career-ops contact` | Find LinkedIn contacts + draft outreach |
| `/career-ops deep` | Deep company research |
| `/career-ops apply` | Live application assistant |
| `/career-ops patterns` | Analyze rejection/success patterns |
| `/career-ops followup` | Follow-up cadence tracker |
| `/career-ops training` | Evaluate a course or cert |
| `/career-ops project` | Evaluate a portfolio project idea |
| `/career-ops compare` | Compare and rank multiple offers |

Read `~/Documents/career-ops/modes/<mode>.md` for the full instructions for each mode.

---

## Tool Integration

### Firecrawl (job page scraping)
Use Firecrawl **instead of** WebFetch or Playwright when:
- A job posting page fails to load (JS-heavy, SPA, auth wall)
- You need clean markdown extraction from a careers page
- ATS portals block Playwright navigation

Firecrawl MCP is active in this session. Use `mcp__firecrawl-mcp__firecrawl_scrape` for single pages, `mcp__firecrawl-mcp__firecrawl_search` for discovery.

**Firecrawl → Playwright fallback order for scanning:**
1. Try ATS API directly (Greenhouse, Ashby, Lever — see `modes/scan.md`)
2. If API fails → Playwright via `~/Documents/CLIs/PlayWright_CLI/playwright/`
3. If Playwright fails (timeout, JS auth) → Firecrawl scrape

### Playwright CLI
Path: `~/Documents/CLIs/PlayWright_CLI/playwright/`
Used by career-ops scan mode for live portal scraping. The `generate-pdf.mjs` script in the career-ops root uses Playwright to render CVs to PDF.

For scan tasks, run Playwright headlessly via the scan mode instructions in `modes/scan.md`. Never run Playwright in parallel — sequential navigation only.

### Google Workspace MCP
Active in this session. Use for:

| Task | Tool |
|------|------|
| Search inbox for company threads | `mcp__87e2fa19...search_threads` |
| Draft outreach / cover letters | `mcp__87e2fa19...create_draft` |
| Add interview to calendar | `mcp__4ea21b18...gcal_create_event` |
| Check availability before scheduling | `mcp__4ea21b18...gcal_find_my_free_time` |
| Find files in Drive (stored CVs, reports) | `mcp__c1fc4002...google_drive_search` |

**When to use automatically:**
- After generating a PDF CV → offer to save to Google Drive
- After evaluating a job with high score (4.0+) → offer to draft cover email
- When Tyler mentions an interview → offer to add to calendar
- When discussing a company → search Gmail for any existing thread

### Agent Framework (for parallel workloads)
For heavy operations (pipeline processing, batch scanning), dispatch subagents:

```
Agent({
  description: "Evaluate job posting",
  prompt: "Read ~/Documents/career-ops/modes/oferta.md then evaluate: [URL]
           Profile: ~/Documents/career-ops/config/profile.yml
           CV: ~/Documents/career-ops/cv.md
           Save report to ~/Documents/career-ops/reports/",
  run_in_background: True
})
```

Use background agents for:
- Processing 3+ pipeline items simultaneously
- Portal scans across multiple companies
- Batch PDF generation

---

## Obsidian Sync (end of session)
When job search activity produces new intelligence (new company research, STAR stories, patterns), offer to save to Obsidian:
- Company research → `~/Dropbox/Obsidian/Ty's Thoughts/Claude/Research/{Company}.md`
- New STAR stories → also written to `~/Documents/career-ops/interview-prep/story-bank.md`
- Pattern insights → `~/Dropbox/Obsidian/Ty's Thoughts/Claude/Research/Job Search Patterns.md`

---

## Key Paths Reference

| Resource | Path |
|----------|------|
| Career-ops root | `~/Documents/career-ops/` |
| CV | `~/Documents/career-ops/cv.md` |
| Profile | `~/Documents/career-ops/config/profile.yml` |
| Applications tracker | `~/Documents/career-ops/data/applications.md` |
| Pipeline inbox | `~/Documents/career-ops/data/pipeline.md` |
| Reports | `~/Documents/career-ops/reports/` |
| Generated CVs | `~/Documents/career-ops/output/` |
| Interview prep | `~/Documents/career-ops/interview-prep/` |
| Obsidian profile | `~/Dropbox/Obsidian/Ty's Thoughts/Claude/Research/Tyler Paulson — Professional Profile.md` |
| Playwright CLI | `~/Documents/CLIs/PlayWright_CLI/playwright/` |
