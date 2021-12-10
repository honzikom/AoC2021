cd("/home/janbohm/Dokumenty/AoC/10")
using Pkg
using CSV
using DataFrames

# Get input, the harderst part
x = read("./input/day10.csv", String)
x = split.(x, "\n")
x = split.(x, "")

y = x[3]

# check whether two brackets are pair
testPair = function(u,v)
    any([u == "(" && v == ")",
         u == "[" && v == "]",
         u == "{" && v == "}",
         u == "<" && v == ">"])
     end


# function to remove pair
oneCycle = function(y)
    drop = []
    for ind in 1:(length(y)-1)
        u = y[ind]
        v = y[ind + 1]
        if testPair(u,v)
            push!(drop,ind)
            push!(drop,ind+1)
        end
    end
    return deleteat!(y, drop)
end

# to avoid calling minimum over empty set
repairEmpty = function(a)
    if length(a) > 0
        return minimum(a)
    else
        return Inf
    end
end

# main function:
findMissing = function(y)
    while true
        # remove all possible pairs
        l = length(y)
        y = oneCycle(y)
        if l == length(y)
                # this is ugly way to find first right bracket
                a = findall(y .== ")")
                a = repairEmpty(a)
                b = findall(y .== "]")
                b = repairEmpty(b)
                c = findall(y .== "}")
                c = repairEmpty(c)
                d = findall(y .== ">")
                d = repairEmpty(d)

                m = minimum([a,b,c,d])
                # if there is one, return it
                if m < Inf
                    m = Int(m)
                    #println("Found ", y[m])
                    return y[m]
                else
                    # otherwise return Inf
                    return m
                end
                break
        end
    end
end

# Part 1

# simple cycle to compute total score, findMissing returns first unpaired right bracket
total = 0
for ind in 1:length(x)
    y = x[ind]
    m = findMissing(y)
    if m == ")"
        total += 3
    elseif m == "]"
        total += 57
    elseif m == "}"
        total += 1197
    elseif m == ">"
        total += 25137
    end
end

println("Solution of part 1, is, uh:  ", total)

# Part 2

# scoring function
# input is vector of remaining left brackets
score = function(y)
    total = 0
    while length(y) > 0
        # pair last bracket and score it
        u = last(y)
        total *= 5
        if u == "("
            total += 1
        elseif u == "["
            total += 2
        elseif u == "{"
            total += 3
        elseif u == "<"
            total += 4
        end
        # remove used bracket
        deleteat!(y, length(y))
    end
    return total
end


scores = []
# compute all scores
for ind in 1:length(x)
    y = x[ind]
    # this condition discards corrupted lines
    if typeof(findMissing(y)) !== SubString{String}
        while length(y) > length(oneCycle(y))
            y = oneCycle(y)
        end
        push!(scores, score(y))
    end
end

deleteat!(scores, length(scores)) # some problem with last line (empty) in input
sort!(scores)

println("Solution of part 2 is, ehm: ",scores[Int(length(scores)/2 + 0.5)])
