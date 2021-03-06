library(tidyverse)
library(dslabs)
library(readr)
library(readxl)
install.packages("htmlwidgets")

data("reported_heights")
setwd("C:/Users/jamesw/Documents/ds-education-wrangling")

# In general, string processing tasks can be divided into detecting, locating, extracting,
# or replacing patterns in strings.

# In our example, we need to locate the comma and replace them with an empty character.
# Base R includes function to perform all these tasks. However, they don't follow a unifying 
# convention, which makes it a bit hard to memorize and use.
#
#The stringr package basically repackages this functionality, but using a more consistent
# approach of naming functions and ordering their arguments.
# For example, in stringr, all the string processing functions start with str_,
# which means that if you type this and then hit Tab,
# R will autocomplete and show you all the available functions,
# which means we don't necessarily have to memorize all the function names.
#
# Another advantage is that the string is always the first argument, which means we can 
# move more easily using the pipe. So we'll be focusing on the stringr package.
# However, because the R Base equivalents are so widely used, we're going to show you a 
# table that includes a map showing you the stringr functions and the R Base equivalents 
# when available.

# String exercises - the problems set where heights are not in inches

not_inches <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- is.na(inches) | inches < smallest | inches > tallest
  ind
}

problems <- reported_heights %>% filter(not_inches(height)) %>% .$height
length(problems)

pattern <- "^[4-7]'\\d{1,2}\"$"

problems[c(2, 10, 11, 12, 15)] %>% str_view(pattern)

str_subset(problems, "inches")
str_subset(problems, "''")

# We will simplify the pattern by no longer using the inches symbol at the end
# so 5'4 will denote 5 feet 4 inches. Now the pattern looks like this:

pattern <- "^[4-7]'\\d{1,2}$"

# Before we run this, we will do some string replacement to replace "feet" and "inches"
# with the feet symbols.

problems %>% str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"", "") %>%
  str_detect(pattern) %>% sum

# Another problem is spaces - we did not get matches where spaces exist
# Spaces can be represented by \s so we can change the pattern to the following

pattern_2 <- "^[4-7]'\\s\\d{1,2}\"$"
str_subset(problems, pattern_2)

# We want a pattern to permit spaces but not require them. The asterisk indicates
# one or more instances. Se we can improve the pattern by adding the * after \\s

pattern_2 <- "^[4-7]'\\s*\\d{1,2}\"$"

# There are two other qualifiers. For none or once, we use ?
# For one or more, we use +
# Note the differences using this code:

yes <- c("5", "6", "5'10", "5 feet", "4'11")
data.frame(string = c("AB", "A1B", "A11B", "A111B", "A1111B"),
           none_or_more = str_detect(yes, "A1*B"),
           none_or_once = str_detect(yes, "A1?B"),
           once_or_more = str_detect(yes, "A1+B"))

# New pattern
not_inches <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- is.na(inches) | inches < smallest | inches > tallest
  ind
}

problems <- reported_heights %>% filter(not_inches(height)) %>% .$height
length(problems)

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
problems %>% str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"", "") %>%
  str_detect(pattern) %>% sum

# Why not use str_replace_all? It could have unintentional consequences

