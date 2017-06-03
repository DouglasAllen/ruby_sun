# Julian
require 'date'

def jme(date)
  jd = date.ajd
  year = date.year
  t = year - 2000
  delta_t = 62.92 + 0.32217 * t + 0.005589 * t**2
  jde = jd + delta_t / 86_400
  jce = (jde - 2_451_545) / 36_525
  jce / 10
end

require_relative 'helio_l'
require_relative 'helio_b'
require_relative 'helio_r'

def coefficients(jme, coeffs)
  # Given the julian century time and the constant name for
  #  the coefficient set to use
  #  sums the time-varying coefficients sub arrays and
  # returns an array with each.
  result = []

  (0..coeffs.size - 1).each do |g|
    group = coeffs[g]
    tsum = 0.0
    group.each do |item|
      tsum += (item[0] * Math.cos(item[1] + item[2] * jme))
    end
    result << tsum
  end
  result
  # end coefficients
end

@horner = lambda { |t, abc|
  abc.each_with_index.reduce(0){ |a, (e, i)| a + e * t**i }
}

def lambda_array(x, arr)
  @horner.call(x, arr)
end

def heliocentric_longitude(jme)
  l = Helio::HELIOCENTRIC_LONGITUDE_COEFFS
  hlc = coefficients(jme, l)
  @horner.call(jme, hlc) % (Math::PI * 2)
  # ((hlc[0] +
  # jme * (hlc[1] +
  # jme * (hlc[2] +
  # jme * (hlc[3] +
  # jme * (hlc[4] +
  # jme * hlc[5]))))) / 1e8) % (Math::PI * 2)
end

def heliocentric_latitude(jme)
  b = Helio::HELIOCENTRIC_LATITUDE_COEFFS
  hlc = coefficients(jme, b)
  @horner.call(jme, hlc) % (Math::PI * 2)
  # ((hlc[0] +
  # jme * (hlc[1] +
  # jme * (hlc[2] +
  # jme * (hlc[3] +
  # jme * hlc[4])))) / 1e8) % (Math::PI * 2)
end

def astronomical_units(jme)
  r = Helio::AU_DISTANCE_COEFFS
  rvl = coefficients(jme, r)
  @horner.call(jme, rvl)
  # (rvl[0] +
  # jme * (rvl[1] +
  # jme * (rvl[2] +
  # jme * (rvl[3] +
  # jme * rvl[4])))) / 1e8
end

def geocentric_longitude(hlon)
  (hlon + Math::PI) % (Math::PI * 2)
end

def geocetric_latitude(hlat)
  -1 * hlat
end

ma = [1287104.793048, 129596581.0481, - 0.5532, 0.000136, - 0.00001149]

date = DateTime.now
jme = jme(date)

hlon = heliocentric_longitude(jme)

glon = geocentric_longitude(hlon)

hlat = heliocentric_latitude(jme)

glat = geocetric_latitude(hlat)

esau = astronomical_units(jme)

mean_anomaly = @horner.call(jme * 10, ma) / 3600 % 360

puts hlon * 180 / Math::PI
puts glon * 180 / Math::PI
puts hlat * 180 / Math::PI
puts glat * 180 / Math::PI
puts esau
puts mean_anomaly

# http://aa.usno.navy.mil/faq/docs/SunApprox.php

d = date.ajd.to_f - 2_451_545.0
g = 357.52911 + 0.98560028 * d
q = 280.46645 + 0.98564736 * d
ec = (
  1.915 * Math.sin(
    g * Math::PI / 180
  )) + 0.020 * Math.sin(
    2 * g * Math::PI / 180
  )
l = q + ec
puts q % 360
puts l % 360

__END__
# jd = Integer(365.25 * (y + 4716)) + Integer(30.006 * (m + 1)) + d + b - 1524.5
# where,
# - Integer is the Integer of the calculated terms (e.g. 8.7 = 8, 8.2 = 8, and -8.7 = 8..etc.).
# -y is the year (e.g. 2001, 2002, ..etc.).
# -m is the month of the year (e.g. 1 for January, ..etc.).
# Note that if m > 2, then y and m are not changed, but if m = 1 or 2, then y = y - 1 and m = m + 12.
# -d is the day of the month with decimal time (e.g. for the second day of the month at 12:30:30 UT, d = 2.521180556).
# -b is equal to 0, for the Julian calendar {i.e. by using b = 0 in Equation 4, jd < 2299160}, and equal to
# (2 - a + Integer (a / 4)) for the Gregorian calendar {i.e. by using b = 0 in Equation 4, jd > 2299160},
# where a = Integer(y / 100).

# In Ruby we just use Date and DateTime classes from standard library.

date = Date.new(2017, 5, 21)
puts date

date_time = DateTime.new(2017, 5, 21, 12, 0, 0)
puts date_time

# now find the Julian Day number
jd = date.jd
puts jd

ajd = date_time.ajd
puts ajd

# Calculate the Julian Ephemeris Day (jde)
# jde = jd + delta_t / 86_400
# ΔT = 62.92 + 0.32217 * t + 0.005589 * t^2
# where: t = y - 2000

year = date.year
t = year - 2000
delta_t = 62.92 + 0.32217 * t + 0.005589 * t**2
jde = jd + delta_t / 86_400
puts jde

# Calculate the Julian century (jc) and the Julian Ephemeris Century (jce) for the 2000 standard epoch
# jc = (jd - 2451545) / 36_525.0
# jce = (jde - 2451545) / 36_525

jc = (jd - 2_451_545) / 36_525.0
puts jc

jce = (jde - 2_451_545) / 36_525
puts jce

# Calculate the Julian Ephemeris Millennium (jme) for the 2000 standard epoch
# jme = jce / 10

jme = jce / 10
puts jme
