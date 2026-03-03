---
user-invocable: true
name: competitive-battlecard
description: Generates comprehensive competitive battlecards for developer products that help sales and marketing teams position against specific competitors. Covers company overview, strengths/weaknesses analysis, objection handling, pricing comparison, and when-to-choose guidance. Use when creating battlecard documents for individual competitors, preparing sales enablement materials, or equipping teams with competitor-specific talking points.
metadata:
  author: prashant-sridharan
  version: "1.0"
  source: "Picks and Shovels by Prashant Sridharan"
---

# Competitive battlecard

This skill generates comprehensive competitive battlecards for developer products that help sales and marketing teams position against specific competitors.

## Core principle

**Be honest and credible.** Developers respect authenticity. Don't claim superiority in areas where the competitor genuinely wins. Instead, acknowledge their strengths and explain when your product is the better choice.

## When to use this skill

Use this skill when you need a detailed battlecard document for a specific competitor. This is different from broader competitive analysis (use the competitive-analysis skill for that). A battlecard is a focused, actionable document designed for sales and marketing teams to reference during customer conversations.

## Research required

Before creating the battlecard, gather:

1. **Competitor intelligence:**
   - Product documentation review
   - Pricing page analysis
   - Customer reviews and feedback
   - Technical blog posts and announcements
   - Sales conversations and objections

2. **Your product knowledge:**
   - Current capabilities and roadmap
   - Pricing and packaging
   - Technical architecture
   - Customer success stories
   - Competitive advantages

3. **Customer insights:**
   - Why customers choose you vs competitor
   - Why customers choose competitor vs you
   - Common evaluation criteria
   - Deal-breaker features or gaps

## Battlecard structure

### 1. Company overview

**Visual header:**
- Competitor logo
- Your logo
- One-sentence summary of how the products differ

**Competitor details:**
- Company name
- Founded date
- Headquarters
- Industries served
- Number of employees
- Annual revenue (if known)
- Funding stage
- Website, LinkedIn, Twitter links

**Comparison context:**
Write 2-3 sentences explaining:
- What category both products occupy
- How they approach the problem differently
- Who they each target

### 2. Strengths analysis

**Competitor strengths:**
List 4-6 genuine strengths with:
- Clear, specific claim (not vague)
- Technical explanation of why it matters
- Use cases where this strength shines
- Links to documentation or proof

**Your strengths:**
List 4-6 of your strongest differentiators with:
- Specific technical capabilities
- Quantifiable advantages where possible
- Developer experience benefits
- Links to features or case studies

### 3. Weaknesses analysis

