-----------------------------------------------------------------------------------------------  
-- @description  请求移动
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(...)


--subMove :位移对象
--vec3 : 目标位置
--time : 持续时间 单位s
--type : 类型  1:线性, 2:抛物线
--完成回调
function M:ctor( subSkill, refMoveFrameEvent)

    --viewEntity
    self.viewEntity = subSkill:GetViewEntity()

    self.subMove = subSkill.com.comMove:GetSub(self.cmdSceneEntityKey)

    --初始化一些数据
    self.subSkill = subSkill

    --原始坐标
    self.vec3_orig = self.viewEntity:GetPosition()

    --offset 转换为世界坐标
    local transform_local = self.viewEntity:GetTransform()
    local vec3_offset = transform_local:TransformDirection(refMoveFrameEvent:GetOffset())
    self.vec3_offset = vec3_offset

    Log.Dump(self.vec3_offset)

    --开始时间
    self.time_start = subSkill:GetTime()

    --持续时间
    self.time = refMoveFrameEvent:GetTime()

    Log.Print("start")

    --更新
    UpdateBeat:Add(self.Update, self)
end

function M:dispose()
    Log.Print("stop")
    UpdateBeat:Remove(self.Update, self)
    self.fCallback = nil
end

function M:Update()
    local time_now = self.subSkill:GetTime()

    --插值比例
    local rate = (time_now - self.time_start) / self.time

    --local 
    if rate > 1 then
        self:dispose()
        return
    end

    local vec3_target = self.vec3_orig + (self.vec3_offset * rate) 

    Log.Print(vec3_target.x, vec3_target.y, vec3_target.z)

    --判断target位置是否合法
    self.subMove:MoveToImmediately(vec3_target, true)
end

function M:GetPosition()
end


return M