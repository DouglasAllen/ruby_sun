require_relative 'algorithms'
require_relative 'julian'
require_relative 'nutation'

# date = DateTime.new(2017, 3, 20, 10, 9, 1.2415797505)
# date = DateTime.new(2017, 3, 20, 10, 17, 0.22)
date = DateTime.new(2017, 6, 21, 4, 24, 4.835)
jme = jme(date)

hlon = hlon(jme) * @rtd
hlat = hlat(jme) * @rtd
esau = au(jme)

glon = glon(jme) * @rtd
glat = glat(jme) * @rtd

mean_anomaly = ma(jme) * @rtd
true_anomaly = nu(jme) * @rtd
mean_longitude = ml(jme) * @rtd
true_longitude = tl(jme) * @rtd
apparent_longitude = al(jme) * @rtd

nut_lon = nutation(jme)[0] * @rtd
nut_eps = nutation(jme)[1] * @rtd
meps = meo(jme) * @rtd
eps = eps(jme) * @rtd
eqe = eqe(jme) * @rtd
lambda = lambda(jme) * @rtd
beta = beta(jme) * @rtd
dec = dec(jme) * @rtd
ra = ra(jme) * @rtd / 15
sha = sha(jme) * @rtd
gmst = gmst(jme) * @rtd / 15
gast = gast(jme) * @rtd / 15
eot = eot(jme) * @rtd / 15 * 60

puts "Date #{date.to_time}"
puts "heliocentric longitude Earth #{hlon}"
puts "heliocentric latitude Earth #{hlat}"
puts "geocentric longitude Sun #{glon}"
puts "geocentric latitude Sun #{glat}"
puts "Earth Sun astronomical units #{esau}"
puts "mean anomaly Sun #{mean_anomaly}"
puts "true anomaly Sun #{true_anomaly}"
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
puts "sidereal hour angle #{sha}"
puts "GMST #{gmst}"
puts "GAST #{gast}"
puts "EOT #{eot}"
