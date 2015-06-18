local class = require "middleclass"

System = class("System")
function System:initialize(accepts)
    self.accepts = accepts or {}
end
function System:update(dt, entities) end
function System:draw(entities) end