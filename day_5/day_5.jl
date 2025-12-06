intervals = Vector{UnitRange{Int}}()

function binary_search_intervals(intervals, left, right, searching)
    if left <= right
        middle = left + div(right - left, 2)
        mid_interval = intervals[middle]
        if searching < first(mid_interval)
            return binary_search_intervals(intervals, left, middle - 1, searching)
        elseif searching in mid_interval
            return true
        elseif searching > last(mid_interval)
            return binary_search_intervals(intervals, middle + 1, right, searching)
        end
    else
        return false
    end
end

count = 0
open("input.txt") do io
    local flag = true
    for line in eachline(io)
        if flag
            if !isempty(line)
                parts = split(line, "-")
                tmp = parse(Int, parts[1]):parse(Int, parts[2])
                push!(intervals, tmp)
            else
                global intervals
                sort!(intervals, by = first)
                merged = Vector{UnitRange{Int}}()
                if !isempty(intervals)
                    local tmp_interval = intervals[1]
					# merging intervals!
					for i in 2:length(intervals)
                        next_interval = intervals[i]
                        if first(next_interval) <= last(tmp_interval) + 1
                            tmp_interval = first(tmp_interval):max(last(tmp_interval), last(next_interval))
                        else
                            push!(merged, tmp_interval)
                            tmp_interval = next_interval
                        end
                    end
                    push!(merged, tmp_interval)
                    intervals = merged
                end
                flag = false
            end
        else
            value = parse(Int, line)
            if binary_search_intervals(intervals, 1, length(intervals), value)
                global count = count + 1
            end
        end
    end
end

println("Part 1: ", count)

count2 = 0
for inter in intervals
	global count2
	count2 = count2 + (last(inter) - first(inter) + 1)
end

println("Part 2: ", count2)