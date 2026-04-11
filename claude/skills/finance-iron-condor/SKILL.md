---
user-invocable: true
name: finance-iron-condor
description: Generates consistent income with defined-risk options spreads. Iron condors for range-bound markets, put credit spreads for bullish bias, call credit spreads for bearish bias. Requires IV rank 40+ for credit spreads, 50+ for condors. Includes rolling and management rules.
---

# Iron condor and credit spread skill

## What this skill does

Generates consistent income in range-bound or low-movement markets by selling defined-risk options spreads. Iron condors profit when a stock stays within a range. Credit spreads profit when a stock stays on one side of a level. Both strategies have capped loss, defined profit, and decay in your favor every day the stock doesn't move.

This is the strategy professional options desks run as a baseline income book -- not a moonshot, a paycheck.

## When to use this skill

**Use iron condors when:**
- IV rank is above 50 (options are expensive, premium decays fast)
- You expect the stock to stay in a range (earnings are over, no major catalyst expected)
- You want income that doesn't depend on direction

**Use put credit spreads when:**
- You are moderately bullish but want defined risk
- IV rank is above 40
- You want to generate income from a stock without owning it

**Use call credit spreads when:**
- You are moderately bearish but want defined risk
- IV rank is above 40
- You want to profit from a stock staying below a resistance level

## Iron condor setup prompt

```
Set up an iron condor on [TICKER].

Current price: $[PRICE]
IV rank: [X]/100 (must be 50+ to run this strategy -- check first)
Expected range: +/-[X]% over the next [DTE] days

Build the condor:
- Short call: [X]% above current price (delta ~0.15-0.20)
- Long call: [X + 2]% above current price (protection)
- Short put: [X]% below current price (delta ~0.15-0.20)
- Long put: [X + 2]% below current price (protection)
- Expiration: [21-45 DTE]

Show me:
1. Premium collected (total credit)
2. Max profit (premium collected)
3. Max loss (spread width - premium collected)
4. Breakeven prices (both sides)
5. Probability of profit (roughly 1 - both delta values combined)
6. Risk/reward ratio

Management rules:
- Close at 50% of max profit (do not get greedy)
- Close if position reaches 200% of max loss (cut losses fast)
- If one side is threatened (price within 1 strike of short strike): roll that side out in time or wider in strike
- Never let a condor go to expiration -- always close or roll at least 7 DTE

Sizing: risk no more than 2% of portfolio on this trade.

Show me the full structure. Wait for confirmation before executing.
```

## Put credit spread setup prompt

```
Set up a put credit spread on [TICKER].

Thesis: [TICKER] will stay above $[SUPPORT LEVEL] for the next [DTE] days.
IV rank: [X]/100 (must be 40+ -- check first)

Build the spread:
- Sell put at $[SUPPORT LEVEL] or just below (delta ~0.25-0.30)
- Buy put $[WIDTH] below that strike (protection, delta ~0.10)
- Expiration: [21-45 DTE]

Show me:
1. Net credit collected
2. Max loss (spread width - credit)
3. Breakeven price
4. Return on risk (credit / max loss)

Management:
- Close at 50% of max profit
- Close if underlying threatens the short put strike
- Do not sell puts below a major support level

Wait for confirmation before executing.
```

## The Greeks -- what they mean for these trades

| Greek | What it does | What it means for a condor |
|-------|--------------|---------------------------|
| Theta | Time decay -- options lose value every day | Works for you. Every day without movement = profit |
| Delta | Price sensitivity | You want near-zero delta -- no directional preference |
| Gamma | How fast delta changes | Enemy near expiration. Close early to avoid. |
| Vega | Sensitivity to IV changes | Works for you when IV drops after entry. Works against you if IV spikes. |

## Rolling a threatened position

If price moves toward one of your short strikes:

```
My iron condor on [TICKER] is threatened. Short [call/put] at $[STRIKE] is at risk.
Current price: $[PRICE]
DTE remaining: [X]

Options:
1. Roll the threatened side out in time (same strike, next expiration) -- collect more premium, buy more time
2. Roll the threatened side wider (same expiration, move short strike further from price) -- reduces premium but increases safety
3. Close the entire condor and take the loss -- cleanest option if you are wrong about direction

Show me the cost/benefit of each option. Do not act until I decide.
```

## Income tracking

Claude maintains `./strategies/condors.json`:

```json
{
  "active_positions": [],
  "closed_positions": [],
  "total_premium_collected": 0,
  "total_premium_kept": 0,
  "win_rate": 0,
  "average_return_on_risk": 0
}
```

Monthly summary every last Friday at 15:00 ET:
- Trades opened and closed
- Win rate
- Total premium collected vs kept
- Best and worst trade of the month
