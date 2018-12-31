#!/bin/bash

width=1088
lheight=28      # 1170 not scaled lines can be written without exceeding maxsize
maxsize=32767   # Cairo PNG max linear size in pixels
lheightc=25     # 1747 scaled lines (with scale=0.75) can be written without exceeding maxsize
scale=0.75      # fontscale for cities png
lheights=$lheight

#svg=
if [ -n "$svg" ] ; then
    ext=svg
    term=svg
    scale=0.6
    bg="background rgb 'white'"
    lheightc=$lheight
    lheights=22
    lmarginc=46
    lmarginc1=46
    lmargincn=24
else
    ext=png
    term=pngcairo
    bg=
    lmarginc=54
    lmarginc1=54
    lmargincn=24
fi

statcounter_log_csv=StatCounter-Log.csv
cities_csv=cities.csv
countries_csv=countries.csv
cities_img=cities.$ext
countries_img=countries.$ext
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
    ((height = lines * lheights))
    head -$lines $cities_tmp > $cities_csv
    gnuplot -e "datafile='$cities_csv'; set term $term size $width,$height $bg; set lmargin $lmarginc1; set output '$lines$cities_img'" $stats_gpi
done

lines=$(wc -l $cities_tmp | cut -f1 -d' ')
((height = lines * lheightc))
if [ -n "$scale" ] ; then
    LC_NUMERIC=C height=$(printf %0.f "$(bc <<< "$height * $scale")")
    [ -z "$svg" ] && scale="fontscale $scale" || scale=
fi
if [ -z "$svg" ] && ((height > maxsize)) ; then
    >&2 echo "Warning: Requested image height $height exceeds Cairo PNG linear size limit $maxsize!"
    height=$maxsize
fi
mv $cities_tmp $cities_csv
gnuplot -e "datafile='$cities_csv'; set term $term size $width,$height $scale $bg; set lmargin $lmarginc; set output '$cities_img'" $stats_gpi
[ "$1" != '-q' ] && echo "  $lines cities were written"

statcounter_report -p -c $spells_fixed_tmp | awk -F\| '{print $2,";",$1}' > $countries_csv
lines=$(wc -l $countries_csv | cut -f1 -d' ')
((height = lines * lheights))
gnuplot -e "datafile='$countries_csv'; set term $term size $width,$height $bg; set lmargin $lmargincn; set output '$countries_img'" $stats_gpi
[ "$1" != '-q' ] && echo "  $lines countries were written"

rm $spells_fixed_tmp

