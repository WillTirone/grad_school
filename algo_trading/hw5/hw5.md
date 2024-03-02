(5 pts) Use QC’s Universe Selections find the top 3 stocks (my market capitalization) in the FinancialServices Sector, and they form 6 distinct pairs. 
Note: Pay attention to the stock tickers and what underlying company they represent. If two of the tickers represent the same company, then you may only use one of the tickers. That is, if your top 3 stocks consist of 2 stocks representing the same company, then you should use only one of them (either is fine) and get the top 4 instead for the third stock. 

Code is in 5.1.py

Tickers were BAC, BRK.B, and JPM

backtest : https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_ab1ad2106fb1be950a983cd6ac20ca36.html

(5 pts) For the period between 1/1/2018 – 1/1/2019, compute the ADFs of the daily returns for each of the pairs. Find the pair {ABC, XYZ} with the lowest ADF and the pair (CDE, UVW) with the highest ADF for the period?

Code is in 5.2.py. For each of the pairs I just manually changed the strings in the pairs variable, so just providing one backtest. This is also the ADF for the first date of the backtest period, 1/3/2018 since the date wasn't specified.

Example of backtest: 

BAC/BRK.B: ADF for BAC and BRK.B : -0.2742272990120326; p-value : 0.9290760328043335
BAC/JPM: ADF for BAC and JPM : -3.9830785876931203; p-value : 0.001501755177663543
BRK.B/BAC: 	ADF for BRK.B and BAC : -1.8341864666030638; p-value : 0.3636259500644374
BRK.B/JPM: ADF for BRK.B and JPM : -1.7451275755940112; p-value : 0.40802406945151304
JPM/BRK.B: ADF for JPM and BRK.B : -1.7719401551194325; p-value : 0.394478896635718
JPM/BAC: ADF for JPM and BAC : -3.936343098485716; p-value : 0.0017830794503334991

The lowest is BAC and JPM and the highest is BAC and BRK.B

(10 pts) With $1M starting capital, assume that the pair {ABC, XYZ} has the lowest ADF, write a pairs trading strategy as stated on slide 136 with entry threshold = 2, and exit threshold at 0, and lookback period = 20 days. Find the backtest return and Sharpe Ratio for the period 1/1/2018 – 1/1/2020.

Using BAC / JPM. Code is in 5.3.py.

Backtest: https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_5d4039460a685ef1a460e116c46af4b5.html

Sharpe: -0.301
Return (Unrealized): $-8,168.73

(5 pts) Repeat #3 for the pair with the highest ADF. Compare the performance statistics in terms of return, drawdown and Sharpe Ratio. Does lower ADF show better performance in this case? 

Using BAC / BRK.B. Code is in 5.3.py (but with changed tickers)

Sharpe: -0.556
Net Profit: $-59,885.96

Backtest: https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_4f1dfa26af5bcf3896909d34b36aa734.html

The lower ADF does seem to perform better.

(10 pts) In #4, implement the following risk management condition. You liquidate all positions when absolute value of zscore > 3. What is the return, drawdown and sharpe ratio if you impose this risk management condition?

Code is in 5.5.py.

This made a huge difference since there was a large drop that was avoide by closing with z>3.

Backtest: https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_fd7e1c1cec63e5ec416672bffcc9f7f7.html

Sharpe:1.039
Return (unrealized): $40,321.44