
require_relative 'helio_l'
require_relative 'helio_b'
require_relative 'helio_r'

include Math

@pi2 = PI * 2
@dtr = PI / 180
@rtd = 180 / PI

def sind(x)
  sin(x * @dtr)
end

def cosd(x)
  cos(x * @dtr)
end


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
      tsum += (item[0] * cos(item[1] + item[2] * j))
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
  horner(j, hlc) % @pi2
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
  (hlon(j) + PI) % @pi2
end

def glat(j)
  -1 * hlat(j)
end

def ma(j)
  a = [1_287_104.793048, 129_596_581.0481, - 0.5532, 0.000136, - 0.00001149]
  horner(j * 10, a) / 3600 % 360 * @dtr
end

def ml(j)
  a = [280.4664567, 36_000.76982779, 0.0003032028,
       1.0 / 499_310.0, 1.0 / -152_990.0, 1.0 / -19_880_000.0]
  horner(j * 10, a) % 360 * @dtr
end

def ec(j)
  (1.915 * sin(ma(j)) +
    0.020 * sin(2 * ma(j))) * @dtr
end

def nu(j)
  ma(j) + ec(j)
end

def tl(j)
  glon(j) - 0.000025 * @dtr
end

def om(j)
  a = [450_160.398036, - 6_962_890.5431, 7.4722, 0.007702, - 0.00005939]
  horner(j * 10, a) / 3600 % 360
end

def al(j)
  (tl(j) - 0.00569 * @dtr - 0.00478 * @dtr * sind(om(j)))
end

def meo(j)
  a = [84_381.406, -46.836769, -0.0001831, 0.00200340, -0.000000576, -0.0000000434]
  horner(j * 10, a) / 3600 * @dtr
end

def eps(j)
  meo(j) + nutation(j)[1]
end

def eqe(j)
  nutation(j)[0] * Math.cos(eps(j))
end

def lambda(j)
  glon(j) + nutation(j)[0] - 0.005691611 / au(j)
end

def beta(j)
  j *= 10
  lsp = -1.397 * j - 0.00031 * j * j
  glat(j) + 0.000011 * (cosd(lsp) - sind(lsp))
end

def dec(j)
  asin(
    sin(beta(j)) * cos(eps(j)) +
    cos(beta(j)) * sin(eps(j)) * sin(lambda(j))
  )
end

def ra(j)
  atan2(
    (sin(lambda(j)) * cos(eps(j)) -
    tan(beta(j)) * sin(eps(j))),
    cos(lambda(j))
  )
end

def sha(j)
  @pi2 - ra(j)
end

def gmst(j)
  a = [280.46061837, 0.000387933, 1 / 38_710_000.0]
  (360.98564736629 * j * 365_250.0 +
  horner(j * 10, a)) % 360 * @dtr
end

def gast(j)
  gmst(j) + eqe(j)
end

def eot(j)
  ma(j) - nu(j) + lambda(j) - ra(j)
end
