#region imports
from AlgorithmImports import *
#endregion


"""
(10 pts) Demonstrate Portfolio Diversification Benefits - Start with $1M and perform backtest 
over the same time period in #1. Let SR[TICKER] denote the Sharpe Ratio of a buy-and-hold strategy
of a stock with the ticker symbol TICKER. Let 0.5MS+0.5XOM denote the portfolio for equal weights
in MS and XOM. Also, SPY is the ETF for S&P market index. Test the validity of the Equation (2) 
on slide 194 by computing the Sharpe Ratios of the four buy-hold strategies below and explain 
why your answers make sense.
"""

class PairsTradingAlgorithm(QCAlgorithm):
    
    def Initialize(self):

        self.SetStartDate(2017,1,1)
        self.SetEndDate(2018,1,1)

        self.SetCash(1000000)
        self.pairs =['SPY']
        self.symbols =[]
        
        for ticker in self.pairs:
            
            self.AddEquity(ticker, Resolution.Daily)
            self.symbols.append(self.Symbol(ticker))

        self.sym1 = self.pairs[0]

    def OnData(self, data):
        
        if not self.Portfolio.Invested:
            self.SetHoldings(self.sym1, 1)
