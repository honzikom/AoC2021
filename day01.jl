cd("/home/janbohm/Dokumenty/AoC/01")
using Pkg
using CSV
using DataFrames

x = CSV.read("./input/day1.csv",DataFrame, header = 0)
x = Matrix(x)
x = vec(x)

# Star 1

println("Number of increaces:", sum(diff(x) .> 0))

# Star 2

a = x[1:length(x)-2]
b = x[2:length(x)-1]
c = x[3:length(x)]

y = a+b+c
println("Number of increaces:", sum(diff(y) .> 0))
