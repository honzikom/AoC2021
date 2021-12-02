cd("/home/janbohm/Dokumenty/AoC/02")
using Pkg
using CSV
using DataFrames

x = CSV.read("./input/day2.csv",DataFrame, header = 0)
rename!(x, ["Direction", "Value"])

# Part 1

horizontal = sum(x.Value[x.Direction .== "forward"])
depth = sum(x.Value[x.Direction .== "down"]) - sum(x.Value[x.Direction .== "up"])

println("The result is: ", horizontal * depth)

# Part 2

h = 0
d = 0
a = 0

x = Matrix(x)
for ind in 1:(size(x)[1])
    if x[ind,1] == "forward"
        h += x[ind,2]
        d += a*x[ind,2]
    elseif x[ind,1] == "down"
        a += x[ind,2]
    elseif x[ind,1] == "up"
        a -= x[ind,2]
    end
end

println("The result is: ", h * d)
