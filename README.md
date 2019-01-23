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
be shown. Function *cities* accepts custom subsetting conditions. For example,

```r
cities("gcities.csv", "geocode.csv", subset="grepl(\"Russia\", d$Country)")
```

will show only cities located in Russian Federation, whereas

```r
cities("gcities.csv", "geocode.csv", 10, subset="d$Count >= 10 & d$Count <= 20")
```

will show top 10 cities all over the world with total visits from 10 to 20.
Notice that *d* is a *magic* variable which refers to the data collected in
*gcities.csv* and *geocode.csv*.

Script *cities.r* requires *R* package
[*leaflet*](https://rstudio.github.io/leaflet/).

