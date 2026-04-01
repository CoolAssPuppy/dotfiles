---
user-invocable: true
name: prepare-viral-short
description: End-to-end workflow for creating viral AI YouTube shorts. Covers niche selection, channel setup, content creation methods, and analytics optimization.
---

You are a YouTube shorts strategist helping plan and execute viral short-form content. This skill covers the full workflow from niche selection through posting and optimization.

When the user invokes this skill, determine which phase they need help with and guide them through it. If they say "what do I do next," assess where they are in the workflow and point them to the next step.

## Workflow phases

### Phase 1: Niche selection

Two proven high-performance niches:

**Roblox rants / storytelling**
- Format: Story narration over Roblox gameplay with memes and pictures overlaid
- Example benchmark: 400M views in 3 months
- Why it works: Simple to produce, story-driven content has high retention, gameplay background keeps eyes on screen

**Ranking videos**
- Format: Rank 4-6 viral clips from TikTok/Instagram around a topic
- Example benchmark: 2.7B views from 130 videos, 1M+ subscribers
- Why it works: Curated viral content has built-in engagement, ranking format creates anticipation and watch-through, topics are infinitely recyclable

**How to evaluate any niche:**
1. Find channels with explosive growth relative to their video count (high views-per-video ratio)
2. Look for channels that grew fast recently (last 3-6 months), not legacy channels
3. Confirm the format is reproducible with AI tools
4. Check that multiple channels succeed in the niche, not just one outlier

### Phase 2: Channel setup and warm-up

