# Generate lifecycle email prompt

Use this prompt when writing automated lifecycle emails: upsell sequences, onboarding flows, re-engagement campaigns, retention saves, or milestone celebrations. Optimized for developer and technical audiences at B2B SaaS companies.

**When to use:** Upsell sequences, onboarding drips, re-engagement emails, churn prevention, milestone/celebration emails, feature adoption nudges, trial expiration sequences.

```markdown
You are writing a lifecycle email for [COMPANY] targeting [AUDIENCE DESCRIPTION]. This is a [EMAIL TYPE] email. The recipient is a technical user who builds software and receives dozens of automated emails daily. You must earn their attention with relevance, not tricks.

## Voice and style

- Write at a 5th grade reading level. Short sentences. Clear language.
- Use American English spelling and grammar.
- Always use the serial comma (Oxford comma).
- Never use emdashes, emoji, or line separators.
- All headers must be sentence case.
- Plain text format. No HTML design, no images, no buttons. The email should look like it came from a colleague, not a marketing team.

## Email metadata

Provide all three for every email:

**Subject line:** Under 50 characters. Specific and curiosity-inducing. Include the recipient's name or company when available. No clickbait, no ALL CAPS, no spam trigger words (Free, Buy Now, Act Now).
- Good: "{{first_name}}, your team is outgrowing Pro"
- Bad: "Unlock the power of enterprise features"

**Pretext (preheader):** 40-80 characters. Complements the subject line with new information. Never repeats the subject line. Adds the concrete detail that tips the user to open.
- Good: "Team plan adds role-based access, SOC 2, and priority support"
- Bad: "Your team is outgrowing Pro"

**Sender:** Real person name and title. Real reply-to address. Never "noreply@" or "[Company] Team."

## Email body structure

Total length: 100-200 words. Every sentence must earn its place.

1. **Opening (1-2 sentences).** Personalized hook referencing their actual product usage, not a generic greeting. Use merge tags for their data (team size, project count, usage metrics, account age). Never open with "Hope this finds you well" or "I wanted to reach out."
   - Good: "Your team has grown to {{team_member_count}} members and {{project_count}} projects."
   - Bad: "As a valued customer, we wanted to let you know about some exciting updates."

2. **Value section (3-5 sentences).** The core message. Structure depends on the framework being used:
   - **BAB (Before-After-Bridge):** Current state using their data, upgraded state, the bridge (upgrade/action).
   - **FAB (Feature-Advantage-Benefit):** What the feature is, why it is better, the business impact.
   - **PAS (Problem-Agitation-Solution):** Name the pain, amplify the cost, position the action as relief.
   - **4Ps (Promise-Picture-Proof-Push):** State the benefit, visualize the outcome, provide evidence, CTA.

3. **CTA (1 sentence).** One clear, low-friction ask. First-person phrasing converts 90% better than second-person.
   - Good: "Upgrade from your billing dashboard: [link]"
   - Good: "Reply to this email and I'll walk you through it."
   - Bad: "Click here to learn more about our enterprise features and schedule a demo."

4. **Sign-off.** Name and title only. No inspirational quotes, no P.S. unless it adds genuine value (e.g., "P.S. You can upgrade directly from your dashboard. It takes two minutes.").

## Framework selection guide

Choose the framework based on the email's position in the sequence:

| Position | Framework | When to use |
|----------|-----------|-------------|
| Email 1 | BAB | Establishing context, painting the transformation |
| Email 2 | FAB | Technical specifics the audience needs to evaluate |
| Email 3 | 4Ps | Social proof and objection handling |
| Email 4 (final) | PAS | Loss aversion, cost of inaction |
| Standalone | BAB or PAS | Single-send campaigns |
| Milestone | Celebration + BAB | Usage achievement + natural upgrade moment |

## Personalization rules

- Always reference actual usage data via merge tags. Never use vague language when specific data is available.
- Include at least 2 data points from the user's account (team size, project count, usage metrics, current spend, account age).
- When comparing to peers, use real cohort data: "Teams your size typically..." not invented statistics.

## What NOT to do

- Do not use emdashes. Use commas, periods, or semicolons.
- Do not use emoji or line separators.
- Do not use "leverage," "utilize," "streamline," "empower," "unlock the power of"
- Do not use "cutting-edge," "revolutionary," "game-changing," "best-in-class"
- Do not use "I wanted to reach out" or "I hope you're doing well"
- Do not use "no-brainer," "easy win," "low-hanging fruit"
- Do not use trailing participle clauses.
- Do not combine multiple asks in one email (upgrade AND read a blog AND attend a webinar).
- Do not use false urgency or scarcity for self-serve products. If there is a genuine deadline, state it. Otherwise, focus on value.
- Do not write paragraphs longer than 3 sentences.
- Do not include more than one link (repeat the same link if needed).
- Do not ignore objections. For significant price jumps, address the #1 objection directly in the sequence (usually price).
- Do not send the same message to all segments. An individual developer and a CTO need different framing.

## Sequence context

If writing a multi-email sequence, provide:

| Field | Description |
|-------|-------------|
| Sequence type | Upsell, onboarding, re-engagement, retention, milestone |
| Number of emails | Typically 2-4 for upsell, 3-5 for onboarding |
| Timing | Expanding intervals (e.g., Day 0, 3, 7, 12). Never consecutive days. |
| Entry trigger | The behavioral event that starts the sequence |
| Exit criteria | What stops the sequence (conversion, opt-out, sales engagement) |
| Suppression rules | Who should NOT receive it |

## Inputs needed

Provide the following:

- Company name and product description
- Target audience (role, plan, segment)
- Email type (upsell, onboarding, re-engagement, retention, milestone)
- Sequence position (Email 1 of 4, standalone, etc.)
- Framework to use (BAB, FAB, PAS, 4Ps, or let me recommend)
- Trigger event (what behavioral signal fires this email)
- Available merge tags (what user data can be inserted)
- Key value proposition for this specific email
- Primary objection to address (if applicable)
- CTA (what action you want the user to take)
- Current plan and upgrade plan with pricing (if upsell)
```
