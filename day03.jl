cd("/home/janbohm/Dokumenty/AoC/03")
using Pkg
using CSV
using DataFrames
using StatsBase

# Get the data
x = CSV.read("./input/day3.csv",DataFrame, header = 0; types = String)
x = Matrix(x)
x = vec(x)
x = collect.(x)
x = hcat(x...)



# Part 1

r = mode.(eachrow(x))
r = parse.(Int, r)
r = r .* (2 .^ reverse(0:11))
result = sum(r) * (2^12 - 1 - sum(r))
println("Solution of part 1: ", result)

# Part 2

ogr = 0
cO2sr = 0

y = parse.(Int, x)

for ind in 1:12
    m = modes(y[ind,:])
    if 1 in m
         m = 1
     else
         m = 0
     end
    y = y[:, y[ind,:] .== m]
    if size(y)[2] == 1
        ogr = y
        println(ogr)
        break
    end
end

y = parse.(Int, x)

for ind in 1:12
    m = modes(y[ind,:])
    m = setdiff([0,1], m)
    if isempty(m)
        m = 0
    end
    y = y[:, y[ind,:] .== m]
    if size(y)[2] == 1
        cO2sr = y
        println(cO2sr)
        break
    end
end

ogr = sum(ogr .* (2 .^ reverse(0:11)))
cO2sr = sum(cO2sr .* (2 .^ reverse(0:11)))

println("Solution of part 2 is: ", ogr*cO2sr)
