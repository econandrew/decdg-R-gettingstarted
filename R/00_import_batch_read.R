library(tidyverse)

# Load downloaded files ---------------------------------------------------

files_list <- dir(path = my_folder, pattern = '_adm1\\.csv$', full.names = TRUE)
files <- map(files_list, read_csv, col_types = cols(.default = "c"))
adm1 <- bind_rows(files)
