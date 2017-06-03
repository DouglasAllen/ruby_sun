require_relative 'algorithms'
require_relative 'julian'

date = DateTime.new(2017, 3, 20, 12)
jme = jme(date)

hlon = heliocentric_longitude(jme)

glon = geocentric_longitude(hlon)

hlat = heliocentric_latitude(jme)

glat = geocetric_latitude(hlat)

esau = astronomical_units(jme)

mean_anomaly = horner(jme * 10, ma) / 3600 % 360

puts "Date #{date.to_time}"
puts "heliocentric longitude Earth #{hlon * 180 / Math::PI}"
puts "geocentric longitude Sun #{glon * 180 / Math::PI}"
puts "heliocentric latitude Earth #{hlat * 180 / Math::PI}"
puts "geocentric latitude Sun #{glat * 180 / Math::PI}"
puts "Earth Sun astronomical units #{esau}"
puts "mean anomaly Sun #{mean_anomaly}"

# http://aa.usno.navy.mil/faq/docs/SunApprox.php

d = date.ajd.to_f - 2_451_545.0
g = mean_anomaly
q = 280.46645 + 0.98564736 * d
ec = (
  1.915 * Math.sin(
    g * Math::PI / 180
  )) + 0.020 * Math.sin(
    2 * g * Math::PI / 180
  )
l = q + ec
puts "mean longitude Sun #{q % 360}"
puts "true longitude Sun #{l % 360}"
