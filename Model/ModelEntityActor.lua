-----------------------------------------------------------------------------------------------  
-- @description  ModelActor , ModelEntityMonster 和
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ModelEntity = import(".ModelEntity")

local CmdScenePosition = import(".Cmd.CmdScenePosition")
local CmdSceneMove = import(".Cmd.CmdSceneMove")
local CmdSceneHost = import(".Cmd.CmdSceneHost")
local CmdSceneEntityBattleProperty = import(".Cmd.CmdSceneEntityBattleProperty")

local M = class(..., ModelEntity)

function M:ctor(cmdSceneEntity)
    M.super.ctor(self, cmdSceneEntity)

    --添加相关组件
    self.cmdSceneHost = self:AddCmd( CmdSceneHost.new(cmdSceneEntity.cmdSceneHost) )
    self.cmdScenePosition = self:AddCmd( CmdScenePosition.new(cmdSceneEntity.cmdScenePosition) )
    self.cmdSceneMove = self:AddCmd( CmdSceneMove.new(cmdSceneEntity.cmdSceneMove) )
    
    --战斗属性
    self.cmdSceneEntityBattleProperty = self:AddCmd( 
        CmdSceneEntityBattleProperty.new( cmdSceneEntity.cmdSceneEntityBattleProperty ) 
    )
end

function M:GetIsMyHost()
    return self.cmdSceneHost:GetIsMyHost()
end

function M:dispose()

end

function M:GetMoveSpeed()
    return 12
end
    

return M