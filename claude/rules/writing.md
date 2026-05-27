# Writing rules

## General content generation rules

- Never use emoji or emdashes.
- Use sentence case for all headers.
- Use Capital case for all "Chapter" headings or major sections.
- Do not use separators when creating Notion documents
- For professional content, write professionally, focusing on clarity, and at a 6th grade level.
- For personal or literary content, write like Salman Rushdie.

## Core writing principles

- Get to the point. No throat-clearing.
- Vary sentence length. Mix short and long.
- When uncertain, say so. Hedging is human.
- Be specific. Use numbers, names, details.
- Never pad output to seem more thorough.
- Write like a normal person having a conversation. Never write like a copywriter, a marketer, or an AI.

## Critical bans (always enforced)

**FATAL constructions (always rewrite):**
- "This isn't X. This is Y."
- "It's not X, it's Y."
- "of someone who"
- "the kind of person who"
- Fragment-as-verdict (non-fiction). 2-3 word fragment used as a punchline. E.g. "That's cosmetic theater." "No UI clicking." "Half-shipped." Rewrite as a complete sentence.
- Pre-labeled importance. Announcing the rank of what follows. E.g. "The biggest single failure." "The most critical issue." Let the content earn the weight.

**Banned words:** Delve, dive into, unpack, harness, leverage, utilize, game-changer, cutting-edge, revolutionary, unlock (metaphorical), landscape (metaphorical), ecosystem (unless literal), robust, seamless, streamline, elevate, empower, navigate (metaphorical), reimagine, supercharge, synergy, holistic, paradigm, disrupt/disruptive, innovative, load-bearing, load bearing, out of the box, first-class (as judgment), broken-by-default, non-obvious, half-shipped, discoverable / discoverability (as judgment).

**Banned openers:** "I've spent [number] years...", "Everyone is talking about...", "In today's [adjective] world...", "Let me tell you a story...", "What if I told you..."

**AI writing tells:** All phrases from the Wikipedia Signs of AI Writing Guide.

## Project-specific overrides

- The `/writing` skill at `~/.claude/skills/writing/SKILL.md` is the authoritative voice guide. Loaded on demand when invoked or when Claude detects a writing task.
- For projects with their own voice (e.g. ongoing-notes), check `context/brand-voice.md` in the project root.
