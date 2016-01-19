#!/bin/bash

width=1200
lheight=32

cities=$(sed -f cities_spells_fix.sed StatCounter-Log.csv | statcounter_report -p -t'"^ "$8" / "$9" / "$10' | awk -F\| '{print $2,";",$1}')

for lines in 20 40 ; do
    let "height = $lines * $lheight"
    echo "$cities" | head -$lines | tac > cities.csv
    gnuplot -e "datafile='cities.csv'; set term pngcairo size $width,$height; set lmargin 54; set output '${lines}cities.png'" stats.gpi
done

lines=$(echo "$cities" | wc -l)
let "height = $lines * $lheight"
echo "$cities" | tac > cities.csv
gnuplot -e "datafile='cities.csv'; set term pngcairo size $width,$height; set lmargin 54; set output 'cities.png'" stats.gpi

statcounter_report -p -t'"^ "$8' StatCounter-Log.csv | awk -F\| '{print $2,";",$1}' | tac > countries.csv
lines=$(wc -l countries.csv | cut -f1 -d' ')
let "height = $lines * $lheight"
gnuplot -e "datafile='countries.csv'; set term pngcairo size $width,$height; set lmargin 24; set output 'countries.png'" stats.gpi

