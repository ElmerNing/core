
local SubBase = import(".SubBase")
local M = class(..., SubBase)


function M:ctor(...)

    M.super.ctor(self, ...)

    local tlName = string.split(self.__cname, ".")
    self.name = tlName[#tlName]
end

--获取此状态管理
function M:GetSubStateMgr()
    if not self.subStateMgr then
        self.subStateMgr = self.com.comStateMgr:GetSub( self.cmdSceneEntityKey )
    end
    return self.subStateMgr
end

--等待一个Trigger
function M:Wait_cor(fTrigger)
    return self:GetSubStateMgr():Wait_cor(fTrigger)
end

--合并若干trigger, 其中全部触发成功 才成功
function M:AndTriggers(...)
    local tlTrigger = {...}

    return function()
        local tlRet = {}
        local isTrigger = true
        for _, trigger in ipairs() do
            local ret = { trigger() }
            tlRet[#tlRet+1] = ret

            --其中一个触发失败, 则失败
            if not ret[1] then isTrigger = false end
        end

        return isTrigger, tlRet

    end
end

--合并若干Triiger, 其中一个触发成功 则成功
function M:OrTirggers(...)
    local tlTrigger = {...}
    return function()
        local tlRet = {}
        local isTrigger = false
        for _, trigger in ipairs(tlTrigger) do
            local ret = { trigger() }
            tlRet[#tlRet+1] = ret
            if ret[1] then isTrigger = true end
        end
        return isTrigger, tlRet
    end
end


--时间触发器, 从time_start后经过time后, 触发, time_start为空 代表从当前时间
function M:TriggerOfTime(time, time_start)
    local time_start = time_start or self:GetTime()
    return function()
        local time_now = self:GetTime()
        return time_start + time <= time_now
    end
end

--获取当前时间 单位秒
function M:GetTime()
    local comTime = self.com.comTime
    return comTime:GetServerTime()
end


--恢复到当前状态
function M:Resume(...)

    --获取当前的状态管理者
    local subStateMgr = self:GetSubStateMgr()
    subStateMgr:ResumeTo(self, ...)
end


--获取当前状态是否正在运行
function M:GetIsRunning()
    local subStateMgr = self:GetSubStateMgr()
    return self == subStateMgr:GetSubStateBase()
end

---------------------------------
--以下是子类需要继承的方法
---------------------------------

--切换当前状态的主函数, 协程接口
function M:Main_cor()
end


function M:GetName()
    return self.name
end

return M