-----------------------------------------------------------------------------------------------  
-- @description  ComSkill的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")
local M = class(..., SubBase)

function M:ctor(...)
    M.super.ctor(self, ...)
    

    --目标entity的key
    self.cmdSceneEntityKey_target = nil
    --self.nextSkill 
    --self.skillRefId
end

--锁敌方式
local tmTlCmdEnumSceneEntity = {
    SceneEntity_Player = { "SceneEntity_Monster" },
    SceneEntity_Monster = { "SceneEntity_Player" },
}

--获取当前目标
function M:GetTarget()
    return self.cmdSceneEntityKey_target
end

--重新寻找目标
-- distance_min 搜索半径
function M:FindTarget(distance_min)
    local modelEntity = self.modelEntity
    local cmdEnumSceneEntity = self.modelEntity:GetCmdEnumSceneEntity()

    --锁敌方式
    local tlCmdEnumSceneEntity = tmTlCmdEnumSceneEntity[cmdEnumSceneEntity]

    --
    assert(tlCmdEnumSceneEntity and #tlCmdEnumSceneEntity > 0, string.format( "类型%s未定义相应的锁敌类型", cmdEnumSceneEntity) )
    return self:FindTargetByEnum(tlCmdEnumSceneEntity, distance_min)
end

--寻找最近的目标, 并修改当前的target, GetTarget
function M:FindTargetByEnum(tlCmdEnumSceneEntity, distance_min)

    local cmdScenePosition_self = self.modelEntity:GetCmd("CmdScenePosition")

    --当前最小距离 以及相应的key
    distance_min = distance_min or 999999
    local cmdSceneEntityKey_min = nil

    --entity组件
    local comEntity = self.com.comEntity

    --搜索其中一项是否满足要求
    local function Search(modelEntity)
        --近似距离, 计算快一些
        local cmdScenePosition = modelEntity:GetCmd("CmdScenePosition")
        local distance = cmdScenePosition_self:SqrDistance(cmdScenePosition)

        --和当前最小值比较
        if distance < distance_min*distance_min then
            distance_min = distance
            cmdSceneEntityKey_min = modelEntity:GetCmdSceneEntityKey()
        end
    end

    --遍历查找 (未来可能要优化 加速)
    for _, cmdEnumSceneEntity in ipairs(tlCmdEnumSceneEntity) do
        comEntity:WalkModel(Search, cmdEnumSceneEntity)
    end

    --切换
    self.cmdSceneEntityKey_target = cmdSceneEntityKey_min

    --返回
    return cmdSceneEntityKey_min
end


--获取附近的人
function M:SearchTlTargetByEnum(tlCmdEnumSceneEntity, distance_min)

    local cmdScenePosition_self = self.modelEntity:GetCmd("CmdScenePosition")

    --当前最小距离 以及相应的key
    distance_min = distance_min or 10

    --entity组件
    local comEntity = self.com.comEntity

    local tlCmdSceneEntityKey = {}

    --搜索其中一项是否满足要求
    local function Search(modelEntity)
        --近似距离, 计算快一些
        local cmdScenePosition = modelEntity:GetCmd("CmdScenePosition")
        local distance = cmdScenePosition_self:SqrDistance(cmdScenePosition)

        --和当前最小值比较
        if distance < distance_min*distance_min then
            tlCmdSceneEntityKey[#tlCmdSceneEntityKey + 1] = modelEntity:GetCmdSceneEntityKey()
        end
    end

    --遍历查找 (未来可能要优化 加速)
    for _, cmdEnumSceneEntity in ipairs(tlCmdEnumSceneEntity) do
        comEntity:WalkModel(Search, cmdEnumSceneEntity)
    end

    --返回
    return tlCmdSceneEntityKey
end




return M