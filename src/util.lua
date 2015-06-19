function math.distance(x1, y1, x2, y2)
    return math.sqrt(math.pow(x2 - x1, 2) + math.pow((y2 - y1), 2))
end

function math.round(n)
    return math.floor(n + 0.5)
end