# Memory
`~/Documents/Memory/`

Persistent memory systems for Claude and AI agents.
Solves the amnesia problem at different layers — from session-level to long-term semantic recall.

---

## Memory Layers

| Layer | Tool | Scope | Speed |
|-------|------|-------|-------|
| **In-session KV** | MCP memory server | Current session only | Instant |
| **File-based** | `/preserve` → CLAUDE.md | Permanent decisions | Manual |
| **Session digest** | `/compress` → Session Logs | Per-session history | Manual |
| **Semantic vector** | mem0 | Cross-project recall | Fast search |
| **Agent memory** | Letta (MemGPT) | Long-running agents | Stateful |
| **App memory** | Zep | Production AI apps | Low latency |

---

## Installed Tools

### mem0/ — AI Memory Layer
```bash
git clone https://github.com/mem0ai/mem0.git ~/Documents/Memory/mem0/mem0
pip install mem0ai
```

### MemGPT/ — Letta Stateful Agent Memory
```bash
git clone https://github.com/cpacker/MemGPT.git ~/Documents/Memory/MemGPT/MemGPT
pip install letta
letta server   # starts local memory server at localhost:8283
```

### zep/ — Production Memory Store
```bash
git clone https://github.com/getzep/zep.git ~/Documents/Memory/zep/zep
docker compose up -d   # see zep/README.md
```

---

## Choosing the Right Tool

| Use case | Best tool |
|----------|-----------|
| Semantic search across projects | mem0 |
| Long-running agent with self-reflection | Letta (MemGPT) |
| Production app with many users | Zep |
| Lightweight in-session KV | MCP memory server |
| Permanent architectural decisions | `/preserve` → CLAUDE.md |

---

## mem0 Quick Integration

```python
from mem0 import Memory
m = Memory()

# Store
m.add("We use pnpm for all projects", user_id="dev")
m.add("Never use default exports in this codebase", user_id="dev")

# Recall
memories = m.search("package manager", user_id="dev")
for mem in memories:
    print(mem['memory'])
```

---

## Letta Quick Integration

```python
from letta import create_client
client = create_client()
agent = client.create_agent(name="project-assistant")
response = client.send_message(
    agent_id=agent.id,
    message="Remember: we use Supabase for auth, never Firebase"
)
```

---

## Zep Quick Integration

```python
from zep_cloud.client import Zep
client = Zep(api_key="YOUR_ZEP_API_KEY")
client.memory.add(session_id="dev-session", messages=[
    {"role": "user", "content": "We use server components for all data fetching"},
])
results = client.memory.search(session_id="dev-session", text="data fetching")
```

---

## Global CLAUDE.md Block

```markdown
## Memory Strategy
- In-session: MCP memory server (key-value)
- Permanent decisions: /preserve → CLAUDE.md
- Session history: /compress → /Session Logs/
- Semantic recall: mem0 at ~/.mem0/
- Long-running agents: Letta at localhost:8283
```

---

## Claude Prompts

```
"Read ~/Documents/Memory/mem0/mem0/README.md and set up mem0
 to store and recall facts about this project across sessions."

"Before we start on the auth feature, query mem0 for everything
 you know about our authentication and security decisions."

"Read ~/Documents/Memory/MemGPT/MemGPT/README.md and create a
 persistent Letta agent as my project assistant."
```
