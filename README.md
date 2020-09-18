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
