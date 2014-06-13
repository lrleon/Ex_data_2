require(ggplot2)
require(gridExtra)

if (! exists("NEI")) {    # verify if NEI data is already loaded
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}

if (! exists("SCC"))    # verify is SCC data is already loaded
    SCC <<- readRDS("Source_Classification_Code.rds")

if (! exists("NEI.on.road"))    # NEI subset containg ON-ROAD types
    NEI.on.road <<- NEI[NEI$type == "ON-ROAD",]

if (! exists("NEI.non.road"))    # NEI subset containg NON-ROAD types
    NEI.non.road <<- NEI[NEI$type == "NON-ROAD",]

if (! exists("NEI.on.road.Baltimore")) 
    NEI.on.road.Baltimore <<- merge(NEI.on.road[NEI.on.road$fips == "24510", ],
                                    SCC[, c(1, 4)], by.x = "SCC", by.y = "SCC")

if (! exists("NEI.non.road.Baltimore")) 
    NEI.non.road.Baltimore <<-
    merge(NEI.non.road[NEI.non.road$fips == "24510", ],
          SCC[, c(1, 4)], by.x = "SCC", by.y = "SCC")

plot5 <- function() {

    g1 <- ggplot(NEI.on.road.Baltimore, aes(year, Emissions)) +
          geom_point(col= "salmon", size = 3, alpha = .4) +
          facet_grid(. ~ EI.Sector) + scale_colour_discrete(guide = FALSE) +
          geom_smooth(method = loess, alpha = .5, color = "red") +
          xlab("ON-ROAD sources (vehicles)") + ylab("PM 2.5 in tons")
    
    g2 <- ggplot(NEI.non.road.Baltimore, aes(year, Emissions)) +
          geom_point(col = "salmon", size = 3, alpha = .4) +
          facet_grid(. ~ EI.Sector) + scale_colour_discrete(guide = FALSE) +
          geom_smooth(method = loess, alpha = .5, color = "red", se = FALSE) +
          xlab("NON-ROAD sources") + ylab("PM 2.5 in tons") 

    grid.arrange(g1, g2, nrow = 2,
                 main = "Emission of PM 2.5 from distint \"mobile\" sources (including \"motor vehicles\") for Baltimore)",
                 sub = textGrob("Years"))
}

plot5()
png(filename = "plot5.png", width = 800)
plot5()
dev.off()
