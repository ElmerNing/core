-----------------------------------------------------------------------------------------------  
-- @description  玩家实体的View
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ViewEntityActor = import(".ViewEntityActor")

local M = class(..., ViewEntityActor)

function M:ctor( modelEntityPlayer )
    M.super.ctor(self,modelEntityPlayer)
    
end
















---------------------------
--重写
---------------------------
function M:GetEntityPath()
    return RefMgr.RefGlobal.playerTempModel
end

return M