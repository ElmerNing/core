
-----------------------------------------------------------------------------------------------  
-- @description  CmdX的一些基类 方便使用
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local Proto = Network.Proto
local M = class(...)

function M:ctor(protoName)
    self.protoName = protoName
    self.eventProxy = EventProxy.new()
end

function M:GetEventProxy()
    return self.eventProxy
end

function M:GetProtoName()
    return self.protoName
end

function M:UpdateProto(cmdX_new)
    local tmFieldChange = Proto.UpdateProto(self.protoName, self, cmdX_new)
    if not tmFieldChange then
        self:Brocast(tmFieldChange)
    end
end

function M:AddListener(f)
    return self.eventProxy:AddListener("event", f)
end

function M:RemoveListener(f)
    self.eventProxy:RemoveListener("event", f)
end

function M:Brocast(tmFieldChange)
    self.eventProxy:Brocast("event", tmFieldChange)
end

function M:Rebuild()
    return Proto.Build(self.protoName, self)
end

function M.CreateSub(classname, protoName)
    --父类
    local Cmd = M

    --子类
    local M = class(classname,  Cmd, function(cmdX)
        return Proto.Build(protoName, cmdX)
    end )

    function M:ctor(cmdX)
        M.super.ctor(self, protoName)
    end

    return M

end

return M