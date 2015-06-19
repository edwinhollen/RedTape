local class = require "middleclass"
require "system"
require "util"
require "components/interactable"
require "components/position"
require "components/image"

InteractableSystem = class("InteractableComponent", System)
function InteractableSystem:initialize()
    System.initialize(self, {InteractableComponent, PositionComponent, ImageComponent})
    self.highlightWidth = 4
    self.highlightStyle = "rough"
    self.requesting = nil
end
function InteractableSystem:request(direction)
    self.requesting = direction
end
function InteractableSystem:update(dt, entities)
    if self.requesting then
        local highlightedEntity
        -- get highlighted entity
        for key, entity in ipairs(entities) do
            local intc = entity:getComponentsOfClass(InteractableComponent)[1]
            if intc.isHighlighted then
                highlightedEntity = entity
                break
            end
        end

        -- collect entities distances
        local entitiesDistances = {}
        for key, entity in ipairs(entities) do
            if entity ~= highlightedEntity then
                local distance = math.distance(
                    highlightedEntity:getComponentsOfClass(PositionComponent)[1].x,
                    highlightedEntity:getComponentsOfClass(PositionComponent)[1].y,
                    entity:getComponentsOfClass(PositionComponent)[1].x,
                    entity:getComponentsOfClass(PositionComponent)[1].y
                )
                local r = {}
                r["entity"] = entity
                r["distance"] = distance
                table.insert(entitiesDistances, r)
            end
        end

        -- order entities by distance
        local orderedEntities = {}
        local count = table.getn(entitiesDistances)
        while table.getn(orderedEntities) < count do
            local smallestEntryKey
            for key, entry in ipairs(entitiesDistances) do
                if smallestEntryKey == nil or entry["distance"] < entitiesDistances[smallestEntryKey]["distance"] then
                    smallestEntryKey = key
                end
            end
            table.insert(orderedEntities, entitiesDistances[smallestEntryKey]["entity"])
            table.remove(entitiesDistances, smallestEntryKey)
        end

        -- find entity in the requested direction

        local matchingEntity
        for key, entity in ipairs(orderedEntities) do
            local eX = entity:getComponentsOfClass(PositionComponent)[1].x
            local eY = entity:getComponentsOfClass(PositionComponent)[1].y

            if (self.requesting == "up" and eY < highlightedEntity:getComponentsOfClass(PositionComponent)[1].y)
                or (self.requesting == "down" and eY > highlightedEntity:getComponentsOfClass(PositionComponent)[1].y)
                or (self.requesting == "left" and eX < highlightedEntity:getComponentsOfClass(PositionComponent)[1].x)
                or (self.requesting == "right" and eX > highlightedEntity:getComponentsOfClass(PositionComponent)[1].x)
            then
                matchingEntity = entity
                break
            end
        end

        if matchingEntity == nil then
            matchingEntity = orderedEntities[table.getn(orderedEntities)]
        end




        -- unset current highlighted entity
        -- set new highlighted entity
        highlightedEntity:getComponentsOfClass(InteractableComponent)[1].isHighlighted = false
        matchingEntity:getComponentsOfClass(InteractableComponent)[1].isHighlighted = true

        -- unset requesting
        self.requesting = nil
    end
end
function InteractableSystem:draw(entities)

    local windowWidth, windowHeight = love.graphics.getDimensions()
    local baseScaleX = windowWidth / 200
    local baseScaleY = windowHeight / 150

    for key, entity in ipairs(entities) do
        local intc = entity:getComponentsOfClass(InteractableComponent)[1]
        local pc = entity:getComponentsOfClass(PositionComponent)[1]
        local imgc = entity:getComponentsOfClass(ImageComponent)[1]
        if intc.isHighlighted then
            local verts = {
                math.floor(pc.x*baseScaleX+0.5), math.floor(pc.y*baseScaleY+0.5),
                math.floor((pc.x*baseScaleX+imgc.image:getWidth()*baseScaleX)+0.5), math.floor(pc.y*baseScaleY+0.5),
                math.floor((pc.x*baseScaleX+imgc.image:getWidth()*baseScaleX)+0.5), math.floor((pc.y*baseScaleY+imgc.image:getHeight()*baseScaleY)+0.5),
                math.floor(pc.x*baseScaleX+0.5), math.floor((pc.y*baseScaleY+imgc.image:getHeight()*baseScaleY)+0.5)
            }
            love.graphics.setLineWidth(self.highlightWidth)
            love.graphics.setLineStyle(self.highlightStyle)
            love.graphics.setColor(0, 50, 255)
            love.graphics.polygon("line", verts)
            love.graphics.setColor(255, 255, 255)
        end
    end
end