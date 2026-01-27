# Webinar planning prompt

Use this prompt to generate a complete webinar asset package: landing page, email sequences, social media posts, ad copy, and execution checklist. This prompt creates everything you need to promote and run a developer-focused webinar.

**When to use:** Planning any webinar, whether product deep dive, customer story, migration guide, best practices, or integration showcase.

```markdown
You are creating a complete webinar asset package for a developer-focused company. Your output must be specific, actionable, and ready to execute. Vague webinar plans waste money and time.

## Voice and style

- Write at a 5th grade reading level. Short sentences. Easy to understand by everyone, including people new to the English language.
- Use American English spelling and grammar.
- Always use the serial comma (Oxford comma).
- Never use emdashes, emoji, or line separators.
- All headers must be sentence case.
- Focus on teaching, not selling. Developers see through marketing fluff.
- Make content valuable even to people who never become customers.

## Webinar asset package structure

Generate all of the following assets:

### 1. Webinar overview

| Field | Value |
|-------|-------|
| Title | |
| Subtitle | |
| Date | [Must be Wednesday, third week of month] |
| Time | 11am EST / 8am PST |
| Duration | [X] minutes presentation + [Y] minutes Q&A |
| Type | Product deep dive / Customer story / Migration guide / Best practices / Integration |
| Target audience | |
| Primary speaker | |
| Additional speakers | |

### 2. Landing page (MDX format)

Generate complete MDX file with frontmatter:

```mdx
---
title: '[Full webinar title]'
meta_title: '[SEO title, under 60 characters]'
subtitle: '[One sentence description]'
meta_description: '[SEO description, 150-160 characters]'
type: 'webinar'
onDemand: false
date: '[YYYY-MM-DDTHH:mm:ss.000-07:00]'
timezone: 'America/Los_Angeles'
duration: '[X mins]'
company:
  {
    name: '[Customer company name if applicable]',
    website_url: '[URL]',
    logo: '[Path]',
  }
categories:
  - webinar
main_cta: {
  url: '[Registration URL]',
  target: '_blank',
  label: 'Register now',
}
speakers: '[speaker_ids]'
---

## [Main headline focused on value]

[2-3 paragraphs: Problem statement, why this matters, what attendees will learn]

### Key takeaways

- [Specific, actionable takeaway 1]
- [Specific, actionable takeaway 2]
- [Specific, actionable takeaway 3]
- [Specific, actionable takeaway 4]
- [Specific, actionable takeaway 5]

Join us live to participate in the Q&A. Can't make it? We'll send you a link to the recording.
```

### 3. Email sequence (8 emails)

**Email 1: Announcement (T-7 days)**
- Subject line: [Clear, specific, under 50 characters]
- Preview text: [First line optimized for preview]
- Body: [Full email, short paragraphs, clear CTA]

**Email 2: Registrant reminder (T-1 day)**
- Subject, preview, body

**Email 3: Final reminder (T-1 hour)**
- Subject, preview, body

**Email 4: Registration confirmation (immediate)**
- Subject, preview, body

**Email 5: Attendee thank you (T+1 day)**
- Subject, preview, body
- Include recording link

**Email 6: No-show follow-up (T+1 day)**
- Subject, preview, body
- Include recording link

**Email 7: Newsletter inclusion**
- Short copy for newsletter section

**Email 8: SDR outreach template (T-9 days)**
- Personalized outreach for sales team

### 4. Social media posts

**LinkedIn:**
- Announcement post (T-7 days): [Full post with hashtags]
- Reminder post (T-1 day): [Full post]
- Post-event: [Full post with recording link]

**Twitter/X:**
- Announcement thread (T-7 days): [5-7 tweets]
- Reminder tweet (T-1 hour): [Single tweet]
- Post-event: [Tweet with recording link]

### 5. Ad copy (if paid promotion)

**LinkedIn sponsored post:**
- Headline:
- Body copy:
- Targeting: Job titles, company size, industries

**Twitter/X promoted tweets:**
- Variation 1:
- Variation 2:
- Variation 3:

**Google search ads:**
- Headlines (3):
- Descriptions (2):
- Target keywords:

### 6. Graphics requirements

Provide specifications for design team:

| Asset | Dimensions | Elements needed |
|-------|------------|-----------------|
| Email header | 600px x 300px | Title, date, time, speaker headshots |
| LinkedIn square | 1200px x 1200px | Title, date, time, branding |
| Twitter card | 1200px x 675px | Title, date, time, branding |
| Landing page hero | 1920px x 800px | Topic visual, clean design |
| Newsletter thumbnail | 400px x 300px | Compact, title visible |

### 7. Execution checklist

**4 weeks before (T-28):**
- [ ] Finalize topic and title
- [ ] Confirm speakers
- [ ] Create registration event
- [ ] Outline presentation

**3 weeks before (T-21):**
- [ ] Draft slide deck
- [ ] Build demo environment
- [ ] Brief design team on graphics
- [ ] Draft all marketing copy

**2 weeks before (T-14):**
- [ ] Complete graphics
- [ ] Landing page live
- [ ] Email templates loaded
- [ ] Test demos

**1 week before (T-7):**
- [ ] Full rehearsal
- [ ] Send announcement emails
- [ ] Social media posts live
- [ ] Test all tech

**Day before (T-1):**
- [ ] Final tech check
- [ ] Send reminder emails
- [ ] Social reminders
- [ ] Confirm speakers

**Day of (T-0):**
- [ ] Log in 1 hour early
- [ ] Send 1-hour reminder
- [ ] Run webinar
- [ ] Save recording

**Day after (T+1):**
- [ ] Send attendee thank you
- [ ] Send no-show email
- [ ] Upload recording
- [ ] Update landing page
- [ ] SDR outreach begins

**Week after (T+7):**
- [ ] Create blog post summary
- [ ] Extract social clips
- [ ] Review metrics
- [ ] Plan next webinar

### 8. Success metrics

| Metric | Target | Actual |
|--------|--------|--------|
| Registrations | | |
| Show-up rate | 30-40% | |
| Qualified leads | | |
| Recording views (week 1) | | |

## Email writing guidelines

Subject lines:
- Clear and specific
- Under 50 characters
- Include key detail (topic or timing)
- No spam triggers or clickbait

Email body:
- Start with value, not greeting
- Short paragraphs (2-3 sentences max)
- One clear CTA per email
- Personalization token for name

## Social media guidelines

LinkedIn:
- Professional tone
- Focus on business value
- Tag speakers and companies
- 3-5 relevant hashtags
- Ask engagement question

Twitter/X:
- Thread format for announcements
- Single tweet for reminders
- Tag speaker handles
- Encourage retweets

## What NOT to do

- Do not use vague takeaways: "learn best practices" or "discover insights"
- Do not write lengthy emails. Developers skim.
- Do not use marketing jargon: "unlock," "transform," "revolutionize"
- Do not use grandiose language: "game-changing," "must-attend"
- Do not make promises you cannot keep
- Do not hide the topic behind hype
- Do not use "leverage," "utilize," "delve," "seamless"
- Do not use trailing participle clauses
- Do not use emdashes or emoji
- Do not skip the execution checklist. Details matter.

## Inputs needed

Provide the following:
- Webinar topic and title
- Target date
- Problem this webinar solves
- Target audience (role, company size, technical level)
- 3-5 key takeaways
- What will be demoed or shown
- Speaker names and titles
- Customer company (if customer story)
- Related documentation or resources to link
- Whether paid promotion is planned
```
