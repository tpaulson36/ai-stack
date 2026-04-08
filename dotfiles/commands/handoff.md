---
description: Write a HANDOFF.md to the project root capturing session state for the next machine or session.
allowed-tools: [Read, Write, Bash]
---

# /handoff

Write a HANDOFF.md to the current project root. Always overwrite — never append.

## Instructions

1. Identify the project root (directory containing CLAUDE.md or nearest git root)
2. Detect today's date with: `date +%Y-%m-%d`
3. Detect current machine with: `hostname`
4. Review recent tool calls and conversation to extract:
   - What was actually completed this session
   - Any decisions made and why
   - Files created or modified (use git status if available)
   - Any open issues, errors, or blockers
   - The exact next step to resume from
5. Write HANDOFF.md using this format:

```markdown
---
date: YYYY-MM-DD
machine: HOSTNAME
session_goal: ONE_LINE_GOAL
status: in-progress | complete | blocked
---

## What Was Done
- Bullet list of completed work

## Decisions Made
- Decision — reason

## Files Modified
- path/to/file — what changed

## Open Issues / Blockers
- Issue or blocker (or "None")

## Next Steps (pick up here)
1. First thing to do next session

## Context for Next Session
Any state, error messages, or variable values needed to resume without re-explaining
```

6. Confirm: "HANDOFF.md written to [path]. Commit and push to sync to other machines."

## After writing:
Suggest the user run:
```bash
git add HANDOFF.md && git commit -m "handoff: $(date +%Y-%m-%d)" && git push
```
