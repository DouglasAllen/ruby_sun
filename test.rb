require_relative 'algorithms'
require_relative 'julian'
require_relative 'nutation'

# date = DateTime.new(2017, 3, 20, 10, 9, 1.2415797505)
# date = DateTime.new(2017, 3, 20, 10, 17, 0.22)
date = DateTime.new(2017, 6, 21, 4, 24, 4.835)
jme = jme(date)

hlon = hlon(jme) * 180 / Math::PI
hlat = hlat(jme) * 180 / Math::PI
esau = au(jme)

glon = glon(jme) * 180 / Math::PI
glat = glat(jme) * 180 / Math::PI

mean_anomaly = ma(jme)
mean_longitude = ml(jme)
true_longitude = tl(jme) * 180 / Math::PI
apparent_longitude = al(jme) * 180 / Math::PI

nut_lon = nutation(jme)[0]
nut_eps = nutation(jme)[1]
eps = meo(jme)
eqe = eqe(jme)
lambda = lambda(jme)

puts "Date #{date.to_time}"
puts "heliocentric longitude Earth #{hlon}"
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
puts "lambda #{lambda}"
