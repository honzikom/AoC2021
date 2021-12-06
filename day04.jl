cd("C:/Users/janbo/Documents/AoC/2021/day04")
using Pkg
using CSV
using DataFrames

# Read vector of draws
draws = CSV.read("./input/day4.txt",DataFrame, header = 0, limit = 1)
draws = vec(Matrix(draws))

# Read matrices
M = CSV.read("./input/day4.txt",DataFrame, header = 1, delim = " ", ignorerepeated = true)
M = Matrix(M)

# create array of those
bingo = []
for ind in 1:100
    push!(bingo, M[(ind-1)*5+1 : ind*5, :])
end

# Strategy is to change drawn values to negative onesin bingos
# and than search for rows/cols that are all negative

# Function to check if all values in vector all negative
function allNeg(x)
    all(x .< 0)
end

#Function to  check if any row/column is all negative
function isWin(M)
    r = any(allNeg.(eachrow(M)))
    c = any(allNeg.(eachcol(M)))
    r + c > 0
end

# Part 1
winner = missing
drawn = missing
found = false
d = 0

while !found # as long as we haven't found winner
    d += 1
    for ind = 1:100 # in each bingo replace drawn value with negative
        M = bingo[ind]
        M[M.==draws[d]] = -M[M.==draws[d]]
        bingo[ind] = M
        if isWin(M) # check if we have winner, if so keep it, last drawn value and chagen while condition
            winner = M
            drawn = draws[d]
            found = true
            break
        end
    end
end

println(winner)
# The negative drawn values make simple to filter undrown ones in final scoring
println("Solution of part one is: ",sum(winner .* (winner .> 0)) * drawn)

# Part 2
d = 0
drops = []
looser = missing
drawn = missing

# while there is some bingo left
while length(bingo) > 0
     d += 1
     drops = [] # empty vec of indices of bingos to be dropped
     for ind = 1:length(bingo) # turn drawn values ngative
         M = bingo[ind]
         M[M.==draws[d]] = -M[M.==draws[d]]
         bingo[ind] = M
         if isWin(M) #if bingo wins, add its index to drops
             push!(drops, ind)
         end
     end

     deleteat!(bingo, drops) # delete all bingos that won this round

     if length(bingo) == 1 && ismissing(looser) # if there is only one left, it's the looser!
         looser = copy(bingo[1]) # this is different than looser = bingo[1], cuz Julia
     end

     if length(bingo) == 0 # if there is none left, this is the last drawn value
         drawn = draws[d]
     end

 end

# replace the final drawn value
looser[looser.==drawn] = - looser[looser.==drawn]
println(looser)

println("Solution of part one is: ", sum(looser .* (looser .> 0)) * drawn)
