library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggvoronoi)
library(spData)
library(ggiraph)
library(data.table)

source('ui.R', local=TRUE)
source('server.R', local=TRUE)

shinyApp(
  ui=ui,
  server=server
)
