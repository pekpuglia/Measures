#assumindo medidas sempre independentes
module Uncertainty

export UncertainNumber, calculate, @unc

using ForwardDiff: gradient
struct UncertainNumber
    x::Float64
    σ::Float64
end

function Base.show(io::IO, n::UncertainNumber)
    print(n.x, " ± ", n.σ, " ")    
end

function calculate(f::Function, param_list::Vector{UncertainNumber})
    x = [p.x for p = param_list]
    σ = [p.σ for p = param_list]

    val = f(x)
    grad = gradient(f, x)
    total_σ = √sum([(g*s)^2 for (g, s) = zip(grad, σ)])
    return UncertainNumber(val, total_σ)
end

macro unc(x::Real, σ::Real)
    return :(UncertainNumber($x, $σ))
end
end

# using .Uncertainty
# a = @unc 1 0.5
# print(a)
# b = @unc 2 0.1
# f(vec) = begin
#     x = vec[1]
#     y = vec[2]
#     √x + sin(y)
# end
# calculate(f, [a, b])