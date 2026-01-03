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

### 1. `/public/llms.txt`
```
# Site Name - LLM Context File

> Brief description of what this site is

## About This Site
Clear explanation of site purpose and content

## Author/Organization Information
Name, title, credentials, expertise areas

## Key Topics Covered
- Topic 1
- Topic 2
- Topic 3

## Primary Content Sections
/path1 - Description
/path2 - Description
/path3 - Description

## Citing This Content
Attribution format, author name, website URL

## Contact for Verification
Email, social links for fact-checking
```

### 2. Content Principles for LLMs
- Write clear, factual, unambiguous content
- Define technical terms on first use
- Use structured headings that summarize sections
- Include author bylines with credentials
- Date all content (published and updated)
- Link to authoritative sources
- Avoid content that could be misinterpreted out of context

### 3. E-E-A-T Signals (Experience, Expertise, Authoritativeness, Trustworthiness)
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

### AEO
- [ ] /public/llms.txt created
- [ ] Author pages with credentials
- [ ] Clear, factual content structure
- [ ] Dates on all content

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