**Competitor weaknesses:**
List 3-5 genuine limitations with:
- Specific technical or product gaps
- Impact on developer workflows
- Scenarios where this causes problems
- Fair comparison (don't exaggerate)

**Your weaknesses:**
List 2-4 honest limitations with:
- Areas where competitor is stronger
- Your product's constraints or trade-offs
- Roadmap items that might address these
- Workarounds or alternatives

### 4. Partnerships and ecosystem

**Competitor partnerships:**
List major partnerships and integrations:
- Partnership name
- Type of integration
- Benefits to users
- Strategic significance

Include partnerships like:
- Cloud provider integrations (AWS, Azure, GCP)
- Platform integrations (Vercel, Netlify, etc.)
- Tool ecosystem (IDEs, frameworks, etc.)

### 5. How competitor wins

Create 3-5 scenarios with this structure:

**[Number] [Scenario title]**
- **Why it matters:** Explain the use case or problem
- **Technical deep dive:**
  - Specific technical capability
  - Architecture or approach that enables it
  - Quantifiable benefits where possible
- **[Competitor] wins here:** One clear sentence on when to choose them

Examples:
- Serverless scaling and cost efficiency
- Instant database branching
- Real-time sync capabilities
- Enterprise compliance and security

### 6. How you win

Create 3-5 scenarios with this structure:

**[Number] [Your advantage]**
- **Why it matters:** Explain the use case or problem
- **Technical deep dive:**
  - Your unique capabilities
  - Architecture or features that deliver value
  - Concrete developer benefits
- **[Your product] wins here:** One clear sentence on when you're the better choice

### 7. Objection handling

For each common objection, provide:

**"[Customer objection in their words]"**

**Customer concern:**
Expand on what they're really asking about

**Objection handling response:**
- Acknowledge what's true in their concern
- Provide context or alternative perspective
- Explain your approach and why it's valid
- Clarify the trade-offs involved
- **TL;DR:** One-sentence summary

Common objection types:
- Technical capabilities comparison
- Pricing and cost efficiency
- Developer experience differences
- Scalability and performance
- Feature gaps or roadmap
- Lock-in and portability concerns

### 8. When to choose summary

**When to choose [your product]:**
- List 4-6 specific scenarios
- Focus on concrete use cases
- Be honest about your sweet spot

**When to choose [competitor]:**
- List 3-4 scenarios where they're genuinely better
- Build credibility through honesty
- Respect the customer's decision-making process

### 9. Product capabilities comparison table

Create a detailed comparison table:

| Category | Competitor product | Your product |
|----------|-------------------|--------------|
| [Feature category] | Key capabilities, strengths, weaknesses | Key capabilities, strengths, weaknesses |

Categories to include:
- Authentication and authorization
- Database and data storage
- Real-time capabilities
- Serverless functions
- File storage
- Security and compliance
- Developer tools and CLI
- API and SDKs
- Monitoring and observability

### 10. Pricing comparison table

Create an honest pricing comparison:

| Tier | Competitor pricing | Your pricing |
|------|-------------------|--------------|
| Free | Storage limits, compute limits, feature restrictions | Storage limits, compute limits, feature restrictions |
| Starter/Launch | Monthly cost, included resources, key features | Monthly cost, included resources, key features |
| Pro/Scale | Monthly cost, included resources, advanced features | Monthly cost, included resources, advanced features |
| Enterprise | Custom pricing, enterprise features, support levels | Custom pricing, enterprise features, support levels |
| Add-ons | Additional compute, storage, other charges | Additional compute, storage, other charges |

### 11. Recent company news

Track important developments:
- Product launches and major features
- Funding announcements
- Key partnerships
- Leadership changes
- Market positioning shifts

### 12. Additional resources

Provide links to:
- Migration guide from competitor (if available)
- Detailed comparison documentation
- Customer testimonials switching from competitor
- Technical blog posts on differences
- Video comparisons or demos

## Output format

Generate as a Notion-compatible markdown document with:
- Clear section headers
- Visual hierarchy with callouts
- Tables for structured comparisons
- Columns for side-by-side information

## Maintenance guidelines

Include at the top:
- Last updated date
- Owner/maintainer
- Review frequency (quarterly recommended)
- Instructions for requesting updates

## Best practices

1. **Be technically accurate**: Developers will fact-check everything
2. **Stay current**: Update battlecards quarterly or when major changes occur
3. **Use customer language**: Frame objections in their actual words
4. **Provide proof**: Link to documentation, benchmarks, case studies
5. **Acknowledge trade-offs**: Every product makes architectural choices with pros and cons
6. **Avoid FUD**: Never use fear, uncertainty, doubt tactics
7. **Respect the competitor**: They're solving real problems for real customers
8. **Focus on fit**: Help customers make the right choice for their needs

## When not to compete

Include guidance on when to recommend the competitor:
- Their architecture genuinely fits better
- They have a must-have feature you lack
- Pricing model aligns better with customer usage
- Integration ecosystem is superior for their stack

This builds trust and credibility.

## Competitive positioning philosophy

The goal is not to "win" every comparison, but to help customers make informed decisions. When you're honest about where competitors excel, you build trust. When you clearly articulate where you excel, you win the right deals.

Focus on finding customers who are a great fit rather than trying to be everything to everyone.

## Quality checklist

Before finalizing:
- [ ] All competitor information is accurate and current
- [ ] Objections reflect real customer concerns
- [ ] Strengths and weaknesses are honest and balanced
- [ ] Technical claims are verifiable with links
- [ ] Pricing information is up to date
- [ ] Use cases are specific, not generic
- [ ] "When to choose" guidance is genuinely helpful
- [ ] Tables are complete and well-formatted
- [ ] Links to resources work and are relevant
- [ ] Tone is respectful and professional
