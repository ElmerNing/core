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
    Network.Send2("CmdSceneMove", {cmdSceneMoveEvent = cmdSceneMoveEvent}, fCallback)
end

--attackEvent
function M:SendCmdSceneAttackEvent(cmdSceneAttackEvent, fCallback)
    Network.Send2("CmdSceneAttack", {cmdSceneAttackEvent = cmdSceneAttackEvent}, fCallback)
end

--
function M:SendCmdSceneAttackEffectEvent(cmdSceneAttackEffectEvent, fCallback)
    Network.Send2("CmdSceneAttackEffect", {cmdSceneAttackEffectEvent = cmdSceneAttackEffectEvent}, fCallback)
end

return M