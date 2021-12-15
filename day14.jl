cd("C:/Users/janbo/Documents/AoC/2021/day14")
using Pkg
using CSV
using DataFrames
using StatsBase


# get data in tow parts:
# o temaplate with starting sequence
# o and set of rules to polymerize
template = CSV.read("./input/day14.txt",DataFrame,
             header = 0, limit = 1, types = String)
template = Matrix(template)[1,1]
template = split(template, "")

rules = CSV.read("./input/day14.txt",DataFrame,
             header = 1, types = String, delim = " -> ")
rules = Matrix(rules)

# implemented function to polymerize
polymerize = function(old, rules)
    new = [String(old[1])]
    for ind in 1:length(old)-1
        x = join(old[ind:ind+1])
        pos = findall(rules[:,1] .== x)
        push!(new, rules[pos, 2][1])
        push!(new, old[ind+1])
    end
    return new
end

#part 1

# just take template and 10x polymerize
old = template
for i in 1:10
    println("\n", i,)
    old = polymerize(old, rules)
end

# and count frequencies of result
c=[]
for l in unique(old)
    push!(c,count(old .== l))
end

println("\n Part1: ", maximum(c) - minimum(c), "\n")

# Part 2

# This is more tricky, run polymerize 40x is impossible for my lamptop and lifetime
# So, we will devide problem in half
# For each possible bigram (e.g. "AC") compute 20 steps and count resulting frequencies
# Then run polymerize with template 20 times, and for each bigram count letters
# each letter in sequence after 20 polymerizations (excep for first and last)
# is in this final count twice, so substract them
 
letters = sort(unique(rules[:,2]))
halfThere = fill(0, length(letters)^2, length(letters))
bigrams = fill("NA", length(letters)^2, 1)
row = 0
for k in 1:length(letters)
    for l in 1:length(letters)
        row += 1
        temp = join([letters[k],letters[l]])
        println(temp)
        bigrams[row] = temp
        old = [letters[k],letters[l]]
        for i in 1:20
            old = polymerize(old, rules)
        end

        for m in 1:length(letters)
            halfThere[row,m] = count(old .== letters[m])
        end
    end
end

old = template
for i in 1:20
    println("\n", i,)
    old = polymerize(old, rules)
end

counts = fill(0, length(letters))
for i in 1:length(old)-1
    a = old[i]
    b = old[i+1]
    r = findall(bigrams .== join([a,b]))
    counts .+= halfThere[r[1][1],:]
end

extras = fill(0, length(letters))
for i in 1:length(letters)
    extras[i] = count(old[2:length(old)-1] .== letters[i])
end

final = counts .- extras
println("\n Part2: ", maximum(final) - minimum(final), "\n")
