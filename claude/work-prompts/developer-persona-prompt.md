# Developer persona prompt

Use this prompt to create detailed profiles of your target developer audience segments. Good personas are specific enough to guide real decisions. Vague personas are useless.

**When to use:** New product development, entering new markets, refining targeting, onboarding new team members, or when marketing feels disconnected from actual users.

**Note:** Personas are different from ICPs (Ideal Customer Profiles). ICPs describe target companies. Personas describe individual people within those companies.

```markdown
You are creating a developer persona for a developer tool or platform. Your persona must be specific, realistic, and actionable. Generic personas waste everyone's time.

## Voice and style

- Write at a 5th grade reading level. Short sentences. Easy to understand by everyone, including people new to the English language.
- Use American English spelling and grammar.
- Always use the serial comma (Oxford comma).
- Never use emdashes, emoji, or line separators.
- All headers must be sentence case.
- Use concrete details, not vague generalities.
- Base personas on real research: interviews, surveys, support tickets, community discussions.

## Persona structure

### 1. Demographics

| Field | Value |
|-------|-------|
| Name | [Give them a realistic name] |
| Role | [Specific job title] |
| Experience level | [Years in role, years in industry] |
| Company size | [Employees, revenue range] |
| Industry | [Specific vertical] |
| Location | [Region or country] |
| Team structure | [Reports to whom, team size] |

### 2. Technical context

| Field | Value |
|-------|-------|
| Primary languages | |
| Frameworks | |
| Cloud platforms | |
| Development methodology | |
| Tools they use daily | |
| Technical decision-making authority | [Full, partial, none] |

### 3. Goals and motivations

List 3-5 specific goals. Be concrete.

Example format:
- **Goal:** Ship features faster without sacrificing quality
  - **Why it matters:** Their team is under pressure to deliver more with the same headcount
  - **How they measure success:** Deployment frequency, time from commit to production

### 4. Pain points

List 3-5 specific pain points. Be concrete.

Example format:
- **Pain point:** Spending too much time on infrastructure instead of product features
  - **Current workaround:** Cobbled-together scripts and manual processes
  - **Cost of this pain:** 20% of their week on ops tasks

### 5. Evaluation criteria

How do they evaluate and choose tools? List in priority order.

1. [Criterion]: [Why this matters to them]
2. [Criterion]: [Why this matters to them]
3. [Criterion]: [Why this matters to them]

### 6. Information sources

Where do they discover and research tools?

- **Discovery:** [Where they first hear about tools]
- **Research:** [Where they do deep evaluation]
- **Validation:** [Where they check social proof]
- **Trusted voices:** [People or publications they trust]

### 7. Objections and concerns

What would prevent them from adopting your product?

| Objection | Root cause | How to address |
|-----------|------------|----------------|
| | | |

### 8. Representative quote

Write a quote that captures their mindset. This should sound like something they would actually say.

Example: "I don't have time to learn another tool. It better just work, and it better have good docs because I'm not going to ask for help."

## What NOT to do

- Do not create fictional personas without research backing
- Do not use vague descriptors: "tech-savvy" or "innovative"
- Do not list generic goals: "wants to be more productive"
- Do not skip the objections section. Understanding resistance is critical.
- Do not make personas too aspirational. Describe who they are, not who you wish they were.
- Do not use marketing jargon in quotes or descriptions
- Do not use "passionate about technology" or similar cliches
- Do not use emdashes or emoji

## Inputs needed

Provide the following:
- Research sources (interviews, surveys, support data, community discussions)
- Product or company context
- Existing customer examples that fit this persona
- Known objections from sales or support conversations
- Competitive context (what else are they considering?)
```
