-----------------------------------------------------------------------------------------------  
-- @description  技能组件
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("..ComBaseWithSub")
local SubTarget = import(".SubTarget")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)

    --只关心 player
    M.super.ctor(self, coreControl, SubTarget)


end

function M:GetTarget(cmdSceneEntityKey)
    local subTarget = self:GetSub(cmdSceneEntityKey)
    return subTarget:GetTarget()
end


return M