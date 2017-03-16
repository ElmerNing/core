-----------------------------------------------------------------------------------------------  
-- @description  管理实体的移动
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------


local ComBaseWithSub = import("..ComBaseWithSub")
local SubMove = import(".SubMove")
local M = class(..., ComBaseWithSub)

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl, SubMove)
end

--是否在移动
function M:IsMove(cmdSceneEntityKey)
    local subMove = self:GetSub(cmdSceneEntityKey)
    return subMove:IsMove()
end

--向某一方向移动
function M:MoveDir(cmdSceneEntityKey, vec3_dir)
    local subMove = self:GetSub(cmdSceneEntityKey)
    return subMove:MoveDir(vec3_dir)
end

--移动到某一个位置
function M:MoveTo(cmdSceneEntityKey, vec3_pos)
    local subMove = self:GetSub(cmdSceneEntityKey)
    return subMove:MoveTo(vec3_pos)
end

--瞬间移动到某一位置
function M:MoveToImmediately(cmdSceneEntityKey, vec3_pos, rotate)
    local subMove = self:GetSub(cmdSceneEntityKey)
    return subMove:MoveToImmediately(vec3_pos, rotate)
end

--停止移动
function M:MoveStop(cmdSceneEntityKey)
    local subMove = self:GetSub(cmdSceneEntityKey)
    return subMove:MoveStop()
end


return M
