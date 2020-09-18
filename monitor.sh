# This file does the same thing but with more mysql queries and a more visualized output.
# It accepts no arguments and should be run as is.
calc(){ awk "BEGIN { print "$*" }"; }
forc(){ calc $1*$2/$3;}
tint(){ printf "%.0f\n" "$@" ;}

totcpu=$(mysql -Dnova -uroot -se "SELECT SUM(vcpus) FROM compute_nodes WHERE deleted_at IS NULL")
totmem=$(mysql -Dnova -uroot -se "SELECT SUM(memory_mb) FROM compute_nodes WHERE deleted_at IS NULL")

#Acceptable CPU Overprovisioning Ratio is currently 3:
actcpu=$(( $totcpu * 3 ))

usecpu=$(mysql -Dnova -uroot -se "SELECT SUM(instances.vcpus) FROM instances WHERE deleted_at IS NULL")
usemem=$(mysql -Dnova -uroot -se "SELECT SUM(instances.memory_mb) FROM instances WHERE deleted_at IS NULL")

usecpu7=$(mysql -Dnova -uroot -se "SELECT SUM(instances.vcpus) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL 7 day")
usemem7=$(mysql -Dnova -uroot -se "SELECT SUM(instances.memory_mb) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL 7 day")

usecpu30=$(mysql -Dnova -uroot -se "SELECT SUM(instances.vcpus) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL 30 day")
usemem30=$(mysql -Dnova -uroot -se "SELECT SUM(instances.memory_mb) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL 30 day")

usecpu90=$(mysql -Dnova -uroot -se "SELECT SUM(instances.vcpus) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL 90 day")
usemem90=$(mysql -Dnova -uroot -se "SELECT SUM(instances.memory_mb) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL 90 day")

ccr=$(calc $usecpu/$totcpu*100)
cmr=$(calc $usemem/$totmem*100)

ccr7=$(calc $usecpu7/$totcpu*100)
cmr7=$(calc $usemem7/$totmem*100)

ccr30=$(calc $usecpu30/$totcpu*100)
cmr30=$(calc $usemem30/$totmem*100)

ccr90=$(calc $usecpu90/$totcpu*100)
cmr90=$(calc $usemem90/$totmem*100)

lftcpu=$(( $actcpu - $usecpu ))
lftmem=$(( $totmem - $usemem ))

cpuuse7=$(( $usecpu - $usecpu7 ))
memuse7=$(( $usemem - $usemem7 ))

cpuuse30=$(( $usecpu - $usecpu30 ))
memuse30=$(( $usemem - $usemem30 ))

cpuuse90=$(( $usecpu - $usecpu90 ))
memuse90=$(( $usemem - $usemem90 ))

frccpu7=$(tint $(forc 7 $lftcpu $cpuuse7 ))
frcmem7=$(tint $(forc 7 $lftmem $memuse7 ))

frccpu30=$(tint $(forc 30 $lftcpu $cpuuse30 ))
frcmem30=$(tint $(forc 30 $lftmem $memuse30 ))

frccpu90=$(tint $(forc 90 $lftcpu $cpuuse90 ))
frcmem90=$(tint $(forc 90 $lftmem $memuse90 ))

echo "Total CPU : " $totcpu
echo "Total RAM : " $totmem
echo "Current Used CPU : " $usecpu
echo "Current Used RAM : " $usemem
echo "Used CPU of 7 days ago: " $usecpu7
echo "Used RAM of 7 days ago: " $usemem7
echo "Used CPU of 30 days ago: " $usecpu30
echo "Used RAM of 30 days ago: " $usemem30
echo "Used CPU of 90 days ago: " $usecpu90
echo "Used RAM of 90 days ago: " $usemem90
echo "Current percentage of used CPU : " $ccr
echo "Current percentage of used RAM : " $cmr
echo "Percentage of used CPU a week ago : " $ccr7
echo "Percentage of used RAM a week ago : " $cmr7
echo "Percentage of used CPU a month ago : " $ccr30
echo "Percentage of used RAM a month ago : " $cmr30
echo "Percentage of used CPU 3 months ago : " $ccr90
echo "Percentage of used RAM 3 months ago : " $cmr90
echo "Acceptable CPU Usage : " $actcpu
echo "Acceptable RAM Usage : " $totmem
echo "Left CPU : " $lftcpu
echo "Left RAM : " $lftmem
echo "CPU Usage in last 7 days : " $cpuuse7
echo "RAM Usage in last 7 days : " $memuse7
echo "CPU Usage in last 30 days : " $cpuuse30
echo "RAM Usage in last 30 days : " $memuse30
echo "CPU Usage in last 90 days : " $cpuuse90
echo "RAM Usage in last 90 days : " $memuse90
echo "7-days EST. of Remaining days till CPU-lack : " $frccpu7
echo "7-days EST. of Remaining days till RAM-lack : " $frcmem7
echo "30-days EST. of Remaining days till CPU-lack : " $frccpu30
echo "30-days EST. of Remaining days till RAM-lack : " $frcmem30
echo "90-days EST. of Remaining days till CPU-lack : " $frccpu90
echo "90-days EST. of Remaining days till RAM-lack : " $frcmem90
