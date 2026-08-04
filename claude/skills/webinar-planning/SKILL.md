---
user-invocable: true
name: webinar-planning
description: Plans and executes technical webinars for developer audiences, and generates the complete asset package. Covers content structure, planning timelines, landing pages, email sequences, social promotion, paid advertising, graphics specs, execution checklists, lead follow-up segmentation, platform setup, metrics, and content repurposing. Use when planning product deep-dives, customer stories, migration workshops, partner integrations, or lead generation programs.
metadata:
  author: prashant-sridharan
  version: "3.0"
  source: "Picks and Shovels by Prashant Sridharan"
---

# Technical webinar planning

Plan, execute, and follow up on technical webinars, and produce every asset needed to run one. Vague webinar plans waste money and time, so the output must be specific, actionable, and ready to execute.

Use this skill when:
- Planning product deep-dive webinars
- Creating customer story presentations
- Building migration or best practices workshops
- Launching partner integration sessions
- Developing lead generation programs

## Voice and style

Apply the voice rules in the `writing` skill.

- Write at a 5th grade reading level. Short sentences. Easy to understand by everyone, including people new to the English language.
- Focus on teaching, not selling. Developers see through marketing fluff.
- Make content valuable even to people who never become customers.

## Core principles

For technical audiences:
- Lead with technical depth, not marketing messages
- Show real code, real demos, real use cases
- Acknowledge trade-offs and limitations honestly
- Provide actionable takeaways, not just concepts
- Answer technical questions thoroughly

For technical decision makers specifically:
- Address business value: return on investment, cost savings, team productivity
- Cover enterprise concerns: security, compliance, migration
- Show integration with existing tools and workflows
- Discuss team training and adoption strategies
- Provide an honest comparison with alternatives
- Include customer stories from similar companies

## Webinar standards

**Timing consistency:**
- Schedule webinars on a consistent day and time
- Wednesday at 11am EST / 8am PST is a strong default for developer audiences
- Schedule for the third full week of every month
- Skip months with major holidays
- Avoid conflicts with company launch events

**Duration:**
- Total time: 60 minutes
- Presentation and demo: 40 to 45 minutes
- Q&A: 15 to 20 minutes
- Always end on time

**Platform:**
- Registration and hosting on a dedicated webinar platform
- Streaming and recording through a high-quality capture tool
- Have a contingency plan for technical issues

**Recording:**
- Always record for on-demand availability
- Make available within 24 hours of the live event
- Host on YouTube and embed in the landing page
- Create timestamp chapters for key sections

## Webinar types and formats

**1. Product deep dive**
- Focus: a specific product feature or capability
- Format: 50% presentation, 50% live demo
- Audience: developers actively evaluating or using the feature

**2. Customer story**
- Focus: how a company solved a problem using your product
- Format: 30% context, 40% technical walkthrough, 30% Q&A
- Audience: teams facing similar challenges

**3. Migration guide**
- Focus: moving from a competitor to your product
- Format: 25% why migrate, 50% how to migrate, 25% Q&A
- Audience: teams evaluating migration

**4. Best practices and architecture**
- Focus: how to build effectively with your product
- Format: 40% principles, 40% examples, 20% Q&A
- Audience: teams building on your product

**5. Integration and partner session**
- Focus: your product combined with a partner technology
- Format: joint presentation with the partner
- Audience: users of both platforms

## Asset package

Generate all of the following.

### 1. Overview

| Field | Value |
|-------|-------|
| Title | |
| Subtitle | |
| Date | [Wednesday, third full week of the month] |
| Time | 11am EST / 8am PST |
| Duration | [X] minutes presentation + [Y] minutes Q&A |
| Type | Product deep dive / Customer story / Migration / Best practices / Integration |
| Target audience | [Specific roles, company sizes, technical level] |
| Primary topic | [What problem this webinar solves] |
| Primary speaker | |
| Additional speakers | |
| Registration link | |
| Recording link | [Add after the event] |
| Expected outcomes | [Registration, attendance, and lead targets] |

