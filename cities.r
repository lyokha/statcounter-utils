library(leaflet)
library(htmltools)

cities <- function(gcities, geocode, len = as.integer(.Machine$integer.max),
                   subset = "TRUE") {
    gcities <- read.csv(file = gcities, header = TRUE, sep = ";", as.is = TRUE)
    geocodes <- read.csv(file = geocode, header = TRUE, sep = ";", as.is = TRUE,
                         na.strings = "null")

    d <- merge(gcities, geocodes, by = c(1, 2, 3))
    d <- d[order(-d$Count), ]
    d <- subset(d, !is.na(d$Longitude))
    d <- subset(d, eval(parse(text = subset)))

    m <- leaflet()
    m <- addTiles(m)

    dh <- head(d, len)

    nrow <- nrow(dh)
    if (nrow == 0) {
        print("No cities to render", quote = FALSE)
        return(m)
    }

    for (x in 1:nrow) {
        l <- list(c(dh[x, 3], "#03F"), c(dh[x, 2], "#F90"), c(dh[x, 1], "#F30"),
                  c("<UNKNOWN LOCATION>", "#666"))

        for (v in l) {
            if (v[1] != "") {
                v[1] <- htmlEscape(v[1])
                break
            }
        }

        m <- addCircleMarkers(m, lng = dh[x, 5], lat = dh[x, 6], color = v[2],
                              radius = 5 * log(dh[x, 4], 10),
                              popup = paste(v[1], ",", dh[x, 4]))
    }

    print(sprintf("%d cities rendered", nrow), quote = FALSE)
    return(m)
}

cities_df <- function(statcounter_log_csv, cities_spells_filter_awk = "") {
    if (cities_spells_filter_awk == "") {
        return(read.csv(statcounter_log_csv, sep = ",", as.is = TRUE))
    }

    cmd <- paste("awk -f", cities_spells_filter_awk, statcounter_log_csv)
    return(read.csv(pipe(cmd), sep = ",", as.is = TRUE))
}

