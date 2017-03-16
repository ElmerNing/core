
local Cmd = import(".Cmd")
local M = Cmd.CreateSub(...,"CmdSceneMove")

function M:GetSpeed()
    return self.speed * 0.0001
end

function M:GetEulerAngle()
    return Vector3.New( self.moveX, self.moveY, self.moveZ ) * 0.0001
end

function M:Update(eulerAngle, speed, cmdEnumSceneMove)
    self.moveX = eulerAngle.x * 10000
    self.moveY = eulerAngle.y * 10000
    self.moveZ = eulerAngle.z * 10000
    self.moveW = 0
    self.speed = speed * 10000 --米每秒

    return self:Rebuild()
end


return M