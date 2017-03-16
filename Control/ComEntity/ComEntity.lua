-----------------------------------------------------------------------------------------------  
-- @description  管理所有Entity
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local ComBase = import("..ComBase")
local M = class(..., ComBase)

local CoreModel = import("...CoreModel")
local CoreView = import("...CoreView")

--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl)

    --数据
    self.coreModel = CoreModel.new()

    --显示
    self.coreView = CoreView.new()

    --事件中心
    self.eventproxy = EventProxy.new()

    --玩家自身对象
    self.viewEntityPlayer_self = nil
    self.modelEntityPlayer_self = nil
end

--析构函数
function M:dispose()
    self.coreModel:dispose()
    self.coreView:dispose()
end


function M:GetEventProxy()
    return self.eventproxy
end

--添加实体
function M:Add(cmdSceneEntity)
    --数据
    local modelEntity = self.coreModel:AddModelEntity(cmdSceneEntity)
    --界面
    local viewEntity = self.coreView:AddViewEntity(modelEntity)

    --如果是玩家对象
    if modelEntity:GetCmdEnumSceneEntity() == "SceneEntity_Player" then 
        --是否是玩家
        if modelEntity:GetId() == self.coreControl:GetPlayerId() then
            self.viewEntityPlayer_self = viewEntity
            self.modelEntityPlayer_self = modelEntity
        end
    end

    --分发事件
    self.eventproxy:Brocast("Add", viewEntity, modelEntity )
end

--获取实体
function M:Get(cmdSceneEntityKey)
    local modelEntity = self.coreModel:GetModelEntity(cmdSceneEntityKey)
    local viewEntity = self.coreView:GetViewEntity(cmdSceneEntityKey)
    return viewEntity, modelEntity
end



--删除
function M:Remove(cmdSceneEntityKey)
    --数据
    self.coreModel:RemoveModelEntity(cmdSceneEntity)
    --界面
    self.coreModel:RemoveViewEntity(cmdSceneEntity)

    --是否是玩家自己
    if cmdSceneEntityKey.cmdEnumSceneEntity == "SceneEntity_Player" then 
        --是否是玩家
        if cmdSceneEntityKey.id == self.coreControl:GetPlayerId() then
            self.viewEntityPlayer_self = nil
            self.modelEntityPlayer_self = nil
        end
    end

    --分发事件
    self.eventproxy:Brocast( "Remove", cmdSceneEntityKey )
end

--获取实体View
function M:GetView(cmdSceneEntityKey)
    local viewEntity = self.coreView:GetModelEntity(cmdSceneEntityKey)
    return viewEntity
end

--获取实体Model
function M:GetModel(cmdSceneEntityKey)
    local viewEntity = self.coreModel:GetModelEntity(cmdSceneEntityKey)
    return viewEntity 
end

--获取自身
function M:GetSelf()
    return self.viewEntityPlayer_self, self.modelEntityPlayer_self
end

--自身model
function M:GetModelSelf()
    return self.modelEntityPlayer_self
end

--自身View
function M:GetViewSelf()
    return self.viewEntityPlayer_self
end

--获取自身的key
function M:GetCmdSceneEntityKeySelf()
    local modelEntity = self.modelEntityPlayer_self
    if modelEntity then
        return modelEntity:GetCmdSceneEntityKey()
    end
end

--遍历实体
function M:Walk(fCallback)
    if not fCallback then return end
    self.coreModel:Walk(function(modelEntity)
        local viewEntity = self.coreView:GetViewEntity( modelEntity:GetCmdSceneEntityKey() )
        fCallback(viewEntity, modelEntity)
    end)
end

--遍历实体View
function M:WalkView(fCallback)
    self.coreView:Walk( fCallback )
end

--遍历实体Model
function M:WalkModel(fCallback)
    self.coreModel:Walk( fCallback )
end

--打印当前全部
function M:Dump()

    
end

return M