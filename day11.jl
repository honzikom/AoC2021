cd("C:/Users/janbo/Documents/AoC/2021/day11")
using Pkg
using CSV
using DataFrames

x = CSV.read("./input/day11.txt",DataFrame, header = 0, types = String)
#x = CSV.read("./input/day11.txt",DataFrame, header = 0, types = String)
x = Matrix(x)
x = split.(x, "")
x = reduce(hcat, x)
x = parse.(Int, x)

# crerate an envelope of 9s around so we do not have to think about corners
# and use simple indexing. -oo is inert to addition
X = fill(-Inf, size(x)[1] + 2, size(x)[2] + 2)
X[2:(size(x)[1]+1) , 2:(size(x)[1]+1)] = x

# Part 1

step = function(X)
    flashes = 0
    X .+= 1
    #as long as there are any ocotpussies to flash:
    while any(X .> 9)
        flashes += 1 # it flashes!
        oct = findall(X .> 9)[1] # take one of them
        # add 1 to its 8 neighbours and change its vlaue to -Inf to avoid repeating flashes
        X[oct[1]-1 : oct[1]+1, oct[2]-1 : oct[2]+1] .+= 1
        X[oct[1], oct[2]] = -Inf
    end
    # after flashing is done, replace -Infs octopussies to zero
    Y = X[2:(size(x)[1]+1) , 2:(size(x)[1]+1)]
    Y[Y .== -Inf] .= 0
    X[2:(size(x)[1]+1) , 2:(size(x)[1]+1)] = Y

    return X, flashes
end

flashes = 0
for i in 1:100
    newX, f = step(X)
    X = newX
    flashes += f
end
println("")
println("Solution of part 1 is: ", flashes, " [flashes of octopussies].")

# Part 2
# the IMPORTANT part is to reset X to input state
X[2:(size(x)[1]+1) , 2:(size(x)[1]+1)] = x
f = 0
counter = 0
while f < 100
    counter += 1
    newX, f = step(X)
    X = newX
    if f==100
        println("Solution of part 2 is: They synchronized at step ", counter)
    end
end
