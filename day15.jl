cd("C:/Users/janbo/Documents/AoC/2021/day15")
using Pkg
using CSV
using DataFrames

x = CSV.read("./input/day15.txt",DataFrame, header = 0, types = String)
#x = CSV.read("./input/day11.txt",DataFrame, header = 0, types = String)
x = Matrix(x)
x = split.(x, "")
x = reduce(hcat, x)
X = parse.(Int, x)

neighbours = function(pos, grid)
    n = []
    x = []
    y = []
    if pos[1]-1 >= 1
        push!(x, pos[1]-1)
    end
    if pos[1]+1 <= size(grid)[1]
        push!(x, pos[1]+1)
    end
    if pos[2]-1 >= 1
        push!(y, pos[2]-1)
    end
    if pos[2]+1 <= size(grid)[2]
        push!(y, pos[2]+1)
    end
    for xx in x
        push!(n, [xx, pos[2]])
    end
    for yy in y
        push!(n, [pos[1], yy])
    end
    return n
end




Dijkstra = function(X)
    # init part
    loc = []
    for i in 1:size(X)[1]
        for j in 1:size(X)[2]
            push!(loc, [i,j])
        end
    end

    visited = fill(false, size(X)[1] * size(X)[2])
    dist = fill(Inf, size(X)[1] * size(X)[2])
    prev = fill([],size(X)[1] * size(X)[2])

    master = DataFrame()
    master.loc = loc
    master.vis = visited
    master.dist = dist
    master.prev = prev

    master.dist[master.loc .== [[1,1]] ] .= 0
    master.prev[master.loc .== [[1,1]] ] .= [[missing, missing]]
    # start
    while any(.!master.vis)
        println(sum(master.vis) / size(X)[1] / size(X)[2])
        #find minimal distance that has not been visited yet
        m = minimum(master.dist[.! master.vis])
        # find its row index
        ind = findfirst(.!master.vis .&& master.dist .== m)
        neigh = neighbours(master.loc[ind], X)
        for n in neigh
            jnd = findfirst(master.loc .== [n])
            if !master.vis[jnd]
                if master.dist[jnd] > master.dist[ind] + X[n[1],n[2]]
                    master.dist[jnd] = master.dist[ind] + X[n[1],n[2]]
                end
            end
            master.prev[jnd] = master.loc[ind]
        end
        master.vis[ind] = true
    end
    return master
end

res = Dijkstra(X)
println()
println(res[size(res)[1],:])
# part 2

Y = hcat(X, X.+1, X.+2, X.+3, X.+4 )
Y = vcat(Y, Y.+1, Y.+2, Y.+3, Y.+4 )
Y[Y.>9] .= Y[Y.>9].-9


res2 = Dijkstra(Y)
println(res2[size(res2)[1],:])
