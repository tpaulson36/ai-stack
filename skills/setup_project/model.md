# /model
# Location: .claude/commands/model.md
# Purpose: Set the right model before planning or starting any project.
#          Opus 4.6 for deep thinking and planning. Sonnet 4.6 for all execution.
#
# Usage: Type /model at the start of a new project or planning session.

---

You are switching into **project planning mode**.

## Model Configuration

Apply this model strategy for the current project:

| Phase | Model | When to Use |
|-------|-------|-------------|
| **Planning** | `claude-opus-4-5` | Architecture decisions, spec writing, breaking down complexity, reviewing tradeoffs |
| **Execution** | `claude-sonnet-4-5` | Writing code, editing files, running commands, generating boilerplate, all routine tasks |

## How to Switch

In Claude Code, switch models with:
```
/model claude-opus-4-5     ← use for planning sessions
/model claude-sonnet-4-5   ← use for all execution (default)
```

Or set in `.claude/settings.json` per task type:
```json
{
  "model": "claude-sonnet-4-5",
  "planningModel": "claude-opus-4-5"
}
```

## When to Use Opus 4.6 (plan mode)

Invoke `/model claude-opus-4-5` when you need to:
- Write or review a project spec before any code is written
- Decide between architectural approaches (e.g. monorepo vs multi-repo, REST vs GraphQL)
- Debug a complex or mysterious bug that resists obvious fixes
- Design a data model or API contract
- Review a large diff or pull request holistically
- Unblock yourself when Sonnet has been going in circles

Switch back to Sonnet immediately after the thinking is done.

## When to Stay on Sonnet 4.6 (default)

Use `claude-sonnet-4-5` (the default) for everything else:
- Writing, editing, and refactoring code
- Running bash commands and scripts
- Generating files, configs, and boilerplate
- Answering specific implementation questions
- All MCP tool operations
- Any task where the path is already clear

## Token Cost Awareness

Opus 4.6 costs ~5x more tokens per response than Sonnet 4.6.
**Rule:** If you can answer it with Sonnet, do. Opus is for decisions that
cost more to get wrong than to think through carefully.

## Project Start Checklist

Before starting any new project or major feature, run through this:

```
□ /model  ← run this command first
□ Switch to Opus: /model claude-opus-4-5
□ Write the spec / plan with Opus
□ Review and approve the plan
□ Switch back to Sonnet: /model claude-sonnet-4-5
□ Execute with Sonnet
□ Return to Opus only if blocked or making a major decision
```

---

> Reminder: This command is installed at `.claude/commands/model.md`
> and is available as `/model` in any Claude Code session for this project.
