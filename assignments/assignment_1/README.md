SDS Autumn 2018, M1, Assignment 1
================
Update: 14/09/2018

Due to various problems and basically easonable complains about the scope and complexity of the assignment:

Following changes:

- Deadline moved to Wednesday
- The assignment will not be graded (however, you will need to deliver something that can pass to finish M1)
- The scope is reduced to only look at the cities and trips-data. If you want to work with the people-data, go ahead but it's not necessary.
- We prepared (pretty identical) starter code in R and Python, which outlines the basic structure, shows how to perform some of the transformations on selected variables, implements basic clustering etc.
- Your job is to take the starter code and build your assignment on top of it by exploring more variables, identifying further patterns etc.

The starter code along with simplyfied datasets (no more TSV) can be found in the zipfile assignment_v2.zip and the (unpacked) folder assignment_v2

The safe way to download it is to take the zipfile (or use Github Desktop).
If you download manually, make sure to rightclick on "row" when you open a dataset.

**Jupyter****: Make sure to place the data (csv files) and the ipynb (notebook file) in the same folder on your machine

**Google Colab** (jupyter cloud): Connect to an instance (green checkmark) --> click on the arrow on the left side --> "files" --> upload the CSVs

**RStudio**: set your working directory using ```setwd("my_working_directory")```


**Monday**: I'm (Roman) around at the uni and you are always welcome to drop by. Really, I do learn a lot from dealing with your problems and any feedback is valuable. I have to check with the secretary Monday morning and perhaps we can have a short problem-solving-feedback round (depends on the room-booking-situation).

================

Daniel S. Hain (<dsh@business.aau.dk>) & Roman Jurowetzki (<roman@business.aau.dk>)
12/09/2018

Introduction
============

In your first assignment, you will mainly work on the first part of the Data Science pipeline, **OSE**. In particular, you will:

-   Clean real-life data, with all its messiness (warning: Roman's scraped data included!).
-   Join data from multiple sources, and on multiple levels of aggregation
-   Explore complex data structures and relationships, guided by descriptive statistics, data-visualization, as well as other tools for exploratory data analysis, including techniques from unsupervised ML

Data: What data do you get?
===========================

You will explore the already known data on **digital nomads**, this time the freshly crawled version. Preliminary findings of our work on that are summarized in [this presentation](https://aaudk-my.sharepoint.com/:b:/g/personal/dsh_id_aau_dk/ESeuvplEytZCuNBhKGmA4U8BOGpfbGIbilqTGdgQLA4a6A?e=UGRnvR). You probably already know the data from [NomadList](https://nomadlist.com/). The files can be found in the `data` folder of the assignment.

City data:
----------

-   731 cities with all possible and impossible features scaped from the Nomadlist platform (2 month ago).
-   Scaped data comes with many problems and this particular table needs proper cleaning.

People data (digital nomads):
-----------------------------

-   A list of ~4000 digital nomads with some basic characteristics
-   A matrix (same order of observations) of their jobs (multiple choice, many did not specify anything)

Trips
-----

-   A table with ~45k individual trips, including destination and time-span of trip

Your tasks
==========

Clean the data
--------------

-   Clean up variables that you are determined to work with (not all might be relevant. Make choices.).
-   Assign appropriate datatypes where needed.
-   Map categorical variables to reasonable numerical values where you think it may be helpful.
-   Argue for your strategy regarding missing values treatment.

Join the data
-------------

-   Join the different data tables on different levels depending on the question that you are exploring.
-   Explain your approach briefly.

Explore the data
----------------

Since we now work on different analytical dimensions (cities, people, trips), there are likewise different perspectives to explore.

### Cities

-   What are the different characteristics of cities digital nomads venture to?
-   Are they differ across countries, continents, etc.?
-   What are similar patterns across cities? Can they be categorized in a meaningful way?
-   Which are the most popular cities (hint: Think about how to measure popularity)?
-   Can we see some patterns (geography, over time etc.?)

### People

-   Likewise, what are the patterns of work-related skills among digital nomads?
-   Can they be categorized in a meaningful way?
-   Do people within these categories display different behavior? (amount of traveling etc.)?

### Jointly

-   Finally, are certain types of digital nomads drawn to particular places?

Present and interpret your findings
-----------------------------------

-   Will be done in a commented notebook (see below).

Deliverables
============

You are asked to deliver a Computational Notebook (R Markdown, R Notebook, or Jupyter Notebook in Python or R, the language is your choice) which answers the above-stated questions. It should have the following characteristics.

-   It should be able to run on every other computer, given it is placed in the same folder as the data. Take for granted that (as it should be for all your fellows), `R` and `Python` (Anaconda distribgution) is installed.
-   This should be possible solely by running the contained code chunk-by-chunk. A good way to test compatibility (this is not always working, unfortunately) is to run the notebook in free hosted environments (Google Colab, kaggle, Azure Notebooks).
-   If you use specific libraries (outside what we used in class) please write a note at the start of the notebook explaining what has to be installed.
-   It should solve the questions in an straightforward and elegant way.
-   It should contain enough explanations to enable your fellow students (or others on a similar level of knowledge) to clearly understand what you are doing, why, what is the outcome, how to interpret it, and how to reconstruct the exercise. Be specific and understandable, but brief.

Further process and dates
=========================

-   You will receive an upload link on peergrade.io by Monday (16.09.2018) morning with concrete instructions.
-   The notebook upload is also due Monday (16.09.2018), 11:55pm. Delays are not accepted.
-   On latest Wednesday (19.09.2018), you will recieve an invitation to peergrade your fellows exams on peergrade.io. You will be asked for the evaluation of 3 peer-assignments is part of the assignment and mandatory.
-   The peergrade evaluation is due Friday (21.09.2018), 11:55pm. Delays are not accepted.

Evaluation
==========

-   Supervised peer-evaluation.
-   Evaluation by 3 peer-reviewers

Hints
=====

-   Besides the usuall stuff, you will particularly find some issues with character values. So, a little refresher or deep-dive into **regular expressions** and **string manipulation** might be necesssary. Consider in `R` the `tidyverse` package [`stringr`](https://www.rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf), in `Python` the string-manipulation functions by `Pandas`
-   Likewise, you will face issues with date-time data, such as conversions and the calculation of time-spans. In `R`, consider the `tidyverse` package [`lubridate`](https://lubridate.tidyverse.org/), in `Python` the date-manipulation functions by `Pandas` (eg., `to_datetime`)
-   Format your document properly, meaning give it a clear and easy-to-follow structure. Don't soent too much energy in making it extremely fancy and pretty, that is not the main part of the exercise. You will need some `markdown` syntax. it's ridiccously simple. All you really need you find [---&gt; Here &lt;---](https://guides.github.com/features/mastering-markdown/)
