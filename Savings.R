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

install.packages("XML")
library(XML)

gdp <- readHTMLTable(readLines("http://bit.ly/CEU-R-gdp"), which = 3)
str(gdp)
head(gdp)

gdp <- data.table(gdp)
install.packages("data.table")
library(data.table)

setDT(gdp)
gdp[1, 2]

gdp[, country := iconv(`Country/Territory`, to = 'ASCII', sub = '')] ##### ALT GR + 7 a speckó karakterre!
str(gdp)

gdp[, gdp := sub(',', '', `Int$`)]
str(gdp)
gdp[, gdp := as.numeric(gdp)]
str(gdp)

countries <- hotels[, unique(country)]
countries
 
countries %in% gdp$country

merge(hotels, gdp, by = 'country')
gdp[, list(country, gdp)]

hotels <- merge(hotels, gdp[, list(country, gdp)], by = 'country')
str(hotels)

hotels[, mean(price_EUR), by = country]

install.packages("ggplot2")
library(ggplot2)

ggplot(hotels, aes(X = (hotels[, mean(price_EUR), by = country]), y = gdp)) + geom_point()

country_stats <- hotels[, list(price = mean(price_EUR), gdp = mean(gdp)), by = country]
ggplot(country_stats, aes(gdp, price)) + geom_point()

country_stats <- hotels[, list(
  price = mean(price_EUR),
  gdp = mean(gdp),
  hotels = .N), by = country]

ggplot(country_stats, aes(gdp, price)) + geom_point(aes(size = hotels)) + geom_smooth()

country_stats2 <- country_stats[price < 200]
ggplot(country_stats2, aes(gdp, price)) + geom_point() + geom_smooth()

for (i in 1:nrow(hotels)) {
  hotels[i, lon := geocode(...)]
  hotels[i,  lat := geocode(...)]
}

install.packages("ggmap")
library(ggmap)
geocode('Budapest, Hungary', source = "dsk")

geocodes <- hotels[, .N, by = citycountry]
for (i in 1:nrow(geocodes)) {
  geocode <- geocode(geocodes[i, citycountry], source = 'dsk')
  geocodes[i, lon := geocode$lon]
  geocodes[i,  lat := geocode$lat]
}

geocodes

worldmap <- map_data('world')
str(worldmap)

ggplot() + geom_polygon()