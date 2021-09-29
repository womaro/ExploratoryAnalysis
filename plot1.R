library(utils)
library(data.table)
library(dplyr)

data_source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
data_dest <- paste(getwd(), "/exdata_data_NEI_data.zip", sep = "")

download.file(data_source, data_dest)

unzip(data_dest)

list.files(getwd())

#dataloc <- paste(getwd(), "/summarySCC_PM25.rds", sep= "")
#dataloc2 <- paste(getwd(), "/Source_Classification_Code.rds", sep= "")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

options(scipen = 100) #remove scientific notation for Total

SumNEI <- NEI %>% group_by(year) %>% summarise(Total = sum(Emissions, na.rm=TRUE))

plot(SumNEI$year,SumNEI$Total,main = "Total pm2.5 emission recorded for given year", col = "blue", pch = 19, cex.axis=0.75, xlab = "Year", ylab = "Total pm 2.5")


dev.copy(png, file = "plot1.PNG")
dev.off()


