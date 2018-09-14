### set working directory
# This will set your working rirectory to the place where the scipt is. Note: Only relevant for 
# r-script files ()endlng with .r). R-Notebooks ()ending with .rmd) by default take 
setwd("folder1/foler2/final_folder") # Change that. Copy&Past your directory path, for example ""

### Cleaning the workspace, meaning deleting all previously loaded data (optimal step)
rm(list=ls())

### Installing packages: If you did not install the packages, uncomment (remove the leading #) the following lines and run
# install.packages("tidyverse")
# install.packages("data.table")

### Loading packages
library(tidyverse) # loads the whole tidyverse, including dplyr, readr, ggplot, etc
library(data.table) # loads the data.table package, in case you use the fread() 

### Loading data
# Necessary: the datafiles you find in the assignment folder have to be placed in the same folder as this script file.

# Best thing to do: fread() from data.table
# header = TRUE tells fread that the first row should be interpreted as variable-name
# data.table = TRUE tells fread that it should not create a data.table (its own data format), but a dataframe instead
# check.names = TRUE will replace space in Variable names with . (because R doesnt like that)
cities_df <- fread("cities_df.csv", header = TRUE, check.names = TRUE, data.table = FALSE) 
trips_df <- fread("trips_df.csv", header = TRUE, check.names = TRUE, data.table = FALSE) 

### Inspect the data
# how dies the data look like? head() prints the first rows
head(cities_df)
head(trips_df)

# variable names are a mix of capital letters, and small letters. Lets make them all small.
colnames(trips_df) <- tolower(colnames(trips_df))
colnames(cities_df) <- tolower(colnames(cities_df))

# Further, we see that for some reasons some variable names (eg., country) appear more than once
# Let's throw them out
cities_df <- cities_df[,!duplicated(colnames(cities_df))]

### Lets only look at cities:
glimpse(cities_df)

# Lets select just some variables to look closer
cities_df <- cities_df %>%
  select(place_slug, walkability, startup.score, quality.of.life, fun, beer)

glimpse(cities_df)

# Lets recode the characters into numeric. Lets only do it for "fun"
# First, check what are the different values "fun" can take.
unique(cities_df$fun)

# That we could recode into numeric. 
# Dont worry about the warning. Only states that the not mentioned values (here, an empty string "") will be replaced by NA
cities_df <- cities_df %>%
  mutate(fun = recode(fun, bad = 1, okay = 2, good = 3, great = 4))

# We also could do that for all other variables. 
# Since they are coded in the same way (bad, okay, good, great), so we can use the same code, only change the variable name
cities_df <- cities_df %>%
  mutate(startup.score = recode(startup.score, bad = 1, okay = 2, good = 3, great = 4),
         walkability = recode(walkability, bad = 1, okay = 2, good = 3, great = 4),
         quality.of.life = recode(quality.of.life, bad = 1, okay = 2, good = 3, great = 4))


# That does not work for "beer". Imaging we are really interested in the costs of beer, since we think its important
# So we have to somehow extract the amount in $ out of the whole weird string.
# There are different ways to do that. I would use regular expressions. We see, that there is first a "$",
# then the price in dollar in numeric with a decimal ".", followed by the local currency. Before the local currency, there is always a space.
# We can use that to extract only the part before the space
# Lets do that step-by-step. First we split the string into 2, one before, and one after the first space
# also note: This could all be done in dplyr, but in this case its easier for you to keep the overview in base-R syntax

x <- str_split_fixed(cities_df$beer, " ", 2)

# In the first column, we should now have only the $, amount, and then the string for the second currency. We now just delete 
# everything non-numeric (but we want to keep the digit)

x[,1] <- gsub("[^0-9\\.]", "", x[,1])
 
cities_df[,"beer"] <- as.numeric(x[,1])
 
# Ok, now we replace our messy beer column with it. Note, we could do that all in-line, doing it in a sepperate object c was
# for you to keep the overview. Also note: Working with strings sucks. Only do that if you really feel you need to.
# Read up on regular expressions in R at: https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html


# We now just drop all NAs for this exercise
cities_df <- cities_df %>%
  drop_na() 

# Further, we drop cities that appear twice. Argument ".keep_all = TRUE" means that we do not want to discard the rest of the variables
cities_df <- cities_df %>%
  distinct(place_slug, .keep_all = TRUE)

# Note: for graphical visualization, we need rownames. Its outdated and silly, but cannot be changed, since the plot function labels by rownames
rownames(cities_df) <- cities_df[,"place_slug"] 

# Ok, now we transformed two categorical variables into numeric one. We coudl do a clustering on them.

# kmeans() is the easiest one, included in base R. More clustering techniques can be found in the "FactoMineR" package
# we only select the variables we want to cluster
# The argument "centers = 3" specifies how many clusters we would like to have
# 
# Trick: Don't forget to scale() the data
?kmeans
km.cities <- kmeans(cities_df %>% select(-place_slug) %>% scale(), centers = 3)

# we could visualize it with the "factoextra" package
library(factoextra)
fviz_cluster(km.cities, 
             data = cities_df %>% select(-place_slug) %>% scale()) 

# Looks weird. but maybe we would have a better clustering with more or different variables. Anyhow, lets bind them to our original city data
# Clustering does not change the order, so we can just bint it.

cities_df <- cities_df %>%
  bind_cols(cluster = km.cities$cluster) 

# We could now see which cluster was more visited, therefore maybe more popular
# Easiest way is to join it with the trips and count how many times there where trips to the cluster
# We know that the variable "place_slug" appears in bost dataframes, so can be used as ID for a merge

trips_df <- trips_df %>%
  left_join(cities_df %>% select(place_slug, cluster), by = "place_slug")

# Now, lets see how many people visited the different clusters overall
trips_df %>%
  group_by(cluster) %>%
  count()

# Note, "count" is a convenience function that can just count. If you wnat to have a mean or something like that
# use the summarize() functions. Look in the M2 script for further guidance

