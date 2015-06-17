local class = require "middleclass"

PositionComponent = class("PositionComponent")
function PositionComponent:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
end
