### statcounter_update

Downloads CSV log and writes its content to a file or merge it with an existing
CSV log file.

### statcounter_report

A very simple script to print highlighted report on a terminal using utility
[*hl*](http://sourceforge.net/projects/hlterm/).

The output of the script may be used to draw various statistics histograms using
[*gnuplot*](http://www.gnuplot.info/) and script *stats.gpi*. For example, let's
collect top 20 cities with most visits.

```sh
statcounter_report -t'"^ "$8" / "$9" / "$10' StatCounter-Log.csv |
awk -F\| '{print $2,";",$1}' | head -20 | tac > 20cities.csv
```

Now let's draw an image using *gnuplot*.

```sh
gnuplot -p -e "datafile='20cities.csv'; set lmargin 54" stats.gpi
```

A window with an image below shall pop up.

<p align="center">
  <img src="../images/images/20cities.png?raw=true" alt="20cities"/>
</p>

The image can also be saved with

```sh
gnuplot -e "datafile='20cities.csv'; set lmargin 54; set term pngcairo size 1200,700; set output '20cities.png'" stats.gpi
```

### group_cities and cities.r

Collected in StatCounter-Log.csv cities can be grouped and sorted by visits and
geocoded.

```sh
group_cities -f cities_spells_fix.awk StatCounter-Log.csv > gcities.csv
group_cities -p yandex -g StatCounter-Log.csv > geocode.csv
```

The geocoding feature makes use of a Python script
[*geocoder*](https://github.com/DenisCarriere/geocoder). To open an interactive
map with 1000 most visited cities in a browser, run in an *R* shell

```r
source("cities.r")
cities("gcities.csv", "geocode.csv", 1000)
```

If the number of cities is not specified then all the cities from the data will
be shown. Function *cities* accepts a custom subsetting function. For example,

```r
cities("gcities.csv", "geocode.csv", FUN = function(x) grepl("Russia", x$Country))
```

will show only cities located in Russian Federation, whereas

```r
cities("gcities.csv", "geocode.csv", 10, FUN = function(x) x$Count %in% 10:20)
```

will show top 10 cities all over the world with total visits from 10 to 20.
Argument *x* of the subsetting function refers to the data collected in
*gcities.csv* and *geocode.csv* with columns *Country*, *Region*, *City*,
*Longitude*, *Lattitude*, and *Count*.

Data for *gcities* can be crafted from the statcounter log directly in *R*. This
lets smarter subsetting of the original data set. Say, to render all the
cities with *page-view* visits happened in the year 2018, run in an *R* shell

```r
pv <- cities_df("StatCounter-Log.csv", "cities_spells_fix.awk")
pv2018 <- pv[grepl("^2018", pv$Date.and.Time), ]
cities(gcities(pv2018), "geocode.csv")
```

Cities from *pv* can also be plotted on a bar chart.

```r
cities.plot(gcities.compound(pv))
```

Countries can be plotted as well.

```r
cities.plot(gcountries(pv))
```

Function *cities.plot* accepts three optional arguments: *title*, *width*, and
*tops*. The second argument corresponds to the width of the plot in pixels:
setting this can be useful for conversion of the chart to a PNG image. The third
argument is a list of numbers to emphasize sets of top cities on the plot. Below
is a simple example of how these arguments can be used.

```r
cities.plot(gcountries(pv), paste0("Countries (", date(), ")"), 1200, c(10, 40, NA))
```

Script *cities.r* requires *R* packages
[*leaflet*](https://rstudio.github.io/leaflet/) and
[*plotly*](https://plot.ly/r/).

