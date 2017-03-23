-----------------------------------------------------------------------------------------------  
-- @description  请求一次攻击
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(...)


function M:ctor(subSkill, attackEventIndex, actionRefId, refAttackFrameEvent)
    





    --储存一些变量方便计算
    self.viewEntity = subSkill:GetViewEntity()
    self.modelEntity = subSkill:GetModelEntity()
    self.comEntity = subSkill.com.comEntity

    --自身
    local cmdSceneEntityKey = subSkill:GetCmdSceneEntityKey()

    --获取目标类型
    local subTarget = subSkill.com.comTarget:GetSub(cmdSceneEntityKey)
    local tlCmdEnumSceneEntity, isIncludeSelf = self:GetTlCmdEnumSceneEntity(refAttackFrameEvent.targetType)

    --快速搜索附近,获取潜在的目标列表
    local tlCmdSceneEntityKey  = subTarget:SearchTlTargetByEnum(tlCmdEnumSceneEntity)

    --目标包括自己则加入自己
    if isIncludeSelf then
        tlCmdSceneEntityKey[#tlCmdSceneEntityKey+1] = cmdSceneEntityKey
    end    

    --通过攻击范围进行过滤
    local tmCmdSceneEntityKey = tlCmdSceneEntityKey
    self:FiltByArea(tmCmdSceneEntityKey, refAttackFrameEvent:GetArea() )
   


    ---------------------------------
    --攻击到的目标
    ---------------------------------
    self.tmCmdSceneEntityKey = tmCmdSceneEntityKey

    --Log.Dump(self.tmCmdSceneEntityKey)

    ---------------------------------
    --受击动画
    ---------------------------------
    --播放受击动画, 这部分需要考虑状态切换 to do
    --local comAnimator = subSkill.com.comAnimator
    for _, key in pairs(tmCmdSceneEntityKey) do
        
        --播放受击动画
        local subHit = self.comEntity:GetSub(key, "comHit")
        subHit:PlayHit(cmdSceneEntityKey, refAttackFrameEvent)
    end


    ---------------------------------
    -- buff
    ---------------------------------

    -- todo

    ---------------------------------
    --计算伤害
    ---------------------------------
    local tlCmdSceneAttackDamageEffect = {}
    for _, cmdSceneEntityKey in ipairs(tmCmdSceneEntityKey) do        
        local cmd = self:ComputeCmdSceneAttackDamageEffect(cmdSceneEntityKey)
        tlCmdSceneAttackDamageEffect[#tlCmdSceneAttackDamageEffect+1] = cmd
    end

    ---------------------------------
    --同步数据
    ---------------------------------
    local modelEntity = self.modelEntity
    local cmdSceneHost= modelEntity:GetCmd("CmdSceneHost")
    if cmdSceneHost and cmdSceneHost:GetIsMyHost() and #tlCmdSceneAttackDamageEffect > 0 then
        local cmdSceneAttackEffectEvent = {
            cmdSceneEntityKey_attack            = modelEntity:GetCmdSceneEntityKey(),
            cmdSceneHost                        = modelEntity.cmdSceneHost:NextCmdHost(),
            attackEventIndex                    = attackEventIndex,
            actionRefId                         = actionRefId,
            frameRefId                          = refAttackFrameEvent.refId,
            tlCmdSceneAttackDamageEffect        = tlCmdSceneAttackDamageEffect,
        }
        subSkill.com.comNet:SendCmdSceneAttackEffectEvent(cmdSceneAttackEffectEvent)
    end
end 

function M:dispose()
end

--是否有击中
function M:GetIsHit()
    return next(self.tmCmdSceneEntityKey) ~= nil
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

end

--转换到本地坐标系
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

--获取是否在圆形area内
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

--获取是否在扇形area内
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

--获取是否在矩形area内
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

--计算伤害
function M:ComputeCmdSceneAttackDamageEffect(cmdSceneEntityKey_target)

    local modelEntity_target = self.comEntity:GetModel(cmdSceneEntityKey_target)
    local modelEntity_attack = self.modelEntity


    local cmdBattleProperty_attack = modelEntity_attack:GetCmd("CmdSceneEntityBattleProperty")
    local cmdBattleProperty_target = modelEntity_target:GetCmd("CmdSceneEntityBattleProperty")


    ---------------------------------
    --各种伤害计算 to do
    ---------------------------------

    --返回伤害
    local cmdSceneAttackDamageEffect = {
        cmdSceneEntityKey = modelEntity_target:GetCmdSceneEntityKey(),
        cmdEnumSceneAttackEffect = "SceneAttackEffect_Damage",
        number = 10,
    }

    return cmdSceneAttackDamageEffect
end

return M