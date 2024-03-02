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

        #self.AddEquity('GS', Resolution.Daily)
        self.AddEquity('MS', Resolution.Daily)
        #self.AddEquity('AMD', Resolution.Daily)
        #self.AddEquity('XOM', Resolution.Daily)

        self.count = 0 
    
    def OnData(self, data: Slice):

        if self.count == 0:
            #self.SetHoldings('GS', 1)
            self.SetHoldings('MS', 1)
            #self.SetHoldings('AMD', 1)
            #self.SetHoldings('XOM', 1)
        
        value = self.Portfolio.TotalUnrealizedProfit
        stop_loss = 0.07 * 1000000
        self.count += 1

        # with 1MM starting value, equates to losing or gaining $70,000
        if (value <=  -stop_loss) or (value >= stop_loss):
            order = self.Liquidate()