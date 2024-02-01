library("raster")
library("sp")
library("dismo")
library("maptools")
################################################################################
# Single species distribution modeling

infile <- "data/MY_SPECIES.csv"
outprefix <- "MY_SPECIES"
outpath <- "output/"
source(file = "functions/sdm-functions_updated.R")

################################################################################
# ANALYSES

# Prepare data
prepared.data <- PrepareData(file = infile)
options(timeout = 6000)
# Run species distribution modeling
sdm.raster <- SDMRaster(data = prepared.data)

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
plot.file <- paste0(outpath, outprefix, "-single-prediction.pdf")
pdf(file = plot.file, useDingbats = FALSE)

# Load in data for map borders
data(wrld_simpl)

# Draw the base map
plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), axes = TRUE, col = "gray95", 
     main = paste0(gsub(pattern = "_", replacement = " ", x = outprefix), " - current"))

# Add the model rasters
plot(sdm.raster, legend = FALSE, add = TRUE)

# Redraw the borders of the base map
plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), add = TRUE, border = "gray10", col = NA)

# Add bounding box around map
box()

# Stop re-direction to PDF graphics device
dev.off()

rm(list = ls())

################################################################################
# Paired species distribution modeling

species1.data.file <- "data/SPECIES1_DATA.csv"
species2.data.file <- "data/SPECIES2_DATA.csv"
outprefix <- "MY_SPECIES"
outpath <- "output/"
source(file = "functions/sdm-functions_updated.R")

################################################################################
# ANALYSES

# Prepare data
species1.data <- PrepareData(file = species1.data.file)
species2.data <- PrepareData(file = species2.data.file)
options(timeout = 6000)
# Run species distribution modeling
# Combine results from species1 and species2
species1.raster <- SDMRaster(data = species1.data)
species2.raster <- SDMRaster(data = species2.data)

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

# Plot the models for species1, species2 and overlap; save to pdf
plot.file <- paste0(outpath, outprefix, "-pairwise-prediction.pdf")
pdf(file = plot.file, useDingbats = FALSE)
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

rm(list = ls())

################################################################################
# Forecast species distribution model for a single species

infile <- "data/MY_SPECIES.csv"
outprefix <- "MY_SPECIES"
outpath <- "output/"
source(file = "functions/sdm-functions_updated.R")

################################################################################
# ANALYSES

# Prepare data
prepared.data <- PrepareData(file = infile)
options(timeout = 6000)
# Run species distribution modeling
sdm.raster <- SDMForecast(data = prepared.data)

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
plot.file <- paste0(outpath, outprefix, "-single-future-prediction.pdf")
pdf(file = plot.file, useDingbats = FALSE)

# Load in data for map borders
data(wrld_simpl)

# Draw the base map
plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), axes = TRUE, col = "gray95", 
     main = paste0(gsub(pattern = "_", replacement = " ", x = outprefix), " - future"))

# Add the model rasters
plot(sdm.raster, legend = FALSE, add = TRUE)

# Redraw the borders of the base map
plot(wrld_simpl, xlim = c(xmin, xmax), ylim = c(ymin, ymax), add = TRUE, border = "gray10", col = NA)

# Add bounding box around map
box()

# Stop re-direction to PDF graphics device
dev.off()

rm(list = ls())

################################################################################
# Forecast species distribution model for paired species

species1.data.file <- "data/SPECIES1_DATA.csv"
species2.data.file <- "data/SPECIES2_DATA.csv"
outprefix <- "MY_SPECIES"
outpath <- "output/"
source(file = "functions/sdm-functions_updated.R")

################################################################################
# ANALYSES

# Prepare data
species1.data <- PrepareData(file = species1.data.file)
species2.data <- PrepareData(file = species2.data.file)
options(timeout = 6000)
# Run species distribution modeling
species1.raster <- SDMForecast(data = species1.data)
species2.raster <- SDMForecast(data = species2.data)

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

# Plot the models for species1, species2 and overlap; save to pdf
plot.file <- paste0(outpath, outprefix, "-pairwise-future-prediction.pdf")
pdf(file = plot.file, useDingbats = FALSE)
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

rm(list = ls())