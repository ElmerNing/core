-----------------------------------------------------------------------------------------------  
-- @description  ComMove的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")

local RequestEffect = import(".RequestEffect")

local M = class(..., SubBase)





function M:ctor(...)
    M.super.ctor(self, ...)

    --缓存身上的
    self.tmRequestEffect = {}
end

function M:dispose()

    --销毁
    for _, request in pairs(self.tmRequestEffect) do
        request:dispose()
    end

    M.super.dispose(self)
end


--返回请求effect的句柄
-- local request = self:AddEffect()
-- request:dispose()
-- request = nil
function M:AddEffect(path, parentName, time, fCallback)
    local viewEntity = self.viewEntity

    --请求特效
    local requestEffect = RequestEffect.new(path, function(go, transform)
        local transform_parent = viewEntity:FindTransform(parentName)
        if transform_parent then
            transform.parent = transform_parent
            transform.localPosition = Vector3.zero
            if fCallback then
                fCallback(go, transform)
            end
        end
    end)

    --设置销毁回调
    requestEffect:SetDisposeCallback(function()
        self.tmRequestEffect[requestEffect] = nil
    end)

    --储存句柄
    self.tmRequestEffect[requestEffect] = requestEffect

    --设置effect的生命
    if time then
        Timer.New(function ()
            requestEffect:dispose()
            requestEffect = nil
        end, time, 1):Start()
    end

    return requestEffect
end




return M