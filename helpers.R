
percent_map <- function(shapefile, data) {
    
    # First read in the shapefile, using the path to the shapefile and the shapefile name minus the
    # extension as arguments
    
    # Next the shapefile has to be converted to a dataframe for use in ggplot2
    shapefile_df <- fortify(shapefile)
    shapefile_df$id <- as.numeric(shapefile_df$id)
  
    
    # Now the shapefile can be plotted as either a geom_path or a geom_polygon.
    # Paths handle clipping better. Polygons can be filled.
    # You need the aesthetics long, lat, and group.
    map <- ggplot(data = shapefile_df, aes(x = long, y = lat, group = group))
    map + geom_path()
    
    map + 
      geom_polygon(aes(fill = id)) +
      coord_fixed(1.3) +
      guides(fill = FALSE)
    
    shapefile_df %>% distinct(id) %>% write.csv("data/districts.csv", row.names = FALSE)
    hpi.data <- read.csv("data/Book1.csv")
    #colnames(hpi.data) <- c("id","year")
    hpi.data2 <- subset(hpi.data, select = c("id", data))
    #hpi.data2
    colnames(hpi.data2) <- c("id","HPI")
    #hpi.data2
    
    shapefile_df <- merge(shapefile_df, hpi.data2, by ="id")
    
    map <- ggplot(data = shapefile_df, aes(x = long, y = lat, group = group))
    
    map + 
      geom_polygon(aes(fill = HPI), color = 'gray', size = 0.1) +
      scale_fill_gradient(high = "#e34a33", low = "#fee8c8", guide = "colorbar") +
      coord_fixed(1.3) +
      guides(fill=guide_colorbar(title="Number of Case")) +
      theme(legend.justification=c(1,0), legend.position=c(1,0))

}
