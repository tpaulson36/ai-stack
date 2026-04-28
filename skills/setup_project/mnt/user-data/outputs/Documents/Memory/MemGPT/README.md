# Letta (MemGPT)
`~/Documents/Memory/MemGPT/`

Letta (formerly MemGPT) is a framework for building stateful LLM agents with
self-editing memory. Agents remember indefinitely, can reflect on past context,
and manage their own memory as they work.

---

## Clone & Install

```bash
git clone https://github.com/cpacker/MemGPT.git ~/Documents/Memory/MemGPT/MemGPT
pip install letta
```

---

## Start the Local Server

```bash
letta server
# Runs at http://localhost:8283
# REST API + web UI included
```

---

## Core Concepts

| Concept | Description |
|---------|-------------|
| **Agents** | Persistent entities with their own memory blocks |
| **Memory blocks** | Named memory sections (persona, human, custom) |
| **Archival memory** | Unlimited long-term storage (vector search) |
| **Recall memory** | Recent conversation history |
| **Tools** | Functions the agent can call (file read, web search, etc.) |

---

## Create a Project Assistant Agent

```python
from letta import create_client

client = create_client()  # connects to local server

# Create a persistent agent
agent = client.create_agent(
    name="project-assistant",
    memory_blocks=[
        {"label": "human", "value": "Developer working on a Next.js SaaS project"},
        {"label": "persona", "value": "I am a senior software architect with deep knowledge of this codebase."},
        {"label": "project", "value": "Stack: Next.js 15, Supabase, Tailwind CSS, TypeScript"}
    ]
)

print(f"Agent ID: {agent.id}")  # save this for future sessions
```

## Resume an Existing Agent (across sessions)

```python
from letta import create_client
client = create_client()

# Use the saved agent ID — it remembers everything
response = client.send_message(
    agent_id="agent-<your-id>",
    role="user",
    message="What do you know about our database schema?"
)
print(response.messages[-1].text)
```

---

## Integration with Claude Code

Add to `~/.claude/CLAUDE.md`:
```markdown
## Persistent Agent
- Letta project assistant runs at localhost:8283
- Agent ID: <your-agent-id>
- Use for: cross-session memory, architectural decisions, codebase knowledge
```

---

## Key Docs
- https://docs.letta.com
- https://github.com/cpacker/MemGPT
- https://app.letta.com (cloud version)
