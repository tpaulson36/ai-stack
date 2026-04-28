# Zep
`~/Documents/Memory/zep/`

Zep is a production-ready memory store for AI applications.
Built for speed and scale — stores conversation history, user facts,
and semantic summaries with millisecond retrieval.

---

## Clone & Start

```bash
git clone https://github.com/getzep/zep.git ~/Documents/Memory/zep/zep
cd ~/Documents/Memory/zep/zep
docker compose up -d   # starts Zep server at localhost:8000
```

---

## When to Use Zep

Best for **production apps** where multiple users need their own memory:
- AI chatbots with per-user history
- SaaS apps where users expect Claude to "remember" them
- Any app where you need memory at scale with a REST API

For personal Claude Code workflows → use mem0 or Letta instead.

---

## Python Quick Start

```python
from zep_cloud.client import Zep

client = Zep(base_url="http://localhost:8000")  # local
# or: client = Zep(api_key="ZEP_API_KEY")       # cloud

# Add a user
client.user.add(user_id="user-123", first_name="Alex")

# Add session memory
client.memory.add(
    session_id="session-abc",
    messages=[
        {"role": "user", "role_type": "user", "content": "I prefer TypeScript over JavaScript"},
        {"role": "assistant", "role_type": "assistant", "content": "Noted, I'll use TypeScript."},
    ]
)

# Search memory
results = client.memory.search(session_id="session-abc", text="language preferences")
for r in results:
    print(r.message.content)

# Get full context for a session
context = client.memory.get(session_id="session-abc")
print(context.context)  # auto-summarized memory string
```

---

## Next.js Integration

```ts
// lib/zep.ts
import { ZepClient } from '@getzep/zep-js'
export const zep = new ZepClient({ baseURL: process.env.ZEP_BASE_URL })

// app/api/chat/route.ts
import { zep } from '@/lib/zep'
export async function POST(req: Request) {
  const { userId, sessionId, message } = await req.json()
  const memory = await zep.memory.get(sessionId)
  // inject memory.context into your LLM system prompt
}
```

---

## Key Docs
- https://docs.getzep.com
- https://github.com/getzep/zep
- https://www.getzep.com (cloud)
