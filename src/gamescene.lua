local class = require "middleclass"
require "scene"
require "ces"

GameScene = class("GameScene", Scene)
function GameScene:initialize()
    print("Starting game scene")
    self.ces = ComponentEntitySystem:new()
    self.ces:addSystem()
end

function GameScene:update(dt)

end

function GameScene:draw()

end
