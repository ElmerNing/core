-----------------------------------------------------------------------------------------------  
-- @description  ComSkill的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBaseWithState = import("..SubBaseWithState")

local M = class(..., SubBaseWithState)




--配置表
local RefSkill = RefMgr.RefSkill
local RefAction = RefMgr.RefAction

--辅助类
local RequestMove = import(".Other.RequestMove")
local RequestAttack = import(".Other.RequestAttack")


function M:ctor(...)
    --M.super.ctor(self, ...)


    local tl = {...}

    local ret, msg = pcall(function() 
        M.super.ctor(self, unpack(tl))    
    end)
    if not ret then
        Log.Print(msg)
    end
    
end

--压入一个技能, 
function M:PushSkill(skillRefId)
    local refSkill = RefSkill.GetRef{
        refId = skillRefId
    }
    self:Resume(refSkill)
end


---------------------------------
-- 以下是内部函数
---------------------------------

--获取响应的SubAnimator
function M:GetSubAnimator()
    local subAnimator = self.com.comAnimator:GetSub(self.cmdSceneEntityKey)
    return subAnimator
end


--主循环
function M:Main_cor(refSkill)
    return self:PlaySkill_cor(refSkill)
end

--同步技能播放, 返回eventIndex
function M:SyncAttack(refSkill)

    --同步服务器
    local modelEntity = self.modelEntity
    local cmdSceneHost= modelEntity:GetCmd("CmdSceneHost")

    --同步
    if cmdSceneHost and cmdSceneHost:GetIsMyHost() then
        local cmdSceneEntityKey = modelEntity:GetCmdSceneEntityKey()
        local cmdSceneAttackEvent = {
            cmdSceneEntityKey_target            = self.com.comTarget:GetTarget(cmdSceneEntityKey),
            cmdSceneEntityKey_attack            = cmdSceneEntityKey,
            cmdSceneHost                        = modelEntity.cmdSceneHost:NextCmdHost(),
            skillRefId                          = refSkill.refId,
        }
        self.com.comNet:SendCmdSceneAttackEvent(cmdSceneAttackEvent)

        --返回此次攻击的eventIndex
        return cmdSceneAttackEvent.cmdSceneHost.eventIndex
    end
end

--同步技能效果
function M:SyncAttackEffect(event)

end

--播放一个技能
function M:PlaySkill_cor(refSkill)

    ---------------------------------
    --需要清空的资源
    ---------------------------------

    --当前正在播放的refSkill
    self.refSkill = refSkill
    self:GetSubAnimator():SetIsAuto(false)
    self.eventIndex = self:SyncAttack(refSkill)

    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 
        self.refSkill = nil
        self.eventIndex = nil
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

    --动作组件
    local subAnimator = self:GetSubAnimator()

    ---------------------------------
    --defer函数 释放以上申请的资源
    ---------------------------------
    local function defer() 
        self.refAction = nil

        --恢复播放速度
        subAnimator:SetSpeed(1)

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

    --时间偏移
    local time_offset = 0

    --播放所有帧事件
    for _, frame in ipairs(tlFrame) do 
        --等待当前帧
        local ret = self:Wait_cor( self:TriggerOfTime(frame.time + time_offset, time_start) ) if not ret then defer() return ret end

        if frame.name == "FrameAttack" then
            --播放攻击帧
            local requestAttack = self:FrameAttack(frame)

            --储存action播放完成后需要销毁的对象
            tlIDispose[#tlIDispose] = requestAttack

            --如果命中, 卡帧
            if requestAttack:GetIsHit() then
                --如果命中, 播放卡帧动画
                local refAttackFrameEvent = frame.ref
                local pauseTime = refAttackFrameEvent:GetAttackPauseTime()
                if pauseTime > 0 then
                    subAnimator:SetSpeed(0)
                    local ret = self:Wait_cor( self:TriggerOfTime(pauseTime) )  if not ret then  defer() return ret end 
                    subAnimator:SetSpeed(1)
                end
            end
        else
            --播放当前帧, 不会暂停协程, 返回action完成后, 需要清理的对象
            local func = self[frame.name]
            if func then
                local tl = func(self, frame)
                if tl then table.insertto( tlIDispose, tl )  end
            end
        end
    end

    --等待动作播放完成
    local ret = self:Wait_cor( self:TriggerOfTime(time + time_offset, time_start) )
    if not ret then
        do defer() return ret end
    end

    ---------------------------------
    --成功返回
    ---------------------------------
    do defer() return true end
end


---------------------------------
-- 各个帧事件
---------------------------------

--播放move, 需要Action播放完成后 销毁的对象
function M:FrameMove(frame)
    local refMoveFrameEvent = frame.ref
    local requestMove = RequestMove.new(self, refMoveFrameEvent)
    return  {requestMove}
end

--攻击帧
function M:FrameAttack(frame)
    local refAttackFrameEvent = frame.ref
    assert(self.eventIndex and self.refAction, "攻击帧调用时机不对")
    local requestAttack = RequestAttack.new(self, self.eventIndex, self.refAction.refId,  refAttackFrameEvent )
    return requestAttack
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
        return  {requestEffect} 
    end  
end









return M