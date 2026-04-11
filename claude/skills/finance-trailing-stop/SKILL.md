---
user-invocable: true
name: finance-trailing-stop
description: Buys a position, sets a hard stop loss floor, and runs a ratcheting trailing stop that locks in gains as the price climbs. Includes optional ladder-in logic to average down at preset levels. Monitors every 5 minutes during market hours via cron.
---

# Trailing stop skill

## What this skill does

Buys a position, sets a hard stop loss floor, and runs a ratcheting trailing stop that locks in gains as the price climbs. Includes optional ladder-in logic to average down at preset levels instead of panic-selling into weakness.

A cron job monitors the position every 5 minutes during market hours and adjusts the floor automatically. You never have to watch it.

## Setup prompt (paste this to activate)

```
Run a trailing stop strategy on [STOCK].

Buy [X] shares at market price right now using my Alpaca paper account.

Rules:

FLOOR: If the stock drops [FLOOR_PCT]% from my fill price, sell everything. That is my stop loss. Max loss I accept on this trade.

TRAILING FLOOR: Once the stock is up [TRIGGER_PCT]% from my fill price, move the stop loss floor up to [TRAIL_PCT]% below the current price. Every time it climbs another [STEP_PCT]%, move the floor up again. The floor only moves up. It never moves down.

LADDER IN (optional): If the stock drops [DIP_1]% from fill price, buy [SHARES_1] more shares. If it drops [DIP_2]%, buy [SHARES_2] more shares. This averages my cost down on dips instead of just sitting in a loss.

After you set this up:
1. Show me a confirmation summary before any order is placed
2. Wait for me to say "go" before executing
3. Set a schedule to check this every 5 minutes during market hours
4. Save the strategy config to ./strategies/trailing-stop.json
```

## Default parameters (change any of these)

| Parameter | Default | What it means |
|-----------|---------|---------------|
| FLOOR_PCT | 10% | Max loss before stop triggers |
| TRIGGER_PCT | 10% | Gain required before trailing begins |
| TRAIL_PCT | 5% | Floor sits this far below current price |
| STEP_PCT | 5% | Each time stock climbs this much, floor ratchets up |
| DIP_1 | 15% | First ladder-in trigger |
| SHARES_1 | 10 | Shares bought at first dip |
| DIP_2 | 25% | Second ladder-in trigger |
| SHARES_2 | 20 | Shares bought at second dip |

## What the monitoring schedule does

Every 5 minutes during market hours, the schedule:

1. Fetches current price
2. Compares to the last recorded floor
3. If current price triggers a floor ratchet: places updated stop order on Alpaca
4. If current price hits the floor: sells all shares, logs exit to `./portfolio-log.md`, cancels schedule
5. If a ladder-in trigger is hit: places buy order, updates cost basis, adjusts floor to reflect new average

## Confirmation summary Claude shows before execution

```
TRAILING STOP PLAN -- [TICKER]

Entry:
  Shares: [X]
  Est. fill price: $[PRICE]
  Total capital at risk: $[X * PRICE]

Stop loss floor:
  Trigger price: $[FLOOR]
  Max loss: $[FLOOR_LOSS] ([FLOOR_PCT]%)

Trailing stop activates at:
  Price: $[TRIGGER_PRICE] (+[TRIGGER_PCT]%)
  Floor moves to: $[TRAIL_FLOOR] ([TRAIL_PCT]% below current)

Ladder-in levels:
  Dip 1: $[DIP_1_PRICE] -> buy [SHARES_1] shares
  Dip 2: $[DIP_2_PRICE] -> buy [SHARES_2] shares

Monitoring: Every 5 min, Mon-Fri 09:30-16:00 ET

Type "go" to execute. Type "change [parameter]" to adjust anything.
```

## Scenario guide

Ask Claude any of these before going live:

- "What happens if [STOCK] shoots up 30% tomorrow?"
- "What happens if it drops 20% on day one?"
- "What is my total risk if both ladder-ins trigger and then the floor hits?"
- "Show me the best-case and worst-case P&L for this trade."
