require_relative 'algorithms'
require_relative 'julian'

date = DateTime.new(2017, 3, 20, 12)
jme = jme(date)

hlon = heliocentric_longitude(jme)

glon = geocentric_longitude(hlon)

hlat = heliocentric_latitude(jme)

glat = geocetric_latitude(hlat)

esau = astronomical_units(jme)

mean_anomaly = ma(jme)
mean_longitude = ml(jme)
true_longitude = tl(jme)

puts "Date #{date.to_time}"
puts "heliocentric longitude Earth #{hlon * 180 / Math::PI}"
puts "geocentric longitude Sun #{glon * 180 / Math::PI}"
puts "heliocentric latitude Earth #{hlat * 180 / Math::PI}"
puts "geocentric latitude Sun #{glat * 180 / Math::PI}"
puts "Earth Sun astronomical units #{esau}"
puts "mean anomaly Sun #{mean_anomaly}"
puts "mean longitude Sun #{mean_longitude}"
puts "true longitude Sun #{true_longitude}"
