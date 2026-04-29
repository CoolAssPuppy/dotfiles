---
user-invocable: true
disable-model-invocation: true
name: finance-risk-of-ruin
description: Calculates probability of account blowup given win rate, win/loss ratio, and position sizing. Uses Kelly criterion for optimal sizing. Monthly review of trading system sustainability. Survival arithmetic -- not optional.
---

# Risk of ruin skill

## What this skill does

Calculates your exact probability of blowing up your account given your win rate, average win/loss ratio, and position sizing. Identifies if your current system is mathematically sustainable or if you are slowly grinding toward zero. One number -- risk of ruin -- tells you whether your trading system survives long-term or eventually destroys the account.

This is not optional. It is survival arithmetic.

## The math professionals use

**Risk of ruin** is the probability that a sequence of losses will deplete your account to zero (or to a point you cannot recover from) given a fixed betting size and win rate.

The simplified formula:

```
R = ((1 - Edge) / (1 + Edge)) ^ N

Where:
  Edge = (Win rate x Avg win) - ((1 - Win rate) x Avg loss) / Avg loss
  N = number of betting units in your account
  R = probability of ruin
```

More practically: if your edge is thin and your position sizes are too large relative to your account, ruin is not a possibility -- it is a mathematical certainty given enough trades.

**Kelly criterion** tells you the mathematically optimal position size to maximize long-term growth without risking ruin:

```
Kelly % = Win rate - ((1 - Win rate) / Win/loss ratio)
```

Most professionals use half-Kelly (50% of the Kelly output) as their max position size to account for model uncertainty.

## Setup prompt (run this monthly)

```
Run a risk of ruin analysis on my trading system.

Pull my trade history from ./portfolio-log.md.

Calculate:
1. PERFORMANCE STATISTICS
   - Total trades: [X]
   - Win rate: [X]% (wins / total trades)
   - Average winning trade: $[X]
   - Average losing trade: $[X]
   - Win/loss ratio: [avg win / avg loss]
   - Largest single loss: $[X] ([X]% of portfolio at time)
   - Longest losing streak: [X] consecutive losses

2. EDGE CALCULATION
   - Mathematical edge per trade: [(Win rate x avg win) - (Loss rate x avg loss)] / avg loss
   - If edge is negative: the system loses money over time. Stop. Reassess.
   - If edge is positive: the system is viable. Calculate risk of ruin.

3. KELLY CRITERION
   - Full Kelly position size: [X]% of portfolio per trade
   - Half-Kelly (recommended): [X]% of portfolio per trade
   - My current average position size: [X]%
   - Assessment: [Oversized / Correctly sized / Undersized]

4. RISK OF RUIN
   - At current position sizing: [X]% probability of 50% drawdown
   - At current position sizing: [X]% probability of 75% drawdown (effectively ruined)
   - At half-Kelly sizing: [X]% probability of 50% drawdown
   - Safe zone: position sizing where ruin probability is below 5%

5. MAX DRAWDOWN SIMULATION
   - Given my win rate and average loss, what is the expected worst losing streak in 100 trades?
   - What would [X] consecutive losses do to my account at current position sizing?
   - At what position size would [X] consecutive losses be survivable without destroying the account?

6. RECOMMENDATIONS
   - Current system: [Viable / Marginal / Unsustainable]
   - Position size adjustment: [Increase / Maintain / Reduce to X%]
   - Win rate improvement needed: [None / Need to reach X% to be viable]
   - One specific change that would most improve long-term survival

Output this analysis in full. Do not sugarcoat. If the system is broken, say so.
```

## Risk of ruin reference table

| Win rate | Win/loss ratio | Max safe position size | Risk of ruin at 2% size |
|----------|----------------|------------------------|-------------------------|
| 40% | 2.0x | 3% | Very low |
| 40% | 1.5x | 1.5% | Low |
| 40% | 1.0x | Negative edge -- do not trade | Certain ruin eventually |
| 50% | 1.5x | 5% | Very low |
| 50% | 1.0x | 0% -- break even, no edge | Ruin from costs alone |
| 60% | 1.0x | 2% | Low |
| 60% | 1.5x | 8% | Negligible |

## Consecutive loss survival test

Before starting any new strategy, run this:

```
Survival test for [STRATEGY NAME]:

My account size: $[X]
Position size I plan to use: [Y]%
My expected win rate for this strategy: [Z]%

1. How many consecutive losses can I absorb before losing 25% of my account?
2. How many consecutive losses before losing 50%?
3. What is the probability of [X] consecutive losses at my expected win rate?
4. Is my position size survivable through a realistic losing streak?

Show me the numbers. If the position size is not survivable, tell me what the maximum safe size is.
```

## Monthly review schedule

```
Run a risk of ruin update on the first Saturday of every month at 10:00 ET.

Recalculate all statistics using the updated trade log.
Flag any deterioration: if win rate or win/loss ratio has declined month-over-month, alert.
Flag any oversizing: if any strategy is running above half-Kelly, alert.
Output a one-page summary. Save to ./risk-review-[MONTH].md
```
