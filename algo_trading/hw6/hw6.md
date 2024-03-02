Assignment 6.1
(15 pts) Explain how the QC implementation of Sharpe Ratio vs the equation (3). Which one makes more sense to you, and why?

The source code for the Sharpe ratio for QC is here: https://github.com/QuantConnect/Lean/blob/master/Common/Statistics/Statistics.cs

They use: 
return (AnnualPerformance(algoPerformance) - riskFreeRate) / (AnnualStandardDeviation(algoPerformance));

And annual performance is calculated like this: 
return Math.Pow((performance.Average() + 1), tradingDaysPerYear) - 1;
And Annual std is: 
return Math.Sqrt(performance.Variance() * tradingDaysPerYear);

So it seems like the difference is that QC uses averages of returns and standard deviation rather than the actual daily return values. This might be slightly more computationally efficient on huge datasets - in the slides, you would probably need a for loop to iterate through each day's returns and the QC example could be vectorized for efficiency. However, I think the formula on the slides is probably more realistic. 

Assignment 6.2

(10 pts) Use the research tool on QC to simulate mean-variance portfolio for two stocks [MS, XOM] with 200 samples, and generate the mean-variance plot. Please use the (daily) historical data from 1/1/2017-1/1/2018 to compute covariance matrix.

This was done in hw6.ipynb. The mean variance plot can be viewed there and is also uploaded.

(10 pts) Find the optimal portfolio weights (wt1, wt2) if you target the daily volatility to be 0.80% and the highest return.

The optimal weights for a volatility of 0.8% are 0.465, 0.535 for MS and XOM respectively.

(10 pts) Demonstrate Portfolio Diversification Benefits - Start with $1M and perform backtest over the same time period in #1. Let SR[TICKER] denote the Sharpe Ratio of a buy-and-hold strategy of a stock with the ticker symbol TICKER. Let 0.5MS+0.5XOM denote the portfolio for equal weights in MS and XOM. Also, SPY is the ETF for S&P market index. Test the validity of the Equation (2) on slide 194 by computing the Sharpe Ratios of the four buy-hold strategies below and explain why your answers make sense.

Calculated in hw6.py (and just switched out ticker strings as needed)

This makes sense because the SR for the pair of MS and XOM combined is between the two SR's by themselves. We see that XOM seems to bring down MS. Of course, diversifying with a large basket of stocks, the S&P 500, further diversifies the Sharpe ratio leading to a higher return and less risk.

SR[MS]: 1.017
https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_28c675d1f7fc729f7875d23941b5dd34.html
SR[XOM]: -0.293
https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_097a3ae5d006122e96efb958c9165d3d.html
SR[0.5MS+0.5XOM]: 0.648
https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_af65f2233c8a6d83121bb406231d9f36.html
SR[SPY]: 2.515
https://www.quantconnect.com/terminal/processCache?request=embedded_backtest_477364ea87ed42b4ea34544b8834174c.html