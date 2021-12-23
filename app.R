library(shiny)
library(tidyverse)
library(ggvoronoi)
library(spData)

source('ui.R', local=TRUE)
source('server.R', local=TRUE)

shinyApp(
  ui=ui,
  server=server
)
