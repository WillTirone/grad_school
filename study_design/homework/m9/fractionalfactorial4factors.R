#this script is relevant for Methods 9 

#this problem is about full and fractional factorial designs
#we will simulate data from a 2^4 full factorial design
#as well as a fractional factorial design with a half replicate

#set up a true mean value for cases that get no treatments at all
trt0 = 10

#set up true values for the main effects for 4 treatments
trta = 2
trtb = -1
trtc = 4
trtd = 3


#set up true values for the effects for two-way interactions 
trtab = 4
trtac = -1
trtad = 2
trtbc = 6
trtbd = -3
trtcd = 2

#these are for use in Problem 3
#trtbc = 0
#trtbd = 0
#trtcd = 0


#we will set all three-way interactions and the four-way interation
trtabc = 0
trtabd = 0
trtacd = 0
trtbcd = 0
trtabcd = 0

#set these 3 and 4 way interactions to zero in your assignment


#let's write down all 16 treatments as combinations of 1s and 0s
#the first column is for treatment a, the second for treatment b, the third for treatment c, and the fourth for treatment d
#we use a 1 when the treatment is active and a 0 when it is not

x0 = c(0, 0, 0, 0)
xa = c(1, 0, 0, 0)
xb = c(0, 1, 0, 0)
xc = c(0, 0, 1, 0)
xd = c(0, 0, 0, 1)
xab = c(1, 1, 0, 0)
xac = c(1, 0, 1, 0)
xad = c(1, 0, 0, 1)
xbc = c(0, 1, 1, 0)
xbd = c(0, 1, 0, 1)
xcd = c(0, 0, 1, 1)
xabc = c(1, 1, 1, 0)
xabd = c(1, 1, 0, 1)
xacd = c(1, 0, 1, 1)
xbcd = c(0, 1, 1, 1)
xabcd = c(1, 1, 1, 1)

## with this information, you can make the datasets needed
#to answer the questions about the full factorial design

n = 4
sigma = 0.2
y0 = rnorm(n, trt0, sigma)
ya = rnorm(n, trt0 + trta, sigma)
yb = rnorm(n, trt0 + trtb, sigma)
yc = rnorm(n, trt0 + trtc, sigma)
yd = rnorm(n, trt0 + trtd, sigma)
yab = rnorm(n, trt0 + trta + trtb + trtab, sigma)
yac = rnorm(n, trt0 + trta + trtc + trtac, sigma)
yad = rnorm(n, trt0 + trta + trtd + trtad, sigma)
ybc = rnorm(n, trt0 + trtb + trtc + trtbc, sigma)
ybd = rnorm(n, trt0 + trtb + trtd + trtbd, sigma)
ycd = rnorm(n, trt0 + trtc + trtd + trtcd, sigma)
yabc = rnorm(n, trt0 + trta + trtb + trtc + trtab + trtbc + trtac + trtabc, sigma)
yabd = rnorm(n, trt0 + trta + trtb + trtd + trtab + trtad + trtbd + trtabd, sigma)
yacd = rnorm(n, trt0 + trta + trtc + trtd + trtac + trtad + trtcd + trtacd, sigma)
ybcd = rnorm(n, trt0 + trtb + trtc + trtd + trtbc + trtbd + trtcd + trtbcd, sigma)
yabcd = rnorm(n, trt0 + trta + trtb + trtc + trtd + trtab + trtac + trtad + trtbc + trtbd + trtcd + trtabc + trtabd + trtacd + trtbcd + trtabcd, sigma)

#make a matrix with 4 rows per treatment group in order of treatment group
thedata = rbind(x0, x0, x0, x0)
thedata = rbind(thedata, xa, xa, xa, xa)
thedata = rbind(thedata, xb, xb, xb, xb)
thedata = rbind(thedata, xc, xc, xc, xc)
thedata = rbind(thedata, xd, xd, xd, xd)
thedata = rbind(thedata, xab, xab, xab, xab)
thedata = rbind(thedata, xac, xac, xac, xac)
thedata = rbind(thedata, xad, xad, xad, xad)
thedata = rbind(thedata, xbc, xbc, xbc, xbc)
thedata = rbind(thedata, xbd, xbd, xbd, xbd)
thedata = rbind(thedata, xcd, xcd, xcd, xcd)
thedata = rbind(thedata, xabc, xabc, xabc, xabc)
thedata = rbind(thedata, xabd, xabd, xabd, xabd)
thedata = rbind(thedata, xacd, xacd, xacd, xacd)
thedata = rbind(thedata, xbcd, xbcd, xbcd, xbcd)
thedata = rbind(thedata, xabcd, xabcd, xabcd, xabcd)

#now add the y column, which is in the same order as thedata
y = c(y0, ya, yb, yc, yd, yab, yac, yad, ybc, ybd, ycd, yabc, yabd, yacd, ybcd, yabcd) 
thedata = cbind(thedata, y)
thedata = data.frame(thedata)
names(thedata)[1:4] = c("a", "b", "c", "d")


#just for kicks, let's analyze the full factorial data with all the interactions

regfull = lm(y~a*b*c*d, data = thedata)
summary(regfull)

#notice that we do a pretty good job estimating all the effects.
#but it is hard to interpret them all, especially the higher order interactions. 
#a useful model fitting strategy involves two steps.

##first, fit the model with all the factors and all the interactions. report the results from this model.
#if it is interpretable, then go ahead and interpret it. If you care about the high order interactions, interpret them.
#you can estimate the mean with a 95% CI for each treatment condition by changing the baseline.


##If you prefer a more interpretable model, try a model with all two-way interactions and set the rest to zero.  why?
#3 way interactions, and definitely 4 way interactions, generally are hard to interpret
#As a result, we often assume that they are negligible.  This assumption needs to be checked!
#For example, you can look at the nested F test to see if the model with all 2-way interactions has
#noticeably worse fit than the model with all interactions.  If so, you might want to interpret the model with higher order interactions.
#you also can compare the R^2 to see if adding the interactions helped much.


#### this part is for making a fractional factorial design
# for a half replicate of a 2^4 factorial experiment, use the following assignments

#x0 = c(0, 0, 0, 0)
#xab = c(1, 1, 0, 0)
#xac = c(1, 0, 1, 0)
#xad = c(1, 0, 0, 1)
#xbc = c(0, 1, 1, 0)
#xbd = c(0, 1, 0, 1)
#xcd = c(0, 0, 1, 1)
#xabcd = c(1, 1, 1, 1)

#you should grab the rows with these assignments from the full factorial dataset that you made. these are rows 1 - 4 and 21 - 44 and 61 - 64

