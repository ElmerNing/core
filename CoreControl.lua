-----------------------------------------------------------------------------------------------  
-- @description  Core模块Controller
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local moduleName = ...


local M = class(...)

--创建
function M:ctor(playerId)

    self.playerId = playerId

    self.tlCom = {}

    self.tmCom = {}

    --实体组件, 主要管理 实体对象的 添加删除 等
    self.comEntity = self:AddCom( "comEntity", import(".Control.ComEntity.ComEntity", moduleName) )

    --移动组件, 主要管理 实体 的移动, 同步实体的位置信息等等
    self.comMove = self:AddCom("comMove", import(".Control.ComMove.ComMove", moduleName) ) 

    --时间组件
    self.comTime = self:AddCom( "comTime", import(".Control.ComTime.ComTime", moduleName) )

    --网络组件
    self.comNet = self:AddCom( "comNet", import(".Control.ComNet.ComNet", moduleName) )

    --事件组件
    self.comEvent = self:AddCom( "comEvent", import(".Control.ComEvent.ComEvent", moduleName) )

    --摄像机组件
    self.comCamera = self:AddCom( "comCamera", import(".Control.ComCamera.ComCamera", moduleName) )

    --动画组件
    self.comAnimator = self:AddCom( "comAnimator", import(".Control.ComAnimator.ComAnimator", moduleName) )

    --技能组件
    self.comSkill = self:AddCom( "comSkill", import(".Control.ComSkill.ComSkill", moduleName)  )

    --目标组件
    self.comTarget = self:AddCom( "comTarget", import(".Control.ComTarget.ComTarget", moduleName)  )

    --帮助函数
    self.comHelper = self:AddCom( "comHelper", import(".Control.ComHelper.ComHelper", moduleName)  )

    --帮助函数
    self.comEffect = self:AddCom( "comEffect", import(".Control.ComEffect.ComEffect", moduleName)  )

    --同步组件 放到最后面
    self.comSync = self:AddCom( "comSync", import(".Control.ComSync.ComSync",moduleName) )

    

    --所有组件执行 init 初始化 函数 
    self:ComExcute("init")

    --Update 和 lateUpdate
    UpdateBeat:Add(self.Update, self)
    LateUpdateBeat:Add(self.LateUpdate, self)
end


--析构
function M:dispose()
    --移除
    UpdateBeat:Remove(self.Update, self)
    LateUpdateBeat:Remove(self.LateUpdate, self)

    --销毁组件
    self:ComExcute("dispose")
end

function M:GetPlayerId()
    return self.playerId
end

--添加组件
function M:AddCom( name, class)

    local ret, msg = pcall(function() 
    
        local com = class.new(self)
        self.tlCom[ #self.tlCom + 1 ] = com
        self.tmCom[name] = com
        return com

    end)
    if not ret then
        Log.Print(msg)
    end
    
    return msg
end

function M:Update()
    local ret, msg = pcall(function() 
        --销毁组件
        self:ComExcute("Update")
    end)
    if not ret then
        Log.Print(msg)
    end
    
    
end


function M:LateUpdate()

    local ret, msg = pcall(function() 
        self:ComExcute("LateUpdate")
    end)
    if not ret then
        Log.Print(msg)
    end
    
    
end

function M:ComExcute(funcName)
    for _, com in ipairs(self.tlCom) do
        local func = com[funcName]
        if func then

            local ret, msg = pcall(function() 
                func(com)
            end)
            if not ret then
                Log.Print(msg)
            end
            
            
        end
    end
end






return M