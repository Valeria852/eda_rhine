runoff <- 130

runoff_ts <- data.frame(time = as.Date(1:90, origin = '2020/12/31'), 
                        value = sample(c(130, 135, 140), 
                                       size = 90, replace = T))
head(runoff_ts)
library(data.table)
runoff_dt <- data.table(runoff_ts)
runoff_dt[value > 130]
runoff_dt[value > 130, mean(value)]
runoff_dt[value > 130, mean(value), by = month(time)]
runoff_dt[, mon := month(time)]
head(runoff_dt)
runoff_dt[, mon_mean := mean(value), by = mon]
head(runoff_dt)
runoff_dt
runoff_monthly_mean <- runoff_dt[, .(mon, mon_mean)] 
runoff_monthly_mean
unique(runoff_monthly_mean)
saveRDS(runoff_dt, file = './data/dt_example.rds')
