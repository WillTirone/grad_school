import statsmodels.api as sm
from statsmodels.tsa.stattools import coint, adfuller
# region imports
from AlgorithmImports import *
# endregion


class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):

        self.lookback = 60

        self.SetStartDate(2018,1,1)
        self.SetEndDate(2019,1,1)

        self.SetCash(1000000)

        self.enter = 2 # Set the enter threshold 
        self.exit = 0  # Set the exit threshold 
        self.lookback = 90  # Set the loockback period 90 days

        # BAC, BRK.B, JPM
        self.pairs =['JPM','BAC']

        self.ticker1 = self.pairs[0]
        self.ticker2 = self.pairs[1]

        self.AddEquity(self.ticker1, Resolution.Daily)
        self.AddEquity(self.ticker2, Resolution.Daily)

        self.symbols = [self.Symbol(self.ticker1), self.Symbol(self.ticker2)]

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

    def OnData(self, data: Slice):

        # get the adf and the actual adf score per the docs
        adf = self.stats(self.symbols)[0]
    
        self.Log(f"ADF for {self.ticker1} and {self.ticker2} : {adf[0]}; p-value : {adf[1]}")