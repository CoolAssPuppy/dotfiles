---
user-invocable: true
name: launch
description: Plans and executes product launches for technical products. Covers launch tiers, sine wave timing, naming conventions, pre-launch preparation, launch day execution, channel strategies, and post-launch activities. Use when launching new products, features, major releases, or planning go-to-market campaigns.
metadata:
  author: prashant-sridharan
  version: "1.0"
  source: "Picks and Shovels by Prashant Sridharan"
---

# Product launches

This skill helps plan and execute product launches for technical products based on the methodology from "Picks and Shovels."

## Core principle

A launch is not a moment; it's a campaign. The goal is sustained visibility and adoption, not a single spike of attention. The best launches feel less like "launches" and more like "this is now available." Focus on helping customers, not creating hype.

---
user-invocable: true

## Launch tiers

Not every launch deserves the same investment. Categorize launches into tiers:

### Tier 1: Major launches

- New products or platforms
- Major version releases (v2.0, v3.0)
- Pivotal new capabilities
- Company milestones (funding, major partnerships)

**Investment:** Full marketing campaign, press, events, executive involvement, 8+ weeks preparation

### Tier 2: Significant launches

- Important new features
- Meaningful integrations
- Performance improvements with measurable impact
- New pricing or packaging

**Investment:** Blog post, social campaign, email to customers, community engagement, 4-6 weeks preparation

### Tier 3: Incremental launches

- Minor features and improvements
- Bug fixes and optimizations
- Documentation updates
- Small quality-of-life improvements

**Investment:** Changelog entry, brief social mention, community update, 1-2 weeks preparation

---
user-invocable: true

## The sine wave pattern

Launches should follow a sine wave pattern of attention:

```
Attention
    ^
    |    /\      /\      /\
    |   /  \    /  \    /  \
    |  /    \  /    \  /    \
    | /      \/      \/      \
    +-------------------------> Time
      Pre    Launch   Post
```

**Pre-launch:** Build anticipation gradually
**Launch:** Peak attention
**Post-launch:** Sustain momentum through follow-up content

### Timing considerations

- **Avoid Mondays:** People are catching up from the weekend
- **Avoid Fridays:** Launches get lost before the weekend
- **Best days:** Tuesday, Wednesday, Thursday
- **Best times:** 9-11 AM in your primary market's timezone
- **Avoid holidays:** Check all major markets for conflicts

---
user-invocable: true

## Product naming

Names matter. Follow these guidelines:

### Naming principles

1. **Easy to spell and pronounce**: Users will type it and say it
2. **Searchable**: Can people find you on Google?
3. **Memorable**: Does it stick after one mention?
4. **Extendable**: Can you build a product family around it?
5. **Available**: Domain, social handles, package names

### Naming patterns that work

- **Descriptive**: Clearly states what it does (CloudFlare, PostgreSQL)
- **Abstract but evocative**: Suggests the benefit (Stripe, Slack)
- **Portmanteau**: Combination words (Instagram, Pinterest)
- **Modified spelling**: Unique but recognizable (Lyft, Flickr)

### Naming anti-patterns

- Generic words that are unsearchable
- Names that sound like competitors
- Hard to spell or pronounce
- Offensive meanings in other languages
- Already trademarked in your industry

---
user-invocable: true

## Pre-launch phase

Start 4-8 weeks before launch:

### Week 4-8: Foundation

- [ ] Finalize positioning and messaging
- [ ] Create launch brief document
- [ ] Identify target audience segments
- [ ] Set measurable goals (signups, traffic, coverage)
- [ ] Align internal stakeholders
- [ ] Identify launch partners and beta users

### Week 2-4: Content creation

- [ ] Write launch blog post
- [ ] Create documentation
- [ ] Prepare demo environment
- [ ] Record product videos
- [ ] Design social media assets
- [ ] Draft email campaigns
- [ ] Prepare press materials (if Tier 1)
- [ ] Prepare Product Hunt, HN, Reddit posts

### Week 1-2: Distribution prep

- [ ] Brief sales team
- [ ] Notify customer success
- [ ] Seed with friendly customers/beta users
- [ ] Prepare community posts (Reddit, HN, Discord)
- [ ] Schedule social media posts
- [ ] Coordinate with partners (if applicable)
- [ ] Set up tracking and analytics
- [ ] Load test infrastructure
- [ ] Create launch day war room plan

### Day before

- [ ] Final review of all materials
- [ ] Confirm all systems are ready
- [ ] Prepare war room/communication channels
- [ ] Brief support team on expected questions
- [ ] Have rollback plan if needed
- [ ] Send reminder emails to registrants (if applicable)

---
user-invocable: true

## Launch day execution

### Morning checklist

- [ ] Publish blog post
- [ ] Update product/website
- [ ] Update documentation
- [ ] Send customer email
- [ ] Post on social channels
- [ ] Push to Product Hunt
- [ ] Post announcement thread on Twitter/X

