                                        # verify if NEI data is already loaded
if (! exists("NEI")) {
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
