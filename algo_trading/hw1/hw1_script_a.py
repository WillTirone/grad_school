# region imports
from AlgorithmImports import *
# endregion

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2020,1,1)
        self.SetEndDate(2021,1,1)
        self.SetCash(1000000)

        # add securities 
        self.AddEquity("GOOG", Resolution.Daily)
        self.GOOG = self.Symbol("GOOG")
        self.AddEquity("AMZN", Resolution.Daily)
        self.AMZN = self.Symbol("AMZN")

        self.count = 0 

    def OnData(self, data: Slice):

        if self.count == 0:
            self.MarketOrder("GOOG", 6000)
            self.MarketOrder("AMZN",-8000)

        value = self.Portfolio.TotalPortfolioValue
        self.Log('Portfolio Value : ' + str(value))

        self.count += 1 

        if value < 900000:
            order_ids = self.Liquidate()
