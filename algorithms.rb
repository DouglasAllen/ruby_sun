
require_relative 'helio_l'
require_relative 'helio_b'
require_relative 'helio_r'

def coefficients(j, coeffs)
  # Given the julian century time and the constant name for
  #  the coefficient set to use
  #  sums the time-varying coefficients sub arrays and
  # returns an array with each.
  result = []

  (0..coeffs.size - 1).each do |g|
    group = coeffs[g]
    tsum = 0.0
    group.each do |item|
      tsum += (item[0] * Math.cos(item[1] + item[2] * j))
    end
    result << tsum
  end
  result
  # end coefficients
end

def horner(t, abc)
  abc.each_with_index.reduce(0) { |a, (e, i)| a + e * t**i }
end

def hlon(j)
  l = Helio::HELIOCENTRIC_LONGITUDE_COEFFS
  hlc = coefficients(j, l)
  horner(j, hlc) % (Math::PI * 2)
end

def hlat(j)
  b = Helio::HELIOCENTRIC_LATITUDE_COEFFS
  hlc = coefficients(j, b)
  horner(j, hlc)
end

def au(j)
  r = Helio::AU_DISTANCE_COEFFS
  rvl = coefficients(j, r)
  horner(j, rvl)
end

def glon(j)
  (hlon(j) + Math::PI) % (Math::PI * 2)
end

def glat(j)
  -1 * hlat(j)
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
  # (ec(ma(j)) + ml(j)) % 360
  glon(j) - 0.000025
end

def om(j)
  a = [450_160.398036, - 6_962_890.5431, 7.4722, 0.007702, - 0.00005939]
  horner(j * 10, a) / 3600 % 360
end

def al(j)
  (tl(j) - 0.00569 - 0.00478 * Math.sin(Math::PI / 180 * om(j))) % 360
end

def meo(j)
  a = [84_381.406, -46.836769, -0.0001831, 0.00200340, -0.000000576, -0.0000000434]
  horner(j * 10, a) / 3600
end

def eqe(j)
  nutation(j)[0] * Math.cos(Math::PI / 180 * meo(j))
end

def lambda(j)
  glon(j) * 180 / Math::PI +
    nutation(j)[0] - 0.005691611 / au(j)
end
