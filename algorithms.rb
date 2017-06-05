
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

def horner(t, abc)
  abc.each_with_index.reduce(0) { |a, (e, i)| a + e * t**i }
end

def heliocentric_longitude(jme)
  l = Helio::HELIOCENTRIC_LONGITUDE_COEFFS
  hlc = coefficients(jme, l)
  horner(jme, hlc) % (Math::PI * 2)
end

def heliocentric_latitude(jme)
  b = Helio::HELIOCENTRIC_LATITUDE_COEFFS
  hlc = coefficients(jme, b)
  horner(jme, hlc)
end

def astronomical_units(jme)
  r = Helio::AU_DISTANCE_COEFFS
  rvl = coefficients(jme, r)
  horner(jme, rvl)
end

def geocentric_longitude(hlon)
  (hlon + Math::PI) % (Math::PI * 2)
end

def geocetric_latitude(hlat)
  -1 * hlat
end

def ma(j)
  a = [1_287_104.793048, 129_596_581.0481, - 0.5532, 0.000136, - 0.00001149]
  horner(j * 10, a) / 3600 % 360
end

def ml(j)
  a = [280.4664567, 36_000.76982779, 0.0003032028,
       1.0 / 499_310.0, 1.0 / -152_990.0, 1.0 / -19_880_000.0]
  horner(j * 10, a) % 360
end

def ec(g)
  1.915 * Math.sin(g * Math::PI / 180) +
    0.020 * Math.sin(2 * g * Math::PI / 180)
end

def tl(j)
  (ec(ma(j)) + ml(j)) % 360
end

def om
  [450_160.398036, - 6_962_890.5431, 7.4722, 0.007702, - 0.00005939]
end
