
library(ggplot2)

if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("NEI.Baltimore")) {
    message("Filtering the data for Baltimore city")
    NEI.Baltimore <<- NEI[NEI$fips == "24510", ]
}

if (! exists("total.emissions.Baltimore.by.type")) {
    total.emissions.Baltimore.by.type <<-
        aggregate(list(Emissions = NEI.Baltimore$Emissions),
                  list(type = NEI.Baltimore$type, year = NEI.Baltimore$year),
                  sum)
}

plot3 <- function() {

    g <- ggplot(total.emissions.Baltimore.by.type, aes(year, Emissions))
    g <- g + geom_line() + facet_grid(. ~ type) + xlab("years") +
         ylab("Total emissions in tons") +
         labs(title="Total emissions of PM25 in Baltimore classified by type")

    print(g)
}

plot3()
png(filename = "plot3.png")
plot3()
dev.off()
