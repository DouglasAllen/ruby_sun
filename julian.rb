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
