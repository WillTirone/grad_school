from sklearn.linear_model import LinearRegression
import numpy as np 
import statsmodels.api as sm
from statsmodels.tsa.stattools import coint, adfuller

#%% 
qb = QuantBook()

start_date = datetime(2021,1,1,0,0)
end_date = datetime(2021,12,31,0,0)

security_list = ['AAPL', 'MSFT', 'AMZN', 'GOOG', 'BRK.B',
                'GOOGL', 'NVDA', 'TSLA', 'XOM', 'UNH', 'SPY']
security_list.sort()

for i in security_list:
    qb.AddEquity(i)

history = qb.History(qb.Securities.Keys, start_date, 
                    end_date, Resolution.Daily).unstack(level=0)['close']
history.columns = security_list


#%% 
# Calculate Beta

#Performed these calculations based on slide 205. (A bit confused though as the question asks for betas from a linear regression but the formula given will not yield beta coefficients from OLS).


#%%

def beta_calc(t1,df):
    # want [0,1] of CORR matrix for CORR(X,Y)
    beta = (np.corrcoef(df[t1], df.SPY)[0,1] *
            (np.std(df[t1]) / np.std(df.SPY)))
    return beta

for i in security_list:
    print(i, ' Beta :', beta_calc(i, history))

#%%

def stats(df, t1, t2):

    Y = df[t1].apply(lambda x: math.log(x))
    X = df[t2].apply(lambda x: math.log(x))
    X = sm.add_constant(X)
    
    model = sm.OLS(Y,X)
    results = model.fit()
    sigma = math.sqrt(results.mse_resid) #standard deviation of the residual
    slope = results.params[1]
    intercept = results.params[0]
    res = results.resid #regression residual has mean =0 by definition
    zscore = res/sigma
    adf = adfuller(res)

    return [adf, zscore, slope]


#%% 

"""
The null hypothesis of the Augmented Dickey-Fuller is that there is a unit root, with the alternative that there is no unit root. 
If the pvalue is above a critical size, then we cannot reject that there is a unit root. We do not want a unit root, 
so that we can conclude that the two stocks will converge and they will be suitable for pairs trading.
"""


#%%
for i in security_list:
    model = stats(history, i, 'SPY')[0]
    print(i, "ADF stat : ", model[0])
    if model[1] < 0.05: # alpha
        print(i, "Statistically Significant p-value : ", model[1])
