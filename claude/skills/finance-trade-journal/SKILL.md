---
user-invocable: true
name: finance-trade-journal
description: Structured logging of every trade -- thesis, entry, emotion state, outcome, and lessons. Weekly performance review every Friday at 15:30 ET identifies losing patterns. Monthly deep review with Sharpe ratio and streak analysis.
---

# Trade journal and performance review skill

## What this skill does

Forces structured logging of every trade -- thesis, entry, emotion state, outcome, and lessons learned. Runs a weekly performance review that identifies losing patterns before they compound. Every professional trader reviews their book. The journal is where improvement actually happens.

## Why this matters

You cannot fix what you do not track. Most retail traders lose the same money the same way for years. They overtrade at the open. They hold losers too long. They cut winners early. They trade bigger when they're up, which means they give it all back when the inevitable bad trade hits. The journal surfaces these patterns in black and white.

## Setup prompt (paste once to activate)

```
Set up a trade journal system.

Every time I place a trade, immediately after execution, prompt me with this:

TRADE LOG -- [TICKER] -- [DATE] [TIME]

1. Thesis (1-3 sentences): Why am I making this trade? What has to be true for it to work?
2. Setup quality (1-5): How clean was the setup? Was I stretching to find a reason?
3. Emotion state: [Calm / Excited / Anxious / Revenge trading / FOMO / Other]
4. Risk defined: [YES / NO] -- Is the stop loss set?
5. Sizing: Is this within my position sizing rules? [YES / NO]

Save my answers to ./portfolio-log.md in the format below.

Also log automatically:
- Entry price
- Stop loss price
- Target price
- Strategy used
- IV rank at entry (if options)

When I close a trade, log:
- Exit price
- P&L in dollars and percent
- Result vs original thesis: [Thesis worked / Thesis wrong / Stopped out / Exited early]
- Lesson (1 sentence): What would I do differently?
```

## Trade log entry format

```
TRADE ENTRY -- [TICKER] -- [DATE] [TIME ET]

Strategy: [Trailing stop / Wheel / Momentum breakout / Options flow / Other]
Direction: [Long / Short / Neutral]

Entry: $[PRICE]
Stop loss: $[PRICE] ([X]% risk)
Target: $[PRICE] ([Y]% gain)
Shares/contracts: [X]
Capital at risk: $[X] ([Y]% of portfolio)
IV rank at entry: [X]/100 (if options)

Thesis:
  [User input]

Setup quality: [1-5]
Emotion state: [User input]
Rules check: [All clear / Flagged: reason]

TRADE EXIT -- [DATE] [TIME ET]

Exit: $[PRICE]
P&L: $[X] ([Y]%)
Hold time: [X] days

Thesis outcome: [Worked / Wrong / Stopped out / Exited early]
Lesson: [User input]
```

## Weekly performance review

Runs every Friday at 15:30 ET, after market close.

```
WEEKLY PERFORMANCE REVIEW -- Week of [DATE]

RESULTS
  Trades: [X] total | [X] wins | [X] losses | Win rate: [X]%
  Total P&L: $[X] ([Y]% of portfolio)
  Best trade: [TICKER] +$[X]
  Worst trade: [TICKER] -$[X]
  Average win: $[X] | Average loss: $[X]
  Win/loss ratio: [X] (must be above 1.5 to be sustainable)

PORTFOLIO
  Total value: $[X]
  Weekly change: [X]%
  vs S&P 500 this week: [+/-X]% alpha

PATTERN ANALYSIS (based on all journal entries)

  By emotion state:
    Calm trades: Win rate [X]%
    Excited/FOMO trades: Win rate [X]%
    Anxious trades: Win rate [X]%
    -> [Flag if non-calm trades underperform significantly]

  By time of day:
    First 30 min (9:30-10:00): Win rate [X]%
    Midday (10:00-14:00): Win rate [X]%
    Last hour (15:00-16:00): Win rate [X]%
    -> [Flag any time slot with win rate below 40%]

  By strategy:
    [Strategy name]: [X] trades, [X]% win rate, avg P&L $[X]
    -> [Flag any strategy underperforming]

  By setup quality (1-5):
    Setups rated 4-5: Win rate [X]%
    Setups rated 1-3: Win rate [X]%
    -> [Flag if low-quality setups are being taken frequently]

NEXT WEEK
  Patterns to watch: [Auto-generated from analysis]
  Rule to reinforce: [Auto-generated]
  Max trades allowed next week: [Based on this week's discipline score]
```

## Monthly deep review

First Saturday of each month, Claude generates:

- Total P&L vs S&P benchmark since inception
- Sharpe ratio estimate (return per unit of risk taken)
- Longest winning streak and losing streak
- Biggest single-day loss (drawdown awareness)
- Top 3 lessons from the month's journal entries
- One rule to add, change, or remove from the trading system based on the data
