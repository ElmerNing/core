-----------------------------------------------------------------------------------------------  
-- @description  储存action的一些状态
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(..., function()
    return {
        isFrameStart = false,         --前摇是否开始
        isFrameBreak = false,         --中断帧是否已执行
        isFrameResponse = false,      --响应帧是否已执行
        isFrameEnd = false,           --后摇帧是否已经执行
    }
end)

--FrameStart
function M:GetIsFrameStart()
    return self.isFrameStart
end

function M:SetIsFrameStart(isFrameStart)
    self.isFrameStart = isFrameStart
end


--FrameBreak
function M:GetIsFrameBreak()
    return self.isFrameBreak
end

function M:SetIsFrameBreak(isFrameBreak)
    self.isFrameBreak = isFrameBreak
end


--FrameResponse
function M:GetIsFrameResponse()
    return self.isFrameResponse
end

function M:SetIsFrameResponse(isFrameResponse)
    self.isFrameResponse = isFrameResponse
end


--FrameEnd
function M:GetIsFrameEnd()
    return self.isFrameEnd
end

function M:SetIsFrameEnd(isFrameEnd)
    self.isFrameEnd = isFrameEnd
end


return M
