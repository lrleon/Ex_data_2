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
                                    SCC[, c(1, 4)], by = "SCC")

if (! exists("NEI.non.road.Baltimore")) 
    NEI.non.road.Baltimore <<-
    merge(NEI.non.road[NEI.non.road$fips == "24510", ],
          SCC[, c(1, 4)], by = "SCC")

if (! exists("NEI.on.road.Los.Angeles")) 
    NEI.on.road.Los.Angeles <<-
    merge(NEI.on.road[NEI.on.road$fips == "06037", ],
          SCC[, c(1, 4)], by = "SCC")

if (! exists("NEI.non.road.Los.Angeles")) 
    NEI.non.road.Los.Angeles <<-
    merge(NEI.non.road[NEI.non.road$fips == "06037", ],
          SCC[, c(1, 4)], by = "SCC")

t.on.road.Baltimore <- NEI.on.road.Baltimore 
t.on.road.Baltimore$City <- "Baltimore" # with column "Baltimore"

t.on.road.Los.Angeles <- NEI.on.road.Los.Angeles 
t.on.road.Los.Angeles$City <- "Los Angeles" # add column "Los Angeles"

totals.on.road <<- rbind(t.on.road.Los.Angeles, t.on.road.Baltimore)
totals.on.road$City <- as.factor(totals.on.road$City)

t.non.road.Baltimore <- NEI.non.road.Baltimore 
t.non.road.Baltimore$City <- "Baltimore" # add column "Baltimore"

t.non.road.Los.Angeles <- NEI.non.road.Los.Angeles 
t.non.road.Los.Angeles$City <- "Los Angeles" # add column "Los Angeles"

totals.non.road <<- rbind(t.non.road.Los.Angeles, t.non.road.Baltimore)
totals.non.road$City <- as.factor(totals.non.road$City)

plot6 <- function() {

    # there is an outlier above 1500 tons in Los Angeles that
    # distortions the smooth for on.road. So I remove it for best
    # appreciation, since there is no loss of trends senses. 
    data <- totals.on.road[totals.on.road$Emissions < 1500, ]
    
    #data <- totals.on.road[totals.on.road$Emissions < 20], ]
    # You can reduce the range of Emissions ir order to see better the red
    # points (BALTIMORE). Try by example with totals.on.road$Emissions < 20

    g.on.road <- ggplot(data, aes(year, Emissions, color = City)) +
          facet_grid(. ~ EI.Sector) + xlab("ON-ROAD sources (motor vehicles)") +
          ylab("PM 2.5 (ON-ROAD) in Tons") +
          geom_point(size = 4, alpha = .3) +
          geom_smooth(method = lm)

    g.non.road <- ggplot(totals.non.road, aes(year, Emissions, color = City)) +
          facet_grid(. ~ EI.Sector) + xlab("NON-ROAD sources") +
          ylab("PM 2.5 (NON-ROAD) in Tons") +
          geom_point(size = 4, alpha = .3) +
          geom_smooth(method = lm, se = FALSE)
                      # smooth std trespasses negative y axis, so se = F
    
    grid.arrange(g.on.road, g.non.road, nrow = 2,
                 main =
   "Comparison of PM 2.5 from mobile sources between Baltimore and Los Angeles",
                 sub = textGrob("Years"))
}

plot6()
png(filename = "plot6.png", width = 1000)
plot6()
dev.off()
