require(ggplot2)
                                        
if (! exists("NEI")) {    # verify if NEI data is already loaded
    message("Reading data. Please wait a few seconds ...")
    NEI <<- readRDS("summarySCC_PM25.rds")
}
                                        
if (! exists("SCC"))    # verify if SCC data is already loaded
    SCC <<- readRDS("Source_Classification_Code.rds")

if (! exists("NEI.coal")) { # verify if coal related is already computed

                                        # determine SSC codes related to coal
    coal.str <- "[cC][oO][aA][lL]"      # the word "coal"
    coal.idx <- grep(coal.str, SCC$EI.Sector)
    SCC.coal <- SCC[coal.idx,]                 # only codes SCC related to coal

                 # select NEI entries whose SCC be related to coal
    NEI.coal <- NEI[!is.na(SCC.coal %in% NEI$SCC), ]

    SCC.sources <- SCC.coal[, c(1, 4)] # 1 is SCC and 4 is EI.Sector

                                        # merge for concatening a col
                                        # with EI.Sector
    NEI.coal <<- merge(NEI.coal, SCC.sources, by.x = "SCC", by.y = "SCC")
}

plot4 <- function() {

    data <- NEI.coal
    g <- ggplot(data, aes(year, Emissions)) + facet_grid(. ~ EI.Sector) +
         geom_point(alpha = .1, size = 2) +
         geom_smooth(method = lm, alpha = .3, col = "darkgray") +
         labs(title = "Emissions of PM 2.5 related to coal in US",
              xlab = "Year", ylab = "PM25 in tons")
    print(g)
}

plot4()
png(filename = "plot4.png", width = 600)
plot4()
dev.off()
