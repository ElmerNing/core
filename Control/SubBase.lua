local M = class(...)


function M:ctor(com, viewEntity, modelEntity)
    self.com = com
    self.viewEntity = viewEntity
    self.modelEntity = modelEntity
    self.cmdSceneEntityKey = modelEntity:GetCmdSceneEntityKey()
end

function M:GetIsSelf()
    return self.modelEntity:GetId() == Core.GetPlayerId()
end

function M:dispose()
end

function M:Update()
end

function M:LateUpdate()
end

return M