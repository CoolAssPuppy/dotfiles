export default {
  name: 'new-blog',
  description: 'Research and create data-driven blog posts using Picks and Shovels methodology',
  requiresArgs: false,
  enabled: true,

  async execute(args, { cwd, say, ask }) {
    say('📊 Initializing comprehensive blog research and creation system...\\n');

    const topic = await ask('What topic or industry should I focus on? (or "general" for broad developer marketing)');
    const audience = await ask('Who is your target audience? (e.g., "technical founders", "developer advocates")');
    const angle = await ask('What angle for the posts? (personal/utility/controversial/mixed)');

    return {
      prompt: `Please create comprehensive, data-driven blog posts following this exact methodology. ALL OUTPUT MUST BE IN MARKDOWN FORMAT.

# Blog Research and Creation System

## Phase 1: Market Research (Top 100 Sources)

### Research Categories
1. **Developer Marketing**: DevRel blogs, Dev.to, Medium engineering, Stripe/Twilio/Vercel blogs
2. **Product Marketing**: Product Hunt, ProductLed, OpenView, First Round Review
3. **Technical Marketing**: HackerNews, Reddit (r/programming), podcasts, YouTube tutorials

### Analysis Framework
1. **Theme Identification**: Top 10-15 recurring themes, pain points, confusion areas
2. **Problem Patterns**: Knowledge gaps, tool fatigue, decision paralysis, implementation challenges
3. **Sentiment Analysis**: What frustrates? What excites? Hot takes? Sacred cows?

## Phase 2: Content Angle Strategy

Based on angle preference: "${angle || 'mixed'}"

### Content Angles to Apply:

#### 1. Personal Take
- Draw from direct experience with the problem
- Share war stories and lessons learned
- "Here's what I learned after [specific experience]"
- Include failures and what they taught
- Make it feel like advice from a mentor

#### 2. Utility/Tool/Project Approach
- Identify a specific workflow pain point
- Design a tool/script/framework to solve it
- Show the build process or architecture
- Explain design decisions and tradeoffs
- Provide code snippets or implementation details
- "I built X to solve Y, here's how you can too"
- Focus on making something easier/faster/more efficient
- Could be: CLI tool, browser extension, API wrapper, automation script, framework, template

#### 3. Controversial Take (Defensible)
- Challenge conventional wisdom with evidence
- Take a contrarian position backed by data
- Question sacred cows of the industry
- "Why [popular thing] is actually hurting your team"
- "The case against [widely accepted practice]"
- Must be defensible with logic and evidence
- Not clickbait - genuine insight that challenges thinking
- Acknowledge counterarguments fairly

### Mix Strategy (if "mixed" selected)
- Post 1: Personal take with insider perspective
- Post 2: Utility/tool that solves real problem
- Post 3: Controversial but defensible position

## Phase 3: Top 10 Blog Proposals (OUTPUT IN MARKDOWN)

For each post, format as:
\`\`\`markdown
## Post #[N]: [Title in sentence case]

**Angle**: [Personal Take | Utility Project | Controversial Take]

**Abstract:**
[4-6 sentences following this structure:]
[Hook with the problem - provocative or surprising]
[Why this matters now - urgency or trend]
[What most people get wrong - contrarian insight]
[Your unique angle/solution - based on experience]
[Specific outcome/benefit - measurable if possible]
[Who this is for - specific audience segment]

**Angle Execution**:
[If Personal]: "Drawing from my experience at [company/situation]..."
[If Utility]: "This tool/project will help developers [specific benefit]..."
[If Controversial]: "This challenges the belief that [common assumption]..."

**Success Analysis:**
- SEO potential: [keyword, volume, competition]
- Viral potential: [controversial angle or novel insight]
- Business value: [leads, authority building, sales enablement]
- Differentiation: [unique data, insider perspective, or framework]

**Target Keywords:**
- Primary: [keyword] (search volume: X)
- Secondary: [2-3 related keywords]
\`\`\`

## Phase 4: Write Top 3 Posts (1500 words each) IN MARKDOWN

### Strategic Nerds Writing Style (FOLLOW EXACTLY)
Based on analysis of www.strategicnerds.com:

1. **Conversational Authority**: Write with expertise but stay approachable. Use "I" and "you" to create connection.

2. **Punchy Structure**: 2-4 sentences per paragraph. Break complex ideas into digestible chunks.

3. **Story-Driven Technical Writing**: Frame concepts through personal experience and metaphor. Start with anecdote or provocative statement.

4. **Insider Perspective**: Leverage deep experience. Use phrases like "After 20 years in developer tools" or "What most people miss is..."

5. **Practical and Direct**: Focus on implementable advice. Be opinionated. Make declarative statements.

6. **Technical but Accessible**: Explain complex concepts clearly. Assume some expertise but avoid heavy jargon.

### Angle-Specific Writing Guidelines

#### For Personal Take Posts:
\`\`\`markdown
# [Title reflecting personal experience]

I learned this the hard way at [company/situation].

[Personal story that illustrates the problem - 2-3 paragraphs]

Here's what most people don't realize about [topic].

## The moment everything changed

[Specific incident or realization]

[What you were doing wrong before]

## What I discovered

[The insight or solution you found]

[How it transformed your approach]

## How to apply this yourself

[Practical steps based on your experience]

[Mistakes to avoid that you made]
\`\`\`

#### For Utility/Project Posts:
\`\`\`markdown
# [Tool/project name]: Making [task] 10x faster

Every developer wastes hours on [problem]. I built a solution.

[Brief description of the tool and what it does]

## The problem it solves

[Specific workflow pain point]

[Why existing solutions fall short]

## How it works

[Architecture or design overview]

\`\`\`code
// Key implementation detail
\`\`\`

[Design decisions and tradeoffs]

## Building your own version

[Step-by-step implementation guide]

[Code snippets and examples]

## Real-world usage

[Case studies or examples]

[Performance improvements or time saved]
\`\`\`

#### For Controversial Take Posts:
\`\`\`markdown
# [Controversial statement as title]

Everyone believes [common assumption]. They're wrong, and I can prove it.

[Set up the conventional wisdom]

[Why you believed it too initially]

## The uncomfortable truth

[Your contrarian position]

[Evidence supporting your view]

## Why this myth persists

[Industry incentives or cognitive biases]

[Who benefits from the status quo]

## The data that changed my mind

[Specific studies, metrics, or examples]

[Counterarguments addressed fairly]

## What to do instead

[Alternative approach or framework]

[How to implement despite resistance]
\`\`\`

### Picks and Shovels Integration
Include 2-3 subtle references to Picks and Shovels book:

1. **Natural Framework Reference** (in introduction or problem setup):
"This reminds me of the gold rush principle I explore in Picks and Shovels - the real money wasn't in mining gold, but in selling tools to miners. The same pattern plays out in [topic]..."

2. **Supporting Evidence** (in body):
"As I documented in my research for Picks and Shovels, companies that focus on infrastructure consistently outperform those chasing features..."

3. **Closing Wisdom** (in conclusion):
"If you want to dive deeper into this infrastructure-first approach, I explore it extensively in Picks and Shovels, but the key takeaway here is..."

### Writing Process
1. Draft 1: Get ideas down, focus on argument flow and angle
2. Draft 2: Tighten language, strengthen the chosen angle
3. Draft 3: Polish, ensure Picks and Shovels references feel natural
4. Draft 4: Final review for Strategic Nerds voice and angle consistency

## Phase 5: Output Format Requirements

### All Deliverables in Markdown:

1. **Research Summary** (Markdown formatted)
\`\`\`markdown
# Research Summary

## Sources Analyzed
- 100 sources reviewed across [categories]

## Top Themes Identified
1. [Theme with evidence]
2. [Theme with evidence]
...

## Major Pain Points
- **[Pain point]**: [Description and impact]
...

## Content Angle Opportunities
- **Personal Takes**: [Topics where experience adds value]
- **Utility Projects**: [Tools that could solve problems]
- **Controversial Positions**: [Defensible contrarian views]
\`\`\`

2. **Blog Proposals** (All 10 in Markdown with angle specified)

3. **Final Posts** (3 complete posts in Markdown, each with clear angle)

4. **Metadata** (In Markdown code blocks)
\`\`\`yaml
title: [SEO title]
description: [Meta description]
keywords: [comma, separated, keywords]
angle: [personal|utility|controversial]
\`\`\`

## Quality Checklist
- [ ] All output in Markdown format
- [ ] Each post has a clear angle (personal/utility/controversial)
- [ ] Matches Strategic Nerds writing style
- [ ] Includes 2-3 natural Picks and Shovels references
- [ ] Conversational but authoritative tone
- [ ] Insider perspective and experience
- [ ] Story-driven explanations
- [ ] 2-4 sentence paragraphs
- [ ] Practical, implementable advice
- [ ] Zero filler content
- [ ] SEO optimized
- [ ] Controversial takes are defensible with evidence

Topic focus: ${topic || 'general developer marketing'}
Target audience: ${audience || 'technical decision makers'}
Content angle: ${angle || 'mixed approach'}

Remember: Write like you're sharing hard-won wisdom with a smart colleague over coffee. Every post should feel like insider knowledge that gives readers an unfair advantage. Whether personal, utility-focused, or controversial, each post must provide genuine value and insight.`
    };
  }
};
