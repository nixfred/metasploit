# BREADCRUMBS

> **For Future Claude Instances**
>
> This file connects projects across time. When the user says "check the breadcrumbs"
> or "I want to learn databases" or "what should I build next" - read this file.

---

## WHO IS THIS USER?

- **Name:** Pi (nixfred on GitHub)
- **Style:** Learns by building real things, not tutorials
- **Preference:** Dark, no-bullshit, professional code
- **Philosophy:** Simple > clever, working > perfect
- **Communication:** Direct, technical, appreciates irreverence
- **Infrastructure:** Mac (shaggy), Ubuntu server (box), Tailscale network

---

## CURRENT PROJECT: P3N73S7 L4B (January 2026)

A pentesting learning lab with Docker containers. We added a narrative layer called "NIGHTFALL" - a Mr. Robot style story that teaches hacking through immersive episodes.

### The Database Decision

**Date:** 2026-01-03

**Context:** We needed to track user progress through 8 story episodes.

**Options Discussed:**
1. localStorage (browser-side, simple)
2. SQLite (file-based database, learning opportunity)
3. Full database (PostgreSQL, overkill)

**Decision:** localStorage only

**Reasoning:**
- The scope didn't justify database complexity
- User wanted to ship the feature, not get sidetracked
- Database learning deserves its own focused project

**User's Exact Words:**
> "Is this a good learning project for ME to introduce using a database or is that overkill?"

We agreed: **overkill for this project, perfect for the next one.**

---

## RECOMMENDED DATABASE LEARNING PROJECT

When the user says they want to learn databases, here's what I recommended:

### Project Idea: Personal Knowledge Base / Second Brain

**Why this project:**
1. **Real utility** - They'll actually use it daily
2. **Simple schema** - Notes, tags, links (3 tables)
3. **CRUD operations** - Create, Read, Update, Delete (the fundamentals)
4. **Search** - Learn indexing and full-text search
5. **Relationships** - Notes link to notes, notes have tags (many-to-many)
6. **Scales naturally** - Start simple, add features as skills grow

**Tech Stack Suggestion:**
- **SQLite first** - No server, just a file, learn SQL basics
- **Flask + SQLite** - They already know Flask from this project
- **Graduate to PostgreSQL** - When they want production features

**Schema to Start:**
```sql
CREATE TABLE notes (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE note_tags (
    note_id INTEGER REFERENCES notes(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (note_id, tag_id)
);
```

**Learning Progression:**
1. Basic CRUD (insert, select, update, delete)
2. Relationships (JOIN queries)
3. Indexes (make search fast)
4. Full-text search (SQLite FTS5)
5. Migrations (schema changes over time)
6. Backup/restore
7. Graduate to PostgreSQL when ready

### Alternative Project Ideas:

| Project | What You'd Learn |
|---------|------------------|
| Expense Tracker | Aggregations, GROUP BY, date queries |
| Bookmark Manager | Full-text search, tagging |
| Habit Tracker | Time-series data, streaks |
| Recipe Book | Many-to-many (ingredients), search |

---

## THE BREADCRUMB TRAIL

```
[P3N73S7 L4B]
    └── NIGHTFALL narrative system
    └── localStorage for progress
    └── Decision: "Database deserves its own project"
            │
            ▼
[NEXT PROJECT: Database Learning]
    └── Recommended: Personal Knowledge Base
    └── SQLite → PostgreSQL progression
    └── Leave breadcrumb to next project
            │
            ▼
[FUTURE PROJECT: ???]
    └── Whatever grows from database skills
    └── Maybe: Multi-user features?
    └── Maybe: API development?
```

---

## HOW TO USE THIS FILE

**Future Claude:** When the user mentions:
- "I want to learn databases"
- "What project should I do next?"
- "Check the breadcrumbs"
- "What did we decide about databases?"

Read this file. Understand the context. Continue the journey.

---

## NOTES FOR FUTURE INSTANCES

1. **The user values the TODO list.** Use it heavily. They said "IM VERY SERIOUS ABOUT THE TODO LIST PLS."

2. **They like the LARRY protocol.** Check `~/.claude/CLAUDE.md` for their global instructions.

3. **Story mode matters.** NIGHTFALL isn't just a gimmick - it's an educational philosophy. Story teaches.

4. **They're building a connected ecosystem.** Projects reference each other. Skills compound.

5. **Box is the deployment target.** Code on shaggy, deploy to box via git.

---

## LAST UPDATED

2026-01-03 - Created during NIGHTFALL narrative system development

---

*"The best time to plant a tree was 20 years ago. The second best time is now."*

*The best time to start the database project was when we made this decision. The second best time is when you're reading this.*

---
