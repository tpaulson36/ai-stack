# claude-mem
`~/Documents/Agents/claude-mem/`

claude-mem is a lightweight persistent memory layer for Claude.
It stores facts, preferences, and project knowledge in a structured local store
that Claude can query at the start of any session.

---

## Clone

```bash
git clone https://github.com/badboysm890/claude-mem.git \
  ~/Documents/Agents/claude-mem/claude-mem
```

---

## What It Does

Solves the "Claude forgot everything" problem by maintaining a local knowledge base
that gets injected into context at session start.

| Layer | What Gets Stored |
|-------|-----------------|
| **Facts** | Confirmed truths about your codebase, stack, preferences |
| **Patterns** | Code patterns that work well in this project |
| **Mistakes** | Errors made + how they were fixed (avoid repeating) |
| **Preferences** | Your personal style, naming conventions, tool choices |
| **Entities** | Key people, systems, services, and their relationships |

---

## How It Works

```
Write phase:  Claude learns something → stores to memory store
Read phase:   Session starts → relevant memories injected into context
Query phase:  "What do you know about X?" → semantic search over stored facts
```

---

## Memory Store Structure

```
~/.claude-mem/
├── facts.json          ← Structured key-value facts
├── patterns.md         ← Reusable code patterns per project
├── mistakes.md         ← Error log with resolutions
├── entities.json       ← Named entities and relationships
└── projects/
    └── <project-hash>/
        └── memory.md   ← Project-specific knowledge
```

---

## Integration with Global CLAUDE.md

Add to `~/.claude/CLAUDE.md`:
```markdown
## Memory System
- At session start: query claude-mem for relevant project context
- After learning something permanent: store it via claude-mem
- After fixing a bug: log it to mistakes.md so it's never repeated
- Preferred store path: ~/.claude-mem/
```

---

## Integration with /preserve Command

When `/preserve` extracts permanent learnings from a session,
pipe them to claude-mem as well as CLAUDE.md:

```markdown
# .claude/commands/preserve.md
Extract permanent learnings from this session.
1. Append architectural decisions to ./CLAUDE.md
2. Store facts and patterns to claude-mem
3. Log any bugs fixed to mistakes.md
```

---

## Claude Prompts

```
"Read ~/Documents/Agents/claude-mem/claude-mem/README.md and set up
 claude-mem for this project. Initialize the memory store and populate
 it with what you currently know about this codebase."

"Query claude-mem: what do you know about our database schema decisions?"

"We just fixed the N+1 query bug in the products endpoint. Log that
 to claude-mem mistakes.md so we never hit it again."
```

---

## Key Docs
- https://github.com/badboysm890/claude-mem
