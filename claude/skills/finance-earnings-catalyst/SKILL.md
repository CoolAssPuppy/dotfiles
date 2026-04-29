---
user-invocable: true
disable-model-invocation: true
name: finance-earnings-catalyst
description: Complete earnings trade playbook. Pre-earnings setup, implied move analysis, strategy selection based on IV rank, execution, and post-earnings management. Compares implied vs historical moves to find edge. Weekly earnings calendar scan on Sundays.
---

# Earnings catalyst skill

## What this skill does

Runs a complete earnings trade playbook: pre-earnings setup, implied move analysis, strategy selection based on IV rank, execution, and post-earnings position management. Earnings are the single highest-volatility event in a stock's calendar. Professional desks prepare days in advance.

## How earnings moves work

Every quarter, a stock makes its biggest price move of the year in a single session. Options price in an "expected move" based on IV -- the market's collective bet on how far the stock will move in either direction. The edge comes from comparing that expected move to historical reality.

- **Market overpricing the move** (implied > historical): sell the expected move, collect premium as IV crushes after the announcement
- **Market underpricing the move** (implied < historical): buy the expected move, profit if the stock exceeds what options are pricing in
- **No edge** (implied = historical): skip it

## Pre-earnings analysis prompt

```
Run a full earnings analysis for [TICKER] reporting on [DATE].

1. EARNINGS SETUP
   - Reporting date and time (before/after market)
   - Analyst consensus EPS estimate and revenue estimate
   - Whisper number (what the market actually expects vs consensus)
   - Last 4 quarters: actual EPS vs estimate, revenue vs estimate, stock move day after

2. IMPLIED MOVE
   - Current ATM IV for the expiration immediately after earnings
   - Implied move in dollars and percent (formula: ATM straddle price / stock price)
   - Historical earnings moves last 4 quarters: actual % move each time
   - Average historical move: [X]%
   - Today's implied move: [Y]%
   - Edge: [Implied > Historical -> sell / Implied < Historical -> buy / No edge -> skip]

3. IV ENVIRONMENT
   - IV rank right now: [X]/100
   - IV percentile: [X]/100
   - Expected IV crush after earnings: typically [X]% drop in IV
   - Higher IV rank = more premium to collect if selling

4. STRATEGY SELECTION
   Based on edge and IV rank, recommend one:

   a) SELL THE MOVE (implied > historical, IV rank 50+):
      - Iron condor: sell OTM call + sell OTM put, buy wings further out
      - Short strangle: sell OTM call + sell OTM put (undefined risk -- only if authorized)
      - Use the +/-[implied move %] as your short strikes

   b) BUY THE MOVE (implied < historical, IV rank 30-):
      - Long straddle: buy ATM call + buy ATM put, same strike, same expiration
      - Long strangle: buy OTM call + OTM put (cheaper, wider breakevens)
      - Use the expiration just after earnings

   c) DIRECTIONAL BET (if you have a strong view on direction):
      - Debit spread: buy ATM call/put, sell OTM call/put as defined-risk directional play
      - If bullish: call debit spread. If bearish: put debit spread.

5. SIZING
   - Max risk: 1% of total portfolio on any single earnings trade
   - Earnings are binary events. Size accordingly.

Show me the analysis and recommended strategy. Do not execute anything. Wait for my decision.
```

## Strategy structure guide

### Iron condor (sell the move)
```
Sell [implied move %] OTM call
Buy [implied move % + 2%] OTM call (protection)
Sell [implied move %] OTM put
Buy [implied move % + 2%] OTM put (protection)
Expiration: first available after earnings announcement
Max profit: total premium collected
Max loss: width of spread - premium collected
Break-even: short strikes +/- premium collected
```

### Long straddle (buy the move)
```
Buy ATM call
Buy ATM put
Same strike, same expiration (just after earnings)
Profit if stock moves more than the combined premium paid
Max loss: premium paid (if stock doesn't move)
```

### Call debit spread (directional bullish)
```
Buy ATM call
Sell OTM call [implied move %] above current price
Same expiration (just after earnings)
Max profit: width of spread - premium paid
Max loss: premium paid
```

## Post-earnings management

Run this immediately after the announcement:

```
Post-earnings review for [TICKER]:

1. Actual move: [X]%
2. My position status: [profit / loss / at max profit / at max loss]
3. Recommended action:
   - If iron condor: IV crushed, take profit if position is at 50%+ of max profit
   - If long straddle: has the position exceeded breakeven? If yes, exit half.
   - If still within range: hold to expiration unless position at 80%+ of max profit
4. Next catalyst for this stock: [date]
```

## Earnings calendar monitoring

```
Set up a weekly scan every Sunday at 18:00 ET.

Pull earnings announcements for the coming week.
Flag any stocks that:
- Are in my current portfolio (automatic review required)
- Are large cap stocks with historically large earnings moves (NVDA, TSLA, META, AAPL, AMZN, GOOGL, MSFT)
- Have unusual options activity in the week before earnings

Output a ranked list by expected move size. I will decide which ones to analyze further.
```
