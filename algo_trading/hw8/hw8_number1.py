# region imports
from AlgorithmImports import *
# endregion

# Ref: https://www.quantconnect.com/docs/v2/research-environment/datasets/equity-options

class FormalBlackAnguilline(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2022, 10, 14)
        self.SetEndDate(2022, 10, 17)
        self.SetCash(100000)  # Set Strategy Cash
        spy = self.AddEquity("QQQ", Resolution.Hour)
        self.symbol = spy.Symbol

        contracts = [
            Symbol.CreateOption(self.symbol, Market.USA, OptionStyle.American, OptionRight.Put, 130, datetime(2022, 11, 11)),
            Symbol.CreateOption(self.symbol, Market.USA, OptionStyle.American, OptionRight.Call, 145, datetime(2022, 11, 18))
        ]
        
        for contract in contracts:
            option = self.AddOptionContract(contract, Resolution.Hour)
            option.PriceModel = OptionPriceModels.BjerksundStensland()

        self.df = pd.DataFrame()
     
    def OnData(self, data: Slice):
        equity = self.Securities[self.symbol]
        for canonical_symbol, chain in data.OptionChains.items():
            for contract in chain:
                greeks = contract.Greeks
                data = {
                    "IV" : contract.ImpliedVolatility,
                    "Delta": greeks.Delta,
                    "Gamma": greeks.Gamma,
                    "Vega": greeks.Vega,
                    "Rho": greeks.Rho,
                    "Theta": greeks.Theta,
                    "LastPrice": contract.LastPrice,
                    "Close": self.Securities[contract.Symbol].Close,
                    "theoreticalPrice" : contract.TheoreticalPrice,
                    "underlyingPrice": equity.Close
                }
                symbol = contract.Symbol
                right = "Put" if symbol.ID.OptionRight == 1 else "Call"
                index = pd.MultiIndex.from_tuples([(symbol.ID.Date, symbol.ID.StrikePrice, right, symbol.Value, self.Time)], names=["expiry", "strike", "type", "symbol", "endTime"])
                self.df = pd.concat([self.df, pd.DataFrame(data, index=index)])
    

    def OnEndOfAlgorithm(self):

        self.ObjectStore.Save("price-models/backtest-df", self.df.sort_index().to_csv())