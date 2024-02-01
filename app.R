#install.packages('shiny')
#install.packages('bslib)
#install.packages('bslib)
library(shiny)
library(bslib)
library(shinyjs)
library(raster)
library(sp)
library(dismo)
library(maptools)
source(file = "functions/sdm-functions_updated.R")
source(file = "functions/plot-functions.R")

sample_data <- read.csv("data/MY_SPECIES.csv",stringsAsFactors = F,sep=',')

ui <- page_navbar(title = 'Species dsitribution model',
                  header=useShinyjs(),
  nav_panel('Single species',
            layout_sidebar(
              sidebar=sidebar(width = 300,
                fileInput('file1_1','Single_species'),
                downloadLink('sample_data','sample data'),
                radioButtons('future_single',label='Type',
                                   choices=c('Current climate data'=FALSE,'Future climate data'=TRUE),
                                   selected = FALSE,inline = TRUE),
                actionButton('run_single','Run',class='btn-inline btn-primary'),
                downloadButton('save_single','Save Image',class='btn-inline')
              ),
              div(style="width:600px;height:600px",
                  plotOutput("plot_single")
                  )
            )),
  nav_panel('Paired species',
            layout_sidebar(
              sidebar=sidebar(width = 300,
                fileInput('file2_1','Species_1'),
                fileInput('file2_2','Species_2'),
                radioButtons('future_paired',label='Type',
                                   choices=c('Current climate data'=FALSE,'Future climate data'=TRUE),
                                   selected = FALSE,inline = TRUE),
                actionButton('run_paired','Run',class='btn-inline btn-primary'),
                downloadButton('save_paired','Save Image',class='btn-inline')
              ),
              div(style="width:600px;height:600px",
                  plotOutput("plot_paired",width = '100%')
                  )
            ))
)


server <- function(input, output, session) {
  output$sample_data <- downloadHandler(
    filename = function() {
      paste0("MY_SPECIES.csv")
    },
    content = function(file) {
      write.csv(sample_data, file)
    }
  )
  #single
  observeEvent( input$file1_1 , {
    file <- input$file1_1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    data<-read.csv(file$datapath,stringsAsFactors = F,sep=',')
    write.csv(data,'data/file1_1.csv')
  })
  observeEvent( input$file1_1 , {
    file <- input$file1_1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    data<-read.csv(file$datapath,stringsAsFactors = F,sep=',')
    write.csv(data,'data/file1_1.csv')
  })
  observeEvent(input$run_single, {
    req(input$file1_1)
    disable('save_single')
    infile<-'data/file1_1.csv'
    future<-input$future_single
    withProgress(message = 'Calculation in progress',
                 detail = 'This may take a while...', value = 0,{
                   incProgress(1/3)
                   prepared.data <- PrepareData(file = infile)
                   single_prediction(prepared.data,future = future)
                   incProgress(1/3)
                   output$plot_single<-renderImage({
                     list(
                       width = 600,
                       height = 600,
                       src=ifelse(future,
                                  'output/MY_SPECIES-single-future.png',
                                  'output/MY_SPECIES-single.png')
                     )
                   }, deleteFile = FALSE)
                   incProgress(1/3)
                   enable('save_single')
    })
  })
  # paired
  observeEvent( input$file2_1 , {
    file <- input$file2_1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    data<-read.csv(file$datapath,stringsAsFactors = F,sep=',')
    write.csv(data,'data/file2_1.csv')
  })
  observeEvent( input$file2_2 , {
    file <- input$file2_2
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    data<-read.csv(file$datapath,stringsAsFactors = F,sep=',')
    write.csv(data,'data/file2_2.csv')
  })
  observeEvent(input$run_paired, {
    req(input$file2_1)
    req(input$file2_2)
    disable('save_paired')
    species1.data.file <- "data/file2_1.csv"
    species2.data.file <- "data/file2_2.csv"
    
    future<-input$future_paired
    withProgress(message = 'Calculation in progress',
                 detail = 'This may take a while...', value = 0,{
                   incProgress(1/3)
                   species1.data <- PrepareData(file = species1.data.file)
                   species2.data <- PrepareData(file = species2.data.file)
                   paired_prediction(species1.data,species2.data,future = future)
                   incProgress(1/3)
                   output$plot_paired<-renderImage({
                     list(
                       width = 600,
                       height = 600,
                       src=ifelse(future,
                                  'output/MY_SPECIES-paired-future.png',
                                  'output/MY_SPECIES-paired.png')
                     )
                   }, deleteFile = FALSE)
                   incProgress(1/3)
                   enable('save_paired')
                 })
  })
  disable('save_single')
  disable('save_paired')
  output$save_single<- downloadHandler(
    filename = function() {
      paste0("MY_SPECIES-single",
             ifelse(input$future_single,'-future ',' '),
             Sys.time(), ".png")
    },
    content = function(file) {
      path=paste0('output/MY_SPECIES-single',
                  ifelse(input$future_single,'-future',''),
                  ".png")
      file.copy(
        from = path,
        to = file
      )
    }
  )
  output$save_paired<- downloadHandler(
    filename = function() {
      paste0("MY_SPECIES-paired",
             ifelse(input$future_single,'-future ',' '),
             Sys.time(), ".png")
    },
    content = function(file) {
      path=paste0('output/MY_SPECIES-paired',
                  ifelse(input$future_single,'-future',''),
                  ".png")
      file.copy(
        from = path,
        to = file
      )
    }
  )
}

shinyApp(ui, server)