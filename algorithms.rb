
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
  p hlc = coefficients(jme, b)
  # @horner.call(jme, hlc) % (Math::PI * 2)
  (hlc[0] +
  jme * (hlc[1] +
  jme * (hlc[2] +
  jme * (hlc[3] +
  jme * hlc[4])))) % (Math::PI * 2)
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

def ma
  [1287104.793048, 129596581.0481, - 0.5532, 0.000136, - 0.00001149]
end
