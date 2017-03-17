-----------------------------------------------------------------------------------------------  
-- @description  可以
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ComBase = import(".ComBase")
local M = class(..., ComBase)


function M:ctor(coreControl, subClass, tmCmdEnumSceneEntity)
    M.super.ctor(self, coreControl)

    --Sub的类型
    self.subClass = subClass

    --所关心的Sub类型, 如果为空, 则关心所有类型
    self.tmCmdEnumSceneEntity = tmCmdEnumSceneEntity


    --所有的对象
    self.tmTmX = {}
end



function M:init()
    M.super.init(self)

    local comEntity = self.comEntity
    local eventproxy = comEntity:GetEventProxy()
    self.eventHandle_add = eventproxy:AddListener("Add", function(viewEntity, modelEntity)

        local cmdEnumSceneEntity = modelEntity:GetCmdEnumSceneEntity()
        local tmCmdEnumSceneEntity = self.tmCmdEnumSceneEntity

        --如果不关心该类型
        if tmCmdEnumSceneEntity and not tmCmdEnumSceneEntity[cmdEnumSceneEntity] then
            return
        end

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

    self:Walk(function(sub)
        sub:dispose()
    end)
end

function M:Update()
    self:WalkFocus(function(sub)
        sub:Update()
    end)
end


function M:LateUpdate()
    self:WalkFocus(function(sub)
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
    local x_old = tmX[cmdSceneEntityKey.id]
    
    --旧的dispose掉
    if x_old then
        x_old:dispose()
    end

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

--遍历关心的
function M:WalkFocus(fCallback)
    if not fCallback then return end
    if self.tmCmdEnumSceneEntity then
        for cmdEnumSceneEntity, _ in pairs(self.tmCmdEnumSceneEntity) do
            self:Walk(fCallback, cmdEnumSceneEntity )
        end
    else
        self:Walk(fCallback)
    end
end

--遍历所有
function M:Walk(fCallback, cmdEnumSceneEntity)
    if not fCallback then return end
    local function WalkTmX(tmX)
        for id, x in pairs(tmX) do
            fCallback( x )
        end
    end
    if not cmdEnumSceneEntity then
        for cmdEnumSceneEntity, tmX in pairs(self.tmTmX) do
            WalkTmX(tmX)    
        end
    else
        local tmX = self.tmTmX[cmdEnumSceneEntity]
        if tmX then WalkTmX(tmX) end
    end
end

return M
