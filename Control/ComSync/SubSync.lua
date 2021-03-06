-----------------------------------------------------------------------------------------------  
-- @description  ComSync的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")
local M = class(..., SubBase)

function M:ctor(...)
    M.super.ctor(self, ...)

    --事件组件
    self.comTime = self.com.comTime

    --网络组件
    self.comNet = self.com.comNet

    --位置
    self.vec3_pos = self.viewEntity:GetPosition()
    
    --时间
    self.time = self.comTime:GetServerTime()

    --停止
    self.isStop = nil

    if self.modelEntity:GetIsActor() then
        self.modelEntityActor = self.modelEntity
    end

    self.cmdSceneHost = self.modelEntityActor:GetCmd("CmdSceneHost")
end


function M:LateUpdate()

    --不是actor
    if not self.modelEntityActor then return end

    local cmdSceneHost = self.modelEntityActor:GetCmd("CmdSceneHost")
    if (not cmdSceneHost) or not cmdSceneHost:GetIsMyHost() then
        return
    end

    --时间
    local time_now = self.comTime:GetServerTime()
    local time_pre = self.time
    local time_offset = time_now - time_pre

    --距离上传提交时间太短
    if time_offset < 0.2 then
        return
    end

    --比较位置
    local vec3_now = self.viewEntity:GetPosition()
    local vec3_pre = self.vec3_pos
    local vec3_offset = vec3_now - vec3_pre

    --长度
    local length = vec3_offset:SqrMagnitude()
    local isStop = length <= 1e-10

    --同步函数
    local function sync()
        
        local modelEntity = self.modelEntityActor

        --更新本地数据
        self.time = time_now
        self.vec3_pos = vec3_now

        --更新model层 并且 生成同步事件
        local speed = isStop and 0 or modelEntity:GetMoveSpeed()
        local eulerAngles = self.viewEntity:GetEulerAngles()
        local cmdSceneMoveEvent = {
            cmdSceneEntityKey       = modelEntity:GetCmdSceneEntityKey(),
            cmdSceneHost            = modelEntity.cmdSceneHost:NextCmdHost(),
            cmdScenePosition        = modelEntity.cmdScenePosition:SetVec3(vec3_now),
            cmdSceneMove            = modelEntity.cmdSceneMove:Update(eulerAngles, speed),
        }
        
        self.comNet:SendCmdSceneMoveEvent(cmdSceneMoveEvent)
    end



    --移动状态发生改变, 同步
    if self.isStop ~= isStop then
        self.isStop = isStop
        sync()
        return
    end

    
    if not isStop then

        --移动中0.5s同步一次
        if time_offset > 0.4 then
            sync()
            return
        end
    else
        --没移动 不更新
        
    end




end


return M