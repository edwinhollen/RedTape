require "gamescene"
require "entity"

local currentScene

function love.load()
    currentScene = GameScene:new()
end

function love.update(dt)
    currentScene:update(dt)
end

function love.draw()
    currentScene:draw()
end