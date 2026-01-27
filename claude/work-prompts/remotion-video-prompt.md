# Remotion video creation prompt

Use this prompt when building videos with Remotion.

## Core principles

### Timing architecture

Always define timing constants at the top of your component:

```typescript
// Timing constants (in frames at 30fps)
const INTRO_START = 0;
const INTRO_END = 45;  // 1.5s
const MAIN_START = 30;
const MAIN_END = 180;
const OUTRO_START = 165;
const OUTRO_END = 210; // 7s total
```

Use these constants everywhere. Never hardcode frame numbers inline.

### Animation patterns

**Default easing:** Always use `Easing.out(Easing.cubic)` unless you have a specific reason not to:

```typescript
import { Easing } from "remotion";

const opacity = interpolate(
  frame,
  [INTRO_START, INTRO_START + 15],
  [0, 1],
  {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
    easing: Easing.out(Easing.cubic),
  }
);
```

**Spring animations:** Use `damping: 200` for smooth, no-bounce motion:

```typescript
const scale = spring({
  frame,
  fps,
  config: { damping: 200 },
});
```

For snappier entrance animations, use `damping: 20, stiffness: 200`.

**Always clamp:** Every `interpolate()` call must have both extrapolate options:

```typescript
{
  extrapolateLeft: "clamp",
  extrapolateRight: "clamp",
}
```

### Phase tracking

Use boolean flags to track which phase the video is in:

```typescript
const isIntroPhase = frame >= INTRO_START && frame < INTRO_END;
const isMainPhase = frame >= MAIN_START && frame < MAIN_END;
const isOutroPhase = frame >= OUTRO_START;
```

Then use these to conditionally render or style elements.

### Text transitions

Text must exit before new text enters. Use this pattern:

```typescript
// Text fades in over 10 frames, holds, then fades out over 10 frames
const textOpacity = interpolate(
  frame,
  [startFrame, startFrame + 10, endFrame - 10, endFrame],
  [0, 1, 1, 0],
  { extrapolateLeft: "clamp", extrapolateRight: "clamp" }
);
```

### Pacing guidelines

- Social media videos: 10-15 seconds total (300-450 frames at 30fps)
- Each text element: Minimum 1.5s visible (45 frames)
- Transitions: 10-15 frames (0.3-0.5s)
- Hold time between transitions: At least 30 frames (1s)
- CTA at end: 2-3 seconds (60-90 frames)

## Component structure

### File organization

```
src/[project-name]/
  index.tsx              # Composition registry with <Folder>
  components/
    templates/           # Reusable video templates
      QuoteReveal.tsx
      StatisticSpotlight.tsx
    shared/              # Shared components
      Background.tsx
      CTA.tsx
  data/
    content.ts           # Video content (typed)
```

### Composition registry pattern

```typescript
import { Composition, Folder } from "remotion";

export const ProjectCompositions: React.FC = () => (
  <Folder name="project-name">
    <Composition
      id="project-name-video-1"
      component={VideoComponent}
      durationInFrames={300}
      fps={30}
      width={1080}
      height={1350}
      defaultProps={videoProps}
    />
  </Folder>
);
```

### Component template

```typescript
import React from "react";
import {
  AbsoluteFill,
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
  Easing,
} from "remotion";

// Timing constants
const PHASE1_START = 0;
const PHASE1_END = 75;
const PHASE2_START = 60;
const PHASE2_END = 180;

export type VideoProps = {
  title: string;
  content: string;
};

export const VideoComponent: React.FC<VideoProps> = ({ title, content }) => {
  const frame = useCurrentFrame();
  const { fps, durationInFrames } = useVideoConfig();

  // Phase tracking
  const isPhase1 = frame < PHASE1_END;
  const isPhase2 = frame >= PHASE2_START && frame < PHASE2_END;

  // Animations
  const phase1Opacity = interpolate(
    frame,
    [PHASE1_START, PHASE1_START + 10, PHASE1_END - 10, PHASE1_END],
    [0, 1, 1, 0],
    { extrapolateLeft: "clamp", extrapolateRight: "clamp" }
  );

  return (
    <AbsoluteFill style={{ backgroundColor: "#0D0D0D" }}>
      {/* Phase 1 content */}
      <AbsoluteFill
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          opacity: phase1Opacity,
        }}
      >
        <div style={{ fontSize: 64, fontWeight: 900, color: "#FFFFFF" }}>
          {title}
        </div>
      </AbsoluteFill>
    </AbsoluteFill>
  );
};
```

