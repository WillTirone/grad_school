#region imports

from AlgorithmImports import *
#endregion

import numpy as np
import pandas as pd
from datetime import timedelta, datetime
import math 
import statsmodels.api as sm
from statsmodels.tsa.stattools import coint, adfuller

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):

        self.SetStartDate(2018,1,1)
        self.SetEndDate(2019,1,1)

        self.SetCash(1000000)

        self.enter = 2
        self.exit = 0 
        self.lookback = 20 

        # BAC, BRK.B, JPM
        self.pairs =['JPM','BAC']

        self.ticker1 = self.pairs[0]
        self.ticker2 = self.pairs[1]

        self.AddEquity(self.ticker1, Resolution.Daily)
        self.AddEquity(self.ticker2, Resolution.Daily)

        self.symbols = [self.Symbol(self.ticker1), self.Symbol(self.ticker2)]
        self.sym1 = self.symbols[0]
        self.sym2 = self.symbols[1]

    # borrowing code presented in class, lecture 8 p. 162
    def stats(self, symbols):
        #symbols is a pair of QC Symbol Object
        self.df = self.History(symbols, self.lookback)
        self.dg = self.df["open"].unstack(level=0)

        Y = self.dg[self.ticker1].apply(lambda x: math.log(x))
        X = self.dg[self.ticker2].apply(lambda x: math.log(x))
        X = sm.add_constant(X)
        
        model = sm.OLS(Y,X)
        results = model.fit()
        sigma = math.sqrt(results.mse_resid) #standard deviation of the residual
        slope = results.params[1]
        intercept = results.params[0]
        res = results.resid #regression residual has mean =0 by definition
        zscore = res/sigma
        adf = adfuller(res)

        return [adf, zscore, slope]

    def OnData(self, data):

        self.IsInvested = (self.Portfolio[self.sym1].Invested) or (self.Portfolio[self.sym2].Invested)
        self.ShortSpread = self.Portfolio[self.sym1].IsShort
        self.LongSpread = self.Portfolio[self.sym1].IsLong

        stats = self.stats([self.sym1, self.sym2])
        self.beta = stats[2]
        zscore= stats[1][-1]
        
        self.wt1 = 1/(1+self.beta)
        self.wt2 = self.beta/(1+self.beta)
        
        self.pos1 = self.Portfolio[self.sym1].Quantity
        self.px1 = self.Portfolio[self.sym1].Price
        self.pos2 = self.Portfolio[self.sym2].Quantity
        self.px2 = self.Portfolio[self.sym2].Price
        
        self.equity =self.Portfolio.TotalPortfolioValue
        
        if self.IsInvested:
            if self.ShortSpread and zscore <= self.exit or \
                self.LongSpread and zscore >= self.exit:
                self.Liquidate()
        else:
            if zscore > self.enter:
                self.SetHoldings(self.sym1, -self.wt1)
                self.SetHoldings(self.sym2, self.wt2)   
            if zscore < -self.enter:
                self.SetHoldings(self.sym1, self.wt1)
                self.SetHoldings(self.sym2, -self.wt2) 

        self.pos1 = self.Portfolio[self.sym1].Quantity
        self.pos2 = self.Portfolio[self.sym2].Quantity