# region imports
from AlgorithmImports import *
# endregion

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2019,2,1)
        self.SetEndDate(2021,2,1)
        self.SetCash(1000000)

        # just commenting and uncommenting the below to find the statistic for 
        # the relevant ticker

        self.AddEquity('GS', Resolution.Daily)
        self.AddEquity('MS', Resolution.Daily)
        self.AddEquity('AMD', Resolution.Daily)
        self.AddEquity('XOM', Resolution.Daily)

        self.count = 0 

    def OnData(self, data: Slice):

        if self.count == 0:
            self.SetHoldings('GS', 0.25)
            self.SetHoldings('MS', -0.25)
            self.SetHoldings('AMD', 0.25)
            self.SetHoldings('XOM', -.25)

        self.count += 1
        