#!/bin/bash 

sed -f cities_spells_fix.sed StatCounter-Log.csv | statcounter_report -p -t'"^ "$8" / "$9" / "$10' | awk -F\| '{print $2,";",$1}' | head -20 | tac > 20cities.csv
gnuplot -e "datafile='20cities.csv'; set term pngcairo size 1200,700; set lmargin 54; set output '20cities.png'" stats.gpi
sed -f cities_spells_fix.sed StatCounter-Log.csv | statcounter_report -p -t'"^ "$8" / "$9" / "$10' | awk -F\| '{print $2,";",$1}' | head -40 | tac > 40cities.csv
gnuplot -e "datafile='40cities.csv'; set term pngcairo size 1200,1400; set lmargin 54; set output '40cities.png'" stats.gpi
sed -f cities_spells_fix.sed StatCounter-Log.csv | statcounter_report -p -t'"^ "$8" / "$9" / "$10' | awk -F\| '{print $2,";",$1}' | tac > cities.csv
gnuplot -e "datafile='cities.csv'; set term pngcairo size 1200,30000; set lmargin 54; set output 'cities.png'" stats.gpi
statcounter_report -p -t'"^ "$8' StatCounter-Log.csv | awk -F\| '{print $2,";",$1}' | tac > countries.csv
gnuplot -e "datafile='countries.csv'; set term pngcairo size 1200,2800; set lmargin 24; set output 'countries.png'" stats.gpi

