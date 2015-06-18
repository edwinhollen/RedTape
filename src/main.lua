require "gamescene"
require "entity"

local currentScene

function love.load()
    love.joystick.loadGamepadMappings("gamecontrollerdb.txt")
    currentScene = GameScene:new()
end

function love.update(dt)
    currentScene:update(dt)
end

function love.draw()
    currentScene:draw()
end