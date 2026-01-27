---
name: gtm-strategy
description: Develops go-to-market strategies for technical products. Covers product-led growth (PLG), sales-led growth (SLG), open-source models, and hybrid approaches. Use when planning acquisition models, designing PLG funnels, building sales motions, or combining bottom-up and top-down strategies.
metadata:
  author: prashant-sridharan
  version: "1.0"
  source: "Picks and Shovels by Prashant Sridharan"
---

# Go-to-market strategy

This skill helps develop go-to-market strategies for technical products based on the methodology from "Picks and Shovels."

## Core principle

Dogmatic thinking has no place in GTM strategy. The goal is to find customers, get them to pay, and grow the business. PLG, SLG, and hybrid approaches are tools, not religions.

---

## GTM model overview

### Product-led growth (PLG)

Bottom-up user acquisition through self-service.

**Characteristics:**
- Users sign up and try without talking to sales
- Product drives conversion
- Low customer acquisition cost (CAC)
- Credit card purchases
- High volume, lower average contract value (ACV)

### Sales-led growth (SLG)

Top-down acquisition through sales engagement.

**Characteristics:**
- Sales team actively engages prospects
- Relationship-driven process
- Higher CAC, higher ACV
- Custom contracts and procurement
- Enterprise focus

### Hybrid approach

Combining PLG and SLG strategically.

**Characteristics:**
- PLG for awareness and initial adoption
- SLG for enterprise expansion
- Product signals inform sales outreach
- Land-and-expand motion

### Open-source and community-led

Acquisition through open-source adoption.

**Characteristics:**
- Free software builds community
- Commercial offerings on top (hosted, enterprise features, support)
- Community becomes competitive advantage
- Long adoption cycles

---

## When PLG makes sense

PLG works best when:

1. **Clear, quick value**: Users can experience value in minutes, not days
2. **Broad audience**: Many developers have the problem you solve
3. **Low complexity**: Minimal setup and configuration required
4. **Self-service purchase**: Credit card transactions work for your ACV
5. **Product can sell itself**: Good DX drives adoption

### PLG example: Supabase model

- Target: Any web/app developer wanting a Firebase alternative
- Audience: Very broad (hobbyists to enterprise departments)
- Value: Get started in a weekend
- Motion: Self-service signup, credit card purchase
- Sales: Identifies high-potential accounts from product usage

### When PLG struggles

- Complex products requiring significant setup
- Narrow target audience
- High ACVs requiring procurement
- Products that need organizational buy-in to evaluate
- Long time-to-value

---

## When SLG makes sense

SLG works best when:

1. **Complex evaluation**: Multiple stakeholders involved
2. **High ACV**: Deals justify sales involvement
3. **Enterprise requirements**: Security, compliance, legal review
4. **Customization needed**: Integration, configuration, professional services
5. **Relationship value**: Trust and support matter in the decision

### SLG example: Timescale model

- Target: Developers with massive data at scale
- Audience: More narrow (enterprise, scale-ups)
- Value: Requires data ingestion and query optimization
- Motion: Sales-assisted evaluation
- ACV: Higher, justifying sales involvement

---

## The PLG funnel

### Funnel stages

1. **Awareness**: How people discover you
2. **Signup**: Converting visitors to registered users
3. **Activation**: Users reach the "aha moment"
4. **Conversion**: Users start paying
5. **Expansion**: Usage grows within accounts

### Key metrics to track

| Stage | Metrics |
|-------|---------|
| Awareness | Website traffic by source |
| Signup | Visitor-to-signup rate |
| Activation | Signup-to-activated rate, time to activate |
| Conversion | Activated-to-paid rate |
| Expansion | Net revenue retention, seat growth |

### PLG team composition

Cross-functional team required:

- **Product/Engineering**: PLG experiments, product features
- **Data science**: Metrics, signals, analysis
- **Developer growth**: Acquisition channels, content
- **Customer success**: Onboarding, adoption
- **Sales**: Enterprise accounts from PLG signals

---

## PLG activation signals

Define what "activation" means for your product:

**Example activation actions:**
- Completing onboarding tutorial
- Using a core feature (running a query, deploying an app)
- Achieving a measurable outcome (uploading data, sending a message)
- Inviting teammates

### Signals to analyze

- Drop-off points in onboarding
- Time to complete activation steps
- Behavior differences between activated and non-activated users
- Multi-user signals (same domain, multiple signups)

---

## PLG to SLG handoff

Not all accounts should stay in PLG:

### ACV vs CAC calculation

| Account type | Approach |
|-------------|----------|
| Low ACV | PLG only (self-service) |
| High ACV | Route to SLG (sales engagement) |

### Hybrid signup flow

Instead of "Try free" and "Request demo":

