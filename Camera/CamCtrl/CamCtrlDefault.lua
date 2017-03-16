-----------------------------------------------------------------------------------------------  
-- @description  默认镜头控制
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local CamCtrl = import(".CamCtrl")
local M = class(..., CamCtrl)

--只有一个MainController
M.cameraController = nil

function M:ctor(camera)
    M.super.ctor(self, camera)
end

function M:GetCameracontroller()
    if M.cameraController then
        return M.cameraController
    end

    local cameraController = self.camera:GetComponent("CameraController")
    if not cameraController then
        cameraController = self.camera.gameObject:AddComponent( typeof(CameraController) )
    end


    --默认参数
    cameraController.distanceMin = 2.3
    cameraController.distanceMax = 30
    cameraController.swipeSpeed = 0.8
    cameraController.smoothSwipeFactor = 0.1


    cameraController:InitHeroMoveCtrl(self.camera,HeroInputManager.OnClickMap,HeroInputManager.OnJoystickMove,
               HeroInputManager.OnJoystickStateChange)

    --初始化参数
    M.cameraController  = cameraController



    return M.cameraController
end

function M:Start(camera)
    self.camera = camera

    local cameraController = self:GetCameracontroller()
    cameraController.target = Core.ActorManager.heroEntity.modelView.transform

    local pos = Vector3.up;

    pos.y = 2.5;
    cameraController:SetDefaultLookAt(-150, 33.9,27, pos)

    pos.y = 1.04;
    cameraController.minLookAtOffset = pos;
    cameraController:Init();

    cameraController.CanPinch=true
    cameraController.CanSwipeX=true
    cameraController.CanSwipeY=true

    cameraController:EnableJoystick(true)
    if not cameraController.enabled then
        cameraController.enabled = true   
    end
end

function M:Stop()
    local cameraController = self:GetCameracontroller()

    cameraController.enabled = false
    cameraController:EnableJoystick(false)
end

function M:LookAtImmediately()
    local cameraController = self:GetCameracontroller()
    cameraController:LookAtImmediately()
end

return M