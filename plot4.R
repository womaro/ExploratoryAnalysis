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

combustionCoalUsed <- grep("Combustion.*?Coal", SCC$combine) #Vector containing combustion and coal as a source

combustionCoalLocations[] <- SCC$SCC[combustionCoalUsed] #Locations where combustion and coal were source in dataset

head(combustionCoalUsed)

CoalComNEI <- NEI[NEI$SCC %in% combustionCoalLocations,]

TotalCoalCombustionNEI <- CoalComNEI %>% group_by(year) %>% summarise(Total = sum(Emissions, na.rm=TRUE))

plot(TotalCoalCombustionNEI$year,TotalCoalCombustionNEI$Total,main = "Total pm2.5 emission from coal combustion in a given year", col = "blue", pch = 19, cex.axis=0.75, xlab = "Year", ylab = "Total pm 2.5")

dev.copy(png, file = "plot4.PNG")
dev.off()