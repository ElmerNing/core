-----------------------------------------------------------------------------------------------  
-- @description  Actor的实体的, 怪物 Player等
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ViewEntity = import(".ViewEntity")

local M = class(..., ViewEntity)

--碰撞类型
local obstacleAvoidanceType = UnityEngine.AI.ObstacleAvoidanceType.NoObstacleAvoidance

function M:ctor(modelEntity)
    M.super.ctor(self, modelEntity)

    --导航Agent
    self.navMeshAgent = CsProxy.GetNavMeshAgent( self.go_parent )
    local navMeshAgent = self.navMeshAgent

    --设置速度
    navMeshAgent.speed = modelEntity:GetMoveSpeed()

    navMeshAgent.stoppingDistance = 0
    navMeshAgent.acceleration = 99999
    navMeshAgent.angularSpeed = 99999
    navMeshAgent.obstacleAvoidanceType = obstacleAvoidanceType

    --动画
    self.animator = nil

end

--获取导航NavMeshAgent
function M:GetNavMeshAgent()
    return self.navMeshAgent
end

--返回动画
function M:GetAnimator()
    return self.animator
end

-------------------------------------
--以下是可以重写的方法
-------------------------------------

function M:OnEntityLoaded()

    self.animator = CsProxy.GetAnimator(self.go_entity)

end

function M:OnEntityUnloaded()
    self.animator = nil
    self.tmAnimatorClipLength = nil
end



return M