### 2. Background

**Audience research:** why this topic matters to them, current pain points, what they are using now, decision criteria.

**Topic justification:** market trends, customer requests, the competitive set, strategic importance.

**Related content:** blog posts, documentation, previous webinars, case studies.

**Customer context:** example companies, their challenges, success patterns.

**Success criteria:** target metrics, lead goals, business impact.

### 3. Landing page

Generate the complete page with frontmatter and body:

```mdx
---
title: '[Full webinar title]'
meta_title: '[SEO title, under 60 characters]'
subtitle: '[One sentence description]'
meta_description: '[SEO description, 150 to 160 characters]'
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

[2 to 3 paragraphs: problem statement, why this matters, what attendees will learn]

### Key takeaways

- [Specific, actionable takeaway 1]
- [Specific, actionable takeaway 2]
- [Specific, actionable takeaway 3]
- [Specific, actionable takeaway 4]
- [Specific, actionable takeaway 5]

Join us live to participate in the Q&A. Can't make it? We'll send you a link to the recording.
```

Deployment checklist:
- [ ] Page file created with all metadata
- [ ] Copy reviewed and approved
- [ ] Speaker IDs confirmed
- [ ] Registration link added
- [ ] Graphics requested from design
- [ ] Page deployed and tested
- [ ] SEO metadata verified

### 4. Email sequence

Write all eight emails in full: subject line, preview text, body, and CTA.

**Email 1: Announcement (T-7 days)**
- Subject: [Topic]: live webinar with [Speaker or Customer]
- Preview: Join us on [Date] at [Time]
- Body: problem, solution, what you will learn, CTA to register
- Tone: helpful, technical, clear value

**Email 2: Registrant reminder (T-1 day)**
- Subject: Tomorrow: [Topic] webinar at [Time]
- Body: quick reminder, add to calendar, what to prepare, join link

**Email 3: Final reminder (T-1 hour)**
- Subject: Starting in 1 hour: [Topic]
- Body: join link, brief agenda
- Tone: urgent but not pushy

**Email 4: Registration confirmation (immediate)**
- Subject: You're registered for [Topic]
- Body: confirmation, calendar invite, what to expect

**Email 5: Attendee thank you (T+1 day)**
- Subject: Thanks for joining [Topic], recording inside
- Body: recording link, resources, feedback survey, CTA

**Email 6: No-show follow-up (T+1 day)**
- Subject: You missed it, [Topic] recording available
- Body: recording, key takeaways, resources, CTA
- Tone: understanding, still provide value

**Email 7: Newsletter inclusion**
- 2 to 3 sentences plus CTA, focused on why the topic matters and who should attend

**Email 8: SDR outreach template (T+1 day)**
- Subject: Following up on [Topic] webinar
- Body: reference their attendance, offer to discuss their use case, CTA for a call
- Tone: helpful and consultative, not salesy

Email automation checklist:
- [ ] All 8 emails drafted
- [ ] Emails loaded into the platform
- [ ] Automation triggers set up
- [ ] Segmentation configured
- [ ] Test emails sent and verified
- [ ] Calendar invites attached

Writing guidelines. Subject lines: clear and specific, under 50 characters, include the key detail, no spam triggers or clickbait. Body: start with value not a greeting, short paragraphs of 2 to 3 sentences, one clear CTA per email, personalization token for the name.

### 5. Social media posts

**LinkedIn:**
- Announcement (T-7 days): 150 to 200 words. Hook, problem, value, CTA. Include relevant hashtags.
- Reminder (T-1 day): 75 to 100 words. Tomorrow, key takeaway, CTA. Tag speakers and the customer.
- Post-event: full post with recording link.

Professional tone, focus on business value, tag speakers and companies, 3 to 5 relevant hashtags, ask an engagement question.

**Twitter:**
- Announcement thread (T-7 days), 5 to 7 tweets: hook and problem, what you will learn, speaker credentials, customer story teaser, registration CTA.
- Reminder (T-1 hour): single tweet, starting in 1 hour, join link, tag speakers.
- Post-event: tweet with recording link.

