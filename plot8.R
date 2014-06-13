require(ggplot2)

if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("SCC"))
    SCC <<- readRDS("Source_Classification_Code.rds")

if (! exists("NEI.point")) 
    NEI.point <<- NEI[NEI$type == "POINT",]

if (! exists("NEI.point.Baltimore")) 
    NEI.point.Baltimore <<-
    merge(NEI.point[NEI.point$fips == "24510", ], SCC[, c(1, 4)],
          by.x = "SCC", by.y = "SCC")

if (! exists("NEI.point.Los.Angeles")) 
    NEI.point.Los.Angeles <<-
    merge(NEI.point[NEI.point$fips == "06037", ],
          SCC[, c(1, 4)], by.x = "SCC", by.y = "SCC")

                                        # add column city with "Baltimore"
t.Baltimore <- NEI.point.Baltimore
t.Baltimore$City <- "Baltimore"

                                        # add column city with "Los Angeles"
t.Los.Angeles <- NEI.point.Los.Angeles
t.Los.Angeles$City <- "Los Angeles"

totals <- rbind(t.Baltimore, t.Los.Angeles)
totals$City <- as.factor(totals$City)

plot8 <- function() {

    # there is an outlier that distortions the smooth. So I remove it for
    # best appreciation, since there is no loss of trends senses
    #data <- totals[totals$Emissions < 1500, ]
    data <- totals[totals$Emissions < 1500, ]
    g <- ggplot(data, aes(year, Emissions, colour=City)) +
         facet_grid(. ~ EI.Sector) +
         ylab("Emission of PM 2.5 (point) in Tons") +
         geom_point(size = 2, alpha = .3) +
         geom_smooth(method = lm) +
         labs(title="Comparison of PM 2.5 due distint to point sources\nbetween Baltimore and Los Angeles")
    print(g)
}

plot8()
png(filename = "plot8.png", width = 1800)
plot8()
dev.off()
