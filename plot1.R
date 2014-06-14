# NOTE FOR CODE READERS
#
# Each one of these scripts is structured in:
#
# 1- Test if data has been read or computed. The quantity of this tests
#    augments conform to the complexity of plot. Each test is an if that
#    tests if the data is already built in a global environment
#    variable. The idea is saving time and allow you to invoke the
#    distint script times, at any order, without repeating the loading
#    and processing 
#
# 2- a plotx() function that builds the plot
#
# 3- Plotting in the screen and after sending it to png device. In this
#    way, the plot can be displayed in the screen at same time that this is
#    written in the png file. The idea of ths approach is that you can
#    corroborate the plot in your screen. Comment the first call to
#    plotx() if you not wish the plot in the screen
#
# Usage
#
#     Simply copy the full script and paste it in a R repl whose working
#     directory contains the files
#                summarySCC_PM25.rds
#                Source_Classification_Code.rds
#
# Because the scheme of loading can variate from an os to another, code
# for downloading is not put. 

if (! exists("NEI")) {    # verify if NEI data is already loaded
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("total.emissions")) {
                                        # compute total of Emissions
    message("Computing total emissions for each year. Please wait ...")
    total.emissions <<- aggregate(list(Emissions=NEI$Emissions),
                                  by=list(year=NEI$year), sum)
}

plot1 <- function() {

    barplot(total.emissions$Emissions, names.arg=total.emissions$year,
            col = colorRampPalette(c("darkred", "yellow3"))(4),
            main="Total emission of PM 2.5 in all US",
            xlab="Year", ylab="Amount of PM 2.5 in tons")
}

plot1()
png(filename = "plot1.png")
plot1()
dev.off()
