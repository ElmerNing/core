-----------------------------------------------------------------------------------------------  
-- @description  实体对象view基类
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(...)

--创建
function M:ctor(modelEntity)

    --绑定的数据
    self.modelEntity = modelEntity

    --挂接的go
    self.go_parent = GameObject.New()
    self.transform_parent = self.go_parent.transform

    self.go_parent.name = self:GetHierachyName()

    --设置为非激活
    self.go_parent:SetActive(false)

    --状态
    self.state = "loading"


    --实体go 和 transform
    self.go_entity = nil
    self.transform_entity = nil
    --实体对应的路径
    self.path_entity = nil

    --位置初始化
    local cmdScenePosition = modelEntity:GetCmd("CmdScenePosition")
    self.transform_parent.position = cmdScenePosition:GetVec3()

    --
    local path = self:GetEntityPath()
    if path and path ~= "" then
        self:LoadEntity( path )
    end
end

--释放
function M:dispose()
    M:UnloadEntity()
    GameObject.Destroy( self.go_parent )
end

function M:GetPosition()
    return self.transform_parent.position
end

function M:SetPosition(vec3)
    self.transform_parent.position = vec3
end

function M:GetEulerAngles()
    return self.transform_parent.eulerAngles
end

function M:LookAt(vec3)
    self.transform_parent:LookAt(vec3)
end

--获取go
function M:GetGo()
    return self.go_parent
end


--是否有Entity加载
function M:GetIsEntityLoaded()
    return self.go_entity ~= nil
end

--加载Entity
function M:LoadEntity(path)
    --实体相同
    if self.path_entity == path then
        return
    end

    self.path_entity = path

    if self.path_entity == nil then
        self:UnloadEntity()
        return
    end


    CsProxy.SpawnActor( CsProxy.GetPrefabAssetPath( path ), function(go)

        --加载完成后, 发现path_entity变了, 直接不用
        if self.path_entity ~= path then
            CsProxy.DespawnActor(go.transform, 0)
            return
        end

        local isFirstLoad = self:GetIsEntityLoaded() == false

        --加载成功
        self.go_entity = go
        self.transform_entity = go.transform

        self.transform_entity.position = self.transform_parent.position

        --挂在父节点
        self.transform_entity.parent = self.transform_parent

        --激活成功
        self.go_parent:SetActive(true)

        --Entity加载成功
        self:OnEntityLoaded(isFirstLoad)
    end )
end

--卸载实体
function M:UnloadEntity()
    if self.transform_entity then
        --
        CsProxy.DespawnActor(self.transform_entity, 0);

        self.transform_entity = nil
        self.go_entity = nil
        self.path_entity = nil

        --entity卸载
        self:OnEntityUnloaded()
    end
end




--释放
function M:dispose()
end

function M:GetModelEntity()
    return self.modelEntity
end

-------------------------------------
--以下是可以重写的方法
-------------------------------------

--获取显示在Hireachy上的名字
function M:GetHierachyName()
    return tostring( self.modelEntity:GetId() )
end

--获取模型的Path
function M:GetEntityPath()
    assert(false, "子类 应重写GetPrefabPath")
end

--当模型加载完成
function M:OnEntityLoaded(isFirstLoad)

end

--当模型被卸载
function M:OnUnloadEntity()
    
end

return M
