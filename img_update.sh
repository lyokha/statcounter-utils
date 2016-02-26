#!/bin/bash

width=1088
lheight=28        # 1170 lines can be written without exceeding maxsize
maxsize=32767     # Cairo PNG max linear size in pixels

statcounter_log_csv=StatCounter-Log.csv
cities_csv=cities.csv
countries_csv=countries.csv
cities_png=cities.png
countries_png=countries.png
stats_gpi=stats.gpi

spells_fixed_tmp=spells_fixed.tmp
cities_tmp=cities.tmp

if [ -e $spells_fixed_tmp ] ; then
    >&2 echo "Error: file $spells_fixed_tmp exists, remove it and try again!"
    exit 1
fi

[ "$1" != '-q' ] && warn_suspicious='-v warn_suspicious=yes' || warn_suspicious=

awk $warn_suspicious -f cities_spells_fix.awk $statcounter_log_csv > $spells_fixed_tmp
statcounter_report -p -t'"^ "$8" / "$9" / "$10' $spells_fixed_tmp | awk -F\| '{print $2,";",$1}' > $cities_tmp

for lines in 20 40 ; do
    ((height = lines * lheight))
    head -$lines $cities_tmp > $cities_csv
    gnuplot -e "datafile='$cities_csv'; set term pngcairo size $width,$height; set lmargin 54; set output '$lines$cities_png'" $stats_gpi
done

lines=$(wc -l $cities_tmp | cut -f1 -d' ')
((height = lines * lheight))
if ((height > maxsize)) ; then
    >&2 echo "Warning: Requested image height $height exceeds Cairo PNG linear size limit $maxsize!"
    height=$maxsize
fi
mv $cities_tmp $cities_csv
gnuplot -e "datafile='$cities_csv'; set term pngcairo size $width,$height; set lmargin 54; set output '$cities_png'" $stats_gpi
[ "$1" != '-q' ] && echo "  $lines cities were written"

statcounter_report -p -c $spells_fixed_tmp | awk -F\| '{print $2,";",$1}' > $countries_csv
lines=$(wc -l $countries_csv | cut -f1 -d' ')
((height = lines * lheight))
gnuplot -e "datafile='$countries_csv'; set term pngcairo size $width,$height; set lmargin 24; set output '$countries_png'" $stats_gpi
[ "$1" != '-q' ] && echo "  $lines countries were written"

rm $spells_fixed_tmp