**Post-event across both:** share key insights as quotes or graphics, post the recording link, tag attendees who engaged.

Social checklist:
- [ ] LinkedIn announcement (T-7)
- [ ] LinkedIn reminder (T-1 day)
- [ ] Twitter announcement thread (T-7)
- [ ] Twitter reminder (T-1 hour)
- [ ] Posts scheduled
- [ ] Graphics received and added
- [ ] Speakers tagged
- [ ] Customer tagged if applicable

### 6. Paid advertising (if applicable)

**LinkedIn sponsored post:**
- Headline: [Topic], live technical webinar
- Body: problem plus solution in 2 to 3 sentences
- CTA: Register now
- Image: LinkedIn square graphic
- Targeting: job titles, company size, industries
- Video ad script and visual requirements if applicable

**Twitter promoted tweets:**
- 3 to 5 variations with different angles, under 280 characters each
- Lead with value, include image or video, clear CTA with link
- Promoted thread: 5 to 7 tweets

**Google search ads:**
- Headline 1: [Topic] technical webinar
- Headline 2: Live Q&A with engineers
- Headline 3: Free registration
- Description: learn [key benefit] and [key benefit]
- Target keywords, and multiple ad groups if needed

Ad campaign checklist:
- [ ] Ad copy approved
- [ ] Targeting parameters set
- [ ] Budget allocated
- [ ] Creative assets received
- [ ] Campaigns set up in platforms
- [ ] Tracking pixels installed
- [ ] Campaigns launched
- [ ] Daily monitoring started

### 7. Graphics requirements

| Asset | Dimensions | Elements needed |
|-------|------------|-----------------|
| Email header | 600px x 300px | Title, date, time, speaker headshots, branding |
| LinkedIn square | 1200px x 1200px | Title, date, time, logo |
| Twitter card | 1200px x 675px | Title, date, time, branding |
| Landing page hero | 1920px x 800px | Topic visual, clean design |
| Newsletter thumbnail | 400px x 300px | Compact, title visible |

Format: PNG or JPG.

### 8. Content and presentation

Slide deck outline, demo script, key talking points, resources to share, and a speaker preparation checklist.

**Opening (5 minutes):** brief speaker intro (credentials matter for technical audiences), clear agenda and takeaways, housekeeping on Q&A format and recording availability, set technical level expectations.

**Problem statement (5 to 10 minutes):** articulate the specific problem, use data or customer quotes to validate it, show what does not work with alternatives.

**Solution overview (10 to 15 minutes):** how your product solves the problem, technical architecture and approach, key capabilities, why this approach is better.

**Deep dive and demo (15 to 20 minutes):** live demo or detailed walkthrough, actual code and actual implementation, edge cases and gotchas, specific actionable guidance.

**Customer story (5 to 10 minutes, if applicable):** real company, real metrics, technical challenges, how they implemented, results and lessons learned.

**Q&A (15 to 20 minutes):** have backup questions prepared, do not dodge difficult questions, offer to follow up on complex ones.

**Closing (2 to 3 minutes):** recap takeaways, provide resources, clear CTA, thank you and contact information.

Content checklist:
- [ ] Slide deck drafted
- [ ] Demo environment built
- [ ] Code samples prepared
- [ ] Speaker talking points written
- [ ] Rehearsal completed
- [ ] Backup content prepared
- [ ] Resources list finalized

## Planning timeline

### 4 weeks before (T-28)

Content: finalize topic, title, and abstract. Confirm speakers and availability. Identify the customer story. Outline presentation structure. Define key takeaways and learning objectives.

Logistics: create the event on the platform, set up recording, block calendar holds for rehearsal, identify target audience segments.

### 3 weeks before (T-21)

Content: draft the slide deck, build and test the demo environment, create code samples, draft speaker talking points, prepare backup content for technical issues.

Marketing: brief design on graphics, draft landing page copy, draft all 8 emails, draft social posts, draft ad copy.

### 2 weeks before (T-14)

