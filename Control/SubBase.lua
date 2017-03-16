local M = class(...)


function M:ctor(com, viewEntity, modelEntity)
    self.com = com
    self.viewEntity = viewEntity
    self.modelEntity = modelEntity
end

function M:Update()
end

function M:LateUpdate()
end

return M