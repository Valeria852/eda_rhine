library(data.table)
library(ggplot2)
runoff_stations_dt <- fread('./data/raw/raw/runoff_stations.csv')
runoff_stations_dt
runoff_stations_dt[, sname := factor(abbreviate(station))]
#add gradient
runoff_stations_dt [, z2 := abs(rnorm(20))]

runoff_stations_dt[, c('sname', 'area', 'altitude')]
ggplot(data = runoff_stations_dt, aes(x = area, y = altitude, col = size)) +
  geom_point(aes(colour = z2)) +
  geom_text(aes(area, altitude, label = sname, color = area))
  
 
ggplot(data = runoff_stations_dt, aes(x = lon, y = lat, col = altitude)) +
  geom_point() +
  geom_text(label = runoff_stations_dt$sname) +
  scale_color_gradient(low = 'dark green', high = 'brown') +
  theme_bw()

