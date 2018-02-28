##########################
# Head
# Author: Andrew McCartney
# Cultural Dimensions And {Mathematics?} Education
# Potential Data Management Project
# Initial Commit: 10/13/2017
# last edited: 10/13/2017
##########################

# Table of Contents

# A: Initial Setup and Global Settings
# A.2: Tidy
# B: Initial Visualisations


# NOTA BENE: Initial Data cleaning in Excel: 
# 1: included indicator variable "is region" and filled it manually for any non-country observation
# 2: Changed "#NULL!" to empty cells to allow tibble:: to interpret them correctly. 

######################################################
# A: initial setup and global settings
######################################################

##########################
# libraries
##########################
library(tidyverse)
library(psych)
library(ggjoy)
library(ggmap)
library(ggthemes)

##########################
# Import data
##########################
setwd("D:\\Personal Projects\\hofstede")
hofstede<-read_csv("hofstede.csv")

hof<-subset(hofstede, hofstede$isregion=="0")
#######################################################
# A.2: Tidy
#######################################################
hof<-hof %>% 
  gather(`pdi`,`idv`,`mas`,`uai`,`ltowvs`,`ivr`, key = "measure", value="value") %>%
  select(-isregion)
#######################################################
# B: initial data visualisations
#######################################################
hof
# Let's see the five variables as a joyplot

hofjoy<-ggplot(hof, aes(x=value, y=measure, fill = measure)) + 
  geom_joy(scale = 2, rel_min_height=0.03, alpha=0.5) + 
  scale_y_discrete(labels = c("Individualism","Restraint","Long Term Orientation",'Masculinity','Power Distance', 'Uncertainty Avoidance'))+
  labs(
    title="Distributions of Hofstede's Cultural Dimensions",
    subtitle = "eliminating sub- and supra-national regions", 
    caption = "data available at: http://geerthofstede.com/research-and-vsm/dimension-data-matrix/"
  ) + guides(fill=FALSE) + 
  theme_gdocs()
hofjoy
########################################################
hofbox<-ggplot(hof, aes(measure, value, color=measure))+
  geom_boxplot()+
  geom_jitter(width=0.2)+
  scale_x_discrete(labels = c("Individualism","Restraint","Long Term Orientation",'Masculinity','Power Distance', 'Uncertainty Avoidance'))+
  labs(
    title="Distributions of Hofstede's Cultural Dimensions",
    subtitle = "eliminating sub- and supra-national regions", 
    caption = "data available at: http://geerthofstede.com/research-and-vsm/dimension-data-matrix/"
  ) + guides(fill=FALSE, color=FALSE) +
  coord_flip() + 
  theme_gdocs()
hofbox 



sd(hofstede$ivr, na.rm=T)
sd(hofstede$mas, na.rm=T)
library(psych)
library(car)
describeBy(hof$value, group=hof$measure)
describeBy
hof
levene.test
?levene.test
