---
user-invocable: true
name: finance-macro-regime
description: Macro checklist before any new position. Analyzes rate environment, dollar direction, market breadth, sector rotation, and VIX to classify the regime as risk-on, risk-off, mixed, or transition. Adjusts position sizing and strategy selection accordingly. Weekly Monday update.
---

# Macro regime filter skill

## What this skill does

Runs a macro checklist before any new position is opened. Answers the one question professionals ask before every trade: am I trading with the current? Rate environment, dollar direction, sector rotation, market breadth -- these are the forces that move entire portfolios. Individual stock analysis means nothing if the macro tide is going out.

## The four macro factors that matter most

**1. Rate environment**
Rising rates hurt growth stocks and tech. Falling rates help them. Rates also affect the cost of carry on leveraged positions and change what sectors are attractively priced on a relative basis.

**2. Dollar direction (DXY)**
A rising dollar hurts multinational earners (they report overseas revenue in weaker currencies) and commodities (priced in dollars, so a stronger dollar makes them more expensive globally). A falling dollar helps international exposure and commodities.

**3. Market breadth**
Is the rally broad or narrow? If the S&P is up but only 30% of stocks are above their 200-day moving average, that is a narrow, fragile rally. Broad rallies (70%+ of stocks participating) are more sustainable.

**4. Sector rotation**
Capital flows to sectors for structural reasons -- rate sensitivity, inflation hedging, defensive vs growth posture. Knowing which sectors institutions are rotating into tells you where the next 3-6 months of outperformance is likely to come from.

## Setup prompt (paste this to activate)

```
Run a macro regime analysis. I want to understand the current environment before I open any new positions.

1. RATE ENVIRONMENT
   - Current Fed funds rate: [X]%
   - 10-year Treasury yield: [X]% and direction (rising/falling/stable)
   - 2-year Treasury yield: [X]%
   - Yield curve: [Inverted / Normal / Steepening / Flattening]
   - Regime: [Tightening / Easing / Neutral / Pivot incoming]
   - Impact on equities: one sentence

2. DOLLAR (DXY)
   - Current DXY level: [X]
   - 1-month trend: [Rising / Falling / Range-bound]
   - Impact on my current positions and potential trades: one sentence

3. MARKET BREADTH
   - % of S&P 500 stocks above their 200-day MA: [X]%
   - % of S&P 500 stocks above their 50-day MA: [X]%
   - New 52-week highs vs lows: [X] highs, [X] lows
   - Breadth verdict: [Healthy / Narrowing / Deteriorating / Expanding]

4. SECTOR ROTATION
   - Top 3 performing sectors last 30 days: [list]
   - Bottom 3 performing sectors last 30 days: [list]
   - Capital is flowing from [X] to [Y]
   - This suggests [RISK ON / RISK OFF / DEFENSIVE / GROWTH] regime

5. VIX AND FEAR
   - VIX: [X] (below 15 = calm, 15-25 = normal, above 25 = fear, above 35 = panic)
   - VIX trend: [Rising / Falling / Stable]
   - Put/call ratio: [X] (above 1.2 = fear, below 0.7 = complacency)

6. REGIME VERDICT
   Based on all of the above, classify the current regime:
   - [RISK ON -- growth and momentum strategies have tailwinds]
   - [RISK OFF -- defensive positioning, reduce exposure, increase cash]
   - [MIXED -- be selective, smaller position sizes]
   - [TRANSITION -- regime is changing, wait for clarity]

7. POSITION IMPLICATIONS
   - For my current open positions: does the macro regime support or contradict them?
   - For my planned trades: does the macro backdrop help or hurt?
   - Recommended adjustment: [None / Reduce size / Increase cash / Rotate sector exposure]
```

## Macro regime trading rules

| Regime | Position sizing | Preferred strategies | Sectors to favor |
|--------|-----------------|----------------------|-----------------|
| Risk on, low VIX | Full size (up to 5% per position) | Momentum, breakouts, growth | Tech, consumer discretionary, small cap |
| Risk on, rising VIX | 75% of normal size | Momentum with tighter stops | Large cap quality, healthcare |
| Risk off, high VIX | 50% of normal size | Income strategies, defined risk | Utilities, consumer staples, gold |
| Panic (VIX >35) | 25% of normal size or cash | Wait | Cash, short-term Treasuries |
| Transition | 50% of normal size | No new breakouts -- wait for clarity | Defensive |

## Weekly macro update schedule

```
Run a macro update every Monday at 08:30 ET.

Pull the five macro factors above.
Compare to last week's reading.
Flag any regime change: if the regime verdict changes from last week, alert prominently.
Output a 10-line summary. No trade recommendations -- just the read.
Save to ./macro-log.md with a timestamp.
```

## Integration with other skills

Before running any of these skills, confirm the macro regime is supportive:

- **finance-momentum-breakout**: Only run in Risk On or Mixed regimes. Not in Risk Off.
- **finance-short-squeeze**: Only viable when VIX < 25. High-VIX environments kill squeeze setups.
- **finance-iron-condor**: Works in any regime -- but widen strikes in high-VIX environments.
- **finance-copy-trading**: Congressional trades tend to be long-horizon -- regime matters less, but size down in Risk Off.
- **finance-wheel**: Viable in any regime -- but check sector of the underlying against sector rotation.
