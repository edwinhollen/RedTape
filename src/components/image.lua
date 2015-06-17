local class = require "middleclass"

ImageComponent = class("ImageComponent")
function ImageComponent:initialize(imageName)
    self.imageName = imageName or nil
    self.rotation = 0
    self.scaleX = 1
    self.scaleY = 1
    self.offsetX = 0
    self.offsetY = 0
end