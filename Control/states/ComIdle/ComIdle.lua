-----------------------------------------------------------------------------------------------  
-- @description  Idle状态组件  管理 run 和 stand 状态  跑步和站立
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("...ComBaseWithSub")
local SubIdle = import(".SubIdle")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    --只关心 player
    M.super.ctor(self, coreControl, SubIdle)
end



return M