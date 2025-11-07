install.packages(c('dplyr', 'ggplot2'))

install.packages('ProjectTemplate')

library(ProjectTemplate)

create.project('myProj')

load.project()

load.project()
cache('cleaned_data')
load.project()


install.packages("tinytex")
tinytex::install_tinytex()