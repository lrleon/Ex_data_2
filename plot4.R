if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("SCC"))
    SCC <<- readRDS("Source_Classification_Code.rds")

if (! exists("NEI.coal")) {
                                        # determine SSC codes related to coal
    coal.str <- "[cC][oO][aA][lL]"
    #coal.idx <- grep(coal.str, SCC$EI.Sector)
    coal.idx <- grep(coal.str, SCC$Short.Name) 
    SCC.coal <- SCC$SCC[coal.idx]              # codes SCC related to coal

                                        # select only SCC related to coal
    NEI.coal <<- NEI[!is.na(match(NEI$SCC, SCC.coal)),]
}

total.emissions.coal <<- aggregate(list(Emissions = NEI.coal$Emissions),
                                   list(year = NEI.coal$year), sum)

plot4 <- function() {

    plot(total.emissions.coal$year, total.emissions.coal$Emissions,
         main = "Total of PM25 related to coal in US",
         xlab = "Year", ylab = "PM25 in tons")
    lines(total.emissions.coal$year, total.emissions.coal$Emissions)
}

plot4()
png(filename = "plot4.png")
plot4()
dev.off()
