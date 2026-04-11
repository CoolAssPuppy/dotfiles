---
user-invocable: true
name: finance-wheel
description: Runs the full three-phase options income cycle -- sell cash-secured puts, take assignment if necessary, sell covered calls. Picks strikes, monitors positions, rolls contracts, and closes early at 50% profit. Run finance-iv-rank first.
---

# Wheel strategy skill

## What this skill does

Runs the full three-phase options income cycle -- sell cash-secured puts, take assignment if necessary, sell covered calls -- automatically. Claude picks strike prices, monitors positions, rolls contracts when needed, and closes early when 50% profit is hit. You check in once a day and collect premiums.

The wheel works in any market direction. Up, down, sideways -- there is always a leg to run.

## How the wheel works (plain English)

**Stage 1 -- Sell puts (get paid to agree to buy)**

You pick a stock you actually want to own. You sell a put option below the current price. Someone pays you a premium for the right to sell you those shares at that price. Two outcomes:

- Stock stays above your strike: contract expires, you keep the premium, sell another one.
- Stock drops below your strike: you buy the shares. But your real cost is the strike price minus all the premiums collected.

**Stage 2 -- Sell covered calls (get paid while you hold)**

You now own 100 shares per contract. You sell a call option above your cost basis. Someone pays you a premium for the right to buy your shares at that price. Two outcomes:

- Stock stays below your strike: contract expires, you keep the premium and the shares, sell another call.
- Stock rises above your strike: your shares get sold at the strike. Take the profit and go back to Stage 1.

Every rotation, you collect premium. The wheel never stops paying.

## Setup prompt (paste this to activate)

```
Run a wheel strategy on [STOCK] using my Alpaca paper account.

My parameters:
- Target entry price (max I'd pay for shares): $[TARGET_PRICE]
- Number of contracts: [X] (each contract = 100 shares)
- Cash reserved for assignment: $[TARGET_PRICE * X * 100]

Stage 1 -- Sell puts:
- Strike: At or below $[TARGET_PRICE], delta 0.20-0.30
- Expiration: 21-45 DTE
- If the put expires worthless, sell another immediately
- If assigned, move to Stage 2

Stage 2 -- Sell covered calls:
- Strike: At or above my cost basis, delta 0.20-0.30
- Expiration: 21-45 DTE
- If the call expires worthless, sell another immediately
- If shares are called away, go back to Stage 1

Rules:
- Never sell a put without enough cash to cover full assignment
- Never sell a covered call below my cost basis
- If a contract hits 50% profit before expiration, close it early and reset
- Check positions every 15 minutes during market hours
- Send me a daily summary at 15:45 ET with: premium collected today, total premium collected, net cost basis, next action

Save the strategy config to ./strategies/wheel.json
Set the monitoring schedule now.

Show me the first trade plan before executing anything.
```

## Parameters reference

| Parameter | Recommended | Why |
|-----------|-------------|-----|
| DTE | 21-45 days | Sweet spot for theta decay without gamma risk |
| Delta | 0.20-0.30 | Out of the money -- premium without high assignment probability |
| Early close | 50% profit | Capture most of the premium, reset the clock faster |
| Strike (put) | 5-10% below current price | Discount entry on a stock you want |
| Strike (call) | 5-10% above cost basis | Income without selling too cheap |

## Cycle tracking

Claude maintains `./strategies/wheel.json` with:

```json
{
  "ticker": "TSLA",
  "stage": 1,
  "contracts": 2,
  "cost_basis": 225.00,
  "total_premium_collected": 1450.00,
  "net_cost_basis": 210.00,
  "current_position": {
    "type": "short_put",
    "strike": 230,
    "expiration": "2024-02-16",
    "premium_collected": 500,
    "current_value": 280,
    "profit_pct": 44
  },
  "history": []
}
```

## Daily summary format

```
WHEEL SUMMARY -- [TICKER] -- [DATE] 15:45 ET

Stage: [1/2]
Current position: [Short put / Covered call] $[STRIKE] exp [DATE]
Premium collected today: $[AMOUNT]
Total premium collected (all cycles): $[TOTAL]
Net cost basis: $[COST_BASIS - TOTAL_PREMIUM]

Status: [On track / Rolling / Early close triggered]
Next action: [Sell another put on expiration / Monitor / Roll to new strike]
```

## Exit rules

- If the stock drops 20% below average cost basis: stop selling calls, flag for user review
- If net cost basis reaches zero (premiums collected = full cost): position is free, log it
- Never sell a covered call below cost basis without explicit user authorization
