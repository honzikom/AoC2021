cd("/home/janbohm/Dokumenty/AoC/09")
using Pkg
using CSV
using DataFrames

# Get input, the harderst part
x = CSV.read("./input/day9.csv",DataFrame, header = 0, types = String)
x = Matrix(x)
x = split.(x, "")
x = reduce(hcat, x)
x = parse.(Int, x)

# crerate an envelope of 9s around so we do not have to think about corners
X = fill(9, size(x)[1] + 2, size(x)[2] + 2)
X[2:101, 2:101] = x

# Part 1
lowpoints = []
for i in 2:101
    for j in 2:101
        neigh = [X[i-1,j] X[i+1,j] X[i, j-1] X[i, j+1]]
        if all(X[i,j] .< neigh)
            push!(lowpoints, X[i,j])
        end
    end
end

println("Solution of part 1: ", sum(lowpoints .+= 1))

# Part 2

# just look for closed areas:
X = X .< 9

# ugly trick to change Boolean to Int:
X = X .+ 1
X = X .- 1

# function finds basins from starting point x,y in X
findBasin = function(x, y, X)
    inside = [[x,y]] # start is inside
    adepts = [[x-1, y], [x+1, y], [x, y+1], [x, y-1]] # neighbours can be inside
    outside =[] # outside is empty

    # iterate over adepts and check if is aso inside
    # if so, add neighbours to adepts and move this adept to inside
    # if not, it is outside
    while length(adepts) > 1
        x = adepts[1][1]
        y = adepts[1][2]
        connection = X[x,y] == 1
        if connection
            push!(inside, [x, y])
            push!(adepts, [x-1, y], [x+1, y], [x, y+1], [x, y-1] )
            unique!(adepts)
        else
            push!(outside, [x,y])
        end
        #you can get adept that is already inside/outside
        setdiff!(adepts, inside)
        setdiff!(adepts, outside)
    end
    return inside
end

# now, let's do it
basins = []
# we will be numbering new basins, because why not, starting with 2
counter = 1
# find some point inside basin (labeled 1), find its basin,
# add it to basins and label its inside in X with different number
while any(X .== 1)
    start = findall(X .== 1)[1]
    b = findBasin(start[1], start[2], X)
    push!(basins, b)
    for i in 1:length(b)
        X[b[i][1],b[i][2]] += counter
    end
    counter += 1
end

# now compute their sizes and sort them
sizesOfBasins = length.(basins)
sort!(sizesOfBasins, rev = true)

println("Solution of part 2 is: ",sizesOfBasins[1] * sizesOfBasins[2] * sizesOfBasins[3])

# Some extra visualization
using ImageView
imshow(X)
