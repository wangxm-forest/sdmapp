library("raster")
library("sp")
library("dismo")
library("maptools")
source(file = "functions/sdm-functions_updated.R")
source(file = "functions/plot-functions.R")

################################################################################
# Single species distribution modeling ----

infile <- "data/MY_SPECIES.csv"

# Prepare data
prepared.data <- PrepareData(file = infile)

single_prediction(prepared.data,future = FALSE)

# Forecast species distribution model for a single species----

single_prediction(prepared.data,future = TRUE)


################################################################################
# Paired species distribution modeling

species1.data.file <- "data/SPECIES1_DATA.csv"
species2.data.file <- "data/SPECIES2_DATA.csv"

# Prepare data
species1.data <- PrepareData(file = species1.data.file)
species2.data <- PrepareData(file = species2.data.file)

paired_prediction(species1.data,species2.data,future=FALSE)

################################################################################
# Forecast species distribution model for paired species

paired_prediction(species1.data,species2.data,future=TRUE)
