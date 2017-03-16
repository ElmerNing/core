


local Cmd = import(".Cmd")
local M = Cmd.CreateSub(...,"CmdSceneHost")

--是否处于被控制状态
function M:GetIsHost()
    return self.playerId ~= 0
end

--是否处于我的控制状态下
function M:GetIsMyHost() 
    return self.playerId == Core.GetPlayerId()
end

--Event递增
function M:NextCmdHost()
    --索引+1
    self.eventIndex = self.eventIndex + 1
    --索引+1
    self.eventTime = Core.coreControl.comTime:GetServerTime()
    --返回自身
    return self:Rebuild()
end



return M