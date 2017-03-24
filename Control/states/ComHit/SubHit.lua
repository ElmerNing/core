-----------------------------------------------------------------------------------------------  
-- @description  ComHit的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBaseWithState = import("...SubBaseWithState")

local M = class(..., SubBaseWithState)




function M:ctor(...)
    M.super.ctor(self, ...)  



end


function M:PlayHit(cmdSceneEntityKey_attacker, refAttackFrameEvent)


    ---------------------------------
    -- 各种判断  to do
    ---------------------------------

    -- to do


    ---------------------------------


    --切换到受击状态
    self:Resume(cmdSceneEntityKey_attacker, refAttackFrameEvent)

end

function M:Main_cor(cmdSceneEntityKey_attacker, refAttackFrameEvent)


    ---------------------------------
    --需要清空的资源
    ---------------------------------

    local viewEntity = self.viewEntity
    local viewEntity_attacker = self.com.comEntity:GetView(cmdSceneEntityKey_attacker)
    local subAnimator = self.com.comEntity:GetSub(self.cmdSceneEntityKey, "comAnimator")

    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 
        subAnimator:SetSpeed(1)
    end

    ---------------------------------
    --主逻辑
    ---------------------------------

    --添加特效, 
    local subEffect = self.com.comEntity:GetSub(self.cmdSceneEntityKey, "comEffect")
    local path, parentName, time = refAttackFrameEvent:GetTargetEffect()
    if refAttackFrameEvent.hitEffect ~= "" and time > 0 then
        subEffect:AddEffect(path, parentName, time)
    end

    --受击面向
    local targetDirection = refAttackFrameEvent:GetTargetDirection()
    if targetDirection == "toAttacker" then
        viewEntity:LookAt( viewEntity_attacker:GetPosition() )
    end
    if targetDirection == "asAttacker" then
        viewEntity:SetEulerAngles( viewEntity_attacker:GetEulerAngles() )
    end

    --卡帧
    local pauseTime = refAttackFrameEvent:GetTargetPauseTime()
    if pauseTime > 0 then
        subAnimator:SetSpeed(0)
        local ret = self:Wait_cor( self:TriggerOfTime(pauseTime) ) if not ret then defer() return ret end
        subAnimator:SetSpeed(1)
    end

    --目标动画
    local targetAction = refAttackFrameEvent:GetTargetAction()
    local time = 0
    if targetAction.animation  then 
        time = subAnimator:Play(targetAction.animation)
    end
    

    ---------------------------------
    -- 击倒 击飞逻辑
    ---------------------------------
    --todo



    --等待受击
    local ret = self:Wait_cor( self:TriggerOfTime(time) ) if not ret then defer() return ret end

    --成功执行
    do defer() return true end
end



return M