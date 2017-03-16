-----------------------------------------------------------------------------------------------  
-- @description  管理时间
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ComBase = import("..ComBase")
local M = class(..., ComBase)

function M:ctor(coreControl)
    M.super.ctor(self, coreControl)

    --第几次调用更新
    self.updateTimes = 0


    --临时处理
    self.time_offset = os.time() - Time.realtimeSinceStartup

end

function M:dipose()
end

function M:Update()
    self.updateTimes = self.updateTimes + 1
end

--单位秒
function M:GetDeltaTime()
    if self.updateTimes ~= self.updateTimes_deltaTime then
        self.deltaTime = Time.deltaTime
        self.updateTimes_deltaTime = self.updateTimes
    end
    return self.deltaTime
end

--单位秒
function M:GetServerTime()
    if self.updateTimes ~= self.updateTimes_serverTime then
        self.serverTime = Time.realtimeSinceStartup + self.time_offset
        self.updateTimes_serverTime = self.updateTimes
    end
    return self.serverTime
end





return M