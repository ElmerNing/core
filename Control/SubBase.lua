local M = class(...)


function M:ctor(com, viewEntity, modelEntity)
    self.com = com
    self.viewEntity = viewEntity
    self.modelEntity = modelEntity
    self.cmdSceneEntityKey = modelEntity:GetCmdSceneEntityKey()

    self.isDisposed = false
end

function M:GetViewEntity()
    return self.viewEntity
end

function M:GetModelEntity()
    return self.modelEntity
end

function M:GetCmdSceneEntityKey()
    return self.cmdSceneEntityKey
end

function M:GetIsSelf()
    return self.modelEntity:GetId() == Core.GetPlayerId()
end

function M:dispose()
    self.isDisposed = true
end

function M:Update()
end

function M:LateUpdate()
end

return M