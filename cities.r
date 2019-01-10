library(leaflet)

gcities <- read.csv(file="gcities.csv", header=TRUE, sep=";")
geocodes <- read.csv(file="geocode.csv", header=TRUE, sep=";")
d <- merge(gcities, geocodes, by=c(1, 2, 3))
d <- d[order(-d$Count),]
d <- subset(d, d$Longitude!="null")

m <- leaflet()
m <- addTiles(m)

dh <- head(d, 2000)
for (x in 1:nrow(dh))
{
    m <- addCircleMarkers(m
                    ,lng=as.numeric(as.character(dh[[x,5]]))
                    ,lat=as.numeric(as.character(dh[[x,6]]))
                    ,color=ifelse(dh[[x,3]]=="", "#F30", "#03F")
                    ,radius=(5 * log(as.numeric(as.character(dh[[x,4]])), 10))
                    ,popup=paste(dh[[x,3]], " ", dh[[x,4]])
                    )
}

