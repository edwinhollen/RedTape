local class = require "middleclass"
require "util"
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
    self.lastInteraction = love.timer.getTime()

    -- add systems
    self.ces:addSystem(ImageSystem:new())
    self.ces:addSystem(self.interactableSystem)

    -- add entities
    self.paperHolderTop = Entity:new({
        PositionComponent:new(40, 60),
        ImageComponent:new(love.graphics.newImage("paperholdertop.png"))
    })

    self.paperHolderBottom = Entity:new({
        PositionComponent:new(40, 60),
        ImageComponent:new(love.graphics.newImage("paperholderbottom.png"))
    })
    self.ces:addEntity(Entity:new({
        PositionComponent:new(0, 0),
        ImageComponent:new(love.graphics.newImage("bg-green.png"))
    }))
    self.ces:addEntity(Entity:new({
        PositionComponent:new(0, 54),
        ImageComponent:new(love.graphics.newImage("woodtable.png"))
    }))
    self.ces:addEntity(self.paperHolderTop)
    self.ces:addEntity(self.paperHolderBottom)
end

function GameScene:update(dt)
    local btn_a = love.joystick.getJoysticks()[1]:isDown(1)
    local xAxis, yAxis = love.joystick.getJoysticks()[1]:getAxes()
    local interactCooldown = 0.25
    local canInteract = (love.timer.getTime() > self.lastInteraction + interactCooldown)

    if (math.round(xAxis) ~= 0 or math.round(yAxis) ~= 0) and canInteract then
        local direction
        if math.round(xAxis) < 0 then direction = "left" end
        if math.round(xAxis) > 0 then direction = "right" end
        if math.round(yAxis) < 0 then direction = "up" end
        if math.round(yAxis) > 0 then direction = "down" end

        if direction then
            self.interactableSystem:request(direction)
            self.lastInteraction = love.timer.getTime()
        end

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
