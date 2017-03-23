-----------------------------------------------------------------------------------------------  
-- @description  ComIdle的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBaseWithState = import("...SubBaseWithState")

local M = class(..., SubBaseWithState)


function M:ctor(...)
    M.super.ctor(self, ...)  

    self:Resume()

end

function M:Update()

    --如果当前没有任何状态. 切换到idle状态
    if self:GetSubStateMgr():GetSubStateBase() == nil then
        self:Resume()
    end
end




function M:Main_cor()

    local function defer()
    end

    local function print(...)
        if self:GetIsSelf() then
            Log.Print(...)
        end
    end


    --animator
    local viewEntity = self.viewEntity
    local subAnimator = self.com.comAnimator:GetSub(self.cmdSceneEntityKey)

    while true do
        --判断逻辑
        local navMeshRender = viewEntity:GetNavMeshAgent()
        if navMeshRender.velocity.sqrMagnitude > 2 then
            subAnimator:Play("run")
        else
            subAnimator:Play("stand")
        end 

        --0.1秒检测一次
        local ret = self:Wait_cor(self:TriggerOfTime(0.1))  if not ret then defer() return ret end
        
    end


    --成功执行完成
    do defer() return true end
end



return M