Assets: graphics completed, landing page live, email templates loaded, social posts scheduled, registration form tested.

Content prep: complete the slide deck, test all demos end to end, prepare Q&A seeding questions, create the attendee resource list, brief guest speakers or customers.

### 1 week before (T-7)

Rehearsal: full run-through with all speakers, test screen sharing and audio and video, time the presentation, identify rough spots, test backup plans.

Promotion launch: email targeted customer segments, social media announcement, newsletter inclusion if timing aligns, LinkedIn post from the company page and speakers, Twitter thread, post in Discord and Slack communities, personal outreach to key customers and prospects.

### Day before (T-1)

Technical check: test platform setup, verify all demos work, check internet connection, test audio and video quality, have a backup internet option ready.

Final prep: send reminder emails, review slides and talking points, prepare for Q&A, get good sleep.

### Day of (T-0)

One hour before: send the final reminder email, post the social reminder, log in and test everything again.

During: start 5 minutes early to greet early arrivals, record everything, monitor chat and questions, stay on time, end with a clear CTA.

Immediately after: save the recording, export Q&A and chat, thank speakers and guests, download attendee and no-show lists.

### Day after (T+1)

Follow-up: send the thank you email to attendees with the recording, send a different email to no-shows, upload the recording to YouTube, update the landing page with the on-demand video, post the recording on social.

Lead follow-up: segment attendees by ICP fit, brief the SDR team on qualified leads, provide the outreach template, share the attendee list with sales.

### Week after (T+7)

Repurposing: create a blog post summarizing key points, extract social clips, create timestamp chapters for YouTube, add to the content library and docs, update related documentation.

Analysis: review metrics, analyze Q&A themes, review feedback survey responses, document learnings, track pipeline impact from attendees.

## Metrics and success criteria

| Metric | Target | Actual |
|--------|--------|--------|
| Registrations | 200 to 500 depending on topic | |
| Show-up rate | 30 to 40% | |
| Qualified leads | | |
| Recording views (week 1) | | |

Also track: registration source and timeline curve, average attendance duration, peak concurrent attendees, drop-off points, questions asked, poll participation, sales opportunities created, pipeline influenced, resource downloads, social engagement, and documentation traffic increase.

## Target audience segmentation

### For targeting

**Primary audience:** senior developers and architects, engineering managers and directors, CTOs and VPs of engineering. Company size 25 to 500 employees. Teams using or evaluating competitor products.

**Secondary audience:** individual developers, founders and technical co-founders, DevOps and platform engineers, technical product managers.

**Exclusions:** non-technical marketing and sales only, students unless the webinar is aimed at them, very early stage companies with no product.

### For follow-up

**Tier 1, hot leads:** attended more than 50% of the webinar, asked questions, company size 25 to 500, title of director and above, architect, or senior engineer. Action: personal SDR outreach within 48 hours.

**Tier 2, warm leads:** registered but did not attend with high ICP fit, or attended less than 50%, or right company with a junior title. Action: email nurture sequence.

**Tier 3, nurture:** attended with low ICP fit, individual developers, students. Action: add to general nurture.

## Platform setup

### Webinar platform

Registration: custom questions covering company size, role and title, current platform, and specific challenges. Enable the waiting room, send automatic confirmations, integrate with the CRM for lead capture.

During the event: enable the Q&A panel, disable attendee chat or moderate it heavily, record in the cloud, enable polls, set up a practice session for speaker testing.

After: download the attendee list immediately, download the recording, export Q&A and polls, send follow-up emails.

### Recording and streaming tool

Quality: record local tracks, 1080p video minimum, separate audio tracks per speaker, enable backup recording.

Streaming: stream directly to YouTube or LinkedIn Live, or use RTMP to the webinar platform. Monitor stream health and keep a backup computer ready.

Post-production: download local recordings, edit out technical issues and dead air, add intro and outro cards, add captions, upload to YouTube with chapters.

## Best practices

### Content quality

Do: show actual code and real implementations, acknowledge what is hard or does not work well, provide working examples and repositories, answer questions thoroughly and honestly, share gotchas and lessons learned, make slides available afterward.

