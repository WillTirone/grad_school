#region imports
from AlgorithmImports import *
#endregion
class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2019,8,20)
        self.SetEndDate(2020,7,20)
        self.SetCash(2000000)

        self.ticker1 ='AMD'
        self.sym1 = self.AddEquity(self.ticker1, Resolution.Daily) #S1
        self.sma = self.SMA(self.ticker1, 20, Resolution.Daily)

        self.port = False

        if self.port:
            self.wt = 0.25 # if we have two stocks, each wt will be 25%
        else:
             self.wt = 0.5 # single stock wt 50%

    def OnData(self, data: Slice):
        
        ind1 = self.sma.Current.Value

        if not self.Portfolio[self.ticker1].Invested:
            if self.sym1.Price > ind1: 
                self.SetHoldings(self.sym1.Symbol, -self.wt)
            elif self.sym1.Price < ind1:
                self.SetHoldings(self.sym1.Symbol, self.wt)
        elif self.Portfolio[self.ticker1].IsLong and self.sym1.Price< ind1 or self.Portfolio[self.ticker1].IsShort and self.sym1.Price> ind1:
            self.SetHoldings(self.sym1.Symbol, 0.0)    

    