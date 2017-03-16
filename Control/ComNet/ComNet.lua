-----------------------------------------------------------------------------------------------  
-- @description  管理网络请求
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

--moveEvent
function M:SendCmdSceneMoveEvent(cmdSceneMoveEvent, fCallback)

    Log.Print("CmdSceneMove")

    Network.Send2("CmdSceneMove", {cmdSceneMoveEvent = cmdSceneMoveEvent}, fCallback)
end

return M