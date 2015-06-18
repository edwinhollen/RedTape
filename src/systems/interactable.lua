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
    self.requestingUp = false
    self.requestingDown = false
    self.requestingLeft = false
    self.requestingRight = false
end
function InteractableSystem:requestUp()
    self.requestingUp = true
end
function InteractableSystem:requestDown()
    self.requestingDown = true
end
function InteractableSystem:requestLeft()
    self.requestingLeft = true
end
function InteractableSystem:requestRight()
    self.requestingRight = true
end
function InteractableSystem:update(dt, entities)
    if self.requestingUp or self.requestingDown or self.requestingLeft or self.requestingRight then
        local highlightedEntity = entities[1]
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
                if smallestEntryKey == nil or entry["distance"] < entitiesDistances[key]["distance"] then
                    smallestEntryKey = key
                end
            end
            table.insert(orderedEntities, entitiesDistances[smallestEntryKey]["entity"])
            table.remove(entitiesDistances, smallestEntryKey)
        end

        for k,v in ipairs(orderedEntities) do
            print(k, v.id)
        end

        -- find entity in the requested direction
        local matchingEntity
        for key, entity in ipairs(orderedEntities) do
            local eX = entity:getComponentsOfClass(PositionComponent)[1].x
            local eY = entity:getComponentsOfClass(PositionComponent)[1].y

            if (self.requestingUp and eY < highlightedEntity:getComponentsOfClass(PositionComponent)[1].y)
                or (self.requestingDown and eY > highlightedEntity:getComponentsOfClass(PositionComponent)[1].y)
                or (self.requestingLeft and eX < highlightedEntity:getComponentsOfClass(PositionComponent)[1].x)
                or (self.requestingRight and eX > highlightedEntity:getComponentsOfClass(PositionComponent)[1].x)
            then
                matchingEntity = entity
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
        self.requestingUp = false
        self.requestingDown = false
        self.requestingLeft = false
        self.requestingRight = false
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

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(entity.id, pc.x*baseScaleX+1, pc.y*baseScaleY+1)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(entity.id, pc.x*baseScaleX, pc.y*baseScaleY)
    end
end