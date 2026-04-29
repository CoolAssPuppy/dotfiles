---
user-invocable: true
disable-model-invocation: true
name: finance-pre-market-prep
description: Runs a structured morning briefing every trading day at 09:00 ET. Covers overnight futures, economic calendar, key levels on open positions, sector movers, and earnings. Produces a concrete game plan for the session.
---

# Pre-market preparation skill

## What this skill does

Runs a structured morning briefing every trading day at 09:00 ET -- 30 minutes before the open. Covers overnight futures, economic calendar, key levels on open positions, sector movers, and earnings. Produces a concrete game plan for the session. You walk into the open knowing exactly what you are watching and why.

Professional traders do this every single morning. Trading without a pre-market brief is like operating without a plan.

## Setup prompt (paste once to activate permanently)

```
Set up a daily pre-market briefing that runs every trading day at 09:00 ET.

Every morning, pull together and show me:

1. OVERNIGHT MARKET
   - S&P 500 futures: direction and % move overnight
   - Nasdaq futures: direction and % move
   - VIX: current level and whether it's up or down from yesterday's close
   - Dollar index (DXY): direction
   - 10-year Treasury yield: level and direction
   One sentence on what the overnight tone suggests.

2. ECONOMIC CALENDAR
   - Any data releases today: time, what it is, consensus estimate
   - Fed speakers scheduled today
   - Flag HIGH IMPACT events (CPI, FOMC, jobs report, GDP) with a warning

3. MY OPEN POSITIONS
   - For each open position: overnight move, distance to stop loss, distance to next profit target
   - Flag any position where the stop loss is within 2% of current price -- requires attention at open

4. SECTOR ROTATION
   - Which sectors are leading premarket (top 2)
   - Which sectors are lagging premarket (bottom 2)
   - One sentence on what that rotation suggests

5. EARNINGS & CATALYSTS TODAY
   - Any stocks in my portfolio reporting earnings today -- flag prominently
   - Major index-moving stocks reporting (AAPL, NVDA, TSLA, META, MSFT, AMZN, GOOGL)
   - Expected move (implied move from options) for anything reporting

6. KEY LEVELS
   - S&P 500: overnight high, overnight low, yesterday's close, key support, key resistance
   - For each open position: same four levels

7. GAME PLAN
   - 3 bullet points maximum
   - What am I watching at the open
   - What would make me add to a position today
   - What would make me reduce or exit a position today

Schedule this for 09:00 ET, Monday-Friday. Save the schedule to ./schedules/pre-market.json
Output the brief directly in chat every morning.
```

## Brief format

```
PRE-MARKET BRIEF -- [DAY], [DATE] -- 09:00 ET

OVERNIGHT TONE
  S&P futures:   [+/-X%] | Nasdaq: [+/-X%] | VIX: [X] ([up/down] [Y])
  DXY: [X] [direction] | 10Y yield: [X]% [direction]
  Read: [One sentence]

CALENDAR -- TODAY
  [TIME ET]  [EVENT]  Consensus: [X]  <- HIGH IMPACT if applicable

MY POSITIONS -- OVERNIGHT
  [TICKER]  $[PRICE] ([+/-X%] overnight)  Stop: $[X] ([Y]% away)  Target: $[X] ([Z]% away)
  !! [TICKER] -- stop within 2%. Watch at open.

SECTOR ROTATION
  Leading:  [SECTOR] [+X%]  |  [SECTOR] [+X%]
  Lagging:  [SECTOR] [-X%]  |  [SECTOR] [-X%]
  Read: [One sentence]

EARNINGS TODAY
  !! [TICKER in my portfolio] -- reports [before/after] market. Expected move: +/-[X]%

KEY LEVELS -- S&P 500
  Overnight high: [X]  |  Low: [X]  |  Yesterday close: [X]
  Support: [X]  |  Resistance: [X]

GAME PLAN
  -> Watching: [specific level or event]
  -> Add if: [specific condition]
  -> Reduce if: [specific condition]
```

## High-impact calendar events -- elevated protocol

On days with CPI, FOMC decision, jobs report, or GDP:

- Reduce all open position sizes by 50% before the release unless user explicitly overrides
- Do not open any new positions within 2 hours of the release
- After the release, wait 15 minutes for volatility to settle before any action
- Flag this in the morning brief in caps: **HIGH IMPACT EVENT TODAY -- REDUCED POSITION SIZING IN EFFECT**
