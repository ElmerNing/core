-----------------------------------------------------------------------------------------------  
-- @description  请求一次攻击
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(...)


function M:ctor(subSkill, refAttackFrameEvent)
       
    self.viewEntity = subSkill:GetViewEntity()
    self.comEntity = subSkill.com.comEntity

    local cmdSceneEntityKey = subSkill:GetCmdSceneEntityKey()

    local subTarget = subSkill.com.comTarget:GetSub(cmdSceneEntityKey)


    --获取相关类型
    local tlCmdEnumSceneEntity = self:GetTlCmdEnumSceneEntity(refAttackFrameEvent.targetType)

    --预先搜索附近
    local tlCmdSceneEntityKey, isIncludeSelf = subTarget:SearchTlTargetByEnum(tlCmdEnumSceneEntity)

    --如果包括自己
    if isIncludeSelf then
        tlCmdSceneEntityKey[#tlCmdSceneEntityKey+1] = cmdSceneEntityKey
    end  

    --转换为tm
    local tmCmdSceneEntityKey = tlCmdSceneEntityKey

    --通过攻击范围内,进行过滤
    self:FiltByArea(tmCmdSceneEntityKey, refAttackFrameEvent:GetArea() )
   

end

function M:dispose()
end


--targetType 1:敌方 2:友方 3:自己 4:自己加友方 5:全体
function M:GetTlCmdEnumSceneEntity(targetType)
    return {
        "SceneEntity_Monster"
    }, false
end



--通过攻击范围内,进行过滤
function M:FiltByArea(tmCmdSceneEntityKey, area)

    local tm = {
        circle = self.GetIsInCircle,
        sector = self.GetIsInSector,
        rect = self.GetIsInRect,
    }

    --过滤函数
    local func = tm[area.typeName] 
    assert(func, string.format( "未实现attackType %s", area.typeName) )

    --移除不满足条件的
    for key, cmdSceneEntityKey in pairs(tmCmdSceneEntityKey) do
        local ret = func(self, cmdSceneEntityKey, area)
        if not ret then tmCmdSceneEntityKey[key] = nil end
    end

    Log.Dump(tmCmdSceneEntityKey)

end

function M:GetLocalPosition(cmdSceneEntityKey)

    --attacker
    local viewEntity_attacker = self.viewEntity
    local transform_attacker = viewEntity_attacker:GetTransform()

    --target
    local viewEntity_target = self.comEntity:GetView(cmdSceneEntityKey) 
    
    --将taget的位置转换为本地坐标来计算
    local vec3_target = transform_attacker:InverseTransformPoint( viewEntity_target:GetPosition() )
    return vec3_target
end

function M:GetIsInCircle(cmdSceneEntityKey, area)
    
    --获取目标的本地坐标系
    local vec3 = self:GetLocalPosition(cmdSceneEntityKey)

    --获取目标与参考点的偏移
    local vec3_offset = vec3 - area.vec3_ref

    --过高
    if math.abs(vec3_offset.y) > area.height then
        return false
    end

    --水平距离 过远
    local x = vec3_offset.x
    local z = vec3_offset.z
    local radius = area.radius
    if x*x + z*z > radius * radius then
        return false
    end

    return true
end

function M:GetIsInSector(cmdSceneEntityKey, area)

    local function Print(...)
        if cmdSceneEntityKey.id == 5 then
            Log.Print(...)
        end
    end

    --获取目标的本地坐标系
    local vec3 = self:GetLocalPosition(cmdSceneEntityKey)

    --获取目标与参考点的偏移
    local vec3_offset = vec3 - area.vec3_ref

    --过高
    if math.abs(vec3_offset.y) > area.height then
        return false
    end
    
    --过远
    local x = vec3_offset.x
    local z = vec3_offset.z
    local radius = area.radius
    if x*x + z*z > radius * radius then
        return false
    end

    --过偏
    local angle = area.angle
    angle = angle * 0.5 
    local rotation = math.atan2(x, z) * (180 / 3.14159)
    if math.abs(rotation) > angle then
        return false
    end

    return true
end

function M:GetIsInRect(cmdSceneEntityKey, area)
    --获取目标的本地坐标系
    local vec3 = self:GetLocalPosition(cmdSceneEntityKey)

    --获取目标与参考点的偏移
    local vec3_offset = vec3 - area.vec3_ref

    --过高
    if math.abs(vec3_offset.y) > area.height then
        return false
    end

    --过远
    if vec3_offset.z > area.length then
        return false
    end

    --过偏
    if math.abs(vec3_offset.x) > area.width * 0.5 then
        return false
    end

    return true
end

return M