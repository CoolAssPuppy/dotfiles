---
user-invocable: true
name: finance-copy-trading
description: Tracks congressional stock disclosures on Capitol Trades and hedge fund 13F filings. Identifies highest-conviction active traders, sizes and times positions that mirror their moves, and monitors on a daily schedule.
---

# Copy trading skill

## What this skill does

Tracks congressional stock disclosures on Capitol Trades and hedge fund 13F filings, identifies the highest-conviction active traders, sizes and times positions that mirror their moves, and monitors them on a schedule. You get the information edge without doing the research yourself.

## Why this works

Members of Congress are required by law to disclose stock trades within 45 days under the STOCK Act. The data shows they consistently beat the market. They sit on regulatory committees, get briefed on policy changes before the public, and know which companies are about to receive government contracts or face investigation.

The 45-day disclosure delay matters, but most congressional positions are held months to years -- not days. Getting in 45 days late still captures most of the move.

## Setup prompt (paste this to activate)

```
Set up a copy trading bot using Capitol Trades (https://www.capitoltrades.com).

Using my Alpaca paper account:

Step 1 -- Find the best trader to follow:
- Scrape Capitol Trades for the last 90 days of congressional trades
- Rank by: return on disclosed trades, recency of activity, trade frequency, consistency of gains
- Show me the top 3 candidates with their stats before picking one
- Wait for me to confirm the target politician before proceeding

Step 2 -- Copy their open positions:
- For each of their currently active trades, evaluate:
  a) How old is the disclosure? (flag if >30 days old)
  b) Is the thesis still intact based on current price vs their entry?
  c) What sector is this? Do I already have concentration risk there?
- Size each position at maximum 2% portfolio risk
- Never put more than 5% of portfolio in a single ticker
- Show me the full trade plan for each position before executing

Step 3 -- Monitor for new disclosures:
- Check Capitol Trades every day at 09:15 ET for new filings from our target politician
- If a new trade appears: evaluate it, size it, show me the plan, wait for my confirmation
- If they sell a position we're copying: flag it immediately and ask if I want to exit

Step 4 -- Performance tracking:
- Compare our copy portfolio P&L vs S&P 500 benchmark weekly
- Log every trade to ./portfolio-log.md with the politician's trade as context

Save the monitoring schedule to ./schedules/ and the strategy config to ./strategies/copy-trading.json

Show me the top 3 candidates first. Do not execute any trades until I confirm.
```

## Trader selection criteria

Claude scores each politician on these factors:

| Factor | Weight | What good looks like |
|--------|--------|---------------------|
| Return on disclosed trades (last 90 days) | 40% | Beating S&P by 10%+ |
| Recency of activity | 25% | Trading within last 30 days |
| Trade frequency | 20% | Active enough to follow (5+ trades/quarter) |
| Consistency | 15% | Not one lucky trade -- a pattern |

## Position sizing for copy trades

Never copy blindly. Use this framework for every position:

1. **Staleness check**: If disclosure is >30 days old, flag for review. If >45 days, require explicit user approval.
2. **Thesis check**: Is the stock above or below their disclosed entry? Has anything material changed in the sector?
3. **Risk sizing**: Risk no more than 2% of total portfolio. Calculate share count from stop loss distance.
4. **Concentration check**: Does this push any sector above 20%? If yes, reduce size or skip.

Formula:
```
Shares = (Portfolio x 0.02) / (Entry price - Stop loss price)
Stop loss = 8% below entry (default) or at nearest support level
```

## Daily monitoring routine (09:15 ET)

```
COPY TRADING BRIEF -- [DATE]

Tracking: [POLITICIAN NAME]
Last disclosure: [DATE] ([X] days ago)

New filings since yesterday: [None / LIST]

Open copy positions:
  [TICKER] | Entered $[X] | Now $[Y] | P&L [Z]% | Their position: [Still open / Closed]

Portfolio vs S&P (since inception):
  Copy portfolio: +[X]%
  S&P 500: +[Y]%
  Alpha: +[Z]%

Action required: [None / New trade to evaluate / Position closed by politician]
```

## Confirmation before every trade

```
COPY TRADE PLAN -- [TICKER]

Source: [POLITICIAN] disclosed [BUY/SELL] on [DATE] ([X] days ago)
Their disclosed price range: $[LOW] - $[HIGH]
Current price: $[NOW]
Price since disclosure: [+X% / -X%]

Thesis still intact: [YES / FLAG -- reason]
Sector concentration after this trade: [X]% (limit 20%)

My entry: $[PRICE]
Stop loss: $[STOP] ([X]% below entry)
Max loss: $[DOLLARS]
Position size: [X] shares ([Y]% of portfolio)

Type "go" to execute. Type "skip" to pass on this one.
```
