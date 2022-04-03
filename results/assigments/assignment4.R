library(data.table)
library(ggplot2)


runoff_summary <- readRDS('data/runoff_summary.rds')
runoff_stats <- readRDS('data/runoff_stats.rds')
runoff_month <- readRDS('data/runoff_month.rds')
runoff_summer <- readRDS('data/runoff_summer.rds')
runoff_winter <- readRDS('data/runoff_winter.rds')
runoff_year <- readRDS('data/runoff_year.rds')

colset_4 <-  c("#D35C37", "#BF9A77", "#D6C6B9", "#97B8C2")
theme_set(theme_bw())

key_stations <- c('DOMA', 'BASR', 'KOEL')

runoff_summary_key <-runoff_summary[sname %in% key_stations]
runoff_month_key <- runoff_month[sname %in% key_stations]
runoff_year_key <- runoff_year[sname %in% key_stations]

runoff_year_key[year <= 2010, age_range := factor('before_2010')]
runoff_year_key[year > 1950, age_range := factor('after_1950')]

ggplot(runoff_year_key, aes(age_range, value, fill = age_range)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = 'free_y') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Age Range") +
  ylab(label = "Runoff (m3/s)") +
  theme_bw()

runoff_month_key[year <= 2010, age_range := factor('before_2010')]
runoff_month_key[year > 1950, age_range := factor('after_1950')]

ggplot(runoff_month_key, aes(factor(month), value, fill = age_range)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = 'free_y') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Month") +
  ylab(label = "Runoff (m3/s)") +
  theme_bw()

#2
runoff_day <- readRDS('data/runoff_day.rds')
runoff_day_key <- runoff_day[sname %in% key_stations]

year_thres <- 1999

runoff_day_key[year <= year_thres, age_range := factor('before_1999')]
runoff_day_key[year > year_thres, age_range := factor('after_1999')]
runoff_day_key[, quantile01 := quantile(value, 0.1), by = .(sname, month)]
runoff_day_key[, quantile09 := quantile(value, 0.9), by = .(sname, month)]


runoff_day_key[, runoff_class := factor('medium')]
runoff_day_key[value <= quantile01, runoff_class := factor('low')]
runoff_day_key[value >= quantile09, runoff_class := factor('high')]
runoff_day_key[, days := .N, .(sname, year, runoff_class, season)]

runoff_day_unique <- unique(runoff_day_key[, .(sname, days, year, age_range, season, runoff_class)])


ggplot(runoff_day_unique[season == 'winter' | season == 'summer'], 
       aes(season, days, fill = age_range)) +
  geom_boxplot() +
  facet_wrap(runoff_class~sname, scales = 'free_y') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Season") +
  ylab(label = "Days") +
  theme_bw()


#3

runoff_winter[, value_norm := scale(value), sname]
runoff_summer[, value_norm := scale(value), sname]
n_stations <- nrow(runoff_summary)


year_thres <- 1980
to_plot <- rbind(cbind(runoff_winter, season = factor('winter')), cbind(runoff_summer, season = factor('summer'))) 

to_plot[year < year_thres, period := factor('1950-1980')]
to_plot[year >= year_thres, period := factor('1981-2010')]

to_plot <- to_plot[year >= 1950]

ggplot(to_plot[year > 1950 & year <= 2010], aes(x = year, y = value_norm, col = sname)) +
  geom_smooth(method = 'loess', formula = y~x, se = 0) + 
  scale_color_manual(values = colorRampPalette(colset_4)(n_stations)) +
  ggtitle('Summer runoff') +
  xlab(label = "Year") +
  ylab(label = "Runoff") +
  theme_bw()


ggplot(to_plot[year > 1950 & year <= 2010], aes(x = year, y = value_norm, col = sname)) +
  geom_smooth(method = 'loess', formula = y~x, se = 0) + 
  scale_color_manual(values = colorRampPalette(colset_4)(n_stations)) +
  ggtitle('Winter runoff') +
  xlab(label = "Year") +
  ylab(label = "Runoff") +
  theme_bw()



