local M = class(...)

function M:ctor(coreControl)
    self.coreControl = coreControl
end

function M:init()
    local tmCom = self.coreControl.tmCom

    for name, com in pairs(tmCom) do
        self[name] = com
    end    
end

function M:dispose()
end

function M:Update()
end

function M:LateUpdate()
    
end

function M:GetCoreControl()
    return self.coreControl
end

function M:hash(cmdSceneEntityKey)
    return cmdSceneEntityKey.id
end



return M