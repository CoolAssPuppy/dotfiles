---
user-invocable: true
name: finance-momentum-breakout
description: Identifies and executes high-probability breakout setups using a five-condition checklist (trend, consolidation, volume dry-up, resistance, volume surge). Tiered exits at 10%, 20%, and trailing remainder. IBD/William O'Neil methodology.
---

# Momentum breakout skill

## What this skill does

Identifies and executes high-probability breakout setups using a five-condition checklist -- the same entry logic used by IBD-style growth traders and quantitative momentum funds. Tiered exits at 10%, 20%, and a trailing remainder mean you capture the full move without giving it all back.

One rule above everything else: **never chase. If you missed it, you missed it.**

## The five conditions (all must be true)

| # | Condition | What to check | Why it matters |
|---|-----------|---------------|----------------|
| 1 | Trend | Above 50-day AND 200-day MA | Momentum requires a rising base |
| 2 | Consolidation | Tight range for 10+ trading days | Energy is coiling |
| 3 | Volume dry-up | Volume below 20-day average during consolidation | Sellers are exhausted |
| 4 | Clear resistance | Price rejected at this level at least twice before | Known ceiling that now becomes floor |
| 5 | Volume surge | Breakout day volume >= 150% of 20-day average | Institutions are buying -- this is the signal |

If any condition is missing: **no trade**.

## Setup prompt (paste this to activate)

```
Run a momentum breakout scan on [TICKER or LIST OF TICKERS].

For each ticker, check all five conditions:
1. Is price above both the 50-day and 200-day moving average?
2. Has the stock been in a tight consolidation range for at least 10 trading days?
3. Is volume during consolidation below the 20-day average?
4. Is there a clear prior resistance level the stock has rejected at least twice?
5. Did the breakout candle close above resistance on volume >= 150% of the 20-day average?

Only proceed if all five are true. If any condition fails, explain which one and why -- then stop.

If all five pass, build the trade plan:

Entry:
- Buy zone: Within 3% above the breakout level
- If stock is already more than 3% above the breakout: wait for first pullback to the breakout level (now support), then evaluate again

Position sizing:
- Risk exactly 1% of total portfolio on this trade
- Stop loss = low of the consolidation base
- Shares = (Portfolio x 0.01) / (Entry price - Stop loss price)
- Show me the math

Profit taking (tiered -- never sell everything at once):
- Sell 1/3 at +10% from entry
- Sell 1/3 at +20% from entry
- Trail the final 1/3 with a stop at 8% below the highest closing price reached

Stop loss rules:
- Initial stop: low of the consolidation base
- After +10% gain: move stop to breakeven -- never lose money on a winner
- After +20% gain: trail at 8% below highest close

Show me the full plan. Wait for "go" before executing.
Set a daily check during market hours to monitor the position and update trailing stops.
```

## What Claude shows before execution

```
MOMENTUM BREAKOUT PLAN -- [TICKER]

Setup check:
  [x] Trend: Above 50-day ($[X]) and 200-day ($[Y])
  [x] Consolidation: [X] days in $[LOW]-$[HIGH] range
  [x] Volume dry-up: Avg [X]K vs 20-day avg [Y]K during base
  [x] Resistance level: $[LEVEL] (rejected [X] times)
  [x] Breakout volume: [X]K = [Y]% of 20-day average

All five conditions: PASS

Entry plan:
  Breakout level: $[LEVEL]
  Current price: $[NOW]
  Valid entry zone: $[LEVEL] -- $[LEVEL * 1.03]
  Status: [In zone / Extended -- wait for pullback]

Position:
  Portfolio: $[TOTAL]
  Risk (1%): $[RISK]
  Stop loss: $[STOP] (consolidation base low)
  Stop distance: $[DIST] ([X]%)
  Shares: [RISK / DIST] = [X] shares
  Capital deployed: $[X * ENTRY]

Profit targets:
  Target 1 (+10%): $[PRICE] -> sell [SHARES/3] shares
  Target 2 (+20%): $[PRICE] -> sell [SHARES/3] shares
  Target 3: trail at 8% below highest close -> sell remaining [SHARES/3]

Type "go" to execute. Type "wait" to hold for pullback.
```

## Failure rules

Exit immediately (no waiting) if:
- Price closes back below the breakout level in the first 5 trading days -- the breakout failed
- The setup had a technical error (wrong volume read, false resistance level)

These are not losses. They are the strategy working correctly. Small, fast losses keep capital available for the next setup.
