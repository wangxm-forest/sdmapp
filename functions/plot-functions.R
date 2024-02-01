single_prediction<-function(prepared.data,
                            outprefix="MY_SPECIES",
                            outpath="output/",
                            future=FALSE){
  options(timeout = 6000)
  # Run species distribution modeling
  if(future==TRUE){
    sdm.raster <- SDMForecast(data = prepared.data)
  } else {
    sdm.raster <- SDMRaster(data = prepared.data)
  }
  ################################################################################
  # PLOT
  
  # Add small value to all raster pixels so plot is colored correctly
  sdm.raster <- sdm.raster + 0.00001
  
  # Determine the geographic extent of our plot
  xmin <- extent(sdm.raster)[1]
  xmax <- extent(sdm.raster)[2]
  ymin <- extent(sdm.raster)[3]
  ymax <- extent(sdm.raster)[4]
  
  # Plot the model; save to pdf
  plot.file <- paste0(outpath, outprefix, ifelse(future,
                                                 "-single-future.png",
                                                 "-single.png"))
  png(file = plot.file,width = 600, height = 600, units = "px")
  
  # Load in data for map borders
  data(wrld_simpl)
  
  # Draw the base map
  plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), axes = TRUE, col = "gray95", 
       main = paste0(gsub(pattern = "_", replacement = " ", x = outprefix), 
                     ifelse(future," - future"," - current")))
  
  # Add the model rasters
  plot(sdm.raster, legend = FALSE, add = TRUE)
  
  # Redraw the borders of the base map
  plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), add = TRUE, border = "gray10", col = NA)
  
  # Add bounding box around map
  box()
  
  # Stop re-direction to PDF graphics device
  dev.off()
}

paired_prediction<-function(species1.data,species2.data,
                            outprefix="MY_SPECIES",
                            outpath="output/",
                            future=FALSE){
  options(timeout = 6000)
  # Run species distribution modeling
  # Combine results from species1 and species2
  if(future==TRUE){
    species1.raster <- SDMForecast(data = species1.data)
    species2.raster <- SDMForecast(data = species2.data)
  } else {
    species1.raster <- SDMRaster(data = species1.data)
    species2.raster <- SDMRaster(data = species2.data)
  }
  # Combine results from species1 and species2
  combined.raster <- StackTwoRasters(raster1 = species1.raster,
                                     raster2 = species2.raster)
  
  # Calculate the % of species2 range occupied by species1
  pixel.freqs <- freq(combined.raster)
  species2 <- pixel.freqs[which(pixel.freqs[, 1] == 2), 2]
  both <- pixel.freqs[which(pixel.freqs[, 1] == 3), 2]
  species2.percent <- round(100 * (both/(species2 + both)), 2)
  
  ################################################################################
  # PLOT
  
  # Add small value to all raster pixels so plot is colored correctly
  combined.raster <- combined.raster + 0.00001
  
  # Determine the geographic extent of our plot
  xmin <- extent(combined.raster)[1]
  xmax <- extent(combined.raster)[2]
  ymin <- extent(combined.raster)[3]
  ymax <- extent(combined.raster)[4]
  
  # Plot the models for species1, species2 and overlap; save to png
  plot.file <- paste0(outpath, outprefix, ifelse(future,
                                                 "-paired-future.png",
                                                 "-paired.png"))
  png(file = plot.file,width = 600, height = 600, units = "px")
  breakpoints <- c(0, 1, 2, 3, 4)
  plot.colors <- c("white", "purple3","darkolivegreen4", "orangered4", "black")
  
  # Load in data for map borders
  data(wrld_simpl)
  
  # Draw the base map
  plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), axes = TRUE, col = "gray95")
  
  # Add the model rasters
  plot(combined.raster, legend = FALSE, add = TRUE, breaks = breakpoints, col = plot.colors)
  
  # Redraw the borders of the base map
  plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), add = TRUE, border = "gray10", col = NA)
  
  # Add the legend
  legend("topright", legend = c("Species_1", "Species_2", "Both"), fill = plot.colors[2:4], bg = "#FFFFFF")
  
  # Add bounding box around map
  box()
  
  # Stop re-direction to PDF graphics device
  dev.off()
}