### Midday checklist

- [ ] Post to Hacker News (Show HN format)
- [ ] Share in relevant subreddits
- [ ] Engage with early comments
- [ ] Track metrics in real-time
- [ ] Address any issues immediately

### Afternoon checklist

- [ ] Post to Dev.to and Hashnode
- [ ] Monitor all channels
- [ ] Respond to every comment and question
- [ ] Share early wins internally

### End of day

- [ ] Capture day-one metrics
- [ ] Identify top-performing channels
- [ ] Note unexpected reactions or questions
- [ ] Plan follow-up content based on response

---
user-invocable: true

## Channel-specific strategies

### Product Hunt

- Launch timing: Tuesday-Thursday, 12:01 AM PT
- Prepare all assets in advance (screenshots, video, description)
- Engage authentically with comments
- Don't ask for upvotes
- Success metrics: upvotes, comments, traffic

### Hacker News

- Use "Show HN" format for new products
- Lead with technical substance, not marketing
- Be prepared for skepticism
- Respond thoughtfully to criticism
- Success metrics: points, comments, traffic quality

### Reddit

- Identify relevant subreddits and their rules
- Respect community guidelines
- Provide value, not just promotion
- Engage in discussions genuinely
- Never astroturf

### Twitter/X

- Thread structure (8-12 tweets)
- Include visual assets and demos
- Engagement tactics: reply to comments
- Post at optimal times for your audience

### YouTube

- Video types: demos (2-5 min), tutorials, deep dives
- SEO optimization: titles, descriptions, tags
- Success metrics: views, watch time, subscribers

### Email

- Segment by customer type
- Personalize where possible
- Clear value proposition
- Single, clear call-to-action

---
user-invocable: true

## Content asset checklist

### Required for all launches

- [ ] Launch blog post (800-1,200 words)
- [ ] Complete documentation
- [ ] Getting started guide (< 5 minutes to value)
- [ ] Demo video (2-5 minutes)
- [ ] Screenshots (5-10 high-quality)
- [ ] Social media graphics

### Nice to have

- [ ] Technical deep dive post
- [ ] Sample code repository
- [ ] Comparison guide vs alternatives
- [ ] Customer testimonials

---
user-invocable: true

## Metrics dashboard

### Awareness metrics

- Website traffic (overall and to launch page)
- Social impressions and engagement
- Press mentions and backlinks
- Community post views and upvotes

### Conversion metrics

- Signups/registrations
- Documentation page views
- Demo requests (enterprise)
- Free trial starts
- First meaningful actions (API calls, etc.)

### Activation metrics

- Users who complete onboarding
- First meaningful action taken
- Time to first value
- Retention at day 1, 7, 30

### Business metrics

- Pipeline generated
- Revenue influenced
- Customer feedback sentiment
- Support ticket volume

---
user-invocable: true

## Post-launch phase

The launch is just the beginning:

### Week 1

- [ ] Publish follow-up content (deep dives, tutorials)
- [ ] Respond to all feedback and questions
- [ ] Retarget engaged users
- [ ] Share customer testimonials
- [ ] Internal debrief on what worked

### Week 2-4

- [ ] Create content addressing common questions
- [ ] Publish case studies from early adopters
- [ ] Iterate based on user feedback
- [ ] Continue community engagement
- [ ] Track conversion from awareness to activation
- [ ] Customer interviews for insights
- [ ] Onboarding optimization

### Ongoing

- [ ] Monthly metrics review
- [ ] Quarterly retrospective
- [ ] Update messaging based on learnings
- [ ] Plan next launch in the sequence

---
user-invocable: true

## Risk mitigation

For each risk, prepare:
- Mitigation plan
- Response protocol
- Communication templates

### Common risks

- **Infrastructure failure**: Load test, have rollback plan
- **Critical bugs**: QA process, fast-fix protocol
- **Low engagement**: Backup promotion plans, community seeding
- **Competitor announcement**: Talking points, differentiation messaging

---
user-invocable: true

## Launch brief template

Create this document for every Tier 1 or Tier 2 launch:

```markdown
# Launch brief: [Product/Feature name]

## Overview
- Launch date: [Date]
- Launch tier: [1/2/3]
- Owner: [Name]

## What we're launching
[2-3 sentence description]

## Why it matters
[Value proposition for customers]

## Target audience
[Primary and secondary segments]

## Key messages
1. [Primary message]
2. [Secondary message]
3. [Tertiary message]

## Success metrics
- [Metric 1]: [Target]
- [Metric 2]: [Target]
- [Metric 3]: [Target]

## Timeline
- [Date]: [Milestone]
- [Date]: [Milestone]
- [Date]: Launch

## Assets needed
- [ ] Blog post
- [ ] Documentation
- [ ] Demo
- [ ] Social assets
- [ ] Email copy
- [ ] [Other]

## Risks and mitigations
- Risk: [Description] / Mitigation: [Plan]
```

