[![Repo Checks](https://github.com/sta523-fa22/midterm1-willtirone/workflows/Repo%20Checks/badge.svg)](https://github.com/sta523-fa22/midterm1-willtirone/actions?query=workflow:%22Repo%20Checks%22)



Sta 523 - Fall 2022 - Midterm 1
-----------

Due Wednesday, October 19th by 5:00 pm.

## Rules

1. Your solutions must be written up using the provided `midterm1.qmd`, this file must include your code and write up for each task.

2. This project is open book, open internet, closed other people. You may use *any* online or book based resource you would like, but you must include citations for any code that you use (directly or indirectly). You *may not* consult with anyone else about this exam other than the myself or the TAs for this course - this includes posting anything online.

3. If you receive help *or* provide help to any other student in this course you will receive a grade of 0 for this assignment. Do not share your code with anyone else in this course.

4. You have until Wednesday, October 19th by 5:00 pm. to complete this project and turn it in via your personal Github repo - late work will be subject to the standard late penalty. Technical difficulties are not an excuse for late work - do not wait until the last minute to commit / push.

5. All of your answers *must* include a brief description / write up of your approach. This includes both annotating / commenting your code *and* a separate written descriptions of all code / implementations. I should be able to suppress *all* code output in your document and still be able to read and make sense of your answers.

6. You may use any packages you like from *CRAN*, however all tasks can be accomplished using the libraries provided by the tidyverse package.

7. Your first goal is to write code that can accomplish all of the given tasks,  however keep in mind that marking will also be based on the quality of the code you write - elegant, efficient code will be given better marks and messy, slow code will be penalized.

<br />

## Data

For this exam you will be working with a data from the 2021 Formula 1 racing season (the 2022 season is currently going on). The data was downloaded from ergast.com in the form of a large JSON file which contains information on the results of all 22 races from the 2021 season. These data were read into R using the `jsonlite` packages and your repo contains the resulting R object saved as `f1.rds` in the `data` directory. This file can be loaded into your R session using
```r
f1 = readRDS(file="data/f1.rds")
```

The data is structured as a list of lists of lists of lists and so on, it is up to you to look at the data and figure out how it is structured and how best to get at the information you need.

<br />

## Task 1 - Tidy the data

Starting from the `f1` object create a tidy data frame from these data with the following columns:

* `race_name` - The name of the race (character type)
* `round` - Round of the race (integer type, between 1 and 22)
* `date` - Date of the race (date class)
* `driver` - Name of a driver, including first and last name (character type)
* `constructor` - Name of a driver's constructor, i.e. team (character type)
* `position` - Position (place) driver finished in for the race (integer type, `NA` if they did not finish for any reason)
* `points` - Number of points the driver earned for the race (integer type)

Each row of this data frame should represent the result of a driver for a particular race.

Print out 10 rows of your data frame, clearly showing the structure and column types of your answer.

### Additional guidance

* For details on how the race results are reported in the data see the [race result page](https://ergast.com/mrd/methods/results/) on Ergast.

* The driver's position information is given by multiple entries in the json - in general `positionText` will be more useful than the `position` entry for determining if the driver finished the race or not.

* An optimal solution to this task will not make excessive use of `unnest_longer` and `unnest_wider` - use these sparingly and avoid creating unnecessary columns - while using them will likely be necessary, opt for `hoist` and similar tools when appropriate.



<br/>


## Task 2 - Drivers' Championship

Using the data frame from Task 1, construct a table showing the World Drivers' Championship standings for this F1 season. This table should *resemble* but not be identical to the results available on [Wikipedia](https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship#World_Drivers'_Championship_standings). Your data frame should also have 24 columns: Driver name, finishing position each of the 22 races, and finally the driver's overall points total for the season. Your data frame should be sorted by points total, you do not need to include any additional logic to handle ties. 

Print out a nicely formatted version of the *complete* table in your rendered document. Nicely formatted here means that the entire table is visible and legible when rendered into html. 


### Additional guidance

* Failure to finish for any reason (did not start, did not finish, disqualified, retired, etc.) should be coded as an `NA`. See the API documentation for more details.

* Race finishes and points total should all have an integer type.

* The order of the race columns should follow the chronological order in which the races occurred.

* Race names from the API are quite long - abbreviating or shortening them may help keep the size of your table down.

<br />

## Task 3 - Cumulative Constructors

Using the data frame from Task 1 (as a starting point), construct a table that contains the *cumulative* points earned by each of the 10 constructors (teams) at the end of each of the 22 races of the 2021 season. 

For example Mercedes earned 41 (25 + 16) points from the Bahrain Grand Prix, 19 (19 + 0) from the Emilia Romagna Grand Prix, and 41 (25 + 16) from the Portuguese Grand Prix. Therefore the row for Mercedes in this data frame would contain the values 41, 60, 101 for the first three columns corresponding to these races. 

Your final data frame should have 23 columns: Constructor name and one column for each of the 22 grand prix races. You results should be ordered by the constructors total points at the end of the season.

Print out a nicely formatted version of the *complete* table in your rendered document.

<br />

## Task 4 - Visualization

Design a visualization that shows the performance of *both* drivers and teams over the course of the 2021 F1 season in terms of the points earned toward the drivers' and constructors' Championship standings. This exercise is meant to be purposefully open ended, come up with a visualization that tells a compelling story about this season and use your write up to justify your design choices. Your write up *must* include a discussion of what you are trying to convey as well as how your visualization achieves those goals.

You may use any visualization tools and/or packages you would like as long as your results are reproducible (e.g. I should be able to change the source data and that change would be reflected in the visualization).

Note that while all of the available data should be shown, not all of it needs to be emphasized / labeled - be selective in what you highlight in order to best convey your narrative.


