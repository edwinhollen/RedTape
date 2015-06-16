local class = require "middleclass"
require "system"

ImageSystem = class("ImageSystem", System)
function ImageSystem:initialize()
    self.accepts = {}
end