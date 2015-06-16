local class = require "middleclass"
local md5 = require "md5"

Entity = class("Entity")
function Entity:initialize(components)
    self.id = md5.sumhexa(tostring(love.timer.getTime()))
    self.components = components or {}
end
function Entity:addComponent(component)
    table.insert(self.components, component)
end
function Entity:hasComponentOfClass(componentClass)
    for key,component in ipairs(self.components) do
        if component:isInstanceOf(componentClass) then
            return true
        end
    end
    return false
end
