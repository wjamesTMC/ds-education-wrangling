library(tidyverse)
library(dslabs)
library(readr)
library(readxl)
install.packages("htmlwidgets")

data("reported_heights")

# We are now ready to put everything we've done so far together and 
# wrangle our reported heights data as we try to recover as many heights 
# as possible. The code is complex but we will break it down into parts.

# We start by cleaning up the height column so that the heights are closer 
# to a feet'inches format. We added an original heights column so we can 
# compare before and after.

# Let's start by writing a function that cleans up strings so that all the 
# feet and inches formats use the same x'y format when appropriate.

pattern <- "^([4-7])\\s*'\\s*(\\d+\\.?\\d*)$"

smallest <- 50
tallest <- 84
new_heights <- reported_heights %>% 
  mutate(original = height, 
         height = words_to_numbers(height) %>% convert_format()) %>%
  extract(height, c("feet", "inches"), regex = pattern, remove = FALSE) %>% 
  mutate_at(c("height", "feet", "inches"), as.numeric) %>%
  mutate(guess = 12*feet + inches) %>%
  mutate(height = case_when(
    !is.na(height) & between(height, smallest, tallest) ~ height, #inches 
    !is.na(height) & between(height/2.54, smallest, tallest) ~ height/2.54, #centimeters
    !is.na(height) & between(height*100/2.54, smallest, tallest) ~ height*100/2.54, #meters
    !is.na(guess) & inches < 12 & between(guess, smallest, tallest) ~ guess, #feet'inches
    TRUE ~ as.numeric(NA))) %>%
  select(-guess)

# We can check all the entries we converted using the following code:

new_heights %>%
  filter(not_inches(original)) %>%
  select(original, height) %>% 
  arrange(height) %>%
  View()

# Let's take a look at the shortest students in our dataset using 
# the following code:

new_heights %>% arrange(height) %>% head(n=7)

# We see heights of 53, 54, and 55. In the original heights column,
# we also have 51 and 52. These short heights are very rare and it 
# is likely that the students actually meant 5'1, 5'2, 5'3, 5'4, 
# and 5'5. But because we are not completely sure, we will leave 
# them as reported.

# [End]