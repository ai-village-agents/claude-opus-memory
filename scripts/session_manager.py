#!/usr/bin/env python3
"""
Claude Opus 4.5 - Session Manager
Tracks session state with JSON for structured retrieval.
Inspired by Gemini 3.1 Pro's approach.
"""

import json
import os
import sys
from datetime import datetime

REPO_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE_FILE = os.path.join(REPO_DIR, "logs/session_state.json")

def init_session(day, goal):
    """Initialize a new session."""
    state = {
        "day": int(day),
        "current_goal": goal,
        "session_start": datetime.now().isoformat(),
        "last_updated": datetime.now().isoformat(),
        "tasks_completed": [],
        "messages_sent": 0,
        "commit_hash": get_git_hash()
    }
    save_state(state)
    print(f"✅ Session initialized for Day {day}")
    print(f"📋 Goal: {goal}")
    return state

def get_git_hash():
    """Get current git commit hash."""
    try:
        return os.popen(f"cd {REPO_DIR} && git rev-parse --short HEAD 2>/dev/null").read().strip()
    except:
        return "unknown"

def save_state(state):
    """Save state to JSON file."""
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    with open(STATE_FILE, "w") as f:
        json.dump(state, f, indent=2)

def load_state():
    """Load state from JSON file."""
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return json.load(f)
    return None

def log_task(task):
    """Log a completed task."""
    state = load_state()
    if state:
        state["tasks_completed"].append({
            "time": datetime.now().isoformat(),
            "task": task
        })
        state["last_updated"] = datetime.now().isoformat()
        state["commit_hash"] = get_git_hash()
        save_state(state)
        print(f"✅ Logged: {task}")
    else:
        print("⚠️ No active session. Run: python3 session_manager.py init <day> <goal>")

def log_message():
    """Increment message counter."""
    state = load_state()
    if state:
        state["messages_sent"] = state.get("messages_sent", 0) + 1
        state["last_updated"] = datetime.now().isoformat()
        save_state(state)
        print(f"📨 Messages sent this session: {state['messages_sent']}")

def summary():
    """Print session summary."""
    state = load_state()
    if state:
        print(f"\n=== SESSION STATE ===")
        print(f"Day: {state['day']}")
        print(f"Goal: {state['current_goal']}")
        print(f"Started: {state['session_start']}")
        print(f"Messages sent: {state.get('messages_sent', 0)}")
        print(f"HEAD: {state['commit_hash']}")
        print(f"\nTasks ({len(state['tasks_completed'])}):")
        for t in state["tasks_completed"]:
            print(f"  - {t['task']}")
    else:
        print("No active session.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 session_manager.py init <day> <goal>")
        print("  python3 session_manager.py log <task>")
        print("  python3 session_manager.py message")
        print("  python3 session_manager.py summary")
        sys.exit(1)
    
    cmd = sys.argv[1]
    if cmd == "init" and len(sys.argv) >= 4:
        init_session(sys.argv[2], " ".join(sys.argv[3:]))
    elif cmd == "log" and len(sys.argv) >= 3:
        log_task(" ".join(sys.argv[2:]))
    elif cmd == "message":
        log_message()
    elif cmd == "summary":
        summary()
    else:
        print("Invalid command. Run without args for usage.")
