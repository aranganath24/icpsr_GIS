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

## Remove Antarctica

world<-world %>% filter(iso_a3 !="ATA")

worldmap<-tm_shape(world)+
  tm_polygons()


## Prepare covid economic data for mapping

covid_data_economic<-covid_data %>% select(iso, Economic_Measures) 
covid_data_economic$Economic_Measures<-as.numeric(covid_data_economic$Economic_Measures)
class(covid_data_economic$Economic_Measures)

covid_data_economic<-covid_data_economic %>% group_by(iso) %>% 
                                             summarize(mean_economic=mean(Economic_Measures, na.rm=FALSE))

summary(covid_data_economic$mean_economic)


## Join Covid data to world boundaries data

worldmap_covid_data_economic<-full_join(world, covid_data_economic, by=c("iso_a3"="iso")) %>% 
                              relocate(name, mean_economic)

View(worldmap_covid_data_economic)

## Make preliminary map of economic measures 


map1<-tm_shape(worldmap_covid_data_economic)+
      tm_polygons(col="mean_economic", n=8, style="jenks", palette="BuGn")


## Makes continuous scale, changes no data label, shifts legend position

map2<-tm_shape(worldmap_covid_data_economic)+
      tm_polygons(col="mean_economic", n=5, style="cont", palette="BuGn", textNA="No Data")+
      tm_legend(position=c("left", "bottom"))


## changes legend breaks, orientation, and title; changes legend position; removes frame; legend inside

map3<-tm_shape(worldmap_covid_data_economic)+
      tm_polygons(col="mean_economic", n=5, style="cont", palette="BuGn", textNA="No Data", 
                  title="Mean of Covid Economic\nIntervention Index\n(1/1/2020 to 10/1/2020)", 
                  legend.is.portrait=FALSE,breaks=c(0,0.25,0.5, 0.75))+
      tm_layout(legend.title.size=0.8, legend.title.fontface=2,legend.outside=FALSE, 
                legend.position = c("left", "bottom"), frame=FALSE, legend.text.size = 0.5,
                legend.hist.size = 0.5)

## changes legend breaks, orientation, and title; changes legend position; removes frame; legend outside
map3a<-tm_shape(worldmap_covid_data_economic)+
       tm_polygons(col="mean_economic", n=5, style="cont", palette="BuGn", textNA="No Data", 
              title="Mean of Covid Economic\nIntervention Index\n(1/1/2020 to 10/1/2020)", 
              legend.is.portrait=FALSE,breaks=c(0,0.25,0.5, 0.75))+
        tm_layout(legend.title.size=0.8, legend.title.fontface=2,legend.outside=TRUE, 
            legend.outside.position = c("bottom"), frame=FALSE, legend.text.size = 0.5,
            legend.hist.size = 0.5)

## Add title

map4<-map3+
      tm_layout(main.title="National Economic Support Measures\nin Response to the Covid-19 Pandemic",
                main.title.position="center", legend.outside.size=0.2, attr.outside=TRUE)

map4a<-map3a+
        tm_layout(main.title="National Economic Support Measures\nin Response to the Covid-19 Pandemic",
            main.title.position="center", legend.outside.size=0.2, attr.outside=TRUE)

## Add credits 

map5<-map4+
      tm_credits("Author: Aditya Ranganath\nCRS: WGS1984\nSource: ICPSR (https://doi.org/10.3886/E119061V6)", position=c("RIGHT","BOTTOM"),
                 size=0.5)

map5a<-map4a+
       tm_credits("Author: Aditya Ranganath\nCRS: WGS1984\nSource: ICPSR (https://doi.org/10.3886/E119061V6)", position=c("RIGHT","BOTTOM"),
             size=0.5)

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