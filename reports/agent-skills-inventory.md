# Agent skills inventory

Generated 2026-08-04T23:33:03+01:00 by `scripts/validate-agent-skills.py`.
Do not edit by hand. Regenerate instead.

## Sources

| Source | Path | Skills | Anomalies |
| --- | --- | --- | --- |
| dotfiles | `/Users/prashant/Developer/dotfiles/claude/skills` | 82 | 1 |
| brain | `/Users/prashant/Developer/brain/.claude/skills` | 27 | 1 |

## Totals

- 109 skills across 109 unique names
- 90 pass, 19 warn, 0 fail
- 0 duplicate names, 0 unresolved conflicts
- 2 anomalies in the source directories

## Skills

| Skill | Source | Description | Status | Claude-specific features | Codex concerns | Duplicate / conflict |
| --- | --- | --- | --- | --- | --- | --- |
| `ad-spend-allocator` | dotfiles | Optimize budget allocation across paid media channels using Marketing Efficiency Ratio (MER), marginal ROAS analysis, diminishing returns modeling, and increme… | pass | none | none | unique |
| `ai-search-visibility-aeo-geo-llmo` | dotfiles | AI search and citation behavior change quickly. The frameworks below use the best available public data as of early 2026 (Google surfaces, ChatGPT, Perplexity,… | pass | none | none | unique |
| `animation-vocabulary` | dotfiles | Reverse-lookup glossary that turns a vague description of a web animation or motion effect into its exact term ("the bouncy thing when a popover opens" → Pop i… | pass | none | none | unique |
| `apple-design` | dotfiles | Apple's approach to interface design and fluid, physical motion, translated for the web. Use when building or reviewing gesture-driven UI, spring animations, d… | pass | none | none | unique |
| `bar-raiser` | brain | Evaluates candidates against Supabase's Bar Raiser framework using an interview transcript and interviewer notes. Produces a hire or no-hire feedback document… | pass | user-invocable | none | unique |
| `blog-post-ideation` | dotfiles | Generates data-driven blog post ideas for developer products based on market research and community insights. Use when planning content calendars, identifying… | pass | user-invocable | none | unique |
| `bofu-seo-aeo-strategy` | dotfiles | Plan, write, and maintain content that wins purchase-near buyers in both organic search and AI answer engines. BOFU content is structurally different from TOFU… | pass | none | none | unique |
| `campaign-analyzer` | dotfiles | Analyze paid media performance across dimensions, funnels, cohorts, and channels — turning data into actionable insights and business narratives. | pass | none | none | unique |
| `case-study` | brain | Create customer case studies that demonstrate product value through real success stories. The customer is the hero. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `channel-copple` | brain | Rewrite or edit content in the voice of Paul Copplestone (Supabase CEO, "Copple"). Trigger on "channel Copple", "make this sound like Copple", "edit this the w… | pass | none | none | unique |
| `cmo-coaching` | brain | Generate a CMO coaching report grading executive presence, judgment, and leadership awareness. Surveys Slack, Linear, and Notion, then saves to personal Notion. | pass | user-invocable | none | unique |
| `competitive-analysis` | dotfiles | Conducts competitive analysis and creates battle cards for technical products. Covers competitor identification, public research, product teardowns, go-to-mark… | pass | user-invocable | none | unique |
| `competitive-battlecard` | dotfiles | Generates comprehensive competitive battlecards for developer products that help sales and marketing teams position against specific competitors. Covers compan… | pass | user-invocable | none | unique |
| `content-strategy` | dotfiles | Creates content marketing strategies for technical products. Covers content pillars, editorial calendars, content briefs, inside-out vs outside-in approaches,… | pass | user-invocable | none | unique |
| `daily-meta-checkin` | brain | Pull the live Midnight Coders Meta ad numbers, cross-check them against Stripe and PostHog, and return a bottom line plus a numbered list of what to do next. | pass | user-invocable | none | unique |
| `data-storytelling` | dotfiles | Transform data into compelling narratives using visualization, context, and persuasive structure. Use when presenting analytics to stakeholders, creating data… | pass | none | none | unique |
| `data-visualization` | dotfiles | Create effective data visualizations with Python (matplotlib, seaborn, plotly). Use when building charts, choosing the right chart type for a dataset, creating… | pass | user-invocable | none | unique |
| `deploy-to-vercel` | dotfiles | Deploy applications and websites to Vercel. Use when the user requests deployment actions like "deploy my app", "deploy and give me the link", "push this live"… | pass | none | none | unique |
| `developer-persona` | brain | Create detailed developer persona profiles that are specific, realistic, and actionable for targeting decisions. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `emil-design-eng` | dotfiles | This skill encodes Emil Kowalski's philosophy on UI polish, component design, animation decisions, and the invisible details that make software feel great. | pass | none | none | unique |
| `event-brief` | brain | Plan and execute conference or event participation with clear objectives, staffing, messaging, and success criteria. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `fiction-devedit` | brain | Generate a comprehensive developmental editorial letter for a fiction manuscript, written as though by a senior developmental editor at Penguin Books. Locates… | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `fiction-diagnostic` | brain | Diagnose a fiction manuscript for the developmental and line-level problems an editor would catch, but at draft stage. Covers POV control and head-hopping, tel… | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `fiction-editing` | brain | Turn editorial feedback into a SUGGESTED-EDITS.md of concrete, in-voice rewrites for a fiction manuscript. Locates the manuscript and the feedback, maps each a… | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `finance-copy-trading` | dotfiles | Tracks congressional stock disclosures on Capitol Trades and hedge fund 13F filings. Identifies highest-conviction active traders, sizes and times positions th… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-earnings-catalyst` | dotfiles | Complete earnings trade playbook. Pre-earnings setup, implied move analysis, strategy selection based on IV rank, execution, and post-earnings management. Comp… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-iron-condor` | dotfiles | Generates consistent income with defined-risk options spreads. Iron condors for range-bound markets, put credit spreads for bullish bias, call credit spreads f… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-iv-rank` | dotfiles | Pre-trade volatility filter for all options trades. Calculates IV rank, IV percentile, term structure, and skew to determine whether to buy or sell premium. Ru… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-macro-regime` | dotfiles | Macro checklist before any new position. Analyzes rate environment, dollar direction, market breadth, sector rotation, and VIX to classify the regime as risk-o… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-master` | dotfiles | Foundation trading system prompt. Sets up Alpaca paper trading connection, standing risk rules, position sizing, trade execution workflow, and monitoring conve… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-momentum-breakout` | dotfiles | Identifies and executes high-probability breakout setups using a five-condition checklist (trend, consolidation, volume dry-up, resistance, volume surge). Tier… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-options-flow` | dotfiles | Reads the options tape like an institutional desk. Identifies unusual options activity, dark pool prints, gamma squeeze setups, and put/call ratios. Classifies… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-pre-market-prep` | dotfiles | Runs a structured morning briefing every trading day at 09:00 ET. Covers overnight futures, economic calendar, key levels on open positions, sector movers, and… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-risk-of-ruin` | dotfiles | Calculates probability of account blowup given win rate, win/loss ratio, and position sizing. Uses Kelly criterion for optimal sizing. Monthly review of tradin… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-short-squeeze` | dotfiles | Screens stocks for short squeeze potential before a squeeze happens. Scores candidates 0-7 on short interest, days to cover, borrow cost, float size, OTM call… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-trade-journal` | dotfiles | Structured logging of every trade -- thesis, entry, emotion state, outcome, and lessons. Weekly performance review every Friday at 15:30 ET identifies losing p… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-trailing-stop` | dotfiles | Buys a position, sets a hard stop loss floor, and runs a ratcheting trailing stop that locks in gains as the price climbs. Includes optional ladder-in logic to… | pass | disable-model-invocation, user-invocable | none | unique |
| `finance-wheel` | dotfiles | Runs the full three-phase options income cycle -- sell cash-secured puts, take assignment if necessary, sell covered calls. Picks strikes, monitors positions,… | pass | disable-model-invocation, user-invocable | none | unique |
| `find-animation-opportunities` | dotfiles | Search a codebase or UI for places that don't animate but should, and reject everything that shouldn't. Read-only; it proposes motion with exact values, it doe… | pass | none | none | unique |
| `find-skills` | dotfiles | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express in… | pass | none | none | unique |
| `generate-ranking-video` | dotfiles | Create viral ranking countdown videos in PolarRanks style. Overlays ranked lists on background video clips. Works for any topic -- books, people, places, movie… | pass | user-invocable | none | unique |
| `go-to-market` | brain | Create structured launch plans with measurable objectives. Scales by launch tier from major to minor. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `google-ads-account-audit` | dotfiles | Systematic 70+ checkpoint audit covering tracking, structure, keywords, ads, bidding, budgets, audiences, and competitive positioning — with ICE-prioritized re… | pass | none | none | unique |
| `google-ads-campaign-builder` | dotfiles | Build and configure Google Ads campaigns across all 10+ campaign types — from campaign type selection through settings, targeting, creatives, and launch. | pass | none | none | unique |
| `google-ads-keyword-engine` | dotfiles | Research, evaluate, mine, and manage keywords for Google Ads — from initial discovery through ongoing search term optimization and negative keyword management. | pass | none | none | unique |
| `google-ads-optimizer` | dotfiles | Optimize running Google Ads campaigns — bid strategy tuning, budget reallocation, Quality Score improvement, ad copy iteration, audience refinement, placement… | pass | none | none | unique |
| `google-ads-scripts` | dotfiles | Select, implement, and manage Google Ads scripts to automate PPC tasks at scale — n-gram analysis, bid management, budget pacing, anomaly detection, and perfor… | pass | none | none | unique |
| `google-merchant-center` | dotfiles | Optimize product feeds for Shopping and Performance Max campaigns — from fixing disapprovals to building custom label strategies that power profitability-based… | pass | none | none | unique |
| `gtm-strategy` | dotfiles | Develops go-to-market strategies for technical products. Covers product-led growth (PLG), sales-led growth (SLG), open-source models, and hybrid approaches. Us… | pass | user-invocable | none | unique |
| `humanize` | dotfiles | Remove signs of AI-generated writing from text. Use when editing or reviewing text to make it sound more natural and human-written. Based on Wikipedia's compre… | pass | allowed-tools, user-invocable | none | unique |
| `impeccable` | dotfiles | Use when the user wants to design, redesign, shape, critique, audit, polish, clarify, distill, harden, optimize, adapt, animate, colorize, extract, or otherwis… | pass | none | none | unique |
| `improve-animations` | dotfiles | Survey a codebase's animation and motion code as a senior motion advisor, then produce a prioritized audit and self-contained implementation plans for other ag… | pass | none | none | unique |
| `ios-deployment` | dotfiles | Ship an iOS app from the command line without opening Xcode. Covers archive, IPA export, App Store Connect API authentication, TestFlight upload (debug builds)… | pass | none | none | unique |
| `launch` | dotfiles | Plans and executes product launches for technical products. Covers launch tiers, sine wave timing, naming conventions, pre-launch preparation, launch day execu… | pass | user-invocable | none | unique |
| `lifecycle-email` | brain | Write automated lifecycle emails: upsell, onboarding, re-engagement, retention, and milestone sequences for technical audiences. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `lifecycle-marketing` | dotfiles | Designs lifecycle marketing programs for technical products across email, in-app, and social channels. Covers behavioral triggers, sequence design, upsell/rete… | pass | user-invocable | none | unique |
| `link-building-digital-pr` | dotfiles | Build backlinks, earned media, and brand mentions that move both traditional rankings and AI visibility. The dominant modern tactic is digital PR anchored to o… | pass | none | none | unique |
| `local-seo-google-business-profile` | dotfiles | Help local and service-area businesses win the map pack, organic local results, and — increasingly — local answers in AI tools. Local search has its own rules:… | pass | none | none | unique |
| `macos-deployment` | dotfiles | Ship a macOS app from the command line without opening Xcode. Covers debug builds, Developer ID signing, notarization, DMG packaging, Sparkle auto-updates, and… | warn (0E/2W) | none | none | unique |
| `meta-ads-account-audit` | dotfiles | Systematic 75+ checkpoint audit based on the Sam Tomlinson framework: ICP validation → signal infrastructure → account structure → audiences → creatives → meas… | pass | none | none | unique |
| `meta-ads-campaign-builder` | dotfiles | Build and configure Meta Ads campaigns across all ODAX objectives — from objective selection through audience strategy, placement, budget, and creative launch. | pass | none | none | unique |
| `meta-ads-creative-engine` | dotfiles | Build a systematic creative testing, production, and rotation pipeline for Meta Ads — prevent fatigue, scale winners, and maintain performance through structur… | pass | none | none | unique |
| `meta-ads-optimizer` | dotfiles | Optimize running Meta Ads campaigns — audience refinement, budget scaling, learning phase management, placement optimization, automation rules, and creative ro… | pass | none | none | unique |
| `meta-ads-playbook` | dotfiles | Meta ads planning playbook: objectives, structure, audiences, creative, testing cadence, Pixel/CAPI measurement. Does not assume live Marketing API access. | pass | none | none | unique |
| `meta-ads-tracking-setup` | dotfiles | Implement and validate Meta Pixel + Conversions API (CAPI) for maximum signal quality — the single biggest lever for Meta Ads performance via the Andromeda ran… | pass | none | none | unique |
| `midnight-coders` | brain | Find influencers, book reviewers, and content creators for The Midnight Coder's Children. Creates a Notion page with leads and suggested outreach. | pass | user-invocable | none | unique |
| `no-use-effect` | dotfiles | Enforce the no-useEffect rule when writing or reviewing React code. ACTIVATE when writing React components, refactoring existing useEffect calls, reviewing PRs… | pass | user-invocable | none | unique |
| `on-page-seo-aeo-optimization` | dotfiles | Turn a draft or existing page into something both Google *and* AI answer engines can index, rank, and cite. This skill operates at the single-page level — keyw… | pass | none | none | unique |
| `paid-media-reporter` | dotfiles | Build performance reports, dashboards, and stakeholder communications that turn ad data into business narratives — client reports, QBRs, audit deliverables, an… | pass | none | none | unique |
| `paid-search-ads-playbook` | dotfiles | Google and Microsoft paid search planning: structure, keywords, match types, negatives, RSAs, bidding lens, and landing-page alignment for conversion-focused s… | pass | none | none | unique |
| `portugal-nationality` | brain | Monitor Portuguese nationality law (Lei da Nacionalidade) for legislative, constitutional, and presidential actions. Creates a Notion page with findings if new… | pass | user-invocable | none | unique |
| `positioning-framework` | brain | Define product positioning in the competitive landscape with messaging pillars using Aristotle's rhetorical framework. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `prepare-videos-for-social` | brain | Edit a talking-head recording down to its good takes and burn TikTok/Reels-style captions on it, matching the Midnight Coder's Children video series. Cuts fals… | warn (0E/1W) | none | none | unique |
| `prepare-viral-short` | dotfiles | End-to-end workflow for creating viral AI YouTube shorts. Covers niche selection, channel setup, content creation methods, and analytics optimization. | pass | user-invocable | none | unique |
| `prfaq` | brain | Write or review an Amazon-style PRFAQ that rallies a team around the customer's problem before a line of code gets written. Drafts the mock press release plus… | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `product-detail-page` | brain | Write copy for product landing pages, feature pages, and capability overviews for developer audiences. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `product-launch-blog` | brain | Write product launch blog posts that lead with the announcement and balance excitement with technical substance. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `product-naming` | brain | Run a naming exercise for an initiative, product, or feature. Decides whether the thing should be branded or described, runs the three-round process from Picks… | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `prompt-picker` | dotfiles | Build a prompt library that reveals how a brand shows up across the full buyer journey in AI search systems. The library is designed for actual LLM visibility… | pass | none | none | unique |
| `remotion-best-practices` | dotfiles | Best practices for Remotion - Video creation in React | warn (0E/1W) | none | none | unique |
| `remotion-video` | brain | Build videos with Remotion. Covers timing architecture, animation patterns, component structure, and styling guidelines. | pass | user-invocable | none | unique |
| `review-animations` | dotfiles | Reviews animation and motion code against a high craft bar derived from Emil Kowalski's design engineering philosophy. Default to flagging; approval is earned. | pass | disable-model-invocation | none | unique |
| `sales-email` | brain | Write concise, relevant sales emails: cold outreach, warm follow-ups, event follow-ups, and nurture campaigns. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `search-reddit` | brain | Find Reddit discussions where Prashant can add value by sharing Strategic Nerds blog posts. Requires human-driven Playwright browsing. | pass | user-invocable | none | unique |
| `seo-aeo-content-strategy` | dotfiles | Design content systems that earn both Google rankings *and* AI citations. The core insight: AI answer engines read content differently than humans — they extra… | pass | none | none | unique |
| `seo-keyword-research-intent-mapping` | dotfiles | Build a keyword universe that reflects how both humans *and* AI answer engines search. Traditional keyword research looks at standalone terms; modern research… | pass | none | none | unique |
| `seo-max-kt` | dotfiles | Long-form SEO and AEO methodology bundle; read SEO_AND_AEO_KT.md for the full corpus. | pass | none | none | unique |
| `seo-reporting-measurement` | dotfiles | Build reports that stakeholders trust, rooted in data sources that are actually reliable. Modern SEO measurement has to reckon with a very specific constraint:… | pass | none | none | unique |
| `source-command-new-blog` | dotfiles | Research and create data-driven blog posts using Picks and Shovels methodology | pass | none | none | unique |
| `source-command-verify-supabase` | dotfiles | Comprehensive Supabase security and best practices verification | warn (0E/1W) | none | none | unique |
| `strategic-nerds` | brain | Find 3-5 online discussions where Prashant can add value by sharing Strategic Nerds blog posts. Creates a Notion page with opportunities and suggested replies. | pass | user-invocable | none | unique |
| `stripe-best-practices` | dotfiles | Guides Stripe integration decisions across API selection (Checkout Sessions vs PaymentIntents), Connect platform setup (Accounts v2, controller properties), bi… | pass | none | none | unique |
| `stripe-directory` | dotfiles | Use when the user wants to find businesses, software, service providers, or partners for a specific industry, workflow, pain point, capability, or job to be do… | pass | allowed-tools | none | unique |
| `stripe-docs` | dotfiles | Use when the user or agent needs to read, search, or look up Stripe documentation or API reference. Prefer this over curl or WebFetch for any docs.stripe.com c… | pass | allowed-tools | none | unique |
| `stripe-projects` | dotfiles | Use when the user wants to provision infrastructure or third-party services using Stripe Projects. Triggers: "I need a database", "set up auth", "add caching",… | pass | allowed-tools | none | unique |
| `supabase` | dotfiles | Use when doing ANY task involving Supabase. Triggers: Supabase products (Database, Auth, Edge Functions, Realtime, Storage, Vectors, Cron, Queues); client libr… | pass | none | none | unique |
| `supabase-postgres-best-practices` | dotfiles | Postgres performance optimization and best practices from Supabase. Use this skill when writing, reviewing, or optimizing Postgres queries, schema designs, or… | pass | none | none | unique |
| `tech-debt-audit` | dotfiles | Thorough, user-invoked tech debt and architecture audit of the current codebase. Produces TECH_DEBT_AUDIT.md with file-cited findings, severity, effort estimat… | pass | disable-model-invocation | none | unique |
| `technical-seo-ai-crawler-audit` | dotfiles | Diagnose and prioritize the technical issues blocking a site from being crawled, indexed, ranked, and cited. Modern technical SEO has two audiences: Google's c… | pass | none | none | unique |
| `thought-leadership-blog` | brain | Write thought leadership blog posts establishing company perspective on industry trends and technical philosophy. | warn (0E/1W) | user-invocable | SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked | unique |
| `upgrade-stripe` | dotfiles | Guide for upgrading Stripe API versions and SDKs | pass | none | none | unique |
| `vercel-composition-patterns` | dotfiles | React composition patterns that scale. Use when refactoring components with boolean prop proliferation, building flexible component libraries, or designing reu… | pass | none | none | unique |
| `vercel-react-best-practices` | dotfiles | React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.js… | pass | none | none | unique |
| `vercel-react-native-skills` | dotfiles | React Native and Expo best practices for building performant mobile apps. Use when building React Native components, optimizing list performance, implementing… | pass | none | none | unique |
| `voice-of-supabase` | brain | Write a Supabase product release blog post in the house voice. Trigger any time the artifact is a public technical writeup about something Supabase is shipping… | pass | none | none | unique |
| `web-design-guidelines` | dotfiles | Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site… | pass | none | none | unique |
| `webinar-planning` | dotfiles | Plans and executes technical webinars for developer audiences, and generates the complete asset package. Covers content structure, planning timelines, landing… | pass | user-invocable | none | unique |
| `weekly-report` | brain | Generate a weekly status report from Linear, Slack, and Notion, dedup against prior reports, and save it to the work Notion database. | pass | user-invocable | none | unique |
| `writing` | dotfiles | Comprehensive voice guide for all writing contexts. Covers fiction voice, non-fiction voice, banned words/phrases, BAD/GOOD examples, and tone calibration. Use… | pass | user-invocable | none | unique |

## Anomalies

| Source | Entry | Kind | Detail |
| --- | --- | --- | --- |
| dotfiles | `i-have-adhd` | no-skill-file | directory contains neither SKILL.md nor skill.md |
| brain | `_shared` | no-skill-file | directory contains neither SKILL.md nor skill.md |

## Findings

### `case-study` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `developer-persona` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `event-brief` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `fiction-devedit` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `fiction-diagnostic` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `fiction-editing` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `go-to-market` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `lifecycle-email` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `macos-deployment` (dotfiles)

- **warn** `absolute-path` sparkle-setup.md:72 contains a system absolute path '/tmp/sparkle-private.pem'
  - Smallest fix: Use a path relative to the skill directory, or describe the location instead of hardcoding it.
- **warn** `absolute-path` troubleshooting.md:64 contains a system absolute path '/tmp/sparkle-private.pem'
  - Smallest fix: Use a path relative to the skill directory, or describe the location instead of hardcoding it.

### `positioning-framework` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `prepare-videos-for-social` (brain)

- **warn** `absolute-path` SKILL.md:23 contains a system absolute path '/private/tmp/prepare-video'
  - Smallest fix: Use a path relative to the skill directory, or describe the location instead of hardcoding it.

### `prfaq` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `product-detail-page` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `product-launch-blog` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `product-naming` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `remotion-best-practices` (dotfiles)

- **warn** `reference-missing-extension` rules/voiceover.md: link './calculate-metadata' resolves only once '.md' is appended; on disk the link is dead
  - Smallest fix: Write it as './calculate-metadata.md'.

### `sales-email` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

### `source-command-verify-supabase` (dotfiles)

- **warn** `absolute-path` SKILL.md:240 contains a system absolute path '/tmp/current-types.ts'
  - Smallest fix: Use a path relative to the skill directory, or describe the location instead of hardcoding it.

### `thought-leadership-blog` (brain)

- **warn** `reference-escapes-skill` SKILL.md: link '../_shared/voice.md' resolves outside the skill directory to /Users/prashant/Developer/brain/.claude/skills/_shared/voice.md; it does not follow the skill when symlinked
  - Smallest fix: sync-agent-skills.sh links the shared '_shared/' directory into both targets so this path still resolves. To make the skill self-contained, inline the shared content or copy it into the skill.

