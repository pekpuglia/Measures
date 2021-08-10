module Measures
include("./unit.jl")
include("./uncertainty.jl")
using .Uncertainty, .Units
export Measure, @meas, calculate

struct Measure
    val::UncertainNumber
    unit::Unit
end

function Base.show(io::IO, m::Measure)
    show(m.val); show(m.unit)
end

function Measure(x::Real, σ::Real, unit::Unit)
    return Measure(UncertainNumber(x, σ), unit)
end

#funciona, mas não entendo a gambi
#permitir variáveis nas outras 2 posições também
macro meas(x::Real, σ::Real, u::Symbol)
    return :(Measure(UncertainNumber($x, $σ), $(esc(u))))
end

#quero sobrecarregar essa função
import .Uncertainty: calculate
function calculate(f::Function, param_list::Vector{Measure})
    val = [p.val for p = param_list]
    u = [p.unit for p = param_list]

    retval = calculate(f, val)
    retu = f(u)
    return Measure(retval, retu)
end
end