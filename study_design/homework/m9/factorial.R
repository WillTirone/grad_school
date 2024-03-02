# Script for factorial experiment done in class

#we have 2 factors: the university attended (Duke, UNC) and sex (M, F)
#these were randomly assigned to students as follows

#for purposes of random assignment, permute a vector of (1, 2, 3, 4)
#make 1 be duke and male (A1, B1)
#make 2 be duke and female ARM (A1, B0)
#make 3 be unc and male (ARM A0, B1)
#make 4 be unc and female (ARM A0, B0)

factassign = c(rep(1, 4), rep(2, 4), rep(3, 4), rep(4, 4))

#factassign
#[1] 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4

#now let's randomly permute these values to make a random assignment
#we collected data sequentially in class according to the assignments

sample(factassign)
# 1 2 4 1 4 3 3 4 2 1 1 3 3 2 2 4


#we had 2 students come in after assignment; they were randomly assigned to 
#group 1 and group 2. 

#I entered the the data file in Excel. let's import to R
factorialexpdata = read.csv("factorialclassdata.csv", header = T)

#make sure we have the right data structure
dim(factorialexpdata)

#weird.... it seems we got 19 rows and 5 columns, when it should be 17 rows and 4 columns
#let's take a look

factorialexpdata

#last 2 rows are NAs, and last column is NAs.  import from excel created some extra rows and columns
#let's delete the extra rows and column

factorialexpdata = factorialexpdata[1:17,1:4]
factorialexpdata

#convert assignment into a categorical variable
factorialexpdata$assignment = as.factor(factorialexpdata$assignment)

#take a look at differences across groups
boxplot(salary~assignment, data=factorialexpdata, xlab = "Treatment", ylab = "Salary")

#box plots are difficult to interpret with only 4 or so observations per box, 
#but, we still can see a few things. 

#first, there is an outlier in group 4.
#we may want to estimate the model with and without that point to see if our conclusions
#are overly sensitive to that point.

#second, there is no obvious need for a transformation of the outcome variable.

#third, the variances of the salaries within each treatment group are not radically different,
#except again group 4 with the outlier. let's look at variances within each group

tapply(factorialexpdata[,1], factorialexpdata[,4], sd)
#       1         2         3         4 
# 10954.451  7500.000  5773.503 19685.020 

#some differences, especially group 4. But with very small sample size, it is difficult to conclude definitivel
#that the variances are different across groups.

#if we don't believe the equal variances assumption, we can get CIs within each group allowing different variances in each group.
#but, the sample sizes are pretty small, and we know there is an outlier in group 4, so let's be forgiving about the equal variance assumption

#let's do a regression analysis, and we will be careful about checking residuals for violations of assumptions

#dependent factors regression with interaction
regfactexpwinteract = lm(salary ~ duke * female, data = factorialexpdata)
boxplot(regfactexpwinteract$residual~factorialexpdata$assignment, xlab = "Treatment", ylab = "Residuals")

#the residuals do not suggest major problems with the modeling assumptions,
#except again group 4.  In this group, the outlier creates a large residual and the
#appearance of non-normally distributed residuals.  We will want to check the results 
#with and without this point to make sure it does not overly influence the results.

#here are the results including all data points

summary(regfactexpwinteract)

#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept)    66667       7622   8.747  8.3e-07 ***
#duke           16333       9640   1.694   0.1140    
#female         18333       9640   1.902   0.0796 .  
#duke:female   -17583      13090  -1.343   0.2022    
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 13200 on 13 degrees of freedom
#Multiple R-squared:  0.2478,    Adjusted R-squared:  0.07423 
#F-statistic: 1.428 on 3 and 13 DF,  p-value: 0.2797

#it looks like going to Duke gives a salary bump for men, and
#having a gender of female gives a salary bump for UNC students.
#but, one does not get a "double bump" for going to Duke and having a female gender.

#the p-value for the interaction effecf is .20. It is not strong evidence for an interaction effect.
#So, let's try the independent factors model for ease of interpretation

###### In general, ethical practice is to pre-specify the analysis that you want to do, and do that analysis.
###### So, if you suspect interactions, it is safest to fit the model with interactions, and report the results.

#independent factors regression -- no interaction
regfactexp = lm(salary ~ duke + female, data = factorialexpdata)
boxplot(regfactexp$residual~factorialexpdata$assignment, xlab = "Treatment", ylab = "Residuals")

#the residuals for the groups are not as evenly above and below 0 for this model
#as they were with the interactions model.  Plus, the R^2 is much lower (see below).

summary(regfactexp)

