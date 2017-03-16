-----------------------------------------------------------------------------------------------  
-- @description  管理同步相关
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------



local ComBaseWithSub = import("..ComBaseWithSub")
local SubSync = import(".SubSync")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl, SubSync)

end


return M