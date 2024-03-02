#region imports
from AlgorithmImports import *
#endregion

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2019,8,20)
        self.SetEndDate(2020,7,20)
        self.SetCash(2000000)

        self.ticker ='ROKU'
        self.sym = self.AddEquity(self.ticker, Resolution.Daily) #S1
        self.sma = self.SMA(self.ticker, 20, Resolution.Daily)

        self.port = False

        if self.port:
            self.wt = 0.25 # if we have two stocks, each wt will be 25%
        else:
             self.wt = 0.5 # single stock wt 50%

    def OnData(self, data: Slice):
        
        ind = self.sma.Current.Value

        if not self.Portfolio[self.ticker].Invested:
            if self.sym.Price > ind:
                self.SetHoldings(self.sym.Symbol, self.wt)
            elif self.sym.Price < ind:
                self.SetHoldings(self.sym.Symbol, -self.wt)
        elif (self.Portfolio[self.ticker].IsLong and self.sym.Price< ind) or (self.Portfolio[self.ticker].IsShort and self.sym.Price> ind):
            self.SetHoldings(self.sym.Symbol, 0.0)
    