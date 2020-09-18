#!/bin/bash
# This is a forecasting script to predict days remaining before we are going to run out of two resources: 
# CPU and RAM
# It takes 3 variables from you and calculates remaining days, so you have to run it like this:
# filename.sh vcpus|memory_mb time_period allowed_overprovisioning_ratio
# Example:
# filename.sh vcpus 14 3
# This command will calculate remaining days before you will run out of CPUs based on your usage in last 14 days and with an allowed overprovisioning ratio of 3.
# Accordingly the same command but for RAM:
# filename.sh memory_mb 14 1
# This command will calculate remaining days before you will run out of RAM based on your usage in last 14 days and with an allowed overprovisioning ratio of 1.


calc(){ awk "BEGIN { print "$*" }"; }
forc(){ calc $1*$2/$3;}
tint(){ printf "%.0f\n" "$@" ;}

if [ $1 == "vcpus" ]
then
total=$(mysql -Dnova -uroot -se "SELECT SUM(vcpus) FROM compute_nodes WHERE deleted_at IS NULL")
else
total=$(mysql -Dnova -uroot -se "SELECT SUM(memory_mb) FROM compute_nodes WHERE deleted_at IS NULL")
fi

actual=$(( $total * $3 ))

current_usage=$(mysql -Dnova -uroot -se "SELECT SUM(instances.$1) FROM instances WHERE deleted_at IS NULL")

spot_time_usage=$"$(mysql -Dnova -uroot -se "SELECT SUM(instances.$1) FROM instances WHERE deleted_at IS NULL AND created_at < now() - INTERVAL $2 day")"

left_resources=$(( $actual - $current_usage ))

timed_usage=$(( $current_usage - $spot_time_usage ))

forcasted_time_available=$(tint $(forc $2 $left_resources $timed_usage ))

echo $forcasted_time_available