1. Single CTA: "Get started"
2. Qualify at signup (company size, role, use case)
3. Route automatically:
   - Small accounts → self-service PLG
   - Large accounts → demo request / sales contact

### Product-led sales (PLS)

Using product signals to trigger sales engagement:

**Signals that indicate sales readiness:**
- Multiple users from same domain
- Heavy usage patterns
- Enterprise features accessed
- Upgrade attempts blocked by plan limits

---

## Sales-led growth strategy

### What product marketing provides for SLG

- Case studies with proof points
- First-meeting decks
- Battle cards for competitive situations
- Demo environments
- ROI calculators
- Technical deep dives

### Enterprise buyer considerations

SLG messaging must address:

- Budget and ROI
- Integration with existing stack
- Scalability and reliability
- Security and compliance
- Vendor stability
- Support and SLAs

### Sales process stages

1. **Discovery**: Understand the problem and requirements
2. **Demo**: Show how you solve their problem
3. **Technical evaluation**: Proof of concept, pilot
4. **Business case**: ROI, stakeholder alignment
5. **Procurement**: Legal, security, contracts
6. **Close**: Final negotiation and signature

---

## Open-source GTM models

### Hosted model

Open-source software free to run yourself; company offers paid hosted version.

**Economics:**
- Low barrier to adoption
- Self-hosters may never pay
- Hosted version provides convenience value
- Upsell on features, scale, support

### Open core model

Core functionality is open-source; premium features are commercial.

**Economics:**
- Community builds around open core
- Enterprise features drive revenue
- Careful balance: core must be valuable, enterprise must be compelling

### Paid services model

Open-source is free; revenue from support, training, integration.

**Economics:**
- Lower margin than product revenue
- Requires significant adoption to generate services demand
- Less common in modern cloud era

### Cloud protection

Use licensing (like Timescale's Cloud Protection License) to prevent hyperscalers from hosting your open-source project competitively.

---

## Converting open-source users

Open-source users often provide no contact information.

### Gathering contact information

- Changelog newsletters (opt-in for updates)
- Community Slack/Discord with email registration
- GitHub discussions with notification preferences
- Gated premium content (enterprise docs, benchmarks)

### Outreach approach

**Do not lead with sales.**

First contact should be:
- Checking in on usage
- Getting feedback
- Understanding what they're building
- Technical conversation

**Then:** Identify if commercial product solves a real pain point.

---

## Hybrid GTM strategy

Combining PLG and SLG strategically:

### Land and expand

1. Individual developer signs up (PLG)
2. Usage grows within team
3. Identify expansion opportunity
4. Sales engages for enterprise deal (SLG)

### Consistent positioning

- Core value proposition stays the same
- Messaging adapts for audience
- PLG content supports SLG conversations
- Seamless experience across motions

### Practical tactics

- **Don't let enterprise accounts into pure PLG**: Route them to sales early
- **Identify high-potential accounts through product**: Multi-user signals, usage patterns
- **Create hand-raiser paths**: Easy ways to request sales engagement
- **Build champions**: Turn initial PLG users into internal advocates

---

## GTM metrics dashboard

### Awareness

- Website traffic by source
- Content performance
- Brand mentions
- Share of voice

### Acquisition

- Signups (total, by segment)
- Demo requests
- Qualified leads
- Cost per lead by channel

### Activation

- Activation rate
- Time to value
- Onboarding completion
- Feature adoption

### Revenue

- Conversion rate (PLG)
- Win rate (SLG)
- Average contract value
- Customer acquisition cost

### Expansion

- Net revenue retention
- Expansion revenue
- Upsell/cross-sell rate
- Seat growth

---

## GTM strategy checklist

Before launching your GTM motion:

- [ ] Defined target customer segments
- [ ] Chosen primary GTM motion (PLG, SLG, hybrid)
- [ ] Validated product-market fit signals
- [ ] Built necessary PLG infrastructure (if applicable)
- [ ] Created sales materials (if SLG)
- [ ] Established metrics and tracking
- [ ] Aligned cross-functional team
- [ ] Defined activation criteria
- [ ] Created handoff processes (PLG to SLG)
- [ ] Set pricing and packaging
- [ ] Prepared for enterprise requirements

---

## Common GTM mistakes

1. **Dogmatic PLG**: Forcing PLG when product/market doesn't fit
2. **Ignoring product**: PLG without product investment fails
3. **PLG without measurement**: No visibility into funnel performance
4. **Separate PLG and SLG**: They should reinforce each other
5. **Enterprise customers in pure PLG**: They need different treatment
6. **Open-source sales outreach**: Leading with sales alienates community
7. **No qualification**: Treating all leads the same wastes resources
8. **Unclear activation**: Not defining or measuring the "aha moment"
