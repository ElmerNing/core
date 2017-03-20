-----------------------------------------------------------------------------------------------  
-- @description  ComMove的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")
local M = class(..., SubBase)

function M:ctor(...)
    M.super.ctor(self, ...)
end

function M:IsMove()
    local viewEntity = self.viewEntity
    local navMeshAgent = viewEntity:GetNavMeshAgent()
    return navMeshAgent.hasPath
end

--往某方向移动
function M:MoveDir(vec3_dir)
    local viewEntity = self.viewEntity
    local modelEntity = self.modelEntity


    local navMeshAgent = viewEntity:GetNavMeshAgent() 

    local speed = modelEntity:GetMoveSpeed()
    local vec3_orig = viewEntity:GetPosition()
    navMeshAgent.speed = speed

    local vec3_offset = vec3_dir * (speed * self.com.comTime:GetDeltaTime() * 3)
    local vec3_target = vec3_orig + vec3_offset

    navMeshAgent:Resume()
    navMeshAgent:SetDestination(vec3_target)
end

--移动到某一个位置
function M:MoveTo(vec3_pos)
    local viewEntity = self.viewEntity
    local modelEntity = self.modelEntity
    local navMeshAgent = viewEntity:GetNavMeshAgent()
    navMeshAgent:Resume()
    navMeshAgent:SetDestination(vec3_pos)
end

--瞬间移动到某一位置
function M:MoveToImmediately( vec3_pos, rotate)
    local viewEntity = self.viewEntity
    local modelEntity = self.modelEntity
    local navMeshAgent = viewEntity:GetNavMeshAgent()
    local vec3_orig = viewEntity:GetPosition()
    local vec3_offset = vec3_pos - vec3_orig
    navMeshAgent:Stop()
    navMeshAgent:Move(vec3_offset)
    --转向
    if rotate then
        viewEntity:LookAt(vec3_pos)
    end
end

--停止移动
function M:MoveStop()
    local viewEntity = self.viewEntity
    local navMeshAgent = viewEntity:GetNavMeshAgent()
    navMeshAgent = navMeshAgent:Stop()
end

--获取位置
function M:GetPosition()
    local viewEntity = self.viewEntity
    
    local speed = modelEntity:GetMoveSpeed()
    local vec3_orig = viewEntity:GetPosition()
    return
end

return M