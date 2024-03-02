# region imports
from AlgorithmImports import *
# endregion

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    """
    1. (5 pts) Compute the Sharpe Ratio of a buy-and-hold strategy for each of the above stocks 
    individually for the given time period, that is, you need to compute four 
    Sharpe Ratios separately, one for each stock.
    """

    def Initialize(self):
        self.SetStartDate(2019,2,1)
        self.SetEndDate(2021,2,1)
        self.SetCash(1000000)

        #self.AddEquity('GS', Resolution.Daily)
        #self.AddEquity('MS', Resolution.Daily)
        #self.AddEquity('AMD', Resolution.Daily)
        self.AddEquity('XOM', Resolution.Daily)

    def OnData(self, data: Slice):

        #self.SetHoldings('GS', 1)
        #self.SetHoldings('MS', 1)
        #self.SetHoldings('AMD', 1)
        self.SetHoldings('XOM', 1)
