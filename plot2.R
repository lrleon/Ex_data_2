
if (! exists("NEI")) {    # verify if NEI data is already loaded
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("total.emissions.Baltimore")) {
                                        # compute total of Emissions
    message("Computing total emissions in Baltimore for each year ...")
    NEI.Baltimore <<- NEI[NEI$fips == "24510", ]
    total.emissions.Baltimore <<-
        aggregate(list(Emissions=NEI.Baltimore$Emissions),
                  by=list(year=NEI.Baltimore$year), sum)
}

plot2 <- function() {

    the.col = colorRampPalette(c("darkred", "yellow3"))(4)
    barplot(total.emissions.Baltimore$Emissions,
            names.arg=total.emissions.Baltimore$year,
            col = c(the.col[1], the.col[3], the.col[2], the.col[4]),
            main="Total emission of PM 2.5 in Baltimore city",
            xlab="Year", ylab="Amount of PM 2.5 in tons")
    lines(total.emissions.Baltimore$year, total.emissions.Baltimore$Emissions)
}

plot2()
png(filename = "plot2.png")
plot2()
dev.off()
