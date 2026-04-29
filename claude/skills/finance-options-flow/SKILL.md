---
user-invocable: true
disable-model-invocation: true
name: finance-options-flow
description: Reads the options tape like an institutional desk. Identifies unusual options activity, dark pool prints, gamma squeeze setups, and put/call ratios. Classifies each print as directional bet, hedge, or synthetic positioning. Intelligence layer, not execution.
---

# Options flow reading skill

## What this skill does

Reads the options tape the way institutional desks do. Identifies unusual options activity -- large block trades, dark pool prints, abnormal volume on specific strikes -- and classifies each print as a directional bet, a hedge, or synthetic positioning. Tells you what trade, if any, it implies.

This is the single biggest informational edge retail traders ignore. When a hedge fund buys $10M in calls on a stock, they did not flip a coin. Options flow is institutional footprints. Learn to read them.

## Concepts you need to know

**Unusual options activity**: Volume on a specific strike/expiration is materially higher than open interest, with no obvious news catalyst. Something is driving that. Worth investigating.

**Dark pool prints**: Large block trades executed off public exchanges to avoid moving the market. When these appear, a fund moved a significant position. The question is: is it accumulation, distribution, or a hedge?

**Gamma squeeze setup**: A stock with high short interest + large open interest in out-of-the-money calls. If the stock moves up, market makers must buy shares to hedge their short call exposure, which pushes the price higher, which forces more buying. Self-reinforcing. Violent when it triggers.

**Put/call ratio**: A ratio below 0.7 is bullish (more call buying than put buying). Above 1.2 is bearish. Extremes in either direction can be contrarian signals.

**IV rank**: Where current implied volatility sits relative to its 52-week range. 0 = historically low. 100 = historically high. High IV rank = sell premium. Low IV rank = buy options.

## Setup prompt (paste this to activate)

```
Analyze options flow for [TICKER or "the market broadly"].

Pull the following data using Alpaca market data or any available options feed:

1. UNUSUAL ACTIVITY SCAN
   - Find strikes where today's volume is more than 3x open interest
   - Flag any single trade over $500K in premium
   - Note whether activity is concentrated in calls or puts
   - Note whether trades are buys (ask side) or sells (bid side)

2. CLASSIFY EACH UNUSUAL PRINT
   For each flagged trade, determine:
   a) Is this a directional bet? (aggressive buy on ask, short-dated, OTM)
   b) Is this a hedge? (deep ITM, long-dated, against a known large stock position)
   c) Is this a synthetic position? (complex spread that implies a directional view without naked exposure)
   Explain your reasoning in plain English.

3. GAMMA SQUEEZE SCREEN
   Check if [TICKER] has:
   - Short interest above 15% of float
   - Large open interest in OTM calls relative to average daily volume
   - Market makers likely net short calls (negative gamma)
   If all three: flag as gamma squeeze candidate and explain what would trigger it

4. PUT/CALL RATIO
   - Current P/C ratio for [TICKER]
   - 20-day average P/C ratio
   - Is current reading extreme? What does it suggest?

5. IV RANK
   - Current IV: [X]%
   - 52-week IV range: [LOW]% - [HIGH]%
   - IV rank: [X] out of 100
   - Implication: [Sell premium / Buy options / Neutral]

6. TRADE IMPLICATION
   Based on all of the above:
   - What is the smart money positioning suggesting?
   - What trade, if any, does the flow imply?
   - What is the risk of acting on this signal? (flow can be a hedge -- not always directional)

Show me the analysis. Do not place any trade. This is intelligence, not an order.
```

## Flow signal classification

| Signal | What it looks like | Implication |
|--------|--------------------|-------------|
| Sweep -- call buys, OTM, short-dated | Large buy hitting multiple exchanges simultaneously | Aggressive directional -- someone wants exposure fast |
| Block print -- deep ITM calls | Single large trade, deep in the money, long-dated | Likely a hedge against existing short position. Not necessarily bullish |
| Put spread buy | Buy near-term put, sell further OTM put | Defined-risk downside protection. Institutional hedging. |
| Ratio spread | Unusual leg structure, more sells than buys | Complex positioning -- do not read as simple bullish/bearish |
| Dark pool block + no news | Large print appears with no obvious catalyst | Watch for follow-through over next 2-5 days. The news comes later. |

## Using flow as confirmation, not signal

Flow is context, not a trigger. Never trade on flow alone. Use it to:

- **Confirm a setup you already have**: You see a breakout forming AND you see unusual call buying. That is an A+ setup.
- **Challenge a setup you're in**: You're long and you see institutional put buying. That is a flag. Do not ignore it.
- **Identify the regime**: Is the market broadly in call-buying or put-buying mode today? That affects every position you have.

## Daily flow scan (optional schedule)

```
Add a daily options flow scan at 10:30 ET and 14:00 ET.

At each scan:
- Check flow on all my open position tickers
- Flag any unusual activity that contradicts my current positioning
- Flag any gamma squeeze candidates in the Russell 2000 (high squeeze potential universe)
- Output a 5-line summary. No action unless I request it.
```