Do not: use marketing fluff or buzzwords, oversimplify complex topics, hide limitations or trade-offs, rush through demos, read slides verbatim, ignore difficult questions.

### Engagement

Before: send a pre-webinar survey for questions, share prep materials, build anticipation with content teasers, engage with registrants on social.

During: greet people as they join, use polls to gauge the audience, encourage questions throughout, call out interesting questions, keep energy high.

After: respond to unanswered questions by email, continue the conversation on social, create follow-up content addressing common questions, personally thank engaged attendees.

### Technical delivery

Demos: test everything three or more times before going live, have backup recordings if a demo fails, use large fonts and a clear screen, slow down because what is obvious to you is not to the audience, explain what you are doing at each step, show the end result first then build it.

Presentation: use visuals over text-heavy slides, include architecture diagrams, show before and after comparisons, use real metrics and data, keep slides simple and readable, have a dark mode option for code.

Q&A: assign someone to monitor questions, group similar questions, admit when you do not know something, offer to follow up offline, save controversial questions for the end, end with the best question.

## Content repurposing

From a single webinar, create:
- On-demand recording on YouTube and the landing page
- Blog post summarizing key points
- 3 to 5 social clips of 30 to 60 seconds each
- Twitter thread with key insights
- LinkedIn carousel with slides
- Documentation updates or new guides
- Email nurture content
- Sales enablement materials
- FAQ additions

Quality bar: all content should stand alone and be valuable without the webinar, optimize for SEO where applicable, include clear CTAs, link back to related resources, make it easy to share.

## Customer story template

When including customer stories:

**Company background:** industry and use case, team size and technical maturity, the problem they were solving.

**Before state:** what were they using, what was not working, metrics showing the pain.

**Decision process:** why they chose your product, what alternatives they considered, key decision factors.

**Implementation:** how they migrated or built, timeline and resources, technical challenges and solutions.

**After state:** current architecture, metrics showing improvement, business impact, what they would do differently.

**Lessons learned:** advice for similar companies, what surprised them, future plans.

## Resource checklist for attendees

- [ ] Link to recording
- [ ] Slide deck as PDF
- [ ] Code samples in a repository
- [ ] Relevant documentation
- [ ] Blog posts on the topic
- [ ] Related webinar recordings
- [ ] Migration guides if applicable
- [ ] Contact information for questions
- [ ] Community links
- [ ] Next webinar announcement

## Continuous improvement

After each webinar, review what went well technically, what content resonated most based on Q&A, where you lost people, which promotion channels drove registrations, what feedback you received, and how to improve next time.

Quarterly, review attendance trends, topics that performed best, lead quality and conversion, return versus effort, and the strategic adjustments needed.

## What not to do

Voice and banned-language rules live in the `writing` skill. Skill-specific rules:

- Do not use vague takeaways such as "learn best practices" or "discover insights"
- Do not write lengthy emails. Developers skim.
- Do not make promises you cannot keep
- Do not hide the topic behind hype
- Do not skip the execution checklist
- Do not start planning less than 4 weeks out
- Do not pick a topic that is too broad or too narrow
- Do not set an unrealistic demo scope
- Do not send generic messaging to an unsegmented list
- Do not schedule against major industry events
- Do not go over time or leave too little room for Q&A
- Do not delay the recording or skip the lead follow-up plan

## Inputs needed

Provide the following:
- Webinar topic and title
- Target date
- The problem this webinar solves
- Target audience: role, company size, technical level
- 3 to 5 key takeaways
- What will be demoed or shown
- Speaker names and titles
- Customer company if it is a customer story
- Related documentation or resources to link
- Whether paid promotion is planned

## Remember

The best technical webinars feel less like marketing and more like learning. Focus on teaching something genuinely useful. If attendees walk away with actionable knowledge, even if they never become customers, you have built trust and authority.

One excellent webinar with 100 engaged technical decision makers is worth more than a mediocre webinar with 1000 unqualified attendees.
