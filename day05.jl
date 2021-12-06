cd("C:/Users/janbo/Documents/AoC/2021/day05")
using Pkg
using CSV
using DataFrames

coord = CSV.read("./input/day5.txt",DataFrame, header = 0, delim = ",")
mid = Matrix(reduce(hcat,split.(coord[:,2], " -> ")))
mid = parse.(Int, mid)
mid = transpose(mid)
coord = [coord[:,1] mid[:,1] mid[:,2] coord[:,3]]

# Part 1
#minimum(coord)
#maximum(coord)

Grid = zeros(1000,1000)
for ind in 1:size(coord)[1]
    if coord[ind,1] == coord[ind,3]
        m = minimum([coord[ind,2] coord[ind,4]])
        M = maximum([coord[ind,2] coord[ind,4]])
        Grid[coord[ind,1], m:M] .+= 1
    elseif coord[ind,2] == coord[ind,4]
        m = minimum([coord[ind,1] coord[ind,3]])
        M = maximum([coord[ind,1] coord[ind,3]])
        Grid[m:M, coord[ind,2]] .+= 1
    end
end

println("Answer to part 1: ", sum(Grid .>= 2))

#Part 2

Grid = zeros(1000,1000)
for ind in 1:size(coord)[1]
    if coord[ind,1] == coord[ind,3]
        m = minimum([coord[ind,2] coord[ind,4]])
        M = maximum([coord[ind,2] coord[ind,4]])
        Grid[coord[ind,1], m:M] .+= 1
    elseif coord[ind,2] == coord[ind,4]
        m = minimum([coord[ind,1] coord[ind,3]])
        M = maximum([coord[ind,1] coord[ind,3]])
        Grid[m:M, coord[ind,2]] .+= 1
    elseif abs(coord[ind,1]-coord[ind,3]) == abs(coord[ind,2]-coord[ind,4])
        if coord[ind,1] < coord[ind,3]
            seq1 = [coord[ind,1] : 1 : coord[ind,3]; ]
        else
            seq1 = [coord[ind,1] : -1 : coord[ind,3]; ]
        end
        if coord[ind,2] < coord[ind,4]
            seq2 = [coord[ind,2] : 1 : coord[ind,4]; ]
        else
            seq2 = [coord[ind,2] : -1 : coord[ind,4]; ]
        end
        for s in 1:length(seq1)
            Grid[seq1[s], seq2[s]] += 1
        end
    end
end

println("Answer to part 2: ", sum(Grid .>= 2))
