local class = require "middleclass"
require "scene"
require "ces"
require "systems/image"
require "entity"
require "components/image"
require "components/position"

GameScene = class("GameScene", Scene)
function GameScene:initialize()
    print("Starting game scene")
    self.ces = ComponentEntitySystem:new()
    self.ces:addSystem(ImageSystem:new())
    self.ces:addEntity(Entity:new({
        PositionComponent:new(20, 20),
        ImageComponent:new("test.png")
    }))
end

function GameScene:update(dt)
    for key, entry in ipairs(self.ces:sort()) do
        entry["system"]:update(dt, entry["entities"])
    end
end

function GameScene:draw()
    for key, entry in ipairs(self.ces:sort()) do
        entry["system"]:draw(entry["entities"])
    end
end
