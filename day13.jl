cd("C:/Users/janbo/Documents/AoC/2021/day13")
using Pkg
using CSV
using DataFrames
using StatsBase

X = CSV.read("./input/day13.txt",DataFrame,
             header = 0, types = String, delim = ",")
instructions = X[ismissing.(X[:,2]),1]
dots = X[.!(ismissing.(X[:,2])),:]
dots = parse.(Int, dots)
dots = Matrix(dots)
dots .+= 1

# build the matrix
maxX = maximum(dots[:,1])
maxY = maximum(dots[:,2])
paper = fill(false, maxY, maxX)

for ind in 1:size(dots)[1]
    paper[dots[ind,2], dots[ind,1]] = true
end

fold = function(paper, direction, place)
    if direction == "y"
        for y in 1:(size(paper)[1] - place)
            paper[place-y,:] = paper[place-y,:] .|| paper[place+y,:]
        end
        return paper[1:(place-1),:]
    elseif direction == "x"
        for x in 1:(size(paper)[2] - place)
            paper[:,place-x] = paper[:,place-x] .|| paper[:,place+x]
        end
        return paper[:, 1:(place-1)]
    end
end

parseInstructions = function(x)
    x = split(x, " ")
    direction = x[3][1]
    place = x[3][3:length(x[3])]
    place = parse(Int,join(place)) + 1
    return string(direction), place
end


# Part 1
d, p = parseInstructions(instructions[1])
paper = fold(paper, d, p)
println("")
println("\n Part1: ",sum(paper), "\n")

# Part 2
for ind in 2:length(instructions)
    d, p = parseInstructions(instructions[ind])
    paper = fold(paper, d, p)
end

# look into console
