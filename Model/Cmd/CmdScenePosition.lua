

local Cmd = import(".Cmd")
local M = Cmd.CreateSub(...,"CmdScenePosition")

function M:Distance(cmdScenePosition)
    return math.sqrt( self:SqrDistance(cmdScenePosition) )
end

function M:SqrDistance(cmdScenePosition)
    local dx = (cmdScenePosition.x - self.x) * 0.0001
    local dy = (cmdScenePosition.y - self.y) * 0.0001
    local dz = (cmdScenePosition.z - self.z) * 0.0001
    return dx*dx + dy*dy + dz*dz
end

--近似距离
function M:SimilarDistance(cmdScenePosition)
    local dx = (cmdScenePosition.x - self.x) * 0.0001
    local dy = (cmdScenePosition.y - self.y) * 0.0001
    local dz = (cmdScenePosition.z - self.z) * 0.0001
    return dx + dy + dz
end

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