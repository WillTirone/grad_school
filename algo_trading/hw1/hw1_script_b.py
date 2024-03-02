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
        self.AddEquity("AMZN", Resolution.Daily)

    def OnData(self, data: Slice):

        # get starting date prices
        if self.Time.day == 1 and self.Time.month == 1 and self.Time.year == 2020:
            self.AMZN_start = self.Securities["AMZN"].Price
            self.GOOG_start = self.Securities["GOOG"].Price

            self.LimitOrder("AMZN", -8000, 1.05 * self.AMZN_start)
            self.LimitOrder("GOOG", 6000, 0.95 * self.GOOG_start)

        value = self.Portfolio.TotalPortfolioValue
        if value < 900000:
            order_ids = self.Liquidate()

        value = self.Portfolio.TotalPortfolioValue
        if value < 900000:
            order_ids = self.Liquidate()