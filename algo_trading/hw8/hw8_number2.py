
import numpy as np
from AlgorithmImports import *

# Ref: https://www.quantconnect.com/docs/v2/research-environment/datasets/equity-options
# https://www.quantconnect.com/docs/v2/writing-algorithms/securities/asset-classes/equity-options/requesting-data

class FormalBlackAnguilline(QCAlgorithm):

    def Initialize(self):

        # given parameters 
        self.SetStartDate(2021, 11, 1)
        self.SetEndDate(2021, 11, 18) 
        self.SetCash(2000000)
        self.lookback = 25
        option = self.AddOption('QQQ', resolution=Resolution.Daily)
        self.equity = self.AddEquity('QQQ', Resolution.Daily).Symbol
        self.option_symbol  = option.Symbol

        option.SetFilter(-1, +1)

    def stats(self):

        self.df = self.History(self.equity, self.lookback)
        self.dg = self.df["open"].unstack(level=0).pct_change().dropna()
        sigma = np.std(self.dg) * 10 # to annualize the 25-day chunks
        return sigma[0]

    def OnData(self,slice):

        chain = slice.OptionChains.get(self.option_symbol)

        if chain:
            # get the contract 
            call = [x for x in chain if x.Right == OptionRight.Call] # get calls 
            contract = sorted(call, key = lambda x: abs(chain.Underlying.Price - x.Strike))[0] # get ATM
            
            # get info about the contract 
            delta = contract.Greeks.Delta
            iv = contract.ImpliedVolatility
            symbol = contract.Symbol

            # order sizing
            option_weight = 0.05
            qqq_quantity = (option_weight * 2000000) / (100 * delta)
            
            # calculate volatility
            sigma = self.stats()

            if sigma > iv:
                self.Liquidate()
                self.SetHoldings(symbol, -option_weight)
                self.Buy('QQQ', qqq_quantity)
            else: 
                self.Liquidate()
                self.SetHoldings(symbol, option_weight)
                self.Buy('QQQ', -qqq_quantity)
    
    def OnOrderEvent(self, orderEvent):
        self.Log(f'{orderEvent}')