#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept)    72627       6372  11.398 1.81e-08 ***
#duke            6797       6706   1.013    0.328    
#female          8797       6706   1.312    0.211    
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 13570 on 14 degrees of freedom
#Multiple R-squared:  0.1434,    Adjusted R-squared:  0.02105 
#F-statistic: 1.172 on 2 and 14 DF,  p-value: 0.3384

#with these results, it is hard to claim any meaningful effects of school or gender. 
#however, the lower-quality residual plot and much lower R^2 suggest the interaction model is a better fit.

#so... let's use the interactions model since it is the more flexible model (allows an interaction to be estimated)

#get 95% CIs for interaction model
confint(regfactexpwinteract)

#                2.5 %   97.5 %
#(Intercept)  50201.368 83131.97
#duke         -4493.805 37160.47
#female       -2493.805 39160.47
#duke:female -45863.412 10696.75

#the confidence intervals are wide, reflecting a lot of uncertainty due to small sample sizes.
#to aid interpretations, let's estimate the average for each group and compare.

###Using the results from the interaction model

#A convenient way to interpret results from the interaction model is to estimate the average for each treatment condition.
#Here are the results from the model we fit already.

#The baseline category is UNC male graduates. So, the intercept tells you the average salary for that group.

#Thus, a 95% CI for the average stated salary for the UNC-male treatment arm is 66293 to 82278.
#confint(regfactexpwinteract)
#               2.5 %   97.5 %
#(Intercept)  50201.368 83131.97

#Now, let's get the 95% CIs for the other three groups.
#create dummy variables for UNC and Male

factorialexpdata$UNC = 1 - factorialexpdata$duke
factorialexpdata$male = 1 - factorialexpdata$female

regfactexpwinteractUNCf = lm(salary ~ duke * male, data = factorialexpdata)
regfactexpwinteractDUKEf = lm(salary ~ UNC * male, data = factorialexpdata)
regfactexpwinteractDUKEm = lm(salary ~ UNC * female, data = factorialexpdata)

#UNC female
confint(regfactexpwinteractUNCf)

#               2.5 %    97.5 %
#(Intercept)  72246.03 97753.965

#Duke female
confint(regfactexpwinteractDUKEf)

#               2.5 %   97.5 %
#(Intercept)  69490.63 98009.37

#Duke male
confint(regfactexpwinteractDUKEm)

#               2.5 %    97.5 %
#(Intercept)  70246.03 95753.965
                          
#UNC male from earlier result
#                2.5 %   97.5 %
#(Intercept)  50201.368 83131.97

#You can report these four confidence intervals, along with the regression results
#These show the suggestive interaction effect that lowers UNC male average stated salaries,
#and is easier to interpret than the set of coefficients.  There does not appear to 
#be much difference among the other three groups.

#Perhaps this is a result of the outlier.  Let's try removing this data point and re-doing the analysis.

### We cannot just remove data points based on their y values to report final results.
### The only justification for removing points is a data error or a value of an explanatory variable 
### that is outside the range we care about (this is not the case in our experiment, which has only the treatment
### indicators as explanatory variables. Insted, we can see how much results change by removing
### individual data points, and if they do, provide a cautionary note with the analysis based on the full dataset.

#make the data excluding the one outlier with 120000 salary
factorialexpdatanoout = factorialexpdata[factorialexpdata$salary<119000,]

#refit the model and look at residuals
regfactexpwinteractnoout = lm(salary ~ duke * female, data = factorialexpdatanoout)
boxplot(regfactexpwinteractnoout$residual~factorialexpdatanoout$assignment, xlab = "Treatment", ylab = "Residuals")

#box plots look a lot nicer -- centered around zero with roughly even spread in each box. 
#Not surprising since we removed a point that influenced the estimates

summary(regfactexpwinteractnoout)

#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept)    66667       4516  14.763 4.66e-09 ***
#duke           16333       5712   2.859   0.0144 *  
#female          9583       5974   1.604   0.1347    
#duke:female    -8833       7951  -1.111   0.2884   

#here is what we had before, with all data points in the model.

#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept)    66667       7622   8.747  8.3e-07 ***
#duke           16333       9640   1.694   0.1140    
#female         18333       9640   1.902   0.0796 .  
#duke:female   -17583      13090  -1.343   0.2022 

#the one data point influenced the estimated effects for Duke and for the interaction.
#but, the overall story of going to Duke giving a bump and having female gender giving a bump--
#although less of a bump than estimated previously--still is the case. 

#I would report the results from the analysis with all data points, and mention that removing
#the one outlier changes the results for UNC women but that the main story (duke gives a bump, female gives a bump)
#does not change significantly.
 