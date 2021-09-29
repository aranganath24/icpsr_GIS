library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(tidyverse)
library(readxl)
library(dplyr)

#Load Tabular Data
IPR_data<-read_excel("Index_IPR_Agriculture.xlsx", sheet="Total_Index")
View(IPR_data)

# Load Spatial Data
country_boundaries<-ne_countries(scale="medium", returnclass="sf")
View(country_boundaries)

# Delete Antarctica
country_boundaries<-country_boundaries %>% filter(iso_a3 !="ATA")

# Check class of Index
class(IPR_data$`Total Index`)

# Select 2015 Observations
IPR_data_2018<-IPR_data %>% filter(year==2018)
View(IPR_data_2018)

# Join Datasets
worldmap_IPR_2018<-full_join(country_boundaries, IPR_data_2018, by=c("iso_a3"="Country_code")) %>% 
                    relocate(Country, 'Total Index')
View(worldmap_IPR_2018)

# Make Map

IPR_2018_map<-tm_shape(worldmap_IPR_2018)+
                tm_polygons(col="Total Index",
                            n=6, 
                            style="jenks", 
                            palette="PuBu",
                            title="Agriculture IPR\nIndex, 2018")+
                tm_layout(frame=FALSE,
                          legend.outside=TRUE,
                          legend.outside.position=c("bottom"),
                          main.title = "Strength of Intellectual Property Protection in Agriculture, 2018",
                          main.title.position = "Center",
                          main.title.size=1,
                          inner.margins=c(0.06,0.10,0.10,0.08),
                          attr.outside=TRUE)+
                tm_credits("Map Author: YOUR NAME\nDataset Author: Mercedes Campi\nCRS:WGS84\nSource:ICPSR",
                           position=c(0.78,0),
                           size=0.38)
IPR_2018_map


tmap_mode("view")
IPR_2018_map


https://www.openicpsr.org/openicpsr/project/121001/version/V1/view?path=/openicpsr/121001/fcr:versions/V1/Index_IPR_Agriculture.xlsx&type=file





