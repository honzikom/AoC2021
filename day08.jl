cd("C:/Users/janbo/Documents/AoC/2021/day08")
using Pkg
using CSV
using DataFrames
using StatsBase

digits = CSV.read("./input/day8.txt",DataFrame, header = 0, delim = " | ")
digits = Matrix(digits)

# Part 1
smallDig = 0
for ind in 1:size(digits)[1]
    x = digits[ind,2]
    x = split(x," ")
    x = length.(x)
    smallDig += sum(in.(x, Ref([2 3 4 7])))
end

println("Solution od part 1: ", smallDig)

# Now the fun part

# function that returns frequencies of segments twice
# countX: in all 10 digits
# countY in the poorly recognizable 5 or 6 segment digits
getCounts = function(x)
    x = split(x," ")
    y = in.(length.(x), Ref([5 6]))
    y = x[y]

    x = split.(x, "")
    x = reduce(vcat, x)

    y = split.(y, "")
    y = reduce(vcat, y)

    countX = countmap(x)
    countY = countmap(y)
    return countX, countY
end

# this two frequencies are enough to decipher correct order
# it is hardcoded, but i coudn't think of anything smarter

decipherSegments = function(countX, countY)
    right_order = fill("x",7,1)
    for letter in ["a", "b", "c", "d", "e", "f", "g"]
        lX = countX[letter]
        lY = countY[letter]
        if lX == 8 && lY == 6
            right_order[1] = letter
        elseif lX == 6 && lY == 4
            right_order[2] = letter
        elseif lX == 8 && lY == 4
            right_order[3] = letter
        elseif lX == 7 && lY == 5
            right_order[4] = letter
        elseif lX == 4 && lY == 3
            right_order[5] = letter
        elseif lX == 9 && lY == 5
            right_order[6] = letter
        elseif lX == 7 && lY == 6
            right_order[7] = letter
        end
    end
    return right_order
end


# now that we know how does the true segmnt look-like, it is easy to recognize it
# again, hardcoded 7-segent numbers

decipherNumber = function(segments, x)
    x = split.(x, "")
    x = in.(segments, Ref(x))
    x = vec(x)
    if x == vec([1 1 1 0 1 1 1 ])
        return 0
    elseif x == vec([0 0 1 0 0 1 0])
        return 1
    elseif x == vec([1 0 1 1 1 0 1])
        return 2
    elseif x == vec([1 0 1 1 0 1 1])
        return 3
    elseif x == vec([0 1 1 1 0 1 0])
        return 4
    elseif x == vec([1 1 0 1 0 1 1])
        return 5
    elseif x == vec([1 1 0 1 1 1 1])
        return 6
    elseif x == vec([1 0 1 0 0 1 0])
        return 7
    elseif x == vec([1 1 1 1 1 1 1])
        return 8
    else
        return 9
    end
end

# with this arsenal, we can solve it!

digit4s = vec(fill(0, size(digits)[1], 1))

for ind in 1:size(digits)[1]
    x = digits[ind,1]
    cX, cY = getCounts(x)
    segments = decipherSegments(cX, cY)

    x = digits[ind, 2]
    x = split(x," ")
    for e in 1:4
        r = decipherNumber(segments, x[e])
        digit4s[ind] += 10^(4-e) * r
    end
end

println("Solution of part 2 is: ", sum(digit4s))
