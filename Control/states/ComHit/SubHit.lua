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


    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 

    end

    ---------------------------------
    --主逻辑
    ---------------------------------

    --


    --animator
    local viewEntity = self.viewEntity
    local subAnimator = self.com.comAnimator:GetSub(self.cmdSceneEntityKey)


    --播放受击动画
    local time = subAnimator:Play("hit")

    --等待受击
    local ret = self:Wait_cor( self:TriggerOfTime(time) ) if not ret then defer() return ret end

    --成功执行
    do defer() return true end

end



return M