# Episode JSON Schema

> Technical specification for lesson JSON files with NIGHTFALL narrative support.

---

## Overview

The schema extends the existing lesson format with optional narrative fields. All new fields are **optional** - lessons without them render normally (backward compatible).

---

## Full Schema

```json
{
  "id": "string (required)",
  "name": "string (required)",
  "difficulty": "string (required): easy|medium|hard",
  "container": "string (required): docker container name",
  "ip": "string (required): target IP address",
  "port": "number (required): target port",
  "short_description": "string (required): shown on card in grid view",
  "description": "string (required): shown at top of lesson page",

  "episode_number": "number (optional): 1-8, determines story order",
  "episode_title": "string (optional): dramatic title, e.g. 'THE DEPLOYMENT'",

  "handler_message": "string (optional): encrypted intel from handler",
  "episode_intro": "string (optional): opening monologue",
  "episode_outro": "string (optional): cliffhanger ending",

  "next_episode_id": "string (optional): id of next episode for navigation",

  "interstitial": {
    "title": "string (optional): interstitial page title",
    "content": "string (optional): interstitial narrative content"
  },

  "steps": [
    {
      "title": "string (required): step title",
      "command": "string (required): command to execute",
      "explanation": "string (required): technical explanation (fallback)",
      "narrative": "string (optional): integrated story+teaching (preferred)",
      "expected": "string (optional): expected output",
      "duration": "string (optional): time estimate"
    }
  ],

  "pwn_command": "string (optional): quick pwn command",
  "success_criteria": "string (required): how to know you succeeded",
  "next_steps": ["string array (optional): suggestions for further learning"]
}
```

---

## Field Details

### Episode Metadata

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `episode_number` | number | No | Position in story (1-8). Lessons without this appear after numbered episodes. |
| `episode_title` | string | No | Dramatic title shown in story mode. E.g., "THE DEPLOYMENT" |
| `next_episode_id` | string | No | ID of next episode. Enables "Next Episode" button. |

### Narrative Blocks

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `handler_message` | string | No | Encrypted message displayed before episode intro. Styled as terminal output. |
| `episode_intro` | string | No | Inner monologue. Sets emotional tone. Displayed after handler message. |
| `episode_outro` | string | No | Cliffhanger. Displayed after all steps. Leads to next episode. |

### Interstitial Page

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `interstitial.title` | string | No | Title for the story page before this episode. |
| `interstitial.content` | string | No | Full narrative content for interstitial page. |

### Step Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | Yes | Step title displayed in UI |
| `command` | string | Yes | Command to copy/execute |
| `explanation` | string | Yes | Technical explanation (always present, used as fallback) |
| `narrative` | string | No | Integrated story+teaching. If present, rendered instead of `explanation`. |
| `expected` | string | No | What output to expect |
| `duration` | string | No | Time estimate (e.g., "5-10 sec") |

---

## Rendering Logic

### Template Pseudocode

```
IF episode has handler_message:
    render handler_message block

IF episode has episode_intro:
    render episode_intro block

FOR each step:
    render step.title
    render step.command
    IF step.narrative exists:
        render step.narrative
    ELSE:
        render step.explanation
    IF step.expected exists:
        render step.expected

IF episode has episode_outro:
    render episode_outro block

IF episode has next_episode_id:
    render "Next Episode" button linking to next_episode_id
ELSE:
    render "More Hacks" button linking to index
```

### Story Mode Detection

Story mode is active when:
1. URL has `?mode=story` parameter, OR
2. localStorage `nightfall_mode` is set to `story`

In story mode:
- Index shows episodes in `episode_number` order
- Interstitial pages appear before episodes
- "Next Episode" navigation is prominent

---

## Example: Minimal Lesson (No Narrative)

Works exactly as before:

```json
{
  "id": "example-lesson",
  "name": "Example Lesson",
  "difficulty": "easy",
  "container": "example",
  "ip": "172.20.0.99",
  "port": 80,
  "short_description": "An example lesson.",
  "description": "Full description here.",
  "steps": [
    {
      "title": "Do the thing",
      "command": "echo hello",
      "explanation": "This prints hello."
    }
  ],
  "success_criteria": "You see 'hello' printed."
}
```

---

## Example: Full Episode (With Narrative)

```json
{
  "id": "tomcat-upload",
  "name": "Tomcat Manager Shell Upload",
  "difficulty": "easy",
  "container": "tomcat",
  "ip": "172.20.0.19",
  "port": 8080,
  "short_description": "Upload a malicious WAR file for RCE.",
  "description": "Exploit misconfigured Tomcat Manager.",

  "episode_number": 3,
  "episode_title": "THE DEPLOYMENT",
  "next_episode_id": "sambacry",

  "handler_message": "The Tomcat server at 172.20.0.19...",
  "episode_intro": "Three days ago I was nobody...",
  "episode_outro": "The files are downloading...",

  "interstitial": {
    "title": "Episode 3",
    "content": "Previously on NIGHTFALL..."
  },

  "steps": [
    {
      "title": "Reconnaissance",
      "command": "nmap -sV 172.20.0.19 -p 8080",
      "explanation": "Scan the target port.",
      "narrative": "Before we move on Cerberus's deployment server..."
    }
  ],

  "pwn_command": "pwn tomcat",
  "success_criteria": "You have a root shell.",
  "next_steps": ["Explore the filesystem", "Look for NIGHTFALL artifacts"]
}
```

---

## Validation Rules

1. All existing required fields must remain present
2. `episode_number` must be unique across all lessons (1-8)
3. `next_episode_id` must reference a valid lesson ID
4. `narrative` should be 2-4 sentences integrating story + teaching
5. Line breaks in narrative fields use `\n`

---

## Migration Path

1. Existing lessons: No changes needed (backward compatible)
2. Add narrative fields one lesson at a time
3. Test each lesson after adding fields
4. Episode order established by adding `episode_number`

---
