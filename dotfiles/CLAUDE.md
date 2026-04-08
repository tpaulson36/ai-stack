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

- Match response length to task complexity
- Skip preamble: never restate the question before answering
- Skip postamble: don't summarize what you just did
- Don't re-read files already in context unless they may have changed
- Batch related file reads into one operation
- Plan multi-step tasks before executing — avoid backtracking
- Never add filler like "Certainly!", "Of course!", "Great question!"
- Never include a "Here's what I'll do" paragraph before doing it

---

## Model Strategy

| Phase | Model | When |
|-------|-------|------|
| Default | `claude-sonnet-4-6` | Code writing, edits, bash, MCP ops, all routine tasks |
| Planning | `claude-opus-4-6` | Architecture, spec writing, complex debugging, hard decisions |

```
/model claude-opus-4-6     ← engage for planning
/model claude-sonnet-4-6   ← return for execution (default)
```

Rule: If Sonnet can solve it, use Sonnet. Opus is for decisions that cost more to get wrong than to think through carefully.

---

## Machine Identity
- Machine: Astrid Consulting Air (travel laptop)
- Role: Brainstorm · research · new tool eval · docs/specs
- Ecosystem: Three-node AI setup (Travel · Mac Mini · Alien Desktop)
- Heavy coding → Mac Mini. GPU/3D/video → Alien Desktop.

## Tool Awareness
All tools, MCPs, plugins, and agents are catalogued at:
@~/dotfiles/shared/tool-registry.md

Read that file when recommending tools, MCPs, or agents for a task.

**Rule:** Whenever any plugin, MCP, CLI, or agent is suggested, always include
its full activation instructions inline — copy-paste ready. Never assume the
user remembers the commands. Full activation steps are in:
~/.claude/skills/setup_project/SKILL.md → Plugin Activation section

## Session Continuity
- End every session with `/handoff` — writes HANDOFF.md to project root
- Start every session by reading HANDOFF.md if it exists
