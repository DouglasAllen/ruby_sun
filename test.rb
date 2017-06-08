require_relative 'algorithms'
require_relative 'julian'
require_relative 'nutation'

# date = DateTime.new(2017, 3, 20, 10, 9, 1.2415797505)
# date = DateTime.new(2017, 3, 20, 10, 17, 0.22)
date = DateTime.new(2017, 6, 21, 4, 20)
jme = jme(date)

hlon = heliocentric_longitude(jme)
glon = geocentric_longitude(hlon)
hlat = heliocentric_latitude(jme)
glat = geocetric_latitude(hlat)
esau = astronomical_units(jme)
mean_anomaly = ma(jme)
mean_longitude = ml(jme)
true_longitude = tl(jme)
apparent_longitude = al(jme)
nut_lon = nutation(jme)[0]
nut_eps = nutation(jme)[1]
eps = meo(jme)
eqe = eqe(jme)

puts "Date #{date.to_time}"
puts "heliocentric longitude Earth #{hlon * 180 / Math::PI}"
puts "geocentric longitude Sun #{glon * 180 / Math::PI}"
puts "heliocentric latitude Earth #{hlat * 180 / Math::PI}"
puts "geocentric latitude Sun #{glat * 180 / Math::PI}"
puts "Earth Sun astronomical units #{esau}"
puts "mean anomaly Sun #{mean_anomaly}"
puts "mean longitude Sun #{mean_longitude}"
puts "true longitude Sun #{true_longitude}"
puts "apparent longitude Sun #{apparent_longitude}"
puts "nut longitude Sun #{nut_lon}"
puts "nut epsilon #{nut_eps}"
puts "equation of equinox #{eqe}"
puts "mean epsilon #{eps}"
puts "epsilon #{eps + nut_eps}"
puts "lambda #{glon * 180 / Math::PI + nut_lon}"
