-----------------------------------------------------------------------------------------------  
-- @description  怪物的实体的展示层
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ViewEntityActor = import(".ViewEntityActor")

local M = class(..., ViewEntityActor)

function M:ctor(modelEntityMonster)
    M.super.ctor(self,modelEntityMonster)
end

---------------------------
--重写
---------------------------
function M:GetEntityPath()
    return RefMgr.RefGlobal.playerTempModel
end

return M