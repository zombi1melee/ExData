##Electric Power Consumption Variations

The household power consumption dataset from <http://archive.ics.uci.edu/ml> measures electrical power consumption in one household at one minute sampling rates for almost over a 4 year period.  Electrical quantities and various submetering values are also available in the dataset.  The overall goal of this task is to investigate household energy use fluctuations over a span of 2 days in February 2007.  Plots were constructed to show comparisons of multivariate data consisting of household energy usage.  


**Dataset variables consist of the following.**

1. Date: format dd/mm/yyyy
2. Time: format hh/mm/ss
3. Global_active_power: household global minute active power averaged in kilowatt
4. Global_reactive_power: household global minute reactive power averaged in kilowatt
5. Voltage: minute averaged in volt
6. Global_intensity: household global minute aveaged current intensity in ampere
7. Sub_metering_1: energy sub-metering No. 1 in watt-hour (kitchen)
8. Sub_metering_2: energy sub-metering No. 2 in watt-hour (laundry room)
9. Sub_metering_3: energy sub-metering No. 3 in watt-hour (water heater/air conditioner)

###**Loading the data**
Only data taken from dates 2007-02-01 and 2007-02-02 were read into and then convert to the appropriate classes.

