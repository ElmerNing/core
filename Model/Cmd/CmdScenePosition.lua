

local Cmd = import(".Cmd")
local M = Cmd.CreateSub(...,"CmdScenePosition")

function M:GetVec3()
    return Vector3.New(self.x, self.y, self.z) * 0.0001
end

function M:SetVec3(vec3)
    self.x = vec3.x * 10000
    self.y = vec3.y * 10000
    self.z = vec3.z * 10000
    return self:Rebuild()
end

return M