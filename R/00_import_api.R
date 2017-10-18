library(wbstats)

# Import from WDI API -----------------------------------------------------

wbsearch(pattern = 'mortality rate, under-5')

df <- wb('SH.DYN.MORT', startdate = 1960, enddate = 2015, country = 'all')

View(df)
