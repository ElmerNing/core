-----------------------------------------------------------------------------------------------  
-- @description  ModelEntity基类
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local moduleName = ...
local M = class(...)

function M:ctor(cmdSceneEntity)
    self.id = cmdSceneEntity.id
    self.cmdEnumSceneEntity = cmdSceneEntity.cmdEnumSceneEntity
    self.cmdSceneEntityKey = {
        id = self.id,
        cmdEnumSceneEntity = self.cmdEnumSceneEntity,
    }
    self.tmCmd = {}
end

function M:dispose()

end

function M:GetIsActor()
    local ModelEntityActor = import(".ModelEntityActor", moduleName)
    local ret = iskindof(self, ModelEntityActor.__cname)
    return ret
end

function M:GetIsPlayer()
    local ModelEntityPlayer = import(".ModelEntityPlayer", moduleName)
    local ret = iskindof(self, ModelEntityPlayer.__cname)
    return ret 
end

--是否是自己
function M:GetIsSelf()
    return self.id == Core.GetPlayerId()
end

function M:GetId()
    return self.id
end

function M:GetCmdEnumSceneEntity()
    return self.cmdEnumSceneEntity
end

function M:GetCmdSceneEntityKey()
    return self.cmdSceneEntityKey
end

--添加组件
function M:AddCmd(cmdX)
    self.tmCmd[cmdX:GetProtoName()] = cmdX
    return cmdX
end

function M:GetCmd(protoName)
    return self.tmCmd[protoName]
end

--删除组件
function M:RemoveCmd(cmdX)
    self.tmCmd[name] = nil
end

return M