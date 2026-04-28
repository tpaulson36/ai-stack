# SuperPowers
`~/Documents/General/SuperPowers/`

SuperPowers is a collection of Claude Code workflow enhancements —
custom commands, agent configurations, and prompt patterns that extend
what Claude Code can do out of the box.

---

## Clone

```bash
git clone https://github.com/superpowers-ai/superpowers.git \
  ~/Documents/General/SuperPowers/superpowers
```

---

## What SuperPowers Provides

### Power Commands
| Command | Purpose |
|---------|---------|
| `/architect` | System design mode — diagrams and decisions before code |
| `/debug` | Structured debugging: reproduce → isolate → fix → verify |
| `/refactor` | Safe refactor with pre/post test verification |
| `/explain` | Deep explanation of any code with context and tradeoffs |
| `/migrate` | Step-by-step migration plans (DB schema, framework, etc.) |
| `/audit` | Security and performance audit of a file or module |

### Enhanced Agents
```
.claude/agents/
├── architect.md    ← System design specialist
├── debugger.md     ← Root cause analysis specialist
├── security.md     ← Security audit specialist
└── migrator.md     ← Migration planning specialist
```

### Prompt Patterns
- **Chain-of-thought forcing** — makes Claude reason step by step before acting
- **Constraint injection** — adds hard limits (no new dependencies, stay in file, etc.)
- **Verification loops** — Claude checks its own output before returning

---

## Installing into a Project

```bash
# Copy commands into your project
cp -r ~/Documents/General/SuperPowers/superpowers/.claude/commands/ .claude/commands/

# Or cherry-pick specific ones
cp ~/Documents/General/SuperPowers/superpowers/.claude/agents/debugger.md .claude/agents/
```

---

## Best Combos

| Goal | Use Together |
|------|-------------|
| New feature | GSD `/spec` → SuperPowers `/architect` → GSD `/build` |
| Bug hunt | SuperPowers `/debug` → PaperClip decision log |
| Code review | GSD `/review` + SuperPowers `/audit` |
| Tech debt | SuperPowers `/refactor` + claude-mem mistake log |

---

## Claude Prompts

```
"Read ~/Documents/General/SuperPowers/superpowers/README.md and install
 the debug and audit agents into this project's .claude/agents/ folder."

"/architect — design the data flow for a real-time notification system
 using Supabase realtime and Next.js server components."

"/audit — review src/lib/auth.ts for security vulnerabilities and
 rate limiting gaps."
```

---

## Key Docs
- https://github.com/superpowers-ai/superpowers
