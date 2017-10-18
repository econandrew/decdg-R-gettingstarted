library(tidyverse)

browseURL('http://gadm.org/')
# http://biogeo.ucdavis.edu/data/gadm2.8/shp/AFG_adm_shp.zip

# Load data ---------------------------------------------------------------

iso <- read_csv('input/iso_codes.csv')
iso <- iso[1:10, ]

# Download files from GADM site -------------------------------------------

# Create folder
my_folder <- './input/batch_download'
dir.create(my_folder)

urls_list <- paste0('http://biogeo.ucdavis.edu/data/gadm2.8/shp/', iso$iso3_code, '_adm_shp.zip')
filenames_list <- paste0(my_folder, '/', iso$iso3_code, '.zip')
download_file <- safely(download.file)
map2(urls_list, filenames_list, download_file)

# unzip files
zipped_files <- dir(my_folder, full.names = TRUE, recursive = TRUE)
map(zipped_files, unzip, exdir = './input/batch_download')
map(zipped_files, file.remove)

rm(iso, filenames_list, urls_list, zipped_files, download_file)
