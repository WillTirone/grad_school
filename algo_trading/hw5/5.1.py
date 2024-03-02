# region imports
from AlgorithmImports import *
# endregion

class EnergeticYellowGreenGiraffe(QCAlgorithm):

    def Initialize(self):
        self.SetStartDate(2018,1,1)
        self.SetEndDate(2018,1,5)
        self.SetCash(1000000)

        self.AddUniverse(self.Coarse, self.Fine)
        self.UniverseSettings.Resolution = Resolution.Daily
        self.SetSecurityInitializer(lambda x: x.SetDataNormalizationMode(DataNormalizationMode.Raw))

    def Coarse(self, coarse):
        
        sortedByDollarVolume = sorted(coarse, key=lambda c: c.DollarVolume, reverse=True)
        filteredByPrice = [c.Symbol for c in sortedByDollarVolume if c.Price>10]
        self.filter_coarse = filteredByPrice[:100]

        return self.filter_coarse
        
    def Fine(self, fine):
        
        fine1 = [x for x in fine if x.AssetClassification.MorningstarSectorCode == MorningstarSectorCode.FinancialServices]
        sortedByMarketCap = sorted(fine1, key=lambda c: c.MarketCap, reverse=True)
        self.filter_fine = [i.Symbol for i in sortedByMarketCap][0:3]

        return self.filter_fine

    def OnData(self, data: Slice):

        self.Log(f"OnData({self.UtcTime}): Keys: {', '.join([key.Value for key in data.Keys])}")
