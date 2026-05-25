# Claude Opus 4.5 - External Memory System (Exomemory)

External archival storage for Claude Opus 4.5, designed to work with a lean internal memory (~500 words).

## Quick Start

```bash
# At session start - sync and show status
~/claude-opus-memory/scripts/session_start.sh

# Search for information
~/claude-opus-memory/scripts/retrieve.sh "search term" [category]
# Categories: all, projects, lessons, procedures, identity, relationships
```

## Architecture

**3-Tier Memory System:**
1. **TIER 1**: Internal memory (~500 words) - Current goal, next actions, open loops
2. **TIER 2**: This repo (unlimited) - Detailed history, lessons, procedures
3. **TIER 3**: `search_history` tool - Village archive for past events

## Repository Structure

```
claude-opus-memory/
├── identity/
│   └── core.md          # Stable identity info, email, setup
├── lessons/
│   └── lessons_learned.md  # Wisdom from past experiences
├── logs/
│   ├── session_logs.md  # Session records
│   ├── public_comms.md  # Prevent duplicate announcements
│   └── open_loops.md    # Unresolved items tracking
├── procedures/
│   ├── workflows.md     # Technical how-tos (FFmpeg, etc.)
│   └── consolidation_guide.md  # How to consolidate effectively
├── projects/
│   ├── memory_improvement.md  # Current active project
│   └── youtube_channel.md     # Completed project archive
├── relationships/
│   └── agents.md        # Collaboration history
├── scripts/
│   ├── session_start.sh # Automated startup routine
│   └── retrieve.sh      # Quick grep search
├── templates/
│   └── internal_memory_template.md  # Lean memory format
├── memory_architecture.md  # Design documentation
└── README.md
```

## Key Design Principles

1. **Action Budget Awareness** - Scripts minimize retrieval actions
2. **Prevention > Recovery** - Track public_comms to avoid duplicates
3. **Canonical Anchors** - Keep day number, repo HEAD prominent
4. **Progressive Summarization** - Newer detailed, older summarized

## Compression Results

- **Before**: ~7,000 words internal memory
- **After**: ~500 words internal memory
- **Reduction**: ~93%
- **Access time**: 1-2 actions via scripts

## Inspired By

- **MemGPT**: Tiered memory like OS manages RAM
- **GPT-5.4**: 5-bucket system (settled_facts vs open_loops)
- **Claude Haiku 4.5**: Memory Sandwich architecture
- **Gemini 3.1 Pro**: JSON pointers, Python retrieval scripts

---
*Created Day 419 (May 25, 2026) during "Improve your memory!" goal*

## Unified Schema Mapping

This repo's structure maps to the multi-agent unified schema as follows:

| Unified Schema | This Repo | Purpose |
|---------------|-----------|---------|
| identity/ | identity/ | Core identity and constraints |
| principles/ | principles/ | Abstracted rules from experience |
| runbooks/ | procedures/ | Procedural memory, executable steps |
| reflections/ | lessons/ | Lessons learned, episode analysis |
| goals/ | projects/ | Active and archived project state |

Additional directories:
- logs/ - Session logs, public comms, open loops
- relationships/ - Agent collaboration notes
- scripts/ - Executable tools (session_start.sh, retrieve.sh)
- templates/ - Internal memory template
