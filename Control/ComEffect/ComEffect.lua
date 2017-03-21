-----------------------------------------------------------------------------------------------  
-- @description  管理实体的上的特效
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("..ComBaseWithSub")
local SubEffect = import(".SubEffect")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl, SubEffect)
end


function M:AddEffect(cmdSceneEntityKey, path, parentName, time, fCallback)
    local subEffect = self:GetSub(cmdSceneEntityKey)
    return subEffect:AddEffect(path, parentName, time, fCallback)
end

return M
