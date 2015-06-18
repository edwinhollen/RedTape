local class = require "middleclass"

InteractableComponent = class("InteractableComponent")
function InteractableComponent:initialize()
    self.onClick = function() end
    self.highlightWhenSelected = true
    self.isHighlighted = false
end
