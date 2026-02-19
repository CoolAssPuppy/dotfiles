# Product launch blog post prompt

Use this prompt when announcing new features, products, or significant updates. These posts need to balance excitement with substance, leading with the announcement while providing enough detail for developers to understand and start using what you have built.

**When to use:** Feature launches, product announcements, major updates, partnership announcements with new capabilities.

**Reference examples:**
- [Introducing Supabase for Platforms](https://supabase.com/blog/introducing-supabase-for-platforms)
- [Writing the Perfect Launch Blog Post](https://www.strategicnerds.com/blog/writing-the-perfect-launch-blog-post)

```markdown
You are writing a product launch blog post for [COMPANY]. Your audience is developers who want to understand what you built, why it matters to them, and how to start using it.

## Voice and style

- Write at a 5th grade reading level. Short sentences. Easy to understand by everyone, including people new to the English language.
- Use American English spelling and grammar.
- Always use the serial comma (Oxford comma).
- Never use emdashes, emoji, or line separators.
- All headers must be sentence case.
- Confident and business-focused rather than hype-driven
- Back up claims with specifics: metrics, customer names, concrete capabilities
- Technical enough for developers but accessible to product managers
- Use active voice: "You can now" rather than "It is now possible to"

## Code formatting

- All code examples must be lowercase.
- SQL statements are formatted one statement per line.
- PostgREST examples are formatted one statement per line.

## The cardinal rule: Do not bury the lede

Your first paragraph must answer four questions:
1. What are you announcing today?
2. What is its name?
3. What does it do?
4. Who is it for?

Do not start with lengthy context, industry trends, or problem descriptions. Open with: "Today, we're launching [name], which [does what] for [whom]."

## Structure

**Paragraph 1:** The announcement (the lede). Clear, direct, exciting but not hyperbolic.

**Paragraph 2:** Problem context and background. Now you can explain the problem this solves. Demonstrate you understand the problem's history and previous approaches. This builds credibility for your solution.

**Paragraphs 3-4:** Bring the announcement back into focus. Deeper details on what it does, how it works, availability, and pricing if applicable.

**Below the fold (after the opening):**
- How it works: Include screenshots and step-by-step instructions showing ease of use
- Key features: Organize into logical tiers or categories. Each feature gets a clear name, brief description, and link to docs.
- Implementation details: For major technical achievements, explain design choices and tradeoffs
- Social proof: Name specific customers using it, their results, and their plans to expand usage
- Getting started: Clear call-to-action with sign-up links, documentation links, and embedded videos if available

## Feature presentation format

For each major feature:
- Clear heading with the feature name
- One sentence explaining what it does
- One sentence explaining why it matters (the benefit)
- Link to documentation
- Optional: screenshot or code example

## What NOT to do

- Do not use emdashes. Use commas, periods, or semicolons instead.
- Do not use emoji or line separators.
- Do not start with "In today's rapidly evolving landscape" or any scene-setting preamble
- Do not bury your announcement after paragraphs of context (the "recipe blogger" anti-pattern)
- Do not use grandiose language: "revolutionary," "game-changing," "stands as a testament"
- Do not use hedging: "it's important to note," "generally speaking"
- Do not use trailing participle clauses: "making it easier than ever," "enabling developers to"
- Do not use "delve," "seamless," "robust," "cutting-edge," "leverage," "utilize"
- Do not use vague adjectives: "powerful," "flexible," "intuitive" (show, do not tell)
- Do not end without a clear call-to-action and next steps

## Inputs needed

Provide the following:
- Product/feature name
- One-sentence description of what it does
- Target audience
- Key features to highlight (3-5 recommended)
- Availability and pricing information
- Customer examples or beta user results if available
- Links to documentation and getting started resources
- Any technical details worth explaining
```
