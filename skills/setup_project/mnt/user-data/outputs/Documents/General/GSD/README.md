# GSD — Get Shit Done
`~/Documents/General/GSD/`

GSD is a meta-prompting and spec-driven development system for Claude Code,
Gemini CLI, and OpenCode. It installs structured agent files, slash commands,
and prompt templates that enforce a disciplined build workflow.

---

## Clone / Install

```bash
# Clone for local reference
git clone https://github.com/gsd-build/get-shit-done.git \
  ~/Documents/General/GSD/get-shit-done

# Or install globally via npm
npm install -g get-shit-done-cc

# Initialize in any project (Claude Code)
get-shit-done-cc --claude --global    # global ~/.claude/ setup
get-shit-done-cc --claude             # project-level .claude/ setup
```

---

## What GSD Installs

### Slash Commands
| Command | Purpose |
|---------|---------|
| `/spec` | Write a spec before writing any code |
| `/build` | Execute a spec step-by-step with checkpoints |
| `/review` | Structured code review against the spec |
| `/done` | Mark a task complete and log the decision |
| `/stuck` | Diagnose why you're blocked and propose next steps |

### Agent Files
```
.claude/
├── commands/
│   ├── spec.md       ← Forces spec-first development
│   ├── build.md      ← Step-by-step build with checkpoints
│   ├── review.md     ← Structured review workflow
│   └── done.md       ← Completion + decision logging
└── rules/
    └── gsd-rules.md  ← Coding discipline rules
```

---

## The GSD Workflow

```
1. /spec    → Write what you're building BEFORE touching code
2. /build   → Implement step by step, checking off spec items
3. /review  → Review against spec, catch regressions
4. /done    → Log what was built and any decisions made
```

**Core principle:** Never write code until the spec is approved.
This prevents scope creep, rework, and "vibe coding" that drifts from intent.

---

## Integration with setup_project

GSD pairs directly with the `setup_project` skill:
- GSD's `/spec` → feeds into `CLAUDE.md` architectural decisions
- GSD's `/done` → feeds into `/preserve` permanent learnings
- GSD's `gsd-rules.md` → import via `@docs/gsd-rules.md` in CLAUDE.md

Add to your project `CLAUDE.md`:
```markdown
## Development Workflow
@~/Documents/General/GSD/get-shit-done/.claude/rules/gsd-rules.md

Always use /spec before starting any new feature.
Always use /done to log completed work.
```

---

## Claude Prompts

```
"Read ~/Documents/General/GSD/get-shit-done/README.md and initialize
 GSD for this project. Install the slash commands into .claude/commands/."

"/spec — I want to build a user authentication flow with Supabase,
 email/password + magic link, and a protected dashboard route."
```

---

## Key Docs
- https://github.com/gsd-build/get-shit-done
