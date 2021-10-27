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

NEI2 <- readRDS("summarySCC_PM25.rds")
SCC2 <- readRDS("Source_Classification_Code.rds")

SCC2$combine <- paste(SCC2$SCC.Level.One, SCC2$SCC.Level.Three) #additional column containing type and source

onRoad <- grep("[mM]otor.*?[vV]ehicles", SCC2$combine) #motor vehicles as source vector

motorVehiclesOnRoad <- SCC2$SCC[onRoad] #Motor vehicle as source

motorVehiclesOnRoadSourceBTvsLA<- NEI2 %>% filter(fips %in% c("24510", "06037")) %>% filter(SCC %in% motorVehiclesOnRoad) #Motor vehicle as source in Baltimore

motorVehiclesOnRoadSourceBTvsLA  <- motorVehiclesOnRoadSourceBTvsLA  %>% group_by(year) %>% summarise(Total = sum(Emissions, na.rm=TRUE))

plot(motorVehiclesOnRoadSourceBTvsLA $year,motorVehiclesOnRoadSourceBTvsLA  $Total,main = "Total pm2.5 emission from motor vehicles in Baltimore in a given year", col = "blue", pch = 19, cex.axis=0.75, xlab = "Year", ylab = "Total pm 2.5")

dev.copy(png, file = "plot6.PNG")
dev.off()