module Units

export Unit

#sobrecarga de get/setIndex, print/display
struct Unit
    composition::Dict{String, Int64}
end

function Unit(str::String)
    return Unit(Dict(str => 1))
end

function Base.show(io::IO, u::Unit)
    ordered_composition = [key for key = keys(u.composition)]
    sort!(ordered_composition, by=(key->u.composition[key]), rev=true)
    for (i, key) = enumerate(ordered_composition)
        print(key)  #funciona no console do Julia, mas não em geral.
                    #O problema é que show(key) coloca aspas na unidade.
        if abs(u.composition[key]) != 1
            show(abs(u.composition[key]))
        end
        #próximo elemento < 0 => colocar /
        if i < length(ordered_composition) && 
                u.composition[ordered_composition[i+1]] < 0
            show(/)
        end
    end
end

function Base.:*(u1::Unit, u2::Unit)
    k1 = keys(u1.composition)
    k2 = keys(u2.composition)

    u = union(k1,k2)
    dict = Dict{String, Int64}()

    for key = u
        val = (key in k1 ? u1.composition[key] : 0) + (key in k2 ? u2.composition[key] : 0)
        if val != 0
            dict[key] = val
        end
    end
    return Unit(dict)        
end

function Base.:/(u1::Unit, u2::Unit)
    k1 = keys(u1.composition)
    k2 = keys(u2.composition)

    u = union(k1,k2)
    dict = Dict{String, Int64}()

    for key = u
        val = (key in k1 ? u1.composition[key] : 0) - (key in k2 ? u2.composition[key] : 0)
        if val != 0
            dict[key] = val
        end
    end
    return Unit(dict)        
end

function Base.:+(u1::Unit, u2::Unit)
    if u1 != u2
        error("Não é possível somar pepinos com abacaxis!")
    end
    return u1
end

function Base.:-(u1::Unit, u2::Unit)
    if u1 != u2
        error("Não é possível subtrair pepinos de abacaxis!")
    end
    return u1
end

function Base.:^(u::Unit, α::Real)
    ret = Unit(Dict())
    for key = keys(u.composition)
        #se o resultado não for inteiro, levanta um erro automaticamente
        #implementar unidades racionais?
        ret.composition[key] = Int64(u.composition[key] * α)
    end
    return ret
end

function Base.sqrt(u::Unit)
    return Unit(Dict(
        key =>Int64(u.composition[key]/2) 
        for key = keys(u.composition)))    
end
end

module SI
using ..Units
m   = Unit("m")     #metro
s   = Unit("s")     #segundo
kg  = Unit("kg")    #quilograma
mol = Unit("mol")   #mol
K   = Unit("K")     #kelvin
cd  = Unit("cd")    #candela
A   = Unit("A")     #ampere
end

