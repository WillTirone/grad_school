# region imports
from AlgorithmImports import *
# endregion

class MeasuredTanJackal(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2020,1,1)
        self.SetEndDate(2021,1,1)
        self.SetCash(1000000)

        # add securities 
        self.AddEquity("GOOG", Resolution.Daily)
        self.AddEquity("AMZN", Resolution.Daily)

        self.amzn_orders = -5628
        self.goog_orders = round(self.amzn_orders * 3/4,0)

    def OnData(self, data: Slice):

        self.Debug(f"AMZN : {self.amzn_orders} \n GOOG : {self.goog_orders}")

        if self.Time.day == 1 and self.Time.year == 2020 and self.Time.month == 1:
            self.MarketOrder("AMZN", self.amzn_orders) 
            self.MarketOrder("GOOG", -self.goog_orders)