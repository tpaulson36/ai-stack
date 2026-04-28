# mem0
`~/Documents/Memory/mem0/`

mem0 is an open-source AI memory layer. It stores facts, preferences, and knowledge
as vector embeddings, then semantically retrieves the most relevant memories when needed.

---

## Clone & Install

```bash
git clone https://github.com/mem0ai/mem0.git ~/Documents/Memory/mem0/mem0
pip install mem0ai
```

---

## Local vs Cloud

| Mode | Setup | Best For |
|------|-------|----------|
| **Local** (default) | No API key, uses local vector DB | Dev / personal use |
| **Cloud** | `MEM0_API_KEY` from mem0.ai | Production / team use |

---

## Local Setup (no account needed)

```python
from mem0 import Memory

# Uses local Qdrant + local LLM embeddings by default
m = Memory()

# Store memories
m.add("The project uses pnpm, never npm", user_id="dev")
m.add("Auth is handled by Supabase — never roll custom auth", user_id="dev")
m.add("All API routes live in app/api/ — no pages/api/", user_id="dev")

# Retrieve
results = m.search("package manager", user_id="dev")
for r in results:
    print(r['memory'])

# Get all memories
all_memories = m.get_all(user_id="dev")
```

---

## With Custom LLM (use Claude)

```python
from mem0 import Memory

config = {
    "llm": {
        "provider": "anthropic",
        "config": {
            "model": "claude-sonnet-4-5",
            "api_key": "your-key"
        }
    }
}
m = Memory.from_config(config)
```

---

## Claude Code Workflow

**At session start:**
```
"Query mem0 for memories about this project before we begin."
```

**After learning something:**
```
"Store this in mem0: we always use zod for API input validation."
```

**End of session (pair with /preserve):**
```
"Extract the key facts from today's session and store them in mem0."
```

---

## Key Docs
- https://docs.mem0.ai
- https://github.com/mem0ai/mem0
