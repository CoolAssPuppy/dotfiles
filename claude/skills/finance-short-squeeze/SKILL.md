---
user-invocable: true
name: finance-short-squeeze
description: Screens stocks for short squeeze potential before a squeeze happens. Scores candidates 0-7 on short interest, days to cover, borrow cost, float size, OTM call OI, price action, and volume. Builds trade plans for high-priority setups.
---

# Short squeeze scanner skill

## What this skill does

Screens stocks for short squeeze potential before a squeeze happens. Identifies setups where high short interest, rising price action, and options market structure combine to create forced-buying dynamics. Getting into a squeeze early -- not chasing it -- is the entire game.

## How a short squeeze works

Short sellers borrow shares and sell them, betting the price falls. They must eventually buy back those shares to return them. If the price rises instead of falling, short sellers face mounting losses and are eventually forced to buy -- which pushes the price higher, which forces more buying. The feedback loop is the squeeze.

A gamma squeeze adds fuel: if there is large open interest in out-of-the-money calls, rising prices force market makers to buy shares to hedge their short call exposure. Two forced-buying mechanisms running simultaneously.

## Screening criteria

A valid squeeze setup needs most of these:

| Factor | Threshold | Why it matters |
|--------|-----------|----------------|
| Short interest | >15% of float | Enough trapped short sellers to matter |
| Days to cover | >5 days | Short sellers can't exit quickly without moving the price |
| Borrow cost (CTB) | >50% annualized | Expensive to stay short -- pressure to close |
| Float size | Small (<50M shares) | Less supply means price moves more on the same buying pressure |
| OTM call open interest | High relative to ADV | Gamma squeeze potential |
| Recent price trend | Breaking above recent resistance | Short sellers going offside |
| Volume surge | >150% of 20-day average | New buyers overwhelming sellers |

## Scanner prompt

```
Run a short squeeze screen.

Scan the following universe: [Russell 2000 / S&P 600 small cap / specific list of tickers]

For each stock, calculate:
1. Short interest as % of float (threshold: >15%)
2. Days to cover (short interest / average daily volume, threshold: >5)
3. Cost to borrow if available (threshold: >50% annualized)
4. Float size (flag stocks under 50M shares)
5. OTM call open interest relative to average daily volume (flag if >0.5x)
6. Price action: is the stock above its 20-day moving average and breaking prior resistance?
7. Volume: is today's volume above 150% of the 20-day average?

Score each stock 0-7 based on how many criteria it meets.
Rank and show me the top 10 candidates.
Flag any with a score of 5 or higher as HIGH PRIORITY.

For each HIGH PRIORITY candidate, build a trade plan:
- Entry zone
- Stop loss
- Position size (1% portfolio risk max)
- What would trigger the squeeze
- What would indicate the squeeze is over (exit signal)

Show me the scan results. Do not execute anything.
```

## Trade plan for a squeeze candidate

```
SHORT SQUEEZE CANDIDATE -- [TICKER]

Setup score: [X]/7
Short interest: [X]% of float
Days to cover: [X]
Borrow cost: [X]%
Float: [X]M shares
OTM call OI: [X] relative to ADV

Price action: [Above/below] 20-day MA. [Breaking/below] resistance at $[X].
Volume: [X]% of 20-day average today.

What triggers the squeeze:
  Price breaks above $[RESISTANCE LEVEL] on high volume.
  Short sellers begin forced covering.

Trade plan:
  Entry zone: $[X] - $[Y] (within 3% of resistance break)
  Stop loss: $[Z] ([X]% below entry -- below breakout level)
  Position: [SHARES] shares = 1% portfolio risk
  Capital deployed: $[X]

Targets (scale out):
  Sell 1/3 at $[+15% from entry]
  Sell 1/3 at $[+30% from entry]
  Trail the rest at 10% below highest close

Exit signals (squeeze is done):
  - Volume collapses back to average or below
  - Short interest drops below 8%
  - Price closes below the initial breakout level

Type "go" to enter. Type "watch" to add to watchlist without entering.
```

## Watchlist monitoring

```
Add [TICKER] to the squeeze watchlist.

Monitor daily at 10:00 ET:
- Check if price has broken above the trigger level
- Check if volume is confirming the move
- Alert me immediately if a watchlist stock triggers

Save watchlist to ./strategies/squeeze-watchlist.json
```
