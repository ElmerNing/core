-----------------------------------------------------------------------------------------------  
-- @description  ComSkill的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")
local M = class(..., SubBase)

--配置表
local RefSkill = RefMgr.RefSkill
local RefAction = RefMgr.RefAction

--辅助类
local RequestEffect = import(".Other.RequestEffect")
local RequestMove = import(".Other.RequestMove")
local RequestAttack = import(".Other.RequestAttack")


function M:ctor(...)
    M.super.ctor(self, ...)

    --下一个技能
    self.refSkill_next = nil

    --当前的协程
    self.cor = nil

    --trigger, 用于update中恢复协程
    self.trigger = nil

    --开启一个协程, 处理
    coroutine.start(function()

        --当前协程
        self.cor = CorUtil.new()
  
        while true do
   
            local ret = self:MainLoop_cor()

            --失败
            if not ret then
                --判断失败原因, 决定是否跳出循环
            end

        end

    end)
end




function M:Update()

    self:CorUpdate()

end

--压入一个技能, 
function M:PushSkill(skillRefId)
    self.refSkill_next = RefSkill.GetRef{
        refId = skillRefId
    }
end


---------------------------------
-- 以下是内部函数
---------------------------------

--获取响应的SubAnimator
function M:GetSubAnimator()
    local subAnimator = self.com.comAnimator:GetSub(self.cmdSceneEntityKey)
    return subAnimator
end

--协程中驱动
function M:CorUpdate()

    --统一退出逻辑
    --if self.Exit then
    --  self.cor:Resume( false )
    --  return
    --end

    --判断triiger是否触发
    if self.trigger then
        local tlRet = { self.trigger() }
        local ret = tlRet[1]
        --成功触发
        if ret then
            self.trigger = nil
            self.cor:Resume( unpack(tlRet) )
        end
    end
end

--协程中等待, 一直到fTrigger 返回true, 协程恢复
function M:Wait(fTrigger)
    local tlRet = { fTrigger() }

    --成功触发
    local ret = tlRet[1]
    if ret then
        return unpack(tlRet)
    end

    --等待触发
    self.trigger = fTrigger
    return self.cor:Yield()
end


--主循环
function M:MainLoop_cor()
    ---------------------------------
    --需要清空的资源
    ---------------------------------

    --pass

    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 
    end

    ---------------------------------
    --主逻辑
    ---------------------------------

    --下一个技能
    local ret, refSkill = self:Wait( self:TriggerOfNextRefSkill() )
    if not ret then
        do defer() return ret end
    end
 
    --播放技能
    local ret = self:PlaySkill_cor(refSkill)
    if not ret then
        do defer() return ret end
    end

    --成功返回
    do defer() return true end
end

--播放一个技能
function M:PlaySkill_cor(refSkill)

    ---------------------------------
    --需要清空的资源
    ---------------------------------

    --当前正在播放的refSkill
    self.refSkill = refSkill
    self:GetSubAnimator():SetIsAuto(false)

    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 
        self.refSkill = nil
        self:GetSubAnimator():SetIsAuto(true)
    end

    ---------------------------------
    --主逻辑
    ---------------------------------

    --遍历action
    local tlActionRefId = refSkill.actionClipRefId
    for _, actionRefId in ipairs(tlActionRefId) do

        --action配置
        local refAction = RefAction.GetRef{
            refId = actionRefId
        }
        assert(refAction, string.format("找不到actionRefId:%s", actionRefId) )

        --播放action
        local ret = self:PlayAction_cor(refAction)
        --action中断
        if not ret then
            do defer() return ret end
        end
    end

    --成功执行
    do defer() return true end
end

--播放一个Action
function M:PlayAction_cor(refAction)

    ---------------------------------
    --需要清空的资源
    ---------------------------------

    --当前的refAction
    self.refAction = refAction

    -- 所有需要dipose的对象
    local tlIDispose = {}

    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 
        self.refAction = nil

        --调用对象的dispose方法
        for _, idispose in ipairs(tlIDispose) do
            idispose:dispose(idispose)
        end
    end

    ---------------------------------
    --主逻辑
    ---------------------------------

    --开始播放动作
    local time = self:GetSubAnimator():Play( refAction.action )
    if not time then
        do defer() return false end
    end

    --技能开始时间
    local time_start = self:GetTime()


    --播放所有技能
    local tlFrame = refAction:GetTlFrame()

    --播放所有帧事件
    for _, frame in ipairs(tlFrame) do
        --播放当前帧, 不会暂停协程, 返回action完成后, 需要清理的对象
        local func = self[frame.name]
        if func then
            local tl = func(self, frame)
            if tl then table.insertto( tlIDispose, tl )  end
        end
    end

    --等待动作播放完成
    local ret = self:Wait( self:TriggerOfTime(time, time_start) )
    if not ret then
        do defer() return ret end
    end

    ---------------------------------
    --成功返回
    ---------------------------------
    do defer() return true end
end


--下个技能触发器
function M:TriggerOfNextRefSkill()
    return function()
        local refSkill = self.refSkill_next
        
        --没有下一个技能 不触发
        if not refSkill then
            return false
        end

        --有下一个技能 触发
        --清空当前的下一个技能
        self.refSkill_next = nil

        --返回
        return true, refSkill
    end
end

--指定起始时间
function M:TriggerOfTime(time, time_start)
    local time_start = time_start or self:GetTime()
    return function()
        local time_now = self:GetTime()
        return time_start + time < time_now
    end
end

--获取当前时间 单位秒
function M:GetTime()
    local comTime = self.com.comTime
    return comTime:GetServerTime()
end

---------------------------------
-- 各个帧事件
---------------------------------

--播放move, 需要Action播放完成后 销毁的对象
function M:FrameMove(frame)
    local refMoveFrameEvent = frame.ref
    
    local requestMove = RequestMove.new(self, refMoveFrameEvent)


    return {requestMove}
end

--攻击帧
function M:FrameAttack(frame)
    local refAttackFrameEvent = frame.ref

    local requestAttack = RequestAttack.new(self, refAttackFrameEvent)

    return {requestAttack}
end

--特效帧
function M:FrameEffect(frame)

    --数据
    local comEffect = self.com.comEffect
    local refEffectFrameEvent = frame.ref

    --特效时间
    local time = refEffectFrameEvent:GetTime()
    if refEffectFrameEvent:GetIsLoop() then
        time = nil -- time nil则无限循环
    end

    --添加特效
    local requestEffect = comEffect:AddEffect(
        self:GetCmdSceneEntityKey(),
        refEffectFrameEvent.effect, 
        refEffectFrameEvent.hangingPoint, time, 
        function(go, transform)
            transform.localPosition=refEffectFrameEvent:GetLocalPosition()
            transform.localEulerAngles=refEffectFrameEvent:GetRotation()
        end
    )

    --如果是无限循环
    if time == nil then
        return {requestEffect} 
    end  
end









return M