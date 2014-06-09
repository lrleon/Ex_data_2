library(ggplot2)

if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("NEI.motor")) 
    NEI.motor <<- NEI[NEI$type == "ON-ROAD",]

if (! exists("total.emissions.motor.Baltimore")) {
    NEI.motor.Baltimore <- NEI.motor[NEI.motor$fips == "24510", ]
    total.emissions.motor.Baltimore <<-
        aggregate(list(Emissions = NEI.motor.Baltimore$Emissions),
                  by=list(year = NEI.motor.Baltimore$year), sum)
}

if (! exists("total.emissions.motor.Los.Angeles")) {
    NEI.motor.Los.Angeles <- NEI.motor[NEI.motor$fips == "06037", ]
    total.emissions.motor.Los.Angeles <<-
        aggregate(list(Emissions = NEI.motor.Los.Angeles$Emissions),
                  by=list(year = NEI.motor.Los.Angeles$year), sum)
}

                                        # add column city with "Baltimore"
t.Baltimore <- total.emissions.motor.Baltimore
t.Baltimore$City <- "Baltimore"

                                        # add column city with "Los Angeles"
t.Los.Angeles <- total.emissions.motor.Los.Angeles
t.Los.Angeles$City <- "Los Angeles"

totals <- rbind(t.Baltimore, t.Los.Angeles)
totals$City <- as.factor(totals$City)

plot6 <- function() {

    g <- ggplot(totals, aes(year, Emissions, colour=City, shape=City)) +
         geom_line() + geom_point() +
         ylab("Total emission of PM25 (ON-ROAD) in Tons") +
         geom_smooth(method = 'lm', linetype = 3, se = FALSE) +
         labs(title="Comparison of PM25 due to vehicles among Baltimore and Los Angeles")
    print(g)
}

plot6()
png(filename = "plot6.png")
plot6()
dev.off()
