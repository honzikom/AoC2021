cd("/home/janbohm/Dokumenty/AoC/03")
using Pkg
using CSV
using DataFrames
using StatsBase

# Get the data
x = CSV.read("./input/day3.csv",DataFrame, header = 0; types = String)
x = Matrix(x) # convert to matrix
x = vec(x) # than to vector
x = collect.(x) # split strings
x = hcat(x...) # and finally, there is 12x1000 matrix 



# Part 1

r = mode.(eachrow(x)) # compute rowvise mode
r = parse.(Int, r) # change from string to Int
r = r .* (2 .^ reverse(0:11)) # and from binary to decimal
result = sum(r) * (2^12 - 1 - sum(r)) # since the other number has XOR bits, sum of them is 2^12

println("Solution of part 1: ", result)

# Part 2

ogr = 0
cO2sr = 0

y = parse.(Int, x)


for ind in 1:12 # for each bit
    m = modes(y[ind,:]) #find modes, there can be two
    if 1 in m # if 1 is one of the modes, take m=1, otherwise m=0
         m = 1
     else
         m = 0
     end
    y = y[:, y[ind,:] .== m] #keep only columns with m in current bit
    if size(y)[2] == 1 # check if only one number is left
        ogr = y
        println(ogr)
        break
    end
end

y = parse.(Int, x)

# this works pretty much the same, just setdiff changes most abundant to least abundant
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
