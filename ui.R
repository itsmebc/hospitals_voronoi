ui <- 
  navbarPage("Reshaping the US using Voronoi tessellation",
             tabPanel("Introduction",
                      sidebarLayout(
                          sidebarPanel(width=3,
                          h3("What is it?"),
                          p("A Voronoi diagram sections an area into regions that are closest to a given set of points.
                            In this project, the given points used are hospital locations. Each region on the map is shaped
                            according to the smallest distance to a hospital."),
                          br(),
                          br(),
                          h3("Why?"),
                          p("There are many areas in the US where immediate medical attention is impossible. 
                            According to a ",
                            a("study", href = "https://www.pewresearch.org/fact-tank/2018/12/12/how-far-americans-live-from-the-closest-hospital-differs-by-community-type/"), 
                            "done by the Pew Research Center, the average rural American lives 10.5 miles from their nearest hospital. 
                            This project explores how the geography of the US would change if counties were abolished in favor of
                            hospital centralization."),
                        ),
                        mainPanel(
                          tags$iframe(
                            seamless = "seamless", 
                            src = "https://cdn.knightlab.com/libs/juxtapose/latest/embed/index.html?uid=3471b80a-5612-11ec-abb7-b9a7ff2ee17c", 
                            height = 540, width = 950
                          )
                        )
                      )
             ),
              tabPanel("States",
                       sidebarLayout(position="left",
                         sidebarPanel(width=3,
                           selectInput("state", "Select state", states[,1]),
                           checkboxGroupInput("checklist", "Hospital type:", choices = c("CRITICAL ACCESS", "LONG TERM CARE", "GENERAL ACUTE CARE"),
                                              selected = c("CRITICAL ACCESS", "LONG TERM CARE", "GENERAL ACUTE CARE")),
                           radioButtons("switch", "Plot: ", choices = c("New", "Original")),
                           
                           hr(style = "border-top: 1px solid #000000;"),
                           p("*Try experimenting with voronoi tessellations by double clicking to add your own hospitals!"),
                           br(),
                           radioButtons("add_hospital_type", "Hospital type: ", choices = c("CRITICAL ACCESS", "LONG TERM CARE", "GENERAL ACUTE CARE")),
                           actionButton("reset", "Reset")),
                       mainPanel(
                         plotOutput("map", dblclick="add_hospital", brush="plot_drag", width="100%", height="800"),
                         br(),
                         tableOutput("hospital_list")),
                         #tableOutput("check")),
                       )
             )
  )
             
