### statcounter_update

Downloads CSV log and writes its content to a file or merge it with an existing
CSV log file.

### statcounter_report

A very simple script to print highlighted report on a terminal using utility
[*hl*](http://sourceforge.net/projects/hlterm/).

The output of the script may be used to draw various statistics histograms using
*gnuplot* and script *stats.gpi*. For example let's collect top 20 cities with
most visits.

```sh
statcounter_report -t'"^ "$8" / "$9" / "$10' StatCounter-Log.csv |
awk -F\| '{print $2,";",$1}' | head -20 | tac > 20cities.csv
```

Now let's draw image using gnuplot.

```sh
gnuplot -p -e "datafile='20cities.csv'" stats.gpi
```

A window with an image below shall pop up.

<p align="center">
  <img src="../images/images/20cities.png?raw=true" alt="20cities"/>
</p>

The image can also be saved with

```sh
gnuplot -e "datafile='20cities.csv'; set term pngcairo size 1200,800; set output '20cities.png'" stats.gpi
```

