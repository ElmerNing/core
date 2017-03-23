-----------------------------------------------------------------------------------------------  
-- @description  管理 状态
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("..ComBaseWithSub")
local SubStateMgr = import(".SubStateMgr")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl, SubStateMgr)
end


return M