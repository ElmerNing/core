-----------------------------------------------------------------------------------------------  
-- @description  请求特效
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(...)


function M:ctor(path, fCallback)

    self.fCallback = fCallback

    self.go = nil

    self.transform = nil

    self.isDisposed = false

    self.lifeTime = 0

    --请求effect
    CsProxy.SpawnEffect(CsProxy.GetPrefabAssetPath(path), function(go)
        
        local go = go
        local transform = go.transform

        --已卸载
        if self.isDisposed then
            CsProxy.DespawnEffect(transform, 0)
            return
        end

        --缓存 unity 对象
        self.go = go
        self.transform = transform

        --回调
        if self.fCallback then
            self.fCallback(go, transform)
        end
    end)
end


function M:dispose()

    --如果已经销毁
    if self.isDisposed then
        return
    end

    --是否清理
    self.isDisposed = true

    --卸载特效
    if self.transform ~= nil then
        CsProxy.DespawnEffect(self.transform, 0)
    end

    --清除lua端的引用
    self.fCallback = nil
    self.go = nil
    self.transform = nil
end

return M