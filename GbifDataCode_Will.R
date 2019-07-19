library(data.table)
library(sf)
library(fasterize)

test<-fread("Corallimorphia/0010704-190621201848488.csv",nrows=50)

all_Corallimorpharia<-fread("Corallimorphia/0010704-190621201848488.csv",select=c("species", "decimalLongitude", "decimalLatitude", "speciesKey"))

all_Alcyonacea<-fread("Alcyonacea/0010708-190621201848488.csv",select=c("species", "decimalLongitude", "decimalLatitude", "speciesKey"))

filt_Coral<-dplyr::filter(all_Corallimorpharia,!is.na(decimalLongitude))
corpoints<- st_as_sf(filt_Coral, coords = c(x="decimalLongitude", y="decimalLatitude"))

sum(is.na(all_Corallimorpharia$decimalLongitude))

r <- raster(corpoints, res = 2)
r <- rasterize(corpoints, r, field = "speciesKey", fun= function(x, ...) {length(unique(na.omit(x)))})
map("world")
plot(r,add=TRUE)
