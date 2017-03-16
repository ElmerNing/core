
-----------------------------------------------------------------------------------------------  
-- @description  Core的view对象管理
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ViewEntityPlayer = import(".View.ViewEntityPlayer")
local ViewEntityMonster = import(".View.ViewEntityMonster")

local M = class(...)


function M:ctor()    

    self.tmViewEntityPlayer = {}
    self.tmViewEntityMonster = {}


    --meta的key为cmdEnumSceneEntity的相关
    self.tmMeta = {}

    self.tmMeta.SceneEntity_Player = {
        class = ViewEntityPlayer,
        tmViewEntity = self.tmViewEntityPlayer,
    }

    self.tmMeta.SceneEntity_Monster = {
        class = ViewEntityMonster,
        tmViewEntity = self.tmViewEntityMonster,
    }
end

function M:dispose()
    for _, meta in pairs(self.tmMeta) do
        local tmViewEntity = meta.tmViewEntity
        for id, viewEntity in pairs(meta.tmViewEntity) do
            viewEntity:dispose()
            tmViewEntity[id] = nil
        end
    end
end

--遍历
function M:Walk(fCallback)
    if not fCallback then return end
    for _, meta in pairs(self.tmMeta) do
        local tmViewEntity = meta.tmViewEntity
        for id, viewEntity in pairs(meta.tmViewEntity) do
            fCallback(viewEntity)
        end
    end
end

--添加ViewEntity
function M:AddViewEntity(modelEntity)
    local cmdEnumSceneEntity = modelEntity:GetCmdEnumSceneEntity()
    local meta = self.tmMeta[cmdEnumSceneEntity]

    local viewEntity = meta.class.new(modelEntity)
    meta.tmViewEntity[ modelEntity:GetId() ] = viewEntity
    return viewEntity
end

--获取ViewEntity
function M:GetViewEntity(cmdSceneEntityKey)
    local cmdEnumSceneEntity = cmdSceneEntityKey.cmdEnumSceneEntity
    local meta = self.tmMeta[cmdEnumSceneEntity]
    return meta.tmViewEntity[ cmdSceneEntityKey.id ] 
end

--删除ViewEntity
function M:RemoveViewEntity(cmdSceneEntityKey)
    local cmdEnumSceneEntity = cmdSceneEntityKey.cmdEnumSceneEntity
    local meta = self.tmMeta[cmdEnumSceneEntity]
    local viewEntity = meta.tmViewEntity[ cmdSceneEntityKey.id ]  
    if not viewEntity then
        viewEntity:dispose()
        meta.tmViewEntity[ cmdSceneEntityKey.id ] = nil
    end
end



return M