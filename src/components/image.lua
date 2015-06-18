local class = require "middleclass"

ImageComponent = class("ImageComponent")
function ImageComponent:initialize(image, autoscale)
    self.image = image or nil
    self.autoscale = autoscale or true
    self.rotation = 0
    self.scaleX = 1
    self.scaleY = 1
    self.offsetX = 0
    self.offsetY = 0
end