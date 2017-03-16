-----------------------------------------------------------------------------------------------  
-- @description  Core模块数据层
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ModelEntityPlayer = import(".Model.ModelEntityPlayer")
local ModelEntityMonster = import(".Model.ModelEntityMonster")

local M = class(...)



function M:ctor()

    --player的容器
    self.tmModelEntityPlayer = {}

    --monster的容器
    self.tmModelEntityMonster = {}

    --若干
    self.tmMeta = {}

    --
    self.tmMeta.SceneEntity_Player = {
        class = ModelEntityPlayer,
        tmModelEntity = self.tmModelEntityPlayer,
    }

    self.tmMeta.SceneEntity_Monster = {
        class = ModelEntityMonster,
        tmModelEntity = self.tmModelEntityMonster,
    }
end

function M:dispose()
    for _, meta in pairs(self.tmMeta) do
        local tmModelEntity = meta.tmModelEntity
        for id, modelEntity in pairs(tmModelEntity) do
            modelEntity:dispose()
            tmModelEntity[id] = nil
        end
    end
end

--获取全部
function M:GetTmMeta()
    return self.tmMeta
end

--遍历
function M:Walk(fCallback)
    if not fCallback then return end
    for _, meta in pairs(self.tmMeta) do
        local tmModelEntity = meta.tmModelEntity
        for id, modelEntity in pairs(tmModelEntity) do
            fCallback(modelEntity)
        end
    end
end

--添加ModelEntity
function M:AddModelEntity(cmdSceneEntity)
    local meta = self.tmMeta[cmdSceneEntity.cmdEnumSceneEntity]
    local modelEntity = meta.class.new(cmdSceneEntity)
    meta.tmModelEntity[cmdSceneEntity.id] = modelEntity
    return modelEntity
end

--获取ModelEntity
function M:GetModelEntity(cmdSceneEntityKey)
    local meta = self.tmMeta[cmdSceneEntityKey.cmdEnumSceneEntity]
    return meta.tmModelEntity[cmdSceneEntityKey.id]
end

--删除MOdelEntity
function M:RemoveModelEntity(cmdSceneEntityKey)
    local meta = self.tmMeta[cmdSceneEntityKey.cmdEnumSceneEntity]
    local modelEntity = meta.tmModelEntity[cmdSceneEntityKey.id]

    --销毁
    if modelEntity then
        modelEntity:dispose()
        meta.tmModelEntity[cmdSceneEntityKey.id] = nil   
    end
end









return M
