Audit and implement comprehensive technical SEO and AI Engine Optimization (AEO) for this site. Check what exists and fix any gaps.

## Technical SEO Foundations

### 1. Sitemap (`/sitemap.xml` or `src/app/sitemap.ts`)
- Dynamic generation including all static and dynamic pages
- Set `lastModified` from actual content dates
- Set `changeFrequency` (daily for blog, weekly for static pages)
- Set `priority` (1.0 homepage, 0.8 main sections, 0.6 content)
- For large sites (>50k URLs), use sitemap index

### 2. Robots.txt (`/robots.txt` or `src/app/robots.ts`)
- Allow all legitimate crawlers
- Block `/api/`, `/admin/`, staging environments
- Reference sitemap URL
- Consider Crawl-delay for rate limiting

### 3. URL Structure
- Clean, readable URLs (no query params for content)
- Consistent trailing slash policy
- Lowercase only
- Hyphens not underscores
- 301 redirects for all old/changed URLs
- No broken links (404s)

### 4. Custom 404 Page
- Helpful error page with navigation
- Search functionality if applicable
- Links to popular content

## JSON-LD Structured Data

### Root Layout (every page)
```
Organization: name, url, logo, founder, sameAs (social links), contactPoint
WebSite: name, url, description, publisher, potentialAction (SearchAction if site has search)
```

### About/Author Pages
```
Person: name, jobTitle, worksFor, description, url, image, sameAs, knowsAbout, alumniOf, hasCredential
```

### Blog Posts/Articles
```
Article: headline, description, image, datePublished, dateModified, author (linked to Person), publisher, mainEntityOfPage
BreadcrumbList: hierarchical navigation path
```

### Product Pages
```
Product: name, description, image, brand, offers (price, availability, currency), aggregateRating, review
```

### FAQ Sections
```
FAQPage: mainEntity array of Question/Answer pairs
```

### How-To/Tutorial Content
```
HowTo: name, description, step array, totalTime, tool, supply
```

### Software/Apps
```
SoftwareApplication: name, operatingSystem, applicationCategory, offers, aggregateRating
```

### Events
```
Event: name, startDate, endDate, location, description, offers, performer, organizer
```

### Videos
```
VideoObject: name, description, thumbnailUrl, uploadDate, duration, contentUrl, embedUrl
```

## Page Metadata

### Every Page Must Have:
- Unique `<title>` (50-60 chars, primary keyword near front)
- Meta `description` (150-160 chars, compelling, includes CTA)
- Canonical URL via `alternates.canonical`
- Exactly one `<h1>` tag matching page intent

### OpenGraph Tags
- `og:title` (can differ from title tag)
- `og:description`
- `og:type` (website, article, product, etc.)
- `og:image` (1200x630px recommended)
- `og:url` (canonical)
- `og:site_name`
- `og:locale`
- `article:published_time` (for articles)
- `article:modified_time` (for articles)
- `article:author` (for articles)

### Twitter Cards
- `twitter:card` (summary_large_image for most)
- `twitter:title`
- `twitter:description`
- `twitter:image`
- `twitter:site` (your @handle)
- `twitter:creator` (author @handle)

### Dynamic OG Images
- Create for homepage, section pages, individual content
- Use shared component for consistent branding
- Include title, branding, relevant imagery
- Test with social media debuggers

## AI Engine Optimization (AEO)

Based on analysis of 1.2 million ChatGPT responses and 30 million citations (source: Kevin Indig, Growth Memo).

### 1. Document position strategy (the "ski ramp")

AI models cite content heavily from the top of a page, tapering off toward the bottom:
- **First 30% of content**: 44.2% of all citations originate here
- **Middle 30-70%**: 31.1% of citations
- **Final 30%**: 24.7% of citations

**What to do:**
- Use BLUF (Bottom Line Up Front): state your conclusion or answer immediately, then elaborate
- Front-load your strongest claims, definitions, and data into the opening sections
- Do not build suspense or save the best insight for the end
- Establish the interpretive frame in the introduction so that everything after it is read through that lens

