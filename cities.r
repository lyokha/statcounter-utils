library(leaflet)
library(leaflet.extras)
library(htmltools)
library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

cities <- function(gcities, geocode, len = as.integer(.Machine$integer.max),
                   FUN = function(x) TRUE) {
    if (!is.data.frame(gcities)) {
        gcities <- read.csv(gcities, header = TRUE, sep = ";", as.is = TRUE)
    }
    if (!is.data.frame(geocode)) {
        geocode <- geocode_df(geocode)
    }

    d <- merge(gcities, geocode, 1:3)
    d <- d[order(-d$Count), ]
    d <- d[!is.na(d$Longitude) & FUN(d), ]

    m <- leaflet() %>% addTiles() %>% addResetMapButton()

    dh <- head(d, len)

    nrow <- nrow(dh)
    if (nrow == 0) {
        stop("No cities to render", call. = FALSE)
    }

    color <- c("#FF3300", "#FF9900", "#0033FF", "#666666")
    #           Country    Region     City       Unknown location

    dh$nc <- case_when(
                 nzchar(dh$City) ~ paste0(htmlEscape(dh$City), color[3]),
                 nzchar(dh$Region) ~ paste0(htmlEscape(dh$Region), color[2]),
                 nzchar(dh$Country) ~ paste0(htmlEscape(dh$Country), color[1]),
                 TRUE ~ paste0(htmlEscape("<UNKNOWN LOCATION>"), color[4]))

    dh <- separate(dh, "nc", c("Name", "Color"), -7)

    m <- addCircleMarkers(m, lng = dh$Longitude, lat = dh$Lattitude,
                          color = dh$Color, radius = 5 * log(dh$Count, 10),
                          popup = paste(dh$Name, ",", dh$Count),
                          label = gsub("; ;", ";",
                                       gsub("(^[; ]+|[; ]+$)", "",
                                            paste(dh$City, dh$Region,
                                                  dh$Country, sep = "; ")),
                                       fixed = TRUE),
                          group = "cities") %>%
         # to make search work with circle markers, delete text
         # "e instanceof t.Path ||" in ~/R/x86_64-redhat-linux-gnu-library ...
         #  /3.5/leaflet.extras/htmlwidgets/build/lfx-search/lfx-search-prod.js
         # (see https://github.com/bhaskarvk/leaflet.extras/issues/143 ...
         #  #issuecomment-450461384).
         addSearchFeatures("cities",
                           searchFeaturesOptions(
                                            zoom = NULL,
                                            moveToLocation = FALSE,
                                            openPopup = TRUE,
                                            autoCollapse = TRUE,
                                            hideMarkerOnCollapse = TRUE)) %>%
         addLegend("bottomright",
                   colors = c(circle_marker_to_legend_color(color[3]),
                              circle_marker_to_legend_color(color[2]),
                              circle_marker_to_legend_color(color[1])),
                   labels = c("City", "Region", "Country"),
                   opacity = 0.5)

    print(paste(nrow, "cities rendered"), quote = FALSE)

    return(m)
}

cities_df <- function(statcounter_log_csv, cities_spells_filter_awk = NULL,
                      warn_suspicious = TRUE, type = "page view") {
    df <- read.csv(`if`(is.null(cities_spells_filter_awk),
                        statcounter_log_csv,
                        pipe(paste("awk -f", cities_spells_filter_awk,
                                   `if`(warn_suspicious,
                                        "-v warn_suspicious=yes", NULL),
                                   statcounter_log_csv))),
                   header = TRUE, sep = ",", quote = "\"", as.is = TRUE)

    if (!is.null(type)) {
        df <- df[df$Type == type, ]
    }

    return(df)
}

geocode_df <- function(geocode) {
    df <- read.csv(geocode, header = TRUE, sep = ";", as.is = TRUE,
                   na.strings = "null")

    return(df)
}

gcities <- function(cs) {
    d <- plyr::count(cs, c("Country", "Region", "City"))
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
    d <- plyr::count(cs, c("Country", "Region", "City"))
    if (!empty(d)) {
        d$City <- paste(d$Country, "/", d$Region, "/", d$City)
    }
    names(d)[4] <- "Count"

    return(d[order(-d$Count), c("City", "Count")])
}

gcountries <- function(cs) {
    d <- plyr::count(cs, c("Country"))
    names(d)[2] <- "Count"

    return(d[order(-d$Count), ])
}

cities.plot <- function(cs, title = NULL, tops = NULL, width = NULL) {
    nrow <- nrow(cs)
    if (nrow == 0) {
        stop("No cities to plot", call. = FALSE)
    }

    w0 <- 1200
    wf <- if (is.null(width)) 1 else w0 / width
    mf <- wf * (max(cs$Count) / 10000)
    cw <- 21
    to <- (cw * nchar(cs$Count) + 300) * mf
    ym <- cs[1, ][["Count"]] + to[1] * 2

    p <- ggplot() + theme(axis.ticks.y = element_blank(),
                          axis.ticks.x = element_blank(),
                          axis.text.x = element_blank(),
                          panel.grid.major = element_blank(),
                          panel.grid.minor = element_blank(),
                          panel.background = element_blank()) +
                    labs(title = title, x = NULL, y = NULL)

    if (is.null(tops)) {
        p <- p + annotate("rect", xmin = 0.1, xmax = 0.9, ymin = 0, ymax = ym,
                          fill = alpha("green", 0.0))
    } else {
        cur <- 0
        ac <- 0.1
        for (i in 1:length(tops)) {
            if (is.na(tops[i]) || tops[i] > nrow) {
                tops[i] <- nrow
            }
            p <- p + annotate("rect",
                              xmin = nrow - tops[i] + 0.5,
                              xmax = nrow - cur + 0.5,
                              ymin = 0, ymax = ym,
                              fill = alpha("green", ac),
                              color = alpha("firebrick1", 0.4),
                              size = 0.4, linetype = "solid") +
                     annotate("text",
                              x = nrow - tops[i] + 1,
                              y = ym - 300 * mf, color = "blue",
                              label = tops[i], size = 3.0, alpha = 0.5)
            cur <- tops[i]
            ac <- ac / 2
            if (tops[i] == nrow) {
                break
            }
        }
    }

    # aliases for better plotly tooltips
    loc <- reorder(cs[[1]], cs$Count)
    cnt <- cs$Count
    pos <- cs$Count + to

    p <- p + scale_x_discrete(limits = rev(cs[[1]])) +
             scale_y_continuous(expand = c(0, 50 * mf, 0, 300 * mf),
                                limits = c(0, NA)) +
             coord_flip() +
             geom_col(aes(loc, cnt), fill = "darkseagreen", alpha = 1.0) +
             geom_text(aes(loc, pos, label = cnt, alpha = 0.75), size = 3.4)

    # Cairo limits linear canvas sizes to 32767 pixels!
    height <- min(25 * nrow + 120, 32720)
    p <- ggplotly(p, height = height, width = width) %>%
         config(toImageButtonOptions =
                    list(filename = `if`(is.null(title), "cities",
                                         gsub("[^[:alnum:]_\\-]", "_", title)),
                         height = height,
                         width = `if`(is.null(width), w0, width), scale = 1),
                displaylogo = FALSE, collaborate = FALSE)

    print(paste(nrow, "cities plotted"), quote = FALSE)

    return(p)
}

