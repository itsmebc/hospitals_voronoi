hospital = read.csv("hospitals.csv") %>%
  filter(TYPE %in% c('CRITICAL ACCESS', 'LONG TERM CARE', 'GENERAL ACUTE CARE')) %>%
  mutate(TYPECOLOR = case_when(TYPE == 'CRITICAL ACCESS' ~ "#eb3483",
                           TYPE == 'LONG TERM CARE' ~ "#fcf803",
                           TYPE == 'GENERAL ACUTE CARE' ~ "#34eb43"))
states = map_data("state") %>% distinct(region)
statesJoin = tibble(region = tolower(state.name), abbv = state.abb)
states = merge(states, statesJoin, by="region", all.x=TRUE)
states[8,][2] = "DC"

server = function(input, output) {
  
  hospitals = hospital
  
  stateAbbv = reactive({
    states %>% filter(region == input$state) %>% pull(abbv)
  })
  
  mapT <- reactive({
    if(input$switch == "New") {
      stat_voronoi(geom="path",
                          outline = map_data("state") %>% filter(region==input$state),
                          color="black")
    }
    else if (input$switch == "Original"){
      geom_polygon(data=map_data("county")%>%filter(region==input$state), 
                   aes(x=long, y=lat, group=group), 
                   color="black",
                   fill="white")
    }
  })
  
  output$map = renderPlot({
    ggplot(hospitals %>% filter(STATE == stateAbbv(),
                                TYPE %in% c(input$checklist)),
           aes(x=LONGITUDE,y=LATITUDE, color=TYPECOLOR))+
           mapT()+
           geom_point(size = 1,
                 stroke = 2,
                 alpha=1,
                 shape=21) +
           theme(panel.background = element_blank(),
                 plot.margin = margin(.1,.1,.1,.1,"cm"),
                 axis.title.x = element_blank(),
                 axis.title.y = element_blank()
                 )
   })
  
  output$info <- renderText({
    paste0("x=", input$add_hospital$x, "\ny=", input$add_hospital$y)
  })
  
  output$dynamic <- renderUI({
    req(input$plot_hover) 
    verbatimTextOutput("vals")
  })
  
  output$vals <- renderPrint({
    hospitals %>% filter(STATE == stateAbbv(), 
                         between(LONGITUDE, input$plot_hover$xmin, input$plot_hover$xmax) & 
                         between(LATITUDE, input$plot_hover$ymin, input$plot_hover$ymax)) %>% 
                  select(NAME, LONGITUDE, LATITUDE)
  })
  
  observeEvent(input$reset, {
    hospitals = hospital
  })
}