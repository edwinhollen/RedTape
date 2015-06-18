local class = require "middleclass"
require "system"
require "components/image"
require "components/position"

ImageSystem = class("ImageSystem", System)
function ImageSystem:initialize()
    System.initialize(self, {ImageComponent})
    self.loadedImages = {}
    self.renderWidth = 200
    self.renderHeight = 150
end
function ImageSystem:draw(entities)
    for entityKey, entity in ipairs(entities) do
        local pc = entity:getComponentsOfClass(PositionComponent)[1]
        local imgComponents = entity:getComponentsOfClass(ImageComponent)
        for ck, imgc in ipairs(imgComponents) do
            local baseScaleX = 1
            local baseScaleY = 1
            if imgc.autoscale then
                local windowWidth, windowHeight = love.graphics.getDimensions()
                baseScaleX = windowWidth / self.renderWidth
                baseScaleY = windowHeight / self.renderHeight
            end
            love.graphics.draw(
                imgc.image,
                math.floor(pc.x * baseScaleX + 0.5),
                math.floor(pc.y * baseScaleY + 0.5),
                imgc.rotation,
                baseScaleX * imgc.scaleX,
                baseScaleY * imgc.scaleY,
                math.floor(baseScaleX * imgc.offsetX),
                math.floor(baseScaleY * imgc.offsetY)
            )
        end
    end
end