### 2. Five winning content characteristics

#### a. Definitive language (2x more citations)
- Citation winners use definitive constructions 36.2% of the time vs 20.2% for losers
- Use phrases like "is defined as," "refers to," "is the process of"
- Resolve queries in a single statement (zero-shot approach)
- The word "is" acts as a strong vector bridge connecting subjects to definitions

**Example:**
- Weak: "SEO can mean different things depending on who you ask"
- Strong: "SEO is the practice of optimizing web pages to rank higher in search engine results"

#### b. Question-answer headers (2x more question marks in cited text)
- Cited text contains question marks 2x more often (18% vs 8.9%)
- 78.4% of question-based citations originate from H2 headings
- Frame H2s as literal user queries, not abstract topic labels
- Answer immediately in the first sentence of the following paragraph
- Use "entity echoing": repeat the topic word at the start of the answer

**Example:**
- Weak header: "The history of SEO"
- Strong header: "When did SEO start?"
- Strong answer: "SEO started in the mid-1990s when..."

#### c. Entity richness (target ~20% named entity density)
- Standard English text contains 5-8% entity density (proper nouns, brands, tools)
- Heavily cited content averages 20.6% entity density
- LLMs treat specific entities as anchors that lower answer uncertainty
- Name-drop tools, brands, people, and competitors freely

**Example:**
- Weak: "There are many good tools for this task" (0% density)
- Strong: "Top tools include Salesforce, HubSpot, and Pipedrive" (30% density)

#### d. Balanced sentiment (target ~0.47 subjectivity)
- On a scale of 0.0 (pure objectivity) to 1.0 (pure opinion), the winning sweet spot is ~0.47
- This is the "analyst voice": combine a fact with analysis in the same sentence
- Avoid both dry Wikipedia-style prose and emotional opinion pieces

**Example:**
- Too objective: "iPhone 15 features the A16 chip"
- Too subjective: "iPhone 15 is the most amazing phone ever made"
- Analyst voice: "iPhone 15 features the A16 chip, making it the strongest option for content creators"

#### e. Business-grade writing clarity (Flesch-Kincaid ~16)
- Citation winners score Flesch-Kincaid 16 (college level)
- Citation losers score 19.1 (PhD/academic level)
- Use simple subject-verb-object sentence structures
- Avoid multisyllabic jargon and winding sentences
- Even sophisticated topics suffer when written at PhD level

### 3. Within-paragraph optimization

Where sentences sit inside a paragraph also matters:
- **Middle of paragraph**: 53% of citations (highest information gain)
- **First sentence**: 24.5% of citations
- **Last sentence**: 22.5% of citations

**What to do:**
- Pack your highest-value claims and data points into the body of paragraphs, not just openers
- ChatGPT seeks sentences with the highest information gain regardless of sentence position
- Use opening sentences to set context, middle sentences for your strongest claims

### 4. `/public/llms.txt`
```
# Site Name - LLM Context File

> Brief description of what this site is

## About this site
Clear explanation of site purpose and content

## Author/organization information
Name, title, credentials, expertise areas

## Key topics covered
- Topic 1
- Topic 2
- Topic 3

## Primary content sections
/path1 - Description
/path2 - Description
/path3 - Description

## Citing this content
Attribution format, author name, website URL

## Contact for verification
Email, social links for fact-checking
```

### 5. E-E-A-T signals (experience, expertise, authoritativeness, trustworthiness)
- Author bio pages with credentials
- Link author pages to content
- Display credentials/certifications
- Show real-world experience
- Include contact information
- Privacy policy and terms of service
- Physical address if applicable

## Content & Internal Linking

### Heading Hierarchy
- One H1 per page (matches intent)
- H2 for main sections
- H3 for subsections
- Never skip levels (h1 > h3)

### Internal Linking
- Link to related content naturally
- Use descriptive anchor text (not "click here")
- Ensure important pages are within 3 clicks of homepage
- Create hub pages for topic clusters