---
user-invocable: true

## Common launch mistakes

1. **Launching on Friday**: Momentum dies over the weekend
2. **No follow-up content**: One-and-done approach wastes initial attention
3. **Ignoring time zones**: Launch when your audience is awake
4. **Underselling Tier 1 launches**: Major launches deserve major investment
5. **Overselling Tier 3 launches**: Feature fatigue kills trust
6. **Not briefing internal teams**: Sales and support need to know first
7. **No rollback plan**: Be ready for technical issues
8. **Forgetting existing customers**: They should hear about it first

---
user-invocable: true

## Channel-specific success metrics

Supplement the channel strategies above with concrete targets:

### Product Hunt

- **Timing:** Launch Tuesday-Thursday at 12:01 AM PT
- **Hunter:** Get a well-known hunter to submit (or submit yourself if you have audience)
- **Assets:** Compelling thumbnail, clear tagline, 3-5 screenshots or demo GIFs, short demo video (under 2 minutes)
- **Engagement:** Respond to every comment within minutes. Engage authentically, avoid canned responses.
- **Success metrics:** Top 5 product of the day, 200+ upvotes, 50+ comments

### Hacker News

- **Post type:** Link directly to blog post or product. Include technical details in first comment.
- **Success metrics:** Front page (top 30), 100+ points, 50+ comments

### Reddit

- **Subreddits:** r/programming (strict rules, high value), product-specific (r/webdev, r/javascript, etc.), r/SideProject (for early-stage)
- **Post format:** Clear, descriptive title. Detailed post explaining problem and solution. Include GitHub link, demo, or code examples.
- **Success metrics:** 500+ upvotes in r/programming, 50+ meaningful comments

### Dev.to / Hashnode

- **Content type:** Technical tutorials, how we built X posts, problem-solving narratives
- **SEO optimization:** Target specific keywords, include code examples, add relevant tags
- **Success metrics:** 1,000+ views, 50+ reactions, featured in top posts

### Twitter/X

- **Thread strategy:** 8-12 tweet thread. Start with hook/problem, build to solution, end with CTA.
- **Visual assets:** Demo GIFs, screenshots, architecture diagrams
- **Success metrics:** 10,000+ impressions, 200+ engagements, 20+ retweets

### YouTube

- **Video types:** Product demo (5-10 minutes), technical deep dive (15-30 minutes), quick start tutorial (3-5 minutes)
- **SEO:** Optimize title and description, include relevant tags, add timestamps
- **Success metrics:** 1,000+ views in first week, 50+ likes, positive comment engagement

### Discord/Slack communities

- Share in communities where you're already active
- Ask for feedback, not just promotion
- Offer exclusive early access or features
- Target framework-specific, platform-specific, and general developer communities

---
user-invocable: true

## Team roles and responsibilities

### Product marketing

- Own launch plan and timeline
- Create messaging and positioning
- Coordinate content creation
- Manage launch day activities

### Product

- Ensure product readiness
- QA and bug fixes
- Create demo environments
- Support technical content

### Engineering

- Infrastructure readiness
- Load testing
- Monitor performance
- Quick response to issues

### Design

- Visual assets creation
- Screenshots and mockups
- Video editing
- Website updates

### Customer success

- Support readiness
- FAQ preparation
- Beta customer engagement
- Early adopter nurturing

### Sales

- Outbound messaging
- Customer conversations
- Deal acceleration
- Feedback loop

---
user-invocable: true

## Success criteria

**Must have (launch is successful if):**
- Product works reliably for first users
- Documentation is complete and helpful
- Support can handle incoming questions
- Target activation metric is hit (e.g., 100 sign-ups)

**Should have (launch exceeded expectations if):**
- Front page of HN or #1 on Product Hunt
- 1,000+ engaged users in first week
- Positive social media sentiment
- Inbound partnership interest

**Nice to have (exceptional launch if):**
- Media coverage or industry analyst mention
- Viral social media moment
- Open source community contributions
- Competitor response or acknowledgment

---
user-invocable: true

## Launch communication plan

**Internal updates:**
- Daily stand-up during launch week
- Slack channel for real-time coordination
- End-of-day metrics summary
- Weekly retrospectives

**External communication:**
- Social media monitoring and response
- Community engagement
- Press and analyst briefings
- Customer email updates

---
user-invocable: true

## Launch day war room

Create a dedicated space (physical or virtual) for:
- Real-time monitoring dashboard
- Team coordination
- Quick decision making
- Issue triaging
- Celebration of wins

Include:
- Live metrics feed
- Social media monitoring
- Support ticket queue
- Issue tracking
- Team chat
