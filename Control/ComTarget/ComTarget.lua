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

--寻找目标
function M:FindTarget()
    
end


return M