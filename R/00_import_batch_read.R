library(tidyverse)

# Load downloaded files ---------------------------------------------------
my_folder <- './input/batch_download'
files_list <- dir(path = my_folder, pattern = '_adm1\\.csv$', full.names = TRUE)
files <- map(files_list, read_csv, col_types = cols(.default = "c"))
adm1 <- bind_rows(files)


# Prep for 01_cleaning.R --------------------------------------------------

adm1 <- adm1 %>%
  select(NAME_0, NAME_1, HASC_1)