## Styling guidelines

### Layout

- Use `AbsoluteFill` for full-screen containers
- Center content with flexbox: `display: "flex", alignItems: "center", justifyContent: "center"`
- Add padding: `padding: "0 60px"` for text containers
- Set `maxWidth` on text (800-900px for readability)

### Typography

- Use Google Fonts via `@remotion/google-fonts`
- Load fonts at component top level, not inside render
- Weights: 400 (normal), 700 (bold), 900 (black)
- Line height: 1.1-1.3 for headlines, 1.4-1.6 for body

```typescript
import { loadFont } from "@remotion/google-fonts/Inter";

const { fontFamily } = loadFont("normal", {
  weights: ["400", "700", "900"],
  subsets: ["latin"],
});
```

### Colors

Define your palette as constants:

```typescript
const COLORS = {
  primary: "#F5D500",    // Gold
  secondary: "#E8910C",  // Orange
  text: "#FFFFFF",
  textMuted: "#888888",
  background: "#0D0D0D",
};
```

### Background effects

Subtle zoom adds polish without distraction:

```typescript
const bgScale = interpolate(
  frame,
  [0, durationInFrames],
  [1, 1.05],
  { extrapolateRight: "clamp" }
);

<AbsoluteFill style={{ transform: `scale(${bgScale})` }}>
  {/* background content */}
</AbsoluteFill>
```

## Common patterns

### Staggered list animation

```typescript
const ListItem: React.FC<{ index: number; text: string }> = ({ index, text }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const delay = index * 10; // 10 frames between each item
  const localFrame = Math.max(0, frame - delay);

  const slideIn = spring({
    frame: localFrame,
    fps,
    config: { damping: 20 },
  });

  const opacity = interpolate(localFrame, [0, 8], [0, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <div
      style={{
        opacity,
        transform: `translateX(${interpolate(slideIn, [0, 1], [-40, 0])}px)`,
      }}
    >
      {text}
    </div>
  );
};
```

### Animated counter

```typescript
const displayNum = Math.round(
  interpolate(frame, [startFrame, startFrame + 30], [0, targetNumber], {
    extrapolateRight: "clamp",
  })
);
```

### Book/product reveal

```typescript
const bookStart = durationInFrames - fps * 3;
const bookLocalFrame = frame - bookStart;

const bookIn = spring({
  frame: Math.max(0, bookLocalFrame),
  fps,
  config: { damping: 20 },
});

const bookOpacity = interpolate(bookLocalFrame, [0, 10], [0, 1], {
  extrapolateLeft: "clamp",
  extrapolateRight: "clamp",
});

const bookScale = interpolate(bookIn, [0, 1], [0.9, 1]);
```

## Rendering

### Command format

```bash
npm run render [composition-id] videos/[project-name]/[video-name].mp4
```

### Batch rendering

Create a shell script for multiple videos:

```bash
#!/bin/bash
npm run render project-video-1 videos/project/video-1.mp4
npm run render project-video-2 videos/project/video-2.mp4
# etc
```

## Debugging tips

1. Use Remotion Studio (`npm start`) to preview in real-time
2. Scrub timeline to check transitions
3. Check frame numbers with `console.log(frame)` temporarily
4. Verify timing constants sum to `durationInFrames`
5. Test at different playback speeds

## Checklist before rendering

- [ ] All timing constants defined at top
- [ ] All interpolations clamped
- [ ] Text exits before new text enters
- [ ] Minimum 45 frames (1.5s) hold time for text
- [ ] CTA visible for 60+ frames (2s)
- [ ] No hardcoded frame numbers inline
- [ ] Fonts loaded correctly
- [ ] Colors from defined palette
- [ ] Content centered with proper padding
