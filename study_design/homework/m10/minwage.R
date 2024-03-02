### Script for analyis of the minimum wage data
# see the slides on Propensity scores for data description

#load in the data
minwagedata = read.csv("minwagedata.txt", header = T)

#check to make sure the data loaded correctly
dim(minwagedata)
minwagedata[1:2,]

summary(minwagedata)

#note that there are more in NJ than PA, and we labeled NJ = 1 and PA = 0
#we will want to switch the 0s and 1s later for matching

#let's look at covariates by NJ and by PA

#first PA
summary(minwagedata[minwagedata$NJ.PA == 0, 3:8])

#now NJ
summary(minwagedata[minwagedata$NJ.PA == 1, 3:8])

#notice that the distributions of prior employment are not well balanced
#other variables pretty close, but we might be able to do better by matching

#since there are more in PA than NJ, we make PA the treated and NJ the control
#we can do this pretty easily by making a new dummy variable

minwagedata$PA.NJ = 0
minwagedata$PA.NJ[minwagedata$NJ.PA == 0] = 1

#fit the logit regression for the propensity scores
pscorereg = glm(PA.NJ ~ EmploymentPre + WagePre + BurgerKing + KFC + Roys + Wendys, data = minwagedata)
pscorereg

#oops... we didn't need to include one of the dummy variables due to collinearity. drop Wendys

pscorereg = glm(PA.NJ ~ EmploymentPre + WagePre + BurgerKing + KFC + Roys, data = minwagedata)
pscorereg

#propensity scores are the predicted probabilities
pscores = predict(pscorereg, type = "response")

#look at propensity scores among treateds and controls

par(mfcol = c(2,1))
summary(pscores[minwagedata$PA.NJ == 1])
summary(pscores[minwagedata$PA.NJ == 0])

hist(pscores[minwagedata$PA.NJ == 1], xlab = "Propensity Score", main = "Propensity scores for PA")
hist(pscores[minwagedata$PA.NJ == 0], xlab = "Propensity Score", main = "Propensity scores for NJ")

#the propensity scores overlap lots, so we can feel good about prospects for matching

#we will use the package MatchIt to do propensity score matching
install.packages("MatchIt")
library(MatchIt)

#main call-- embed the logistic regression inside the call

#you can use the matchit software to examine covariate balance before matching
#specify the treatment and the covariates you want to examine in the formula call

prematchesMW =  matchit(PA.NJ ~ EmploymentPre + WagePre + BurgerKing + KFC + Roys, method = NULL, distance = "glm", data = minwagedata)
summary(prematchesMW)

#close balance would result in values of the standardized difference, eCDF, and maxCDF close to zero, and variance ratios close to one
#for descriptions of all output, see https://kosukeimai.github.io/MatchIt/reference/plot.matchit.html

##now let's do propensity score matching using a main effects only logistic regression
matchesMW = matchit(PA.NJ ~ EmploymentPre + WagePre + BurgerKing + KFC + Roys, method = "nearest", distance = "glm", data = minwagedata)

#if you want, see the row numbers of the matched controls
matchesMW$match.matrix

#if you want, create a new dataset with only the matched controls -- we won't use this command, but including it here for completeness
matchedcontroldataMW = minwagedata[matchesMW$match.matrix,]

#look at pscores of new sample
summary(pscores[minwagedata$PA.NJ == 1])
summary(pscores[matchesMW$match.matrix])

#instead, you can do similar things using the matchit plotting commands -- this is the easier approach!
plot(matchesMW, type ="histogram", interactive = F)
plot(matchesMW, type ="jitter", interactive = F)

#create the combined dataset using function from MatchIt
minwagematcheddata = match.data(matchesMW)
head(minwagematcheddata)

##balance post-matching. 
#can see results conveniently using the summary command on the MatchIt object
#use un=FALSE option to suppress printing of balance statistics before matching

summary(matchesMW, un=FALSE)

#generally improved balance!  But, not quite balanced for percentage of Roys restaurants
#maybe we can enhance the propensity score model to improve balance (or try a different matching method)

#let's take a look at the outputs for interactions and squared terms for the covariates
#these are useful to balance if interaction or quadratic terms might be important in the ultimate regression model for the outcome

summary(matchesMW, interactions = T, un=FALSE)

#looks like some quantities involving Roys restaurants not so good after matching.
#this is a clue.  maybe we can find a better balance using interaction effects in the logistic regression...

matchesMWint = matchit(PA.NJ ~ WagePre*(BurgerKing + KFC + Roys) + EmploymentPre*(BurgerKing + KFC + Roys), method = "nearest", distance = "glm", data = minwagedata, )

#we will start looking at the results with "interaction" option  in summary() turned off

summary(matchesMWint, un=FALSE)

#this seems to be an improvement! we have closer balance,
#turn on the interaction option to get results for interactions and squared terms

summary(matchesMWint, interactions = T, un=FALSE)

#again, an improvement!

#I tried adding quadratic terms to the propensity score logistic regression, but they did not obviously help with the balance.  
#So, let's go with the matchesMWint as the final matched control set

#we can create the final matched set
minwagematcheddata = match.data(matchesMWint)

### analysis
#we can estimate the difference in the outcome variable
trteffct = mean(minwagematcheddata$EmploymentPost[minwagematcheddata$PA.NJ==1]) - mean(minwagematcheddata$EmploymentPost[minwagematcheddata$PA.NJ==0])

#for SEs, treat the data like two independent samples  

se = sqrt(var(minwagematcheddata$EmploymentPost[minwagematcheddata$PA.NJ==1])/73 + var(minwagematcheddata$EmploymentPost[minwagematcheddata$PA.NJ==0])/73)

#so confidence intervals would be
trteffct - 1.96*se
trteffct + 1.96*se


#a problem with this estimator is that there is still imbalance in the treated and 
#matched control covariate distributions!  So, we really shouldn't use it...

#given imbalances remaining, we should do a regression analysis to 
#control for covariates when estimating the treatment effect.
#this involves regressing on the relevant covariates and adding a dummy variable
#for the treatment.  This is a regular STA 210 or STA 521 analysis, so I leave it
#to you if you want to pursue it further!