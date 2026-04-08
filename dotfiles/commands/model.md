# Model Strategy

Use this as a reference when deciding which model to engage.

| Phase | Model | When |
|-------|-------|------|
| Default | `claude-sonnet-4-6` | Code writing, edits, bash, MCP ops, all routine tasks |
| Planning | `claude-opus-4-6` | Architecture, spec writing, complex debugging, hard decisions |

**To switch:**
```
/model claude-opus-4-6     ← engage for planning
/model claude-sonnet-4-6   ← return for execution (default)
```

**Rule:** If Sonnet can solve it, use Sonnet. Opus is for decisions that cost more to get wrong than to think through carefully.
