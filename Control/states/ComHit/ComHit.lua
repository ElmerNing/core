-----------------------------------------------------------------------------------------------  
-- @description  受击状态
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("...ComBaseWithSub")
local SubHit = import(".SubHit")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    --只关心 player
    M.super.ctor(self, coreControl, SubHit)

end



return M