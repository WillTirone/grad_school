# region imports
from AlgorithmImports import *
# endregion

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2019,8,20)
        self.SetEndDate(2020,7,20)
        self.SetCash(2000000)

        self.ticker1 ='ROKU'
        self.sym1 = self.AddEquity(self.ticker1, Resolution.Daily) #S1
        self.sma1 = self.SMA(self.ticker1, 20, Resolution.Daily)

        self.ticker2 = 'AMD'
        self.sym2 = self.AddEquity(self.ticker2, Resolution.Daily) #S2
        self.sma2 = self.SMA(self.ticker2, 20, Resolution.Daily)

        self.port = True

        if self.port:
            self.wt = 0.25 # if we have two stocks, each wt will be 25%
        else:
             self.wt = 0.5 # single stock wt 50%

    def OnData(self, data: Slice):
        
        ind1 = self.sma1.Current.Value
        ind2 = self.sma2.Current.Value

        self.Debug("Price1 " + str(self.sym1.Price) + "indicator " +str(ind1))
        self.Debug("Price2 " + str(self.sym2.Price) + "indicator " +str(ind2))

        if not self.Portfolio[self.ticker1].Invested:
            if self.sym1.Price > ind1:
                self.SetHoldings(self.sym1.Symbol, self.wt)
            elif self.sym1.Price < ind1:
                self.SetHoldings(self.sym1.Symbol, -self.wt)
        elif self.Portfolio[self.ticker1].IsLong and self.sym1.Price< ind1 or \
            self.Portfolio[self.ticker1].IsShort and self.sym1.Price> ind1:
            self.SetHoldings(self.sym1.Symbol, 0.0)

        #Trend-reversal Strategy for self.ticker1
        if self.port:
            if not self.Portfolio[self.ticker2].Invested:
                if self.sym2.Price > ind2:
                    self.SetHoldings(self.sym2.Symbol, -self.wt)
                elif self.sym2.Price <ind2:
                    self.SetHoldings(self.sym2.Symbol, self.wt)
            elif self.Portfolio[self.ticker2].IsLong and self.sym2.Price< ind2 or \
                self.Portfolio[self.ticker2].IsShort and self.sym2.Price> ind2:
                self.SetHoldings(self.sym2.Symbol, 0.0)

    