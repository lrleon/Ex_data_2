if (! exists("NEI")) {
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("SCC"))
    SCC <<- readRDS("Source_Classification_Code.rds")

if (! exists("NEI.motor")) {
                                        # determine SSC codes related to motor
    motor.str <- "[mM][oO][tT][oO][rR]"
    motor.idx <- grep(motor.str, SCC$Short.Name)
    SCC.motor <- SCC$SCC[motor.idx]              # codes SCC related to motor

                                        # select only SCC related to motor
    NEI.motor <<- NEI[!is.na(match(NEI$SCC, SCC.motor)),]
}

if (! exists("total.emissions.motor.Baltimore")) {
    NEI.motor.Baltimore <- NEI[NEI.motor$fips == "24510", ]
    total.emissions.motor.Baltimore <<-
        aggregate(list(Emissions = NEI.motor.Baltimore$Emissions),
                  by=list(year = NEI.motor.Baltimore$year), sum)
}

if (! exists("total.emissions.motor.Los.Angeles")) {
    NEI.motor.Los.Angeles <- NEI[NEI.motor$fips == "06037", ]
    total.emissions.motor.Los.Angeles <<-
        aggregate(list(Emissions = NEI.motor.Los.Angeles$Emissions),
                  by=list(year = NEI.motor.Los.Angeles$year), sum)
}

plot6 <- function() {

    g <- ggplot() +
        geom_line(data = total.emissions.motor.Baltimore,
                  aes(year, Emissions), color="red") +
        geom_line(data = total.emissions.motor.Los.Angeles,
                  aes(year, Emissions), color="blue") +
        ylab("Emission of PM25 in Tons") +
        geom_point(data = total.emissions.motor.Baltimore,
                   aes(year, Emissions)) +
        geom_point(data = total.emissions.motor.Los.Angeles,
                   aes(year, Emissions))
    print(g)
}

plot6()
png(filename = "plot6.png")
plot6()
dev.off()
