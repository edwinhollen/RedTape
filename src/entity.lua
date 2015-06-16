local class = require "middleclass"
local md5 = require "md5"

Entity = class("Entity")
function Entity:initialize()
    self.id = md5.sumhexa(tostring(love.timer.getTime()))
end
