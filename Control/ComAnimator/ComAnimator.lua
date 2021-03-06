-----------------------------------------------------------------------------------------------  
-- @description  管理实体的移动
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("..ComBaseWithSub")
local SubAnimator = import(".SubAnimator")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl, SubAnimator)
end

--返回播放时间
function M:Play(cmdSceneEntityKey, stateName)
    local subAnimator = self:GetSub(cmdSceneEntityKey)
    return subAnimator:Play(stateName)
end


return M
