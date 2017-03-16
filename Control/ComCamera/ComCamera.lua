-----------------------------------------------------------------------------------------------  
-- @description  
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ComBase = import("..ComBase")
local M = class(..., ComBase)

function M:ctor(coreControl)
    M.super.ctor(self, coreControl)
    --相机
    self.camera = nil
    self.transform_camera = nil

    --镜头参数
    self.x_rotation = 0
    self.y_rotation = 0
    self.distance = 10
    self.vec3_offset = Vector3.zero

    --镜头位置
    self.vec3_camera = Vector3.zero

    --设置默认参数
    self:SetRotation(150, 180)
    self:SetDistance(27)
    self:SetOffest(  Vector3.New(0,2.5,0) )
    self:Apply()

    CsProxy.CreatePrefab("UI/Main/MainCamera.prefab", nil, "Default", function(go)
        self.camera = go:GetComponent("Camera")
        self.transform_camera = self.camera.transform
    end)
end

function M:dispose()

end

function M:LateUpdate()
    local camera = self.camera
    if not camera then return end

    local viewEntity, modelEntity = self.comEntity:GetSelf()
    if not viewEntity then return end
    
    local go = viewEntity:GetGo()

    local vec3 = go.transform.position
    self.transform_camera.position = self.vec3_camera + vec3
    self.transform_camera:LookAt(vec3 + self.vec3_offset)

    CsProxy.UpdateSceneView(vec3, 30)
end

function M:SetRotation(x, y)
    self.x_rotation = x
    self.y_rotation = y
end

function M:SetDistance(distance)
    self.distance = distance
end

function M:SetOffest(vec3_offset)
    self.vec3_offset = vec3_offset
end

function M:Apply()
    local vec3 = Vector3.back * self.distance
    local quan = Quaternion.Euler(self.x_rotation, self.y_rotation, 0)
    self.vec3_camera = self.vec3_offset + quan * vec3
end




return M