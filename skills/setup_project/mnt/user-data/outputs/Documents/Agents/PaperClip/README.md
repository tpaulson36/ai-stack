# PaperClip
`~/Documents/Agents/PaperClip/`

PaperClip is a persistent, context-aware task and memory management agent for Claude.
It gives Claude a structured way to track tasks, decisions, and project state
across sessions without losing context.

---

## Clone

```bash
git clone https://github.com/PaperClipAGI/paperclip.git \
  ~/Documents/Agents/PaperClip/paperclip
```

---

## What It Does

| Feature | Description |
|---------|-------------|
| **Task tracking** | Maintains a structured todo list Claude can read and update |
| **Decision log** | Records why choices were made, not just what was chosen |
| **Context snapshots** | Saves project state at checkpoints for future sessions |
| **Priority management** | Scores and ranks tasks by impact and urgency |
| **Agent handoff** | Passes structured context to sub-agents cleanly |

---

## Core Concepts

### The PaperClip Loop
```
Session Start → Load context snapshot
      ↓
Work on tasks → Update task states
      ↓
Make decisions → Log to decision record
      ↓
Session End → Save snapshot + compress
```

### File Structure It Creates
```
.paperclip/
├── tasks.md          ← Active task list with status
├── decisions.md      ← Decision log with rationale
├── context.md        ← Current project state snapshot
└── archive/          ← Completed session snapshots
```

---

## Integration with CLAUDE.md

Add to your project `CLAUDE.md`:
```markdown
## Task Management
- Task list: .paperclip/tasks.md
- Decision log: .paperclip/decisions.md
- Before starting work: read .paperclip/context.md
- After completing tasks: update .paperclip/tasks.md
- Before ending session: run /compress and update .paperclip/context.md
```

---

## Claude Prompts

```
"Read ~/Documents/Agents/PaperClip/paperclip/README.md and initialize
 PaperClip for this project. Create the .paperclip/ directory and
 populate context.md with what you know about this codebase."

"Check .paperclip/tasks.md and tell me what's highest priority.
 Then update the status of completed items."

"We just decided to use Supabase instead of Planetscale. Log that
 decision with rationale to .paperclip/decisions.md."
```

---

## Key Docs
- https://github.com/PaperClipAGI/paperclip
