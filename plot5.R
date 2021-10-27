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

onRoad <- grep("[mM]otor.*?[vV]ehicles", SCC$combine) #motor vehicles as source vector

#combustionCoalUsed <- grep("Combustion.*?Coal", SCC$combine)
#typeof(onRoad)

motorVehiclesOnRoad <- SCC$SCC[onRoad] #Motor vehicle as source

#motorVehiclesOnRoad  = as.character(levels(motorVehiclesOnRoad)[as.integer(motorVehiclesOnRoad)]) # convert factor to vector

motorVehiclesOnRoadSource <- NEI[NEI$SCC %in% motorVehiclesOnRoad,]

CoalComNEI <- NEI[NEI$SCC %in% combustionCoalLocations,]

head(motorVehiclesOnRoad)

newSCC$SCC <- as.character(newSCC$SCC)

test <- dplyr::bind_rows(SCC)

test <- newSCC[SCC == "10100102"]

motorVehiclesOnRoadSource  <- motorVehiclesOnRoadSource  %>% filter(fips == "24510") #Motor vehicle as source in Baltimore

motorVehiclesOnRoadSource  <- motorVehiclesOnRoadSource  %>% group_by(year) %>% summarise(Total = sum(Emissions, na.rm=TRUE))

plot(motorVehiclesOnRoadSource$year,motorVehiclesOnRoadSource $Total,main = "Total pm2.5 emission from coal combustion in a given year", col = "blue", pch = 19, cex.axis=0.75, xlab = "Year", ylab = "Total pm 2.5")

dev.copy(png, file = "plot5.PNG")
dev.off()