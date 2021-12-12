cd("C:/Users/janbo/Documents/AoC/2021/day12")
using Pkg
using CSV
using DataFrames
using StatsBase

X = CSV.read("./input/day12.txt",DataFrame,
             header = 0, types = String, delim = "-")
X = Matrix(X)


paths = []



fork = function(x)
    if x == 2
        return 2
    else
        return 1
    end
end


# here is function for main loop
step = function(paths, X)
    extPaths = []
    for i in 1:length(paths)
        x = paths[i]
        Y = X
        # remove all rows with used small caves
        if last(x) != "end"
            for j in 1:(length(x)-1)
                l = split(x[j], "")[1]
                if l == lowercase(l)
                    Y = Y[Y[:,1] .!= x[j], :]
                    Y = Y[Y[:,2] .!= x[j], :]
                end
            end

            inds = findall(Y .== last(x))
            for ii in 1:length(inds)
                ext = Y[inds[ii][1], fork(inds[ii][2] + 1)]
                push!(extPaths, push!(copy(x), ext))
            end
        else
            push!(extPaths, x)
        end
    end
    return(extPaths)
end

# start of part 1
# just begin before main loop
paths = []
inds = findall(X .== "start")
for i in 1:length(inds)
    l = X[inds[i][1], inds[i][2]]
    r = X[inds[i][1], fork(inds[i][2] + 1)]
    push!(paths, [l,r])
end


test = true
while test
    extPaths = step(paths, X)
    if length(extPaths) == length(paths)
        test = false
        println("")
        println("Part1: There are ", length(paths), " paths.")
    end
    paths = extPaths
end

m = maximum(length.(paths))

# here is function for main loop
step2 = function(paths, X)
    extPaths = []
    for i in 1:length(paths)
        x = paths[i]
        Y = X
        # remove all rows with used small caves
        if last(x) != "end"
            inds = findall(Y .== last(x))
            for ii in 1:length(inds)
                ext = Y[inds[ii][1], fork(inds[ii][2] + 1)]
                push!(extPaths, push!(copy(x), ext))
            end
        else
            push!(extPaths, x)
        end
    end
    return(extPaths)
end



isValidPath = function(x)
    x = x[x .!= "start"]
    x = x[x .!= "end"]
    x = x[lowercase.(x) .== x]
    
    c = []
    for l in unique(x)
        push!(c,count(x .== l))
    end
    if all(c .<= 2) && count(c .== 2) <= 1
        return true
    else
        return false
    end
end


X = CSV.read("./input/day12.txt",DataFrame,
             header = 0, types = String, delim = "-")
X = Matrix(X)

paths = []
inds = findall(X .== "start")
for i in 1:length(inds)
    l = X[inds[i][1], inds[i][2]]
    r = X[inds[i][1], fork(inds[i][2] + 1)]
    push!(paths, [l,r])
end


X = X[X[:,1].!= "start",:]
X = X[X[:,2].!= "start",:]



for i in 1:(m+1)
    println("")
    println(i)
    paths = step2(paths, X)
    paths = paths[isValidPath.(paths)]
end

# well, now we should have all solution in paths and many invalid ones
paths = paths[last.(paths) .== "end"]
v = isValidPath.(paths)
println("")
println("Part2: There are ", sum(v), " paths.")
