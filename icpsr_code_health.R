#Load Libraries
library(readxl)
library(tidyverse)
library(tmap)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

#Set working directory
setwd("~/Documents/git_repositories/icpsr_GIS")

# Read in Covid Data
covid_data<-read_excel("Gov_Responses2Covid19_last.xlsx", sheet="Dataset")
View(covid_data)

# Bring in world boundaries data 
world<-ne_countries(scale="medium", returnclass="sf")

worldmap<-tm_shape(world)+
           tm_polygons()


## Prepare covid economic data for mapping

covid_data_health<-covid_data %>% select(iso, Rigidity_Public_Health) 
covid_data_health$Rigidity_Public_Health<-as.numeric(covid_data_health$Rigidity_Public_Health)
class(covid_data_health$Rigidity_Public_Health)

covid_data_health<-covid_data_health %>% group_by(iso) %>% 
                                         summarize(mean_health_rigidity=mean(Rigidity_Public_Health, na.rm=FALSE))


## Join Covid data to world boundaries data

worldmap_covid_data_health<-full_join(world, covid_data_health, by=c("iso_a3"="iso")) %>% 
                              relocate(name, mean_health_rigidity)

View(worldmap_covid_data_health)



## Make preliminary map of economic measures 


map1<-tm_shape(worldmap_covid_data_health)+
      tm_polygons(col="mean_health_rigidity", n=6, style="jenks", palette="BuGn")


map1












##Introduction (ICPSR, motivation)
##Download data from ICPSR
## Load ICPSR data into R Studio
## Bring in map data and visualize map
##Clean ICPSR data
## Join ICPSR data to world map
## Create map
## Customize
## Conclusion
## Student Activity
## Answers to student activity 
## Student challenge
## Answers to student challenge





https://r-spatial.org/r/2018/10/25/ggplot2-sf.html