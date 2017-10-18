library(readxl)
library(tidyverse)


# Load data ---------------------------------------------------------------

df <- read_excel("./input/mortality rate.xlsx", skip = 6)


# Tidy data ---------------------------------------------------------------

out <- df %>%
  gather(key = 'temp', value = 'data', U5MR.1950:U5MR.2015) %>%
  separate(col = 'temp', into = c('indicator', 'year'), sep = '\\.') %>%
  spread(key = 'Uncertainty bounds*', value = 'data')
  

# Save data ---------------------------------------------------------------

write.csv(out, file = './output/tidy_data.csv', row.names = FALSE, na = '')
