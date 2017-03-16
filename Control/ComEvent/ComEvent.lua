-----------------------------------------------------------------------------------------------  
-- @description  管理相关事件
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local ComBase = import("..ComBase")
local M = class(..., ComBase)

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl)
end

return M