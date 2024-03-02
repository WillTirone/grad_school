# R script for fractional factorial experiment

#we used a half replicate of a 2^3 factorial design for the paper airplane experiment
#treatment conditions were as follows

#a = paperclip in back, long paper, wings
#b = paperclip in front, short paper, wings
#c = paperclip in front, long paper, no wings
#abc = paperclip in back, short paper, no wings

#we didn't get to collect the data in class, so I used data from when I ran this experiment in a previous semester
#there were 5 students in each condition. the code below was used to generate the random assignment

fracfactrt = c(rep("a", 5), rep("b", 5), rep("c", 5), rep("abc", 5))
sample(fracfactrt)   # this shuffles the values, which made the random assignment.

#we also had one extra student who was randomly assigned to condition c.

#read in data
fracfactclass = read.csv("fractionalfactorialclass.csv", header = T)

#convert trt to a factor variable for use in plotting
fracfactclass$trt = as.factor(fracfactclass$trt)

#initial EDA
boxplot(fracfactclass$distance~ fracfactclass$trt, ylab = "Distance in chairs", xlab = "Treatment")

#looks like some evidence that group a was the best on average.  
#no serious outliers.  the data are constrained at 0, which affected the c group.
#but, overall, a normality assumption seems reasonable for these data.

#let's run a regression with main effects for each factor
regfracclass = lm(distance~backclip + shortpage + nowings, data = fracfactclass)

#check residuals
boxplot(regfracclass$residual~ fracfactclass$trt, ylab = "Residuals", xlab = "Treatment")

#the residuals look pretty evenly spread around zero. 
#given sample size, the linear regression assumptions are not unreasonable 
#we can use the model without any transformations

summary(regfracclass) 

#looks like a and c are important effects, but b is not.

#What happens if you try to include an interaction between nowings and shortpage?

regfracclassintWS = lm(distance~nowings * shortpage + backclip, data = fracfactclass) 
summary(regfracclassintWS)

# R won't estimate the interaction coefficient, as it gives NA for the interaction

#why is this the case?  because of perfect linear dependence in the X matrix (the predictor matrix)
#let's take a look at the X matrix if we include the interaction for wings and short, and all main effects
#here are all the possible values from the dataset for all the variables we could include

#  trt  intercept   nowings   shortpage  backclip   nowings:shortpage
#   c      1          1            0        0            0
#   b      1          0            1        0            0
#   a      1          0            0        1            0
#  abc     1          1            1        1            1

#now let's show that we can get front from a linear combination of wing, short, and wing:short
#consider a new variable, combo =  intercept + 2*nowings:shortpage - nowings - shortpage

#  trt   intercept  nowings   shortpage    backclip     nowings:shortpage   combo
#   c      1          1          0           0              0                 0
#   b      1          0          1           0              0                 0 
#   a      1          0          0           1              0                 1
#  abc     1          1          1           1              1                 1

#Notice that the vector for combo is exactly the same as the vector for backclip
#In other words, backclip is a perfect linear combination of the intercept, nowings, shortpage, and nowings:shortpage
#recall from regression that you cannot estimate the coefficients when you have perfect colinearity among the predictor variables.
#thus, we cannot estimate a main effect of backclip at the same time as trying to estimate the 
#interaction of nowings:shortpage.  We say that these two effects are "aliased." 

#you also can find that nowings is aliased with the interaction shortpage:backclip.  so, you can't estimate the main effect of nowings at the same time 
# as the interaction between shortpage and backclip

#you also can find that shortpage is aliased with the interaction nowings:backclip.  so, you can't estimate the main effect of shortpage at the same time 
# as the interaction between nowings and backclip
 
#what to do? you have to make assumptions about the interactions.  In particular, if you believe each of the factors could have main effects, you have to
#assume that ALL the interaction coefficients equal zero.  this is the most common assumption.  alternatively, you could assume that factor C has no effect, 
#and include the interaction of AB (or B has no effect and include AC, or A has no effect and include BC).  But, this is not typically done.  You made the
#experiment use 3 factors because you expected them to all to be important, or at least wanted to learn about them.  Thus, it doesn't make sense to assume
#a main effect is zero after the fact.  It makes more sense to assume the interaction effect is zero.

#one can have more complicated factorial designs, for example, with 4 or 5 factors. usually it doesn't go beyond that, since it starts getting complicated to interpret.

#with more than 3 factors, you have aliasing between various interactions and main effects.  We will see this in a Methods assignment. 