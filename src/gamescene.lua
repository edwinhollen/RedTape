local class = require "middleclass"
require "scene"
require "ces"
require "entity"
require "systems/image"
require "systems/interactable"
require "components/image"
require "components/position"

GameScene = class("GameScene", Scene)
function GameScene:initialize()
    print("Starting game scene")
    self.ces = ComponentEntitySystem:new()
    self.interactableSystem = InteractableSystem:new()

    -- add systems
    self.ces:addSystem(ImageSystem:new())
    self.ces:addSystem(self.interactableSystem)

    self.ces:addEntity(Entity:new({
        PositionComponent:new(0, 0),
        ImageComponent:new(love.graphics.newImage("bg-green.png"))
    }))
    self.ces:addEntity(Entity:new({
        PositionComponent:new(0, 54),
        ImageComponent:new(love.graphics.newImage("woodtable.png"))
    }))
    self.ces:addEntity(Entity:new({
        PositionComponent:new(40, 65),
        ImageComponent:new(love.graphics.newImage("paper1.png")),
        InteractableComponent:new()
    }))
    self.ces:addEntity(Entity:new({
        PositionComponent:new(75, 61),
        ImageComponent:new(love.graphics.newImage("paper1.png")),
        InteractableComponent:new()
    }))

    local highlightedinteractable = InteractableComponent:new()
    highlightedinteractable.isHighlighted = true
    self.ces:addEntity(Entity:new({
        PositionComponent:new(120, 72),
        ImageComponent:new(love.graphics.newImage("paper1.png")),
        highlightedinteractable
    }))
end

function GameScene:update(dt)
    local btn_a = love.joystick.getJoysticks()[1]:isDown(1)
    local xAxis, yAxis = love.joystick.getJoysticks()[1]:getAxes()

    if math.floor(xAxis + 0.5) > 0 then
        print("going right")
        self.interactableSystem:requestRight()
    elseif math.floor(xAxis + 0.5) < 0 then
        print("going left")
        self.interactableSystem:requestLeft()
    end

    if math.floor(yAxis + 0.5) > 0 then
        print("giong down")
        self.interactableSystem:requestDown()
    elseif math.floor(yAxis + 0.5) < 0 then
        print("going up")
        self.interactableSystem:requestUp()
    end

    for key, entry in ipairs(self.ces:sort()) do
        entry["system"]:update(dt, entry["entities"])
    end
end

function GameScene:draw()
    for key, entry in ipairs(self.ces:sort()) do
        entry["system"]:draw(entry["entities"])
    end
end
