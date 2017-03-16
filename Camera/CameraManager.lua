-----------------------------------------------------------------------------------------------  
-- @description  主相机
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

--提取
local CamCtrlDefault = import(".CamCtrl.CamCtrlDefault")


local M = class(...)
    
M.state = "idle" -- loading running

--相机
M.camera = nil

--相机控制器
M.camCtrl = nil

M.camCtrlDefault = nil

function M.GetCamera()
    return M.camera
end

function M.Start()
    assert(M.state ~= "loading")

    if M.state == "running" then return end
    
    M.state = "loading"
    CsProxy.CreatePrefab("UI/Main/MainCamera.prefab", Core.transRoot, "Default", function(go)
        M.camera = go:GetComponent("Camera")
        M.Enter()
    end)
end

function M.Enter()
    M.state = "running"
    --M.SetCamCtrlDefault(nil)
end

function M.Stop()
    assert(M.state == "running", "CoreCamera必须为running") 
    M.state = "idle"
    GameObject.Destroy(M.camera.gameObject)
    M.camera = nil
    if M.camCtrl then
        M.camCtrl:Stop()
    end
    M.camCtrl = nil
end

--
function M.SetCamCtrl(camCtrl)
    assert(M.state == "running", "CoreCamera必须为running") 
    --停止旧的camCtrl
    if M.camCtrl ~= nil then M.camCtrl:Stop() end
    --开启新的camCtrl
    if camCtrl then camCtrl:Start(M.camera) end
    --储存新的值
    M.camCtrl = camCtrl
end

function M.SetCamCtrlDefault()
    if not M.camCtrlDefault then
        M.camCtrlDefault = CamCtrlDefault.new()
    end
    M.SetCamCtrl(M.camCtrlDefault) 
end



return M