

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

plot5 <- function() {

    plot(total.emissions.motor.Baltimore$year,
         total.emissions.motor.Baltimore$Emissions,
         main = "Total of PM25 related to motor in Baltimore",
         xlab = "Year", ylab = "PM25 in tons")
    lines(total.emissions.motor.Baltimore$year,
          total.emissions.motor.Baltimore$Emissions)
}

plot5()
png(filename = "plot5.png")
plot5()
dev.off()
