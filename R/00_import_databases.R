library(httr)
library(DBI)
library(RSQLServer)
library(dplyr)
options(warn = -1)

# Set database connection -------------------------------------------------

set_config(config(ssl_verifypeer = 0L))

drv = dbDriver("SQLServer")
dcs <- dbConnect(drv = drv, 
                 server = 'DCS',
                 file = './input/sql.yaml')


# Explore tables ----------------------------------------------------------

dbListTables(dcs)
wdi_db <- tbl(dcs, "WDI_Fact")
wdi_db

results <- wdi_db %>%
  filter(Indicator_Code == 'SH.H2O.SAFE.ZS') 
results

results %>% show_query()

results <- collect(results)

# End database connection
dbDisconnect(dcs)
