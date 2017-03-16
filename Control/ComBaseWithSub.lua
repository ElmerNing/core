-----------------------------------------------------------------------------------------------  
-- @description  可以
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ComBase = import(".ComBase")
local M = class(..., ComBase)

function M:ctor(coreControl, subClass)
    M.super.ctor(self, coreControl)

    self.subClass = subClass

    self.tmTmX = {}
end

function M:init()
    M.super.init(self)

    local comEntity = self.comEntity
    local eventproxy = comEntity:GetEventProxy()
    self.eventHandle_add = eventproxy:AddListener("Add", function(viewEntity, modelEntity)
        self:SetSub( modelEntity:GetCmdSceneEntityKey(), self.subClass.new(self, viewEntity, modelEntity) )
    end)
    self.eventHandle_remove = eventproxy:AddListener("Remove", function(cmdSceneEntityKey) 
        self:SetSub(cmdSceneEntityKey, nil)
    end)
end

function M:dispose()
    local comEntity = self.comEntity
    local eventproxy = comEntity:GetEventProxy()
    eventproxy:RemoveListener( "Add",     self.eventHandle_add)
    eventproxy:RemoveListener( "Remove",  self.eventHandle_remove)
end

function M:Update()
    self:Walk(function(sub)
        sub:Update()
    end)
end


function M:LateUpdate()
    self:Walk(function(sub)
        sub:LateUpdate()
    end)
end

function M:GetTmSub(cmdEnumSceneEntity)
    local tmX = self.tmTmX[cmdEnumSceneEntity]
    if not tmX then
        tmX = {}
        self.tmTmX[cmdEnumSceneEntity] = tmX
    end
    return tmX
end

function M:SetSub(cmdSceneEntityKey, x)

    cmdSceneEntityKey = cmdSceneEntityKey or self.comEntity:GetCmdSceneEntityKeySelf()

    local tmX = self:GetTmSub(cmdSceneEntityKey.cmdEnumSceneEntity)
    tmX[cmdSceneEntityKey.id] = x
end

function M:GetSub(cmdSceneEntityKey)

    cmdSceneEntityKey = cmdSceneEntityKey or self.comEntity:GetCmdSceneEntityKeySelf()

    local tmX = self:GetTmSub(cmdSceneEntityKey.cmdEnumSceneEntity)
    local x = tmX[cmdSceneEntityKey.id]
    return x
end

function M:Clear()
    self.tmTmX = {}
end

function M:Walk(fCallback)
    if not fCallback then return end
    --local cmdSceneEntityKey = {}
    for cmdEnumSceneEntity, tmX in pairs(self.tmTmX) do
        for id, x in pairs(tmX) do
            --cmdSceneEntityKey.cmdEnumSceneEntity = cmdEnumSceneEntity
            --cmdSceneEntityKey.id = id
            fCallback( x )
        end
    end
end

return M
