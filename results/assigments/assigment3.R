library(data.table)
library(ggplot2)

runoff_day <- readRDS('data/runoff_day.rds')

runoff_stations <- runoff_day[, .(mean_day = round(mean(value), 0), sd_day = round(sd(value), 0), min_day = round(min(value), 0), max_day = round(max(value), 0)), by = sname]

runoff_st_tidy <- melt(runoff_stations, id.vars = 'sname', variable.name = 'stats', value.name = 'runoff')

ggplot(runoff_st_tidy, aes(sname, runoff, shape = stats, col = stats)) + 
  geom_point(aes(col = stats, shape = stats))


runoff_stations[, variation_coefficient := sd_day/mean_day, by = sname]
coefficient_and_skewness <- runoff_stats[, .(sname, skewness, variation_coefficient)]


runoff_summary <- readRDS('./data/runoff_summary.rds')
runoff_month <- readRDS('./data/runoff_month.rds')

runoff_class1 <- runoff_summary[, .(sname, runoff_class)]
runoff_month1 <- runoff_month[runoff_class1, on = 'sname']

ggplot(runoff_month1, aes(x = factor(month), y = value, fill = runoff_class)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = 'free')

ggplot(runoff_day, aes(x = sname, y = value)) +
  geom_boxplot()


colours <- c('coral3', 'burlywood3', 'cadetblue3')

runoff_summary[, area_class := factor('small')]
runoff_summary[area >= 10000 & area < 110000, area_class:= factor('medium')]
runoff_summary[area >= 110000, area_class := factor('large')]

runoff_summary[, alt_class := factor('low')]
runoff_summary[altitude >= 50 & altitude < 350, alt_class := factor('medium')]
runoff_summary[altitude >= 350, alt_class := factor('high')]
runoff_summary

datatable <- runoff_summary[, .(sname, area, alt_class)]
class_area_alt <- runoff_stations[datatable, on = 'sname']

ggplot(class_area_alt, aes(x = mean_day, y = area, col = sname, cex = alt_class)) +
  geom_point() +
  scale_color_manual(values = colorRampPalette(colours)(17)) +
  theme_bw()










