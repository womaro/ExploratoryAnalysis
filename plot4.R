library(utils)
library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)

data_source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
data_dest <- paste(getwd(), "/exdata_data_NEI_data.zip", sep = "")

options(scipen = 100) #remove scientific notation for Total

download.file(data_source, data_dest)

unzip(data_dest)

list.files(getwd())

#dataloc <- paste(getwd(), "/summarySCC_PM25.rds", sep= "")
#dataloc2 <- paste(getwd(), "/Source_Classification_Code.rds", sep= "")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

SCC$combine <- paste(SCC$SCC.Level.One, SCC$SCC.Level.Three) #additional column containing type and source

coalUsed <- grep("Combustion.*?Coal)", SCC$combine, value = TRUE)

pattern <- c("Combustion", "Coal")

all(str_detect(SCC$combine,pattern))

test <- str_extract(SCC$combine, "Combustion", "Coal")

coalused
head(NEI)
head(SCC, 10)
head(coalUsed, 10)


BaltimoreNEI <- NEI %>% filter(fips == "06037") %>% group_by(year, type) %>% summarise(Total = sum(Emissions, na.rm=TRUE))

q <- qplot(year, Total, data = BaltimoreNEI, facets = .~type) + geom_smooth(size = 0.9, linetype = 1, method = "lm", se = FALSE) #main plot

q + ggtitle(label = "PM2.5 sources in Baltimore by type across years") +theme(plot.title = element_text(hjust = 0.5))  +labs(x = "Year of measurement", y = "Total pm2.5 in Baltimore") + coord_cartesian(ylim = c(0, 22000)) # and some additional settings to it

dev.copy(png, file = "plot3.PNG")
dev.off()