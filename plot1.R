
if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("total.emissions")) {
                                        # compute total average of Emissions
    message("Computing total emissions for each year ...")
    total.emissions <<- aggregate(list(Emissions=NEI$Emissions),
                                  by=list(year=NEI$year), sum)
}

plot1 <- function() {

    plot(total.emissions$year, total.emissions$Emissions,
         main="Total emission of PM25 in all US",
         xlab="Year", ylab="Amount of PM25 in tons")
    lines(total.emissions$year, total.emissions$Emissions)
}

plot1()
png(filename = "plot1.png")
plot1()
dev.off()
