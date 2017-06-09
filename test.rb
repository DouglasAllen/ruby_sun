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

mean_anomaly = ma(jme) * 180 / Math::PI
mean_longitude = ml(jme) * 180 / Math::PI
true_longitude = tl(jme) * 180 / Math::PI
apparent_longitude = al(jme) * 180 / Math::PI

nut_lon = nutation(jme)[0] * 180 / Math::PI
nut_eps = nutation(jme)[1] * 180 / Math::PI
meps = meo(jme) * 180 / Math::PI
eps = eps(jme) * 180 / Math::PI
eqe = eqe(jme) * 180 / Math::PI
lambda = lambda(jme) * 180 / Math::PI
beta = beta(jme) * 180 / Math::PI
dec = dec(jme) * 180 / Math::PI
ra = ra(jme) * 180 / Math::PI

puts "Date #{date.to_time}"
puts "heliocentric longitude Earth #{hlon}"
puts "heliocentric latitude Earth #{hlat}"
puts "geocentric longitude Sun #{glon}"
puts "geocentric latitude Sun #{glat}"
puts "Earth Sun astronomical units #{esau}"
puts "mean anomaly Sun #{mean_anomaly}"
puts "mean longitude Sun #{mean_longitude}"
puts "true longitude Sun #{true_longitude}"
puts "apparent longitude Sun #{apparent_longitude}"
puts "nut longitude Sun #{nut_lon}"
puts "nut epsilon #{nut_eps}"
puts "equation of equinox #{eqe}"
puts "mean epsilon #{meps}"
puts "epsilon #{eps}"
puts "lambda #{lambda}"
puts "beta #{beta}"
puts "declination #{dec}"
puts "right ascension #{ra}"
