[![Check Assignment](https://github.com/sta523-fa22/hw01_lab01_team04/workflows/Check%20Assignment/badge.svg)](https://github.com/sta523-fa22/hw01_lab01_team04/actions?query=workflow:%22Check%20Assignment%22)



Sta 523, Fall 2022 - Homework 1
-------------
Due by 5:00 pm on Friday, September 16th.


* Bao, Yunhong - [yunhong.bao@duke.edu](mailto:yunhong.bao@duke.edu)
* Sheng, Xinyi - [xinyi.sheng@duke.edu](mailto:xinyi.sheng@duke.edu)
* Tirone, William - [william.tirone@duke.edu](mailto:william.tirone@duke.edu)
* Zeng, Yucan - [yucan.zeng@duke.edu](mailto:yucan.zeng@duke.edu)


<br/>

![fizz buzz](fizzbuzz.png?raw=true)

## Background

FizzBuzz is a common programming interview question used to establish if a candidate can program in a language that they claim experience in.

A slightly modified version of the typical problem statement is as follows:

> "Write a program that given a vector of numbers as input returns a new vector that contains the original values, but with multiples of three replaced by "Fizz", multiples of five replaced by "Buzz", and numbers which are multiples of both three and five replaced by "FizzBuzz"."

<br/>

## Task 1 - Implement fizzbuzz 

Your goal here is to implement the FizzBuzz algorithm as described above by writing a function in R called `fizzbuzz`. Your `fizzbuzz` function should conform to the description provided above in terms of basic behavior (more detailed specifications are included below). You should program defensively - validate any input and make sure that you have a reasonable response to any invalid input.

You solution must also include a write up of your implementation that broadly describes how you approached the problem and constructed your solution (think something along the lines of the methods section of a journal article). For example, your write up for this task should be explicit about what your team considers good vs bad input and a justification for those choices.

This is not a terribly complex or novel task, and solutions in R and many other languages are easily googleable - the point of this exercise is to get used to the workflow and tools we will be using in this class. This includes RStudio, git, GitHub, Quarto, etc. - so use this as opportunity to familiarize yourself with these tools as we will be using them throughout the rest of the semester.

Detailed requirements:
* Your function must be named `fizzbuzz` and take a single argument named `input`.
* Input must be a numeric vector (either double or integer type is allowed)
* Your implementation must use a `for` loop
* If input is double type then all values must be coercible to integer without rounding or truncating (i.e. 5 or 5.0 are valid but 5.1 is not)
* All input values must be >=0
* All input values must be finite
* An invalid input values should immediately result in an appropriate error
* The returned vector should always have a character type (even if none of the input values are divisible by 3 or 5)
* All error messages should be informative (see [tidyverse style guide on error messages](https://style.tidyverse.org/error-messages.html))

<br/>

## Task 2 - Re-Implement fizzbuzz

*Note* - This task depends on material that will be covered in Lecture 4 on Sept, 9th - feel free to attempt it before then. For those new to R and/or S3 the assigned readings will be useful. Consider moving on to Task 3 if you have not had this Lecture yet.

For this task you will be revising your implementation of `fizzbuzz` in Task 1 to leverage R's S3 object system for a cleaner and more readable implementation. Your new version **must** use R's S3 object system and should be as elegant and efficient as possible.

One of the learning objectives of this particular task is to help you develop a better sense of what makes code "good" vs "bad". This is a skill that comes with experience, but it is also something that we want to foster as much as possible in this course. An excellent introduction to some of the ideas around this were presenting by Jenny Bryan in her 2018 UseR conference keynote titled "Code Smells and Feels". I highly recommend either watching the talk on [youtube](https://www.youtube.com/watch?v=7oyiPBjLAWY) or at least looking through the slides on [github](https://github.com/jennybc/code-smells-and-feels). This talk is a wonderful introduction into what good R code should look like as well as the process of refactoring existing code to improve its overall quality. 

Detailed requirements:
* Your re-implemented function must be named `fizzbuzz_s3` and take a single argument named `input`
* Your implementation must meet all of the requirements listed for `fizzbuzz` above, except for the requirement to use a `for` loop.
* Keep in mind that we are looking for efficient *and* readable solutions.

<br/>

## Task 3 - Testing

Another important aspect of programming is learning to test your code - this is useful for checking for correctness but it is also useful as a way of expressing the requirements for function(s) programmatically. For a more through introduction to testing in R see the [testing chapter](https://r-pkgs.org/tests.html) in the [R Package book](https://r-pkgs.org/) which discusses the use of the [testthat package](https://testthat.r-lib.org/). We will discuss formal testing in more detail later on in the course.

Specifically, for this task we will be using a simple testing scheme that exclusively relies on the `stopifnot()` function. See the relevant section of `hw1.qmd` for examples of tests for both good and bad inputs. For this task you must include additional tests to cover all of the requirements described above for both `fizzbuzz` and `fizzbuzz_s3`. These tests should be included in the relevant sections of Task 1 and Task 2 of `hw1.Rmd`. You should add at least 1 new test to each testing section in your qmd.

<br/>

## Submission and Marking

This homework is due by 5:00 pm on Friday, September 16th. You are to complete the assignment as a team and to keep everything (code, write ups, etc.) in your team's repository (commit early and often). Only the work committed to the repositories' **main** branch by the deadline will be graded. As mentioned in syllabus and Lecture 1, all team members are expected to contribute equal *effort* for this assignment - individual contributions will be assessed after the assignment is completed via peer evaluations and commit histories.

The final product for this assignment should be a single qmd document (`hw1.qmd`) that contains all code and text for the tasks described above. This document should be clearly and cleanly formatted and present all of your results. Style and formatting does count for this assignment, so please take the time to make sure everything looks good and your text and code are properly formatted. This document must be reproducible and we must be able to render it with minimal intervention - documents that do not render will be penalized.

Note that your repository includes several automated feedback actions enabled, the results of which will be visible on GitHub via the badges at the top of your README and the actions tab. These are meant to give you feedback around the structure and reproducibility of your repository and assignment - they do not assess the correctness of your work. You should consider them a necessary but not sufficient condition when turning in your work - passing all of the checks simply means your have met a minimum standard of reproducibility for the assignment.

Finally, we will not be enforcing any particular coding style, however it is important that the code your team produces is *readable* and *consistent* in its formatting. There are several R style guides online, e.g. from [Google](https://google.github.io/styleguide/Rguide.xml) and from the [tidyverse team](https://style.tidyverse.org/) that are a good place to start. As a team you should decide on what conventions you will use and the entire team should conform to them.