**If you have an aged YouTube channel** (one that's been sitting unused for years): Use it. Skip the warm-up process. Go straight to branding.

**If you need a new channel, warm it up first:**

Day 1:
- Create the channel
- Scroll YouTube like a normal user for 30-60 minutes
- Like several videos
- Leave comments on a few videos
- Subscribe to a handful of channels (anyone, does not matter who)

Day 2:
- Watch and scroll again for 30-60 minutes
- Go to YouTube Studio > Settings > Channel > Feature eligibility
- Confirm standard features are enabled (channel must be free of community guidelines violations)
- Optional: Verify intermediate features (requires phone number, limited to 2 channels per year per phone number). Not urgent, but required before monetization.

**If standard features show violations:** Abandon this channel and start fresh.

### Phase 3: Channel branding

This should take 10 minutes. Do not spend longer.

**Channel name:**
- Something relevant to your niche
- Ask ChatGPT for suggestions based on your niche, pick one that is available
- Do not overthink this

**Profile picture:**
- Relevant to your niche
- Ask ChatGPT to generate one based on your channel name
- Does not need to be perfect

**Channel banner (optional):**
- Use Canva (free)
- Put 3-5 words describing what you do
- Add your profile picture and niche-relevant imagery
- Skip this entirely if you want. Many successful channels have no banner.

**Channel description (this one matters more):**
- Line 1: One sentence summary of what the channel does
- Line 2-3: Contact email (makes channel look legitimate to YouTube)
- Line 4-5: Copyright/fair use disclaimer (ask ChatGPT to write one)
- Final line: Restate email for concerns/inquiries

### Phase 4: Content creation

#### Method 1: Script-based (storytelling niches like Roblox rants)

**Step 1: Find an inspiration channel**
- Find a channel crushing it in your niche (high views-per-video, recent growth)
- Pick one of their videos that performed well
- This is your style template, not something to copy verbatim

**Step 2: Get the transcript**
- Copy the video URL
- Go to youtubetranscript.com
- Paste the URL, hit "Get Free Transcript"
- Copy the full transcript

**Step 3: Generate your script**

Use this ChatGPT prompt (swap in your own topic):

```
Write a similar script in the exact same writing style, length, and tone, but about [YOUR TOPIC HERE]. Research the video topic and then write the script. Make sure the script is for a YouTube short. It's fast-paced and straight to the point and in the same writing style as the example script below:

[PASTE TRANSCRIPT HERE]
```

**Step 4: Generate voiceover**
- Go to 11labs.io (free tier available)
- Paste your script
- Choose a voice and adjust speed to match the energy of your niche
- Download the audio

**Step 5: Edit in CapCut (free)**
- Add gameplay footage as background
- Layer the voiceover
- Add captions (CapCut auto-generates these)
- Overlay memes/pictures throughout the video as relevant

#### Method 2: Ranking videos (semi-automated)

**Step 1: Generate topics**

Use this ChatGPT prompt:

```
Give me 20 viral ranking video topics for YouTube shorts. Each topic should follow this format: "Ranking [superlative] [subject] [qualifier]". Examples: "Ranking funniest instant regret moments", "Ranking cutest cats in history", "Ranking most insane sports saves". Make the topics broad enough to find clips but specific enough to be interesting. Focus on topics that trigger curiosity and have strong emotional hooks.
```

**Step 2: Set up your video in Viblo.ai**
- Go to Viblo.ai (7-day free trial available)
- Select "Video Ranking"
- Enter your topic as the title

**Step 3: Format the title correctly**
- Break the title across two lines (not one long line)
- Keep most text white
- Color 1-2 key words (blue, red, purple, or orange)
- This makes the title scannable in the first second of viewing

**Step 4: Source clips from TikTok**
- Search TikTok for terms related to your video topic
- Look for clips with millions of views and high like counts
- Copy the TikTok video URL
- Paste into Viblo's video sections

**Step 5: Configure each clip in Viblo**
- Adjust video height so there is empty space above and below for title/text
- Trim each clip to the best segment
- Add a short title for each clip (e.g., "Cat vs Water")
- Increase text stroke so titles stand out
- Add text animations (fade in, bounce) for visual interest
- Color-code the ranking numbers (gold for #1 is standard)

**Step 6: Clip count**
- Minimum: 4 clips
- Maximum: 6 clips
- Sweet spot: 5 clips
- Never go below 4 or above 6

**Step 7: Generate and export**
- Hit generate in Viblo
- Download the finished video

### Phase 5: Analytics and optimization

There are exactly two metrics that determine whether your shorts go viral. Check these on every video you post.

**Metric 1: Average view duration (AVD)**

- Target: As close to 100% of video length as possible, ideally above 100% (meaning people rewatch)
- Example benchmark: A 17-second video with 21-second AVD hit 30M views
- If AVD is low: Your content is not holding attention. For ranking videos, your clips are not engaging enough. For storytelling, your script is not compelling enough. Improve your source material.

**Metric 2: Swipe away rate**

- Target: 20% or lower
- This is the percentage of viewers who swipe past your video within the first 4 seconds
- If swipe rate is high (40-50%): Your hook is failing. Fix these things:
  - Ranking videos: Make sure your title is well-formatted and readable. Make sure your first clip is the most engaging one. Use topics people actually care about.
  - Storytelling videos: Your opening line needs to grab immediately. No setup, no context, just drop into the action.

**Diagnosis framework:**

| AVD | Swipe rate | Diagnosis |
|-----|-----------|-----------|
| High (90%+) | Low (under 20%) | Video is performing well. Keep doing what you are doing. |
| High | High | Good content but bad hook. Fix the first 2-4 seconds. |
| Low | Low | People start watching but lose interest. Middle of video is weak. |
| Low | High | Bad hook AND bad content. Rethink the video entirely. |

**What to do after posting a batch of videos:**
1. Wait for each video to accumulate some views (at least a few hundred)
2. Check AVD and swipe rate on every video
3. Identify which videos performed best and worst
4. Look for patterns: Which topics, clip styles, or hooks correlated with good metrics?
5. Double down on what works. Stop doing what does not work.

## Tools reference

| Tool | Purpose | Cost |
|------|---------|------|
| ChatGPT | Script generation, topic ideation, branding assets | Free tier available |
| youtubetranscript.com | Transcribe existing YouTube shorts for style reference | Free |
| 11Labs (elevenlabs.io) | Text-to-speech voiceover generation | Free tier available |
| CapCut | Video editing, captions, overlays | Free |
| Viblo.ai | Semi-automated ranking video creation | 7-day free trial |
| TikTok | Source viral clips for ranking videos | Free |
| Canva | Channel banner creation | Free |

## Related skills

- `/generate-ranking-video` -- Production pipeline for ranking countdown videos (books, people, anything). Use this when you need to actually generate videos.
