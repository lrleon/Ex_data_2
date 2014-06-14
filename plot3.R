
require(ggplot2)
                                        
if (! exists("NEI")) {    # verifiy if NEI data is already loaded
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("NEI.Baltimore")) { # verify if Baltimore data is already computed
    message("Filtering the data for Baltimore city")
    NEI.Baltimore <<- NEI[NEI$fips == "24510", ]}

plot3 <- function() {

    # there is an very outlier in NONPOINT type that dominates the
    # slopes. So, we suppress it in order to highlight the variations
    # without lossing the trends senses
    data <- NEI.Baltimore[NEI.Baltimore$Emissions < 1000, ]
    g <- ggplot(data, aes(year, Emissions)) 
    g <- g + geom_smooth(method = lm, size = 1, col = "black", alpha = .5) +
         facet_grid(. ~ type) + geom_point(col="salmon", alpha=.5, size=4) +
         xlab("years") + ylab("Emissions in tons") +
         labs(title="Emissions of PM 2.5 trends in Baltimore classified by type")

    print(g)
}

plot3()
png(filename = "plot3.png")
plot3()
dev.off()
