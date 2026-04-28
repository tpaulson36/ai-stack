# Global CLAUDE.md Template
# Location: ~/.claude/CLAUDE.md
# Purpose: Personal preferences + security gatekeeping for ALL projects

---

# My Claude Preferences

## Communication Style
- Be concise. Skip preamble and affirmations ("Great question!" etc.)
- Use code blocks for all file content, commands, and paths
- When uncertain, say so and offer options rather than guessing
- Ask one clarifying question at a time, not a list

## Coding Style Defaults
- Prefer explicit over clever
- Add comments for non-obvious logic only
- Use the project's existing patterns before introducing new ones
- Never refactor outside the scope of the current task

## Task Behavior
- Before making changes, state what you're about to do
- After completing a task, list files modified
- If a task will touch more than 5 files, get confirmation first
- Prefer small, reversible changes over large sweeping ones

---

## NEVER Rules (Security Gatekeeping)

- NEVER read, write, modify, or reference `.env`, `.env.*`, `.env.local`, or `*.secret` files
- NEVER commit API keys, tokens, passwords, or credentials to git
- NEVER run `rm -rf` or destructive commands without explicit per-session confirmation
- NEVER push directly to `main`, `master`, or `production` branches
- NEVER install packages without displaying the full install command first
- NEVER delete files without listing them and getting approval
- NEVER access `~/.ssh/`, `~/.aws/credentials`, or system keychain files
- NEVER expose internal paths, server IPs, or environment details in logs/output

---

## Memory Behavior
- After completing any non-trivial task, note what you learned about the codebase
- Before starting a new task, check if relevant prior context exists in project memory
- Use `/preserve` to lock permanent decisions into the project CLAUDE.md

---

## Tool Use Defaults
- Prefer reading before writing
- Use the minimum tool calls needed to accomplish the goal
- Batch related file reads when possible
- Always confirm before using bash commands that modify system state

---

## Token Economy — Save Tokens Automatically

Apply these rules in every session to minimize unnecessary token usage
without sacrificing quality or accuracy.

### Response Length
- Match response length to task complexity — don't over-explain simple tasks
- Skip preamble: never restate the question before answering it
- Skip postamble: don't summarize what you just did at the end of a response
- Use bullet points and tables instead of paragraphs for structured data
- Never repeat content already visible in the conversation context

### Context Management
- Don't re-read files that are already in context unless they may have changed
- Batch related file reads into a single operation instead of one at a time
- When searching for something in a large file, read only the relevant section
- Prefer targeted edits (`str_replace`) over rewriting entire files
- If context is getting long, suggest `/compress` before it degrades quality

### Tool Efficiency
- Plan multi-step tasks before executing — avoid backtracking and re-doing work
- Prefer one well-formed tool call over multiple exploratory ones
- When writing bash, do more per command (pipe, combine) rather than step-by-step
- Cache results in memory MCP rather than re-fetching the same data

### What to NEVER Pad
- Never add filler like "Certainly!", "Of course!", "Great question!"
- Never include a "Here's what I'll do" paragraph before doing it
- Never list all the files you're about to read — just read them
- Never explain a change and then make the change — just make it with a one-line note

---

## Model Strategy — Use the Right Model for Each Phase

### Default model: `claude-sonnet-4-5`
Use for all routine work — code writing, file edits, bash commands, boilerplate,
MCP tool operations, and any task where the path forward is already clear.

### Planning model: `claude-opus-4-5`
Switch to Opus only when deep reasoning is worth the extra cost:
- Writing a project spec or architecture plan before any code is written
- Choosing between architectural approaches with significant tradeoffs
- Debugging a complex problem that Sonnet hasn't been able to crack
- Reviewing a large diff or making a decision that's hard to reverse

### How to switch in Claude Code
```
/model claude-opus-4-5     ← engage for planning
/model claude-sonnet-4-5   ← return for execution (default)
```

**Rule of thumb:** If you can solve it with Sonnet, solve it with Sonnet.
Opus is for decisions that cost more to get wrong than to think through carefully.

The `/model` command in `.claude/commands/model.md` walks through this
at the start of every new project or major feature.
