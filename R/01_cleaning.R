library(readxl)
library(stringi)

# Load data ---------------------------------------------------------------

source('R/00_import_batch_read.R')
gaul <- read_excel('input/gaul_master.xlsx')


# Merge - 1 ---------------------------------------------------------------

merged <- left_join(adm1, gaul)
# Number of failed merge
sum(is.na(merged$GAUL_CODE))


# prep data ---------------------------------------------------------------

# All to lower case
gaul[] <- map(gaul, tolower)
adm1[] <- map(adm1, tolower)

# remove accents
gaul[] <- map(gaul, stri_trans_general, "Latin-ASCII")
adm1[] <- map(adm1, stri_trans_general, "Latin-ASCII")

# Merge - 2 ---------------------------------------------------------------

merged <- left_join(adm1, gaul)
# Number of failed merge
sum(is.na(merged$GAUL_CODE))


# Number of admin regions per country -------------------------------------

region_count <- merged %>%
  group_by(NAME_0) %>%
  summarise(
    n_regions = n()
  )


