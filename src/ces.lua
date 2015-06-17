local class = require "middleclass"

ComponentEntitySystem = class("ComponentEntitySystem")
function ComponentEntitySystem:initialize(systems, entities)
    self.systems = systems or {}
    self.entities = entities or {}
end
function ComponentEntitySystem:addEntity(entity)
    table.insert(self.entities, entity)
end
function ComponentEntitySystem:removeEntity(entity)
    table.remove(self.entities, entity)
end
function ComponentEntitySystem:addSystem(system)
    table.insert(self.systems, system)
end
function ComponentEntitySystem:removeSystem(system)
    table.remove(self.systems, system)
end
function ComponentEntitySystem:sort()
    local sorted = {}
    for key, system in ipairs(self.systems) do
        local returnObj = {}
        returnObj["system"] = system
        returnObj["entities"] = {}
        for entityKey, entity in ipairs(self.entities) do
            local match = true
            for componentClassKey, componentClass in ipairs(system.accepts) do
                if not entity:hasComponentOfClass(componentClass) then
                    match = false
                    break
                end
            end
            if match then
                table.insert(returnObj["entities"], entity)
            end
        end
        table.insert(sorted, returnObj)
    end
    return sorted
end