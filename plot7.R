require(ggplot2)

if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("SCC"))
    SCC <<- readRDS("Source_Classification_Code.rds")

if (! exists("NEI.non.road")) 
    NEI.non.road <<- NEI[NEI$type == "NON-ROAD",]

if (! exists("NEI.non.road.Baltimore")) 
    NEI.non.road.Baltimore <<-
    merge(NEI.non.road[NEI.non.road$fips == "24510", ], SCC[, c(1, 4)],
          by.x = "SCC", by.y = "SCC")

if (! exists("NEI.non.road.Los.Angeles")) 
    NEI.non.road.Los.Angeles <<-
    merge(NEI.non.road[NEI.non.road$fips == "06037", ],
          SCC[, c(1, 4)], by.x = "SCC", by.y = "SCC")

                                        # add column city with "Baltimore"
t.Baltimore <- NEI.non.road.Baltimore
t.Baltimore$City <- "Baltimore"

                                        # add column city with "Los Angeles"
t.Los.Angeles <- NEI.non.road.Los.Angeles
t.Los.Angeles$City <- "Los Angeles"

totals <- rbind(t.Baltimore, t.Los.Angeles)
totals$City <- as.factor(totals$City)

plot7 <- function() {

    # there is an outlier that distortions the smooth. So I remove it for
    # best appreciation, since there is no loss of trends senses
    #data <- totals[totals$Emissions < 1500, ]
    #data <- totals[totals$Emissions < 1500, ]
    data <- totals
    g <- ggplot(data, aes(year, Emissions, colour=City)) +
         facet_grid(. ~ EI.Sector) +
         ylab("Emission of PM 2.5 (NON-ROAD) in Tons") +
         geom_point(size = 2, alpha = .3) +
         geom_smooth(method = loess) +
         labs(title="Comparison of PM 2.5 due distint to non.road vehicles sources\nbetween Baltimore and Los Angeles")
    print(g)
}

plot7()
png(filename = "plot7.png", width = 1000)
plot7()
dev.off()
