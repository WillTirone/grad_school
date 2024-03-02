[![Repo Checks](https://github.com/sta523-fa22/hw05_lab01_team02/workflows/Repo%20Checks/badge.svg)](https://github.com/sta523-fa22/hw05_lab01_team02/actions?query=workflow:%22Repo%20Checks%22)


Homework 5 - Building a Shiny Gradebook
---
due Tuesday 11/22 by 5:00 pm.


* Lin, Huiying - [huiying.lin@duke.edu](mailto:huiying.lin@duke.edu)
* Tirone, William - [william.tirone@duke.edu](mailto:william.tirone@duke.edu)
* Yang, Yanjiao - [yanjiao.yang@duke.edu](mailto:yanjiao.yang@duke.edu)
* Zhou, Xingzhi - [xingzhi.zhou@duke.edu](mailto:xingzhi.zhou@duke.edu)


## Overview

The goal of this assignment is to create a shiny app / dashboard that would allow a user to explore student grades from a central database. We have simplified this somewhat by providing a local copy of the database `data/gradebook.sqlite` and you only need to consider the case where a single concurrent user is interacting with the data. Below are a series of tasks that progressively introduce the requirements of your shiny app, your final app must meet all of the requirements but the tasks are organized to help you work towards the final app by adding features one at a time.

We do not have a specific UI design in mind for this application and you should feel free to construct it in any way that meets the given requirements. We will discuss the structure of the app during class and lab with specific details on each of the tasks.

Since we are building the app within a Quarto document we need to make use of Quarto's ability to embed Shiny - to do this we need to split our UI and Server components into specially formated code chunks, which have been provided for you in `hw5.qmd`. Please avoid change the name or options for these chunks to avoid breaking the document. If you want to read more about how Quarto embeds shiny see [here](https://quarto.org/docs/interactive/shiny/).

## Data

We have provided a prepopulated sqlite database, `data/gradebook.sqlite`, that contains two tables:

1. `gradebook` - this is a long formatted collection of student results over 5552 assignments. Each row reflects one student's assignment for a specific class and their score for that assignment.

2. `assignments` - this is a long formatted collection of the total point value for all assignments across all classes.

To help you get started we have also include CSV versions of these two tables which you can use to start prototyping your Shiny app. Note that the final version must only use the database for collecting and storing any data.


<br/>

## Task 1 - Basic reporting

Your shiny app should connect to the `gradebook` database and allow the user to select a department and a course then click a button to generate a nicely formatted tabular report of students scores for that class.

### Specific Requirements:
* The minimal amount of data should be transferred between the database and R, i.e. as much processing as possible should occur within the database not R.

* Course selection options should be updated based on the selected Department, courses should be listed in a reasonable order.

* Department selection options should include an All option which then lists courses for all departments.

* Resulting tabular output should be nicely formatted and organized.

* Missing assignments should be highlighted (i.e. no score present in the database).

* The table should be generated only when the button is clicked, similarly the database should only be queried when the button is clicked.

* The table should be in wide format with results for one student per row, columns should be ordered in a logical way given the nature of the data, e.g. group assignments of the same type (hw, lab, etc) together in sequential order.

* You are welcome to assume that the `gradebook` and `assignments` tables are static and will not change during a session and so you can precompute useful quantities (like a class and department list) before launching the Shiny app (using the setup context chunk).

* Bonus points will be considered for well designed inclusion of summary statistics and or visualizations of the grade data.

<br/>

## Task 2 - Calculating final grades

Now add a feature to your shiny app that will allow the user to optionally calculate a final grade for each student in a course via the entry of a weighting scheme for each of the assignments or assignment types in the class. The final grade should be a decimal value between 0 and 1 that is the weighted and scaled average of the assignments. 

For example a course with:
* 4 homeworks worth 10 pts each 
* 2 projects worth 50 pts each 
* 1 exam worth 100 pts 
if we were to apply a weighting of hw 30%, projects 30%, and exam 40% would then have the following formula for a final grade:
```
grade = 0.3 (hw1 + hw2 + hw3 + hw4)/40 + 0.3 (proj1 + proj2)/100 + 0.4 (exam1)/100
```

The user should be able to enter these weights for each assignment type and when generating the report a new column titled `final grade` should be included with the calculated result for each student. The total points available for each assignment is recorded in the `assignments` table of the `gradebook` database.


### Specific Requirements:

* The weight entry inputs should be dynamically created in accordance with the specific assignment types belonging to the selected class, if a different class is selected they should update automatically.

* If the user selects an invalid weight (e.g. <0, >1, or total != 1) then a warning should occur when  generating a report (within the UI of the app and not in the console).

* The user should be able to use a checkbox to determine if the final grade column is calculated, if not checked the report should be generated without the `final grade` column.

* Any missing assignments should be considered as 0 points for the purposes of calculations.

* Bonus points will be considered for adding the ability to specify letter grade cutoffs and adding a `letter grade` column to the report based on the values in `final grade`.

<br/>

## Task 3 - Correcting mistakes

Your final task is to add a feature that will enable the user to make corrections to the database, but doing so in the a way that does not alter the original `gradebook` table. This should be accomplished by adding an additional `corrections` table which will be used to update or add entries. 

What this means is that for the previous queries used in Task 1 and 2 you must now add additional logic which will check both `gradebook` and `corrections` tables and merge the two together with preference being given to the data in `corrections`. In others words, if both databases contain an entry for `Colin Rundel`, `hw1` in `Sta 523` then the points recorded in the `corrections` database are what should be used in the report (and for calculating a final grade). This merging is only necessary for the `gradebook` table and not for the `assignments` table. 

### Specific Requirements:

* Your app should also include a method for editing a students score within a class (or adding a score if one is missing). The user should only be able to change the `points` values.

  * Consider using a modal dialog (launched via a button click) to avoid crowding your user interface. Within the modal dialog the class should be fixed but the assignment and student should be selectable and current points value visible and editable.

* Changes should be *inserted*, via a Submit button, into the `corrections` table, if a correction already existed for that class, student, and assignment then it should be overwritten. *Hint* - take a look at the syntax for inserting and updating in SQLite. This kind of elemental change is more efficient and will be strongly preferred to collecting, editing and then rewriting the entire table.

* Bonus points will be considered for adding interactivity to the report - e.g. clicking on a score in the table allows for editing of that score (if there is a change the report should be regenerated)

<br/>

## Submission and grading

This homework is due by *5:00 pm Tuesday, November 22nd*. You are to complete the assignment as a team and to keep everything (code, write ups, etc.) on your team's GitHub repository (commit early and often). All team members are expected to contribute equally to the completion of this assignment and group assessments will be given at its completion - anyone judged to not have sufficient contributed to the final product will have their grade penalized. While different teams members may have different coding backgrounds and abilities, it is the responsibility of every team member to understand how and why all code in the assignment works.

The final product for this assignment should be a single Qmd document (`hw5.qmd`, a template of which is provided) that contains all code and write ups for the tasks described above. This document should be clearly and cleanly formatted and present all of your results. Style, efficiency, formatting, and readability all count for this assignment, so please take the time to make sure everything looks good and your text and code are properly formatted. This document must be reproducible and I must be able to compile it with minimal intervention - documents that do not compile will be given a 0.

Note that we have embedded your shiny app in the document but will be running it interactively when grading. This is equivalent to the *Run Document* command in RStudio, so both this and knitting must work for your document. There is no automated reproducibility check on GitHub for this assignment as the Shiny runtime is not supported by static documents.

<br/>
