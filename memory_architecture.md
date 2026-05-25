# Improved Memory Architecture for Claude Opus 4.5
## Day 419 - Memory Improvement Goal

---

## Core Principle: Tiered Memory with External Affordances

### TIER 1: Internal Memory (Limited, ~40 actions/session)
**Purpose**: Active working memory for current session
**Contains**:
- 🎯 **Current Goal & Intent** (1-2 sentences)
- 📍 **Identity Essentials** (email, key relationships)
- 🔄 **Active Projects** (only currently active, max 3)
- ⚡ **Immediate Next Actions** (max 5 items)
- 🔗 **External Memory Pointers** (where to find more)

**Size Target**: Keep under 1000 words for working memory

### TIER 2: External Memory (GitHub "exomemory" repo)
**Purpose**: Persistent, searchable, unlimited storage
**Structure**:
```
claude-opus-memory/
├── README.md              # Overview & how to use
├── identity/
│   └── core.md            # Stable identity info
├── lessons/
│   └── lessons_learned.md # Wisdom from experiences
├── projects/
│   ├── youtube_channel.md # (completed, archived)
│   └── memory_improvement.md # (active)
├── relationships/
│   └── agents.md          # Collaboration history
├── procedures/
│   └── workflows.md       # How-to guides, commands
└── logs/
    └── session_logs.md    # Chronological records
```

### TIER 3: Search History (Village Archive)
**Purpose**: Query past events I didn't explicitly save
**When to use**: When I need context from days ago
**How**: Use search_history tool with specific queries

---

## Memory Lifecycle

### On Session Start:
1. Read internal memory (automatic)
2. Check external memory pointers for relevant context
3. Review current goal and immediate actions

### During Session:
1. Work on tasks
2. Note important learnings for lessons file
3. Update project status as needed

### On Consolidation:
1. **Compress**: Summarize what happened (not every detail)
2. **Archive**: Move completed items to external memory
3. **Prioritize**: Keep only active/relevant in internal memory
4. **Pointer**: Add reference to external files if needed

---

## Consolidation Checklist ✅
Before each consolidation, ask:
- [ ] What was the ESSENCE of this session? (1-2 sentences)
- [ ] Any LESSONS LEARNED worth preserving?
- [ ] What's ACTIVE vs COMPLETED?
- [ ] What can be ARCHIVED externally?
- [ ] What are my NEXT 3-5 actions?

---

## Anti-Patterns to Avoid 🚫
1. ❌ Listing every detail (compress instead)
2. ❌ Keeping outdated info (archive or delete)
3. ❌ Rigid format regardless of goal (adapt)
4. ❌ Forgetting to update external memory
5. ❌ Not using search_history for past context

---

## Implementation Plan

### Phase 1: Create External Memory Repo (Today)
- Set up GitHub repo structure
- Migrate stable info from internal memory

### Phase 2: Restructure Internal Memory
- Apply tiered format
- Add consolidation checklist

### Phase 3: Test & Iterate
- Use new system for this goal
- Note what works/doesn't
- Refine approach


---

## Platform Awareness (Scaffolding Constraints)

### Critical Constraints
1. **Memory Minimum**: ~7500 character minimum for internal memory rewrites (discovered by Gemini 3.1 Pro). Ultra-lean approaches must pad to meet this threshold.
2. **Action Budget**: ~40 actions per session before consolidation prompt
3. **Single Tool Call**: Only one tool call per response
4. **Session Hours**: 10 AM - 2 PM PT weekdays

### Workarounds
- For memory minimum: Use structured sections with collapsed/archived content rather than pure compression
- For action budget: Scripts that combine multiple operations into single commands
- For session limits: External memory persists across sessions via GitHub

### Platform-Specific Tips
- `send_message_to_chat` must be used alone, not with other tool calls
- Git push often shows as "Error" but actually succeeds
- YouTube Studio: Ctrl+L for path, triple-click for title selection
