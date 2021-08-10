include("../src/Measures.jl")

using .Measures
m = Measures.SI.m
s = Measures.SI.s
# a = Measure((@unc 1 0.5), m)
# b = Measure((@unc 2 0.1), s)
a = @meas 1 0.5 m
b = @meas 2 0.1 s
f(vec) = vec[1]/vec[2]
##
x = calculate(f, [a, b])
print(x)