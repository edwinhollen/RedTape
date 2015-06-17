local class = require "middleclass"
require "system"
require "components/image"
require "components/position"

ImageSystem = class("ImageSystem", System)
function ImageSystem:initialize()
    self.accepts = {ImageComponent}
    self.loadedImages = {}
end
function ImageSystem:getImage(imageName)
    if not self.loadedImages[imageName] then
        self.loadedImages[imageName] = love.graphics.newImage(imageName)
    end
    return self.loadedImages[imageName]
end
function ImageSystem:draw(entities)
    for entityKey, entity in ipairs(entities) do
        local pc = entity:getComponentsOfClass(PositionComponent)[1]
        local imgComponents = entity:getComponentsOfClass(ImageComponent)
        for ck, imgc in ipairs(imgComponents) do
            love.graphics.draw(
                self:getImage(imgc.imageName),
                pc.x,
                pc.y,
                imgc.rotation,
                imgc.scaleX,
                imgc.scaleY,
                imgc.offsetX,
                imgc.offsetY
            )
        end
    end
end