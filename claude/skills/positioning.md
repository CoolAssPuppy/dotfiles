---
name: positioning
description: Creates positioning and messaging frameworks for technical products. Develops segmentation strategies, ideal customer profiles (ICP), value propositions, and messaging hierarchies using Aristotle's rhetorical principles. Use when defining target audiences, crafting product positioning, developing messaging, differentiating from competitors, or creating foundational marketing materials.
metadata:
  author: prashant-sridharan
  version: "2.0"
  source: "Picks and Shovels by Prashant Sridharan"
---

# Product positioning and messaging

This skill helps create positioning and messaging frameworks for technical products based on the methodology from "Picks and Shovels."

## Core principle

Positioning is about owning a specific place in your customer's mind. For technical products, this means being the obvious choice for a specific type of buyer solving a specific problem.

---

## Workflow

Follow these steps in order:

1. Define market segmentation
2. Create ideal customer profile (ICP)
3. Develop positioning statement
4. Build messaging hierarchy
5. Create value propositions

---

## Step 1: Market segmentation

Segment your market using these dimensions:

**By role:**
- Individual contributors (hobbyists, side projects)
- Startup teams (early-stage, resource-constrained)
- Enterprise teams (compliance, scale, support needs)
- Platform teams (infrastructure, operations)

**By technology stack:**
- Language preferences
- Framework preferences
- Infrastructure preferences (cloud-native, on-prem, hybrid)

**By use case:**
- Building new applications
- Migrating existing systems
- Scaling infrastructure
- Reducing costs

**By buying behavior:**
- Self-serve (credit card purchases)
- Procurement-driven (enterprise sales)
- Open-source-first (community adoption)

### Output format

```markdown
## Market segmentation

### Primary segment
- Role: [specific role]
- Technology: [stack preferences]
- Use case: [primary problem they solve]
- Buying: [how they purchase]

### Secondary segment
[Same structure]
```

---

## Step 2: Ideal customer profile (ICP)

Create a detailed ICP using this framework:

**Demographics:**
- Company size (employees, team size)
- Industry vertical
- Geographic focus
- Funding stage (if startup)

**Technographics:**
- Current tools and infrastructure
- Technical maturity level
- Build vs. buy philosophy

**Behaviors:**
- Where they learn (blogs, YouTube, conferences)
- How they evaluate tools (POCs, benchmarks, peer reviews)
- Who influences decisions (individual, team, management)

**Pain points:**
- Primary technical challenges
- Business pressures they face
- What keeps them from solving problems today

### Output format

```markdown
## Ideal customer profile

### Demographics
- Company size: [range]
- Industry: [verticals]
- Funding/revenue: [stage or range]

### Technographics
- Stack: [technologies they use]
- Maturity: [early/mid/late adopters]
- Philosophy: [build vs. buy preference]

### Behaviors
- Learning: [channels they use]
- Evaluation: [how they choose tools]
- Influencers: [who affects decisions]

### Pain points
1. [Primary pain point with context]
2. [Secondary pain point]
3. [Tertiary pain point]
```

---

## Step 3: Positioning statement

Use this template:

```
For [target customer]
who [has this problem/need],
[Product name] is a [category]
that [key benefit].
Unlike [primary alternative],
we [key differentiator].
```

**Guidelines:**
- Target customer must match your ICP
- Problem must be specific and urgent
- Category should be recognizable (or define a new one strategically)
- Key benefit must be measurable or demonstrable
- Differentiator must be defensible and meaningful

### Positioning types

Choose your positioning approach:

1. **Category leader**: Own an existing category ("the best Postgres database")
2. **Category creator**: Define a new category ("real-time analytics for developers")
3. **Challenger**: Position against the incumbent ("Firebase alternative")
4. **Niche specialist**: Own a specific use case ("time-series data at scale")

### Category test

After completing the positioning statement, test each major element in isolation:

- Can the category alone answer "what is this?" ("Service business" fails. "Time-series database" passes. "Developer platform" is borderline.)
- Can the use case alone answer "what is this?" ("Helps developers build real-time dashboards" passes. "Makes development easier" fails.)
- If either test fails, go back and revise.

### Problem-framing variants

Rewrite the problem summary three ways:

- Category-anchored: frame the problem as a gap in the category
- Use-case-anchored: frame the problem as a daily workflow pain
- Alternative-anchored: frame the problem as frustration with the current approach

Recommend which framing best fits the go-to-market motion.

### Output format

```markdown
### Problem-framing variants
Category-anchored: [Problem framed as a category gap]
Use-case-anchored: [Problem framed as a workflow pain]
Alternative-anchored: [Problem framed as a displacement story]
Recommended framing: [Which one and why]
```

---

## Step 4: Messaging hierarchy

Build a three-level messaging hierarchy using Aristotle's rhetorical framework:

**Level 1: Headline (5-10 words)**
- The single most important thing you want customers to remember
- Should pass the "billboard test" (understood in 3 seconds)

**Level 2: Value pillars (3 pillars using Aristotle's framework)**

Pillar 1 - Emotional Appeal (Pathos):
- Brief: Why will users love using this? What productivity gains or pain relief does it provide?
- Mechanism: How does the product technically enable this emotional benefit? What is the approach that makes daily work better?
- Consequence: What happens if the customer does not act? What pain persists or worsens?
- Proof points: testimonials, community sentiment, adoption stories

Pillar 2 - Logical Appeal (Logos):
- Brief: What unique technical capabilities does it have? What are the measurable differentiators?
- Mechanism: What is the technical approach that enables these capabilities? How does the architecture or design make this possible?
- Consequence: What happens if the customer does not act? What inefficiency, cost, or limitation remains?
- Proof points: technical documentation, benchmarks, architecture

Pillar 3 - Credibility Appeal (Ethos):
- Brief: Why can customers depend on this long-term? What track record, team background, or backing proves reliability?
- Mechanism: What is the approach that ensures ongoing reliability? Security certifications, enterprise adoption, funding, open source health.
- Consequence: What happens if the customer does not act? What trust, compliance, or stability risk remains?
- Proof points: customer logos, uptime stats, team credentials

**Level 3: Proof points (2-3 per pillar)**
- Specific features, metrics, or customer outcomes
- Evidence that backs up each value pillar

### Output format

```markdown
## Messaging hierarchy

### Headline
[5-10 word statement]

### Value pillars

#### Pillar 1: Emotional Appeal (Pathos)
[One sentence description]

How it works: [The mechanism or approach that enables this benefit]
Without this: [What happens if the customer does not act]
Proof points:
- [Specific feature or metric]
- [Customer outcome or benchmark]

#### Pillar 2: Logical Appeal (Logos)
[One sentence description]

How it works: [The mechanism or approach that enables this benefit]
Without this: [What happens if the customer does not act]
Proof points:
- [Specific feature or metric]
- [Customer outcome or benchmark]

#### Pillar 3: Credibility Appeal (Ethos)
[One sentence description]

How it works: [The mechanism or approach that enables this benefit]
Without this: [What happens if the customer does not act]
Proof points:
- [Specific feature or metric]
- [Customer outcome or benchmark]
```

---

## Step 4b: Differentiation summary

After completing the three pillars, write one sentence that synthesizes all pillars into a unified differentiation story. This closes the narrative loop from problem to solution and becomes a reusable asset for press boilerplate, executive summaries, and elevator pitches.

### Output format

```markdown
## Differentiation summary
[One sentence synthesizing all three pillars]
```

---

## Step 5: Value propositions

Create value propositions for different audiences and contexts:

**For technical evaluators:**
- Focus on capabilities, performance, user experience
- Use technical language and specifics
- Include code examples or architecture diagrams

**For technical decision makers:**
- Balance technical depth with business value
- Address scalability, reliability, support
- Include total cost of ownership considerations

**For business stakeholders:**
- Focus on outcomes and ROI
- Address risk, vendor stability, compliance
- Use business language, not technical jargon

### Value proposition template

```markdown
## Value proposition: [Audience]

### Hook
[One sentence that captures attention]

### Problem
[The specific challenge this audience faces]

### Solution
[How your product addresses this]

### Proof
[Evidence: metrics, customers, benchmarks]

### Call to action
[What you want them to do next]
```

---

## Competitive positioning

For each competitor, provide:
- What they genuinely do well (be honest - it builds credibility)
- Where you have defensible advantages
- The specific use cases where you win
- When you should actually recommend them instead (yes, really)
- How to handle objections when they come up in evaluation

---

## Messaging guidelines

**DO:**
- Lead with technical capability, then business benefit
- Use precise technical terminology correctly
- Show working code examples in all materials
- Acknowledge limitations and tradeoffs honestly
- Let the product speak through demos and docs

**DON'T:**
- Use superlatives without proof ("blazing fast", "revolutionary")
- Lead with business value before technical substance
- Hide pricing or require sales calls for basic info
- Ignore competitor strengths in comparisons
- Create artificial urgency or scarcity

Apply the "Help First" principle: every piece of positioning should help customers understand if this product solves their problem, even if the answer is no.

---

## Validation tests

Before finalizing positioning, run these four tests. If any fails, revise before moving to messaging.

1. **The duck test.** Does your positioning clearly name what you are in language a developer would use? If you need to explain your category label, it is wrong.
2. **The category test.** Can your category alone answer "what is this?" Can your use case alone answer it? If not, the element is too vague.
3. **The swap test.** Can your primary competitor say your positioning statement truthfully by replacing your product name with theirs? If yes, you have table stakes, not differentiation.
4. **The consequence test.** Does each pillar have a tangible, specific consequence of inaction? If the consequence is vague, the pillar is not solving a real problem.

---

## Common mistakes to avoid

1. **Being too broad**: "For everyone" is not a positioning
2. **Feature-first messaging**: Lead with benefits, not features
3. **Copying competitors**: Differentiate or lose
4. **Ignoring the status quo**: Your biggest competitor is often "do nothing"
5. **Jargon overload**: Clarity beats cleverness
6. **Inconsistent messaging**: Same core story across all channels
