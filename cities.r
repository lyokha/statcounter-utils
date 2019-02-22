library(leaflet)
library(htmltools)
library(plyr)
library(ggplot2)
library(plotly)

cities <- function(gcities, geocode, len = as.integer(.Machine$integer.max),
                   FUN = function(x) TRUE) {
    if (!is.data.frame(gcities)) {
        gcities <- read.csv(gcities, header = TRUE, sep = ";", as.is = TRUE)
    }
    geocodes <- read.csv(geocode, header = TRUE, sep = ";", as.is = TRUE,
                         na.strings = "null")

    d <- merge(gcities, geocodes, 1:3)
    d <- d[order(-d$Count), ]
    d <- d[!is.na(d$Longitude) & FUN(d), ]

    m <- leaflet()
    m <- addTiles(m)

    dh <- head(d, len)

    nrow <- nrow(dh)
    if (nrow == 0) {
        print("No cities to render", quote = FALSE)
        return(m)
    }

    color <- c("#FF3300", "#FF9900", "#0033FF", "#666666")
    #           Country    Region     City       Unknown location

    for (x in 1:nrow) {
        l <- list(c(dh[x, 3], color[3]), c(dh[x, 2], color[2]),
                  c(dh[x, 1], color[1]), c("<UNKNOWN LOCATION>", color[4]))

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

    m <- addLegend(m, "bottomright",
                   colors = c(circle_marker_to_legend_color(color[3]),
                              circle_marker_to_legend_color(color[2]),
                              circle_marker_to_legend_color(color[1])),
                   labels = c("City", "Region", "Country"),
                   opacity = 0.5)

    print(paste(nrow, "cities rendered"), quote = FALSE)

    return(m)
}

cities_df <- function(statcounter_log_csv, cities_spells_filter_awk = "",
                      warn_suspicious = FALSE,
                      type = "page view") {
    df <- read.csv(`if`(cities_spells_filter_awk == "",
                        statcounter_log_csv,
                        pipe(paste("awk -f", cities_spells_filter_awk,
                                   if (warn_suspicious)
                                       "-v warn_suspicious=yes" else "",
                                   statcounter_log_csv))),
                   header = TRUE, sep = ",", quote = "\"", as.is = TRUE)

    if (type != "") {
        df <- df[df$Type == type, ]
    }

    return(df)
}

gcities <- function(cs) {
    d <- count(cs, c("Country", "Region", "City"))
    names(d)[4] <- "Count"

    return(d[order(-d$Count), ])
}

circle_marker_to_legend_color <- function(color,
                                          marker_opacity = 0.3,
                                          stroke_opacity = 0.7,
                                          stroke_width = "medium") {
    c <- col2rgb(color)
    cv <- paste("rgba(", c[1], ", ", c[2], ", ", c[3], ", ", sep = "")

    return(paste(cv, marker_opacity, "); border-radius: 50%; border: ",
                 stroke_width, " solid ", cv, stroke_opacity,
                 "); box-sizing: border-box", sep = ""))
}

gcities.compound <- function(cs) {
    d <- count(cs, c("Country", "Region", "City"))
    d$City <- paste(d$Country, "/", d$Region, "/", d$City)
    names(d)[4] <- "Count"

    return(d[order(-d$Count), c("City", "Count")])
}

gcountries <- function(cs) {
    d <- count(cs, c("Country"))
    names(d)[2] <- "Count"

    return(d[order(-d$Count), ])
}

cities.plot <- function(cs, title = NULL, width = NULL) {
    wf <- if (is.null(width)) 1 else 1600 / width
    mf <- wf * (max(cs$Count) / 10000)
    cw <- 21
    p <- ggplot(cs, aes(reorder(cs[[1]], cs$Count), cs$Count)) +
        geom_bar(stat = "identity", fill = "red", alpha = 0.75) +
        coord_flip() +
        scale_y_continuous(expand = c(0, 50 * mf, 0, 300 * mf),
                           limits = c(0, NA)) +
        geom_text(aes(label = cs$Count,
                      y = cs$Count + (cw * nchar(cs$Count) + 175) * mf,
                      alpha = 0.75),
                  size = 3.4) +
        theme(axis.ticks.y = element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank()
              ) +
        labs(title = title, x = NULL, y = NULL)
    # Cairo limits linear canvas sizes to 32767 pixels!
    height <- min(25 * nrow(cs), 32600)
    p <- ggplotly(p, height = height, width = width)

    print(paste(nrow(cs), "cities plotted"), quote = FALSE)

    return(p)
}