### Images
- Descriptive alt text (not keyword stuffing)
- Compressed/optimized (WebP preferred)
- Lazy loading for below-fold images
- Proper width/height to prevent layout shift

## RSS/Atom Feeds

For sites with regularly updated content:
- `/api/rss` or `/feed.xml` endpoint
- Include title, description, pubDate, link, guid
- Add `<link rel="alternate" type="application/rss+xml">` in head
- Consider JSON Feed as alternative

## Performance (Core Web Vitals)

### LCP (Largest Contentful Paint) < 2.5s
- Optimize hero images
- Preload critical assets
- Use CDN

### FID (First Input Delay) < 100ms
- Minimize JavaScript
- Code split
- Defer non-critical scripts

### CLS (Cumulative Layout Shift) < 0.1
- Set image dimensions
- Reserve space for ads/embeds
- Avoid inserting content above existing content

## Security & Trust

- HTTPS everywhere (redirect HTTP)
- Security headers (CSP, HSTS, X-Frame-Options)
- Privacy policy page
- Terms of service page
- Contact page with real contact info
- Cookie consent if applicable

## Favicons & App Icons

- `/favicon.ico` (32x32)
- `/icon.svg` (scalable)
- `/apple-icon.png` (180x180)
- `manifest.json` for PWA

## International (if applicable)

- `hreflang` tags for language variants
- `lang` attribute on `<html>`
- Localized content, not just translated
- Country-specific domains or subdirectories

## Verification & Monitoring

- Google Search Console verification
- Bing Webmaster Tools
- Analytics (privacy-respecting option preferred)
- Uptime monitoring
- Broken link checking

## Checklist

### Technical Foundation
- [ ] Dynamic sitemap.xml with all pages
- [ ] robots.txt with sitemap reference
- [ ] Clean URL structure
- [ ] 301 redirects for old URLs
- [ ] Custom 404 page
- [ ] HTTPS with redirect from HTTP

### Structured Data
- [ ] Organization + WebSite in root layout
- [ ] Person schema on author pages
- [ ] Article + BreadcrumbList on blog posts
- [ ] Product schema on product pages (if applicable)
- [ ] FAQPage schema on FAQ sections (if applicable)
- [ ] Test with Google Rich Results Test

### Page-Level SEO
- [ ] Unique title (50-60 chars) on every page
- [ ] Unique description (150-160 chars) on every page
- [ ] Canonical URL on every page
- [ ] One H1 per page
- [ ] Proper heading hierarchy
- [ ] Alt text on all images

### Social/Sharing
- [ ] OpenGraph tags on every page
- [ ] Twitter Card tags on every page
- [ ] Dynamic OG images for all page types
- [ ] Test with Facebook Debugger and Twitter Card Validator

### AEO (content structure for AI citation)
- [ ] /public/llms.txt created
- [ ] BLUF structure: conclusions and key definitions in the first 30% of each page
- [ ] H2 headings framed as user queries (not abstract topic labels)
- [ ] Immediate answers after question headers using entity echoing
- [ ] Definitive language: "is defined as," "refers to" constructions throughout
- [ ] Entity density ~20%: specific brands, tools, people named (not generic references)
- [ ] Balanced sentiment ~0.47: analyst voice combining facts with analysis
- [ ] Readability at Flesch-Kincaid ~16 (college level, not PhD)
- [ ] Author pages with credentials (E-E-A-T)
- [ ] Dates on all content (published and updated)

### Performance & Trust
- [ ] Core Web Vitals passing
- [ ] Privacy policy page
- [ ] Contact information visible
- [ ] Favicons and app icons

### Feeds & Discovery
- [ ] RSS feed for blog content
- [ ] Feed autodiscovery link in head

### Final Verification
- [ ] Build passes with no errors
- [ ] Test all pages in Google Rich Results Test
- [ ] Validate with Lighthouse SEO audit
- [ ] Check mobile-friendliness
