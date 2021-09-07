library(utils)
library(data.table)
library(dplyr)

data_source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
data_dest <- paste(getwd(), "/exdata_data_NEI_data.zip", sep = "")

download.file(data_source, data_dest)

unzip(data_dest)

list.files(getwd())

dataloc <- paste(getwd(), "/summarySCC_PM25.rds", sep= "")

dataloc2 <- paste(getwd(), "/Source_Classification_Code.rds", sep= "")

introdata <- readRDS(dataloc)
loctranslate <- readRDS(dataloc2)

head(introdata)
head(loctranslate)

test



