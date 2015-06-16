local class = require "middleclass"

System = class("System")
function System:initialize()
    self.accepts = {}
end
function System:update(dt, entities) end
function System:draw(entities) end