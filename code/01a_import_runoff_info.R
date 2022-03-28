library(data.table)
list.files('data/raw')
runoff_stations <- fread('./data/raw/raw/runoff_stations.csv')
head(runoff_stations)
runoff_stations$station

runoff_stations[, sname := factor(abbreviate(station))]
head(runoff_stations)

runoff_stations[, id := factor(id)]
head(runoff_stations)
runoff_stations[, lat := round(lat, 3)]
head(runoff_stations)

runoff_stations[, lon := round(lon, 3)]
head(runoff_stations)

runoff_stations[, altitude := round(altitude, 0)]
head(runoff_stations)

saveRDS(runoff_stations, './data/runoff_stations_raw.rds')

getwd()
