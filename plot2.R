
if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("total.emissions.Baltimore")) {
                                        # compute total average of Emissions
    message("Computing total emissions in Baltimore for each year ...")
    NEI.Baltimore <-- NEI[NEI$fips == "24510", ]
    total.emissions.Baltimore <<-
        aggregate(list(Emissions=NEI.Baltimore$Emissions),
                  by=list(year=NEI.Baltimore$year), sum)
}

plot2 <- function() {
    
    plot(total.emissions.Baltimore$year, total.emissions.Baltimore$Emissions,
         main="Total emission of PM25 in Baltimore city",
         xlab="Year", ylab="Amount of PM25 in tons")
    lines(total.emissions.Baltimore$year, total.emissions.Baltimore$Emissions)
}

plot2()
png(filename = "plot2.png")
plot2()
dev.off()
