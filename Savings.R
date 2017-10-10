install.packages("data.table")
library(data.table)
hotels <- fread("http://bit.ly/CEU-R-hotels-2017-v2")
str(hotels)
x <- 'Budapest, Hungary'
str(strsplit(x, ', '))
strsplit(x, ', ')[[1]][2]

hotels[, country := strsplit(city, ', ')[[1]][2], by = city]
str(hotels)

?sub

# regular expression magyarazatot megnezni R-ben

sub('.*, ', '', x)

hotels[, citycountry := city]
str(hotels)

hotels[, city := strsplit(citycountry, ', ')[[1]][1], by = citycountry]
str(hotels)

hotels[country == "Hungary", .N]
test <- hotels[country == "Germany", .N, by = city]
test[, .N]

hotels[, .N, by = city][, mean(N)]

hotels_per_city <- hotels[, .N, by = list(city, country)]
hotels_per_city[country == "Germany", mean(N)]
hotels_per_city[, mean(N), by = country]

hotels_per_city[, P := N / sum(N), by = country]
hotels_per_city
print(setorder(hotels_per_city, country))

HU_for_ggplot <- hotels[country == "Hungary" & rating > 4.5,]

install.packages("ggplot2")
library(ggplot2)

ggplot(HU_for_ggplot, aes(price)) + geom_histogram()
str(HU_for_ggplot)

ggplot(HU_for_ggplot, aes(price_HUF)) + geom_histogram()
