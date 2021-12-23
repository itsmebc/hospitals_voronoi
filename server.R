hospital = read.csv("hospitals.csv") %>%
  filter(TYPE %in% c('CRITICAL ACCESS', 'LONG TERM CARE', 'GENERAL ACUTE CARE'))
states = map_data("state") %>% distinct(region)
statesJoin = tibble(region = tolower(state.name), abbv = state.abb)
states = merge(states, statesJoin, by="region", all.x=TRUE)
states[8,][2] = "DC"

server = function(input, output) {

  hospitals = reactiveValues()
  hospitals$df = hospital %>% select(LONGITUDE, LATITUDE, NAME, TYPE, STATE)
  
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
  
  typeColors = c("#ff1700", "#ffa600", "#4d6910")
  
  output$map = renderPlot({
    ggplot(hospitals$df %>% filter(STATE == stateAbbv(),
                                TYPE %in% c(input$checklist)),
           aes(x=LONGITUDE,y=LATITUDE))+
           mapT()+
           geom_point(aes(color=factor(TYPE)),
                 size = 1,
                 stroke = 2,
                 alpha=1)+
           theme(panel.background = element_blank(),
                 plot.margin = margin(.1,.1,.1,.1,"cm"),
                 axis.title.x = element_blank(),
                 axis.title.y = element_blank(),
                 legend.position = "top",
                 legend.text= element_text(size=16),
                 legend.key.size = unit(1,"cm"),
                 legend.title = element_blank()
                 )+
      scale_color_manual(values = c("CRITICAL ACCESS" = typeColors[[1]],
                                    "LONG TERM CARE" = typeColors[[2]],
                                    "GENERAL ACUTE CARE" = typeColors[[3]]))
   })
  
  #output$check <- renderTable(hospitals$df %>% filter(STATE == stateAbbv()))
  
  observeEvent(input$add_hospital, {
    hospitals$df = hospitals$df %>% add_row(
      "LONGITUDE" =as.double(input$add_hospital$x),
      
      "LATITUDE" =as.double(input$add_hospital$y),
      "NAME" = "User Input",
      "TYPE" = as.character(input$add_hospital_type),
      "STATE" = as.character(stateAbbv()))
  })
  
  # output$hospital_list <- renderTable({
  #   data.frame("vals")
  # })
  
  output$hospital_list <- renderTable({
    validate(
      need(!is.null(input$plot_drag), "Click and drag to display the list of hospitals in the drawn box."))
    hospitals$df %>% filter(STATE == stateAbbv(), 
                         between(LONGITUDE, input$plot_drag$xmin, input$plot_drag$xmax) & 
                         between(LATITUDE, input$plot_drag$ymin, input$plot_drag$ymax)) %>% 
                  select(NAME, TYPE, LONGITUDE, LATITUDE)
  })

  
  observeEvent(input$reset, {
    hospitals$df = hospital %>% select(LONGITUDE, LATITUDE, NAME, TYPE, STATE)
  })
}