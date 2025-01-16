# sdmapp
This is a shiny app developed to run SDM with current and future climate data for single and paired species. We are building this app based on the code from: https://github.com/jcoliver/biodiversity-sdm-lesson/tree/master.
## Dependencies
+ shiny
+ bslib
+ shinyjs
+ raster
+ sp
+ dismo
+ maptools
## Structure
+ data:

  You should download your data from iNaturalist, more details can be found in jcoliver's lesson listed above.
  + file1_1.csv: the file will be used for single species modeling and forecasting in the App (will be rewritten by the uploaded file)
  + file2_1.csv: the file will be used for paired species modeling and forecasting in the App (will be rewritten by the uploaded file)
  + file2_2.csv: the file will be used for paired species modeling and forecasting in the App (will be rewritten by the uploaded file)
  + MY_SPECIES.csv: a piece of sample data can be downloaded from the App to check the data format. Please notice that the data should be harvested from iNaturalist with the same format. For how to do that, check Instructions/Part 1: Project Outline
+ functions:
  + plot_functions.R: functions for making the plots
  + sdm_functions_updated.R: this is the original sdm_functions file downloaded from jcoliver's biodiversity-sdm-lesson. I only made some changes about 1) the resolution of worldclimate data (I changed it from 2.5 to 10, the finer resolution is great, but it really TAKES LOTS OF TIME!!) and 2) how to get the forecasting climate data. Originally, the forecasting climate data was downloaded and read in directly, but it didn't work well with Shiny, so I changed it to download the forecasting climate data by using GetData().
+ app.R: code for running the Shiny app. You can test it in R, but you need to publish it before other people can get access to it. Go to https://www.shinyapps.io/ to publish it. You might want to make sure it is always in the running status during the group project period.
+ Species distribution model_update.R: I put all the code for sdm analysis in biodiversity-sdm-lesson into one script for easily transfering to Shiny code
+ code.R: analysis code I actually used in the Shiny App

## Potential issues you might encounter
See wiki for solutions
