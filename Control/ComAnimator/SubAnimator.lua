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
    self.viewEntityActor = nil
    
    if self.modelEntity:GetIsActor() then
        self.viewEntityActor = self.viewEntity 
    end

    self.vec3_lastupdate = self.viewEntity:GetPosition()

    self.state = nil
end

function M:SetState(animator, state)
    if self.state ~= state then
        self.state = state
        animator:SetInteger("State",
            UnityEngine.Animator.StringToHash(string.lower(state))
        )
    end
end

function M:LateUpdate()

    local viewEntityActor = self.viewEntityActor

    if not viewEntityActor then return end

    local animator = self.viewEntityActor:GetAnimator()
    if not animator then return end

    local navMeshRender = viewEntityActor:GetNavMeshAgent()
    if navMeshRender.hasPath then
        self:SetState(animator, "run")
    else
        self:SetState(animator, "stand")
    end 
end


return M