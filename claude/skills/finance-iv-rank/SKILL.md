---
user-invocable: true
name: finance-iv-rank
description: Pre-trade volatility filter for all options trades. Calculates IV rank, IV percentile, term structure, and skew to determine whether to buy or sell premium. Run this before any options strategy. Includes earnings IV spike protocol.
---

# IV rank and volatility filter skill

## What this skill does

Tells you what the options market is pricing in for a stock -- and whether that's cheap or expensive relative to history. One number (IV rank) changes your entire strategy. High volatility: sell premium. Low volatility: buy options. This filter runs before any options trade.

Professional desks never put on an options trade without checking this. It is the first question, not the last.

## The core concept

**Implied volatility (IV)** is what the options market expects the stock to move. It is priced into every option you buy or sell.

**IV rank** tells you where current IV sits relative to its 52-week range:

```
IV Rank = (Current IV - 52-week low IV) / (52-week high IV - 52-week low IV) x 100
```

- IV rank of 80+: volatility is historically high. Options are expensive. **Sell premium.**
- IV rank of 20-: volatility is historically low. Options are cheap. **Buy options.**
- IV rank of 20-80: neutral. Use strategy that fits the directional view, not the vol view.

**IV percentile** is the % of trading days in the past year where IV was below today's level. More precise than IV rank for skewed distributions. Both matter.

## Setup prompt (paste this to activate)

```
Before any options trade I consider, run this volatility analysis on [TICKER]:

1. CURRENT IV
   - At-the-money IV for the nearest monthly expiration
   - 52-week IV high and low
   - IV rank (0-100)
   - IV percentile (0-100)

2. TERM STRUCTURE
   - Is IV higher in near-term expirations than long-term? (backwardation = fear/event-driven)
   - Is IV lower in near-term than long-term? (contango = normal, calm market)
   - Note any kinks in the term structure (earnings dates, known events)

3. SKEW
   - Are puts trading at significantly higher IV than calls? (negative skew = hedging demand, fear)
   - Are calls trading at higher IV than puts? (positive skew = speculative call buying)
   - Skew direction matters for strategy selection

4. STRATEGY IMPLICATION
   Based on IV rank and skew, recommend:
   - IV rank 70+: prefer selling strategies (short put, covered call, iron condor, credit spread)
   - IV rank 30-: prefer buying strategies (long call, long put, debit spread, calendar spread)
   - IV rank 30-70: use strategy based on directional bias, not vol edge

5. SIZING ADJUSTMENT
   - High IV environments: reduce position size by 20% (options can move against you fast)
   - Low IV environments: standard sizing is fine -- premium is cheap, losses are capped

Show me this analysis for [TICKER]. Do not place any trade. This is a pre-trade filter.
```

## IV rank strategy guide

| IV Rank | Regime | Preferred strategies |
|---------|--------|----------------------|
| 80-100 | Elevated -- crush is likely | Short straddle, iron condor, credit spread, short put |
| 60-80 | Above average -- sell bias | Covered call, cash-secured put, put credit spread |
| 40-60 | Neutral | Direction-based -- use debit spread for defined risk |
| 20-40 | Below average -- buy bias | Debit spread, calendar spread, diagonal |
| 0-20 | Low -- options cheap | Long calls, long puts, long straddle for earnings |

## Earnings IV spike -- specific protocol

Before any earnings play, run this:

```
Earnings IV analysis for [TICKER] reporting [DATE]:

1. Current ATM IV for the expiration just after earnings
2. Historical IV at same point before last 4 earnings
3. Average IV crush after earnings (how much IV drops after the announcement)
4. Implied move: what the market is pricing in as the expected earnings move
5. Historical earnings moves: actual move for last 4 quarters
6. Edge analysis:
   - If implied move > avg historical move: sell the expected move (iron condor, strangle)
   - If implied move < avg historical move: buy the expected move (straddle, strangle)
   - If no edge: skip the trade

Show me the analysis. Do not execute anything.
```

## Integrate with other skills

This skill feeds into:
- **finance-wheel**: Always check IV rank before selecting wheel strikes. High IV = better premium, wider strikes.
- **finance-options-flow**: Flow reads differently at high vs low IV. A big call buy in low-IV means someone expects a move. Same buy in high-IV may just be hedging.
- **finance-earnings-catalyst**: IV rank determines whether you sell or buy the earnings move.
- **finance-iron-condor**: Only run these when IV rank is above 50.
