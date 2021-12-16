cd("C:/Users/janbo/Documents/AoC/2021/day15")
using Pkg
using CSV
using DataFrames

x = CSV.read("./input/day15small.txt",DataFrame, header = 0, types = String)
#x = CSV.read("./input/day11.txt",DataFrame, header = 0, types = String)
x = Matrix(x)
x = split.(x, "")
x = reduce(hcat, x)
X = parse.(Int, x)

neighbours = function(pos, grid)

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
    while any(.!master.visited)
        #find minimal distance that has not been visited yet
        m = minimum(master.dist[.! master.vis])
        # find its row index
        ind = findfirst(.!master.vis .&& master.dist .== m)
        n = neighbours(master.loc[ind])


    end
end
