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

    self.viewEntityActor = self.viewEntity 

    self.vec3_lastupdate = self.viewEntity:GetPosition()

    --是否自由切换
    self.isAuto = true

    --动画时间
    self.tmTime = nil

    

end

function M:SetIsAuto(isAuto)
    self.isAuto = isAuto
end

function M:SetState(animator, stateName, reset)

    local state_org = animator:GetInteger("State")
    local state_new = UnityEngine.Animator.StringToHash(string.lower(stateName))

    if state_org ~= state_new then
        animator:SetInteger("State", state_new)
        return
    end

    if reset then
        animator:Play(state_new, -1, 0)
    end
end

--返回播放时间
--返回空 代表播放失败
function M:Play(stateName)

    

    --animator是否加载完成
    local animator = self:GetAnimator()
    if not animator then return end
    
    --时间
    local time = self:GetTime(stateName)
    if not time then return end
    
    --播放
    --self:SetState(animator, stateName, true)

    local state_org = animator:GetInteger("State")
    local state_new = UnityEngine.Animator.StringToHash(string.lower(stateName))

    if state_org ~= state_new then
        animator:SetInteger("State", state_new) 
    end

    animator:Play(state_new, -1, 0)

    --需要起始时间 fuck 不知道怎么实现
    --if not normalizedTime then
    --animator:Play(state, -1, )
    --end

    --返回播放时间
    return time
end

function M:GetTmTime()
    if not self.tmTime then
        local animator = self:GetAnimator()
        if animator then
            self.tmTime = CsProxy.GetAnimatorClipLengthDic(animator)
        end
    end
    return self.tmTime
end

--获取时间
function M:GetTime(state)
    local tmTime = self:GetTmTime()
    if not tmTime then return nil end
    if not tmTime:ContainsKey(state) then return nil end
    return tmTime:get_Item(state)
end

--获取animator
function M:GetAnimator()
    if not self.animator then
        self.animator = self.viewEntityActor:GetAnimator()
    end
    return self.animator
end

function M:LateUpdate()
    
    --不是自由
    if not self.isAuto then return end

    --animator
    local viewEntityActor = self.viewEntityActor
    local animator = self.viewEntityActor:GetAnimator()
    if not animator then return end

    --判断逻辑
    local navMeshRender = viewEntityActor:GetNavMeshAgent()
    if navMeshRender.hasPath then
        self:SetState(animator, "run")
    else
        self:SetState(animator, "stand")
    end 
end


return M