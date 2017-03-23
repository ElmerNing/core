-----------------------------------------------------------------------------------------------  
-- @description  ComState的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")
local M = class(..., SubBase)


function M:ctor(...)
    M.super.ctor(self, ...)

    --当前的协程
    self.cor = nil

    --trigger, 用于update中恢复协程
    self.trigger = nil

    --当前状态对象
    self.subStateBase = nil

    --当前状态对象
    self.subStateBase_next = nil

    --进入下一状态的参数列表
    self.tlParam_next = {}

    --开启一个协程, 所有的subStateBase的Main都运行于此协程中
    coroutine.wrap(function()
        
        self.cor = CorUtil.new()
        self:Loop_cor()

    end)()
end

function M:dispose()

    --退出协程
    self.cor:Resume(false)

    M.super.dispose(self)
end

function M:Update()

    --判断triiger是否触发
    if self.trigger then
        local tlRet = { self.trigger() }
        local ret = tlRet[1]
        --成功触发
        if ret then
            self.trigger = nil
            --恢复
            self.cor:Resume( unpack(tlRet) )
        end
    end
end

--获取当前的sub状态
function M:GetSubStateBase()
    return self.subStateBase
end

--主循环
function M:Loop_cor()

    --等待下一帧
    local function triggerOfNextFrame()
        local i = 0
        return function()
            i = i + 1
            return i >= 2
        end
    end

    --主循环
    while true do
        self:Main_cor()
        --等下一帧
        self:Wait_cor( triggerOfNextFrame() )

        --如果被销毁了 直接停止
        if self.isDisposed then return end
    end
end

function M:Main_cor()
    while true do
        if self.subStateBase_next then
            
            --切换状态
            self.subStateBase = self.subStateBase_next
            self.subStateBase_next = nil

            --切换参数
            local tlParam = self.tlParam_next
            self.tlParam_next = nil

            --切换到状态
            self.subStateBase:Main_cor( unpack( tlParam ) )

            --执行完毕. 当前的subState设置为空
            self.subStateBase = nil
        else
            break
        end
    end
end

--等待一个触发器
function M:Wait_cor(fTrigger)

    local tlRet = { fTrigger() }
    --成功触发
    local ret = tlRet[1]
    if ret then
        return unpack(tlRet)
    end
    --等待触发
    self.trigger = fTrigger
    local tlRet = { self.cor:Yield() }
    self.trigger = nil
    return unpack(tlRet)
end


--恢复到这个状态
function M:ResumeTo(subStateBase, ...)


    self.subStateBase_next = subStateBase
    self.tlParam_next = {...}

    --如果有上一个状态
    
    --中断上一次
    self.cor:Resume(false)
    
end




return M
