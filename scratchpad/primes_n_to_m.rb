#require 'library'
require 'coupler'
include Coupler
n = ARGV[0].to_i
m = ARGV[1].to_i

p = couple(:'TestPrimes').new(m).primes

puts p.select{|x| x >= n}.map{|m| m.to_s(2)}.join(",")

