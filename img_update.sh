#!/bin/bash

width=1088
lheight=28      # 1170 not scaled lines can be written without exceeding maxsize
maxsize=32767   # Cairo PNG max linear size in pixels
lheightc=25     # 2016 scaled lines (with scale=0.65) can be written without exceeding maxsize
scale=0.65      # fontscale for cities png
lheights=$lheight
bg="background rgb 'white'"

quiet=
svg=

while getopts :qs opt ; do
    case $opt in
        q) quiet=1 ;;
        s) svg=1 ;;
       \?) echo "Invalid option: -$OPTARG" >&2
           exit 1 ;;
    esac
done

if [ -z "$svg" ] ; then
    ext=png
    term=pngcairo
    lmarginc=60
    lmarginc1=58
    lmargincn=26
else
    ext=svg
    term=svg
    scale=0.6
    lheightc=$lheight
    lheights=22
    lmarginc=46
    lmarginc1=46
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

warn_suspicious=
warn_spam=

if [ -z "$quiet" ] ; then
    warn_suspicious='-v warn_suspicious=yes'
    warn_spam='-v warn_spam=yes'
fi

awk $warn_suspicious $warn_spam -f cities_spells_fix.awk $statcounter_log_csv > $spells_fixed_tmp
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
[ -z "$quiet" ] && echo "  $lines cities were written"

statcounter_report -p -c $spells_fixed_tmp | awk -F\| '{print $2,";",$1}' > $countries_csv
lines=$(wc -l $countries_csv | cut -f1 -d' ')
((height = lines * lheights))
gnuplot -e "datafile='$countries_csv'; set term $term size $width,$height $bg; set lmargin $lmargincn; set output '$countries_img'" $stats_gpi
[ -z "$quiet" ] && echo "  $lines countries were written"

rm $spells_fixed_tmp

