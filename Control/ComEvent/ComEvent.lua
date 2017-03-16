-----------------------------------------------------------------------------------------------  
-- @description  管理相关事件
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local ComBaseWithSub = import("..ComBaseWithSub")
local SubEvent = import(".SubEvent")
local ObjEvent = SubEvent.ObjEvent

local M = class(..., ComBaseWithSub)



--构造函数
function M:ctor(coreControl)
    M.super.ctor(self, coreControl, SubEvent)

    --消息映射
    local tm = {
        CmdSceneAddEntityAppMsg     = self.OnAdd,
        CmdSceneDeleteEntityAppMsg  = self.OnRemove,
        CmdSceneMoveAppMsg          = self.OnMove,
        CmdSceneHostAppMsg          = self.OnHost,
        CmdSceneAttackAppMsg        = self.OnAttack,
        CmdSceneAttackEffectAppMsg  = self.OnAttackEffect,
    }

    --储存注册句柄
    local tmHandler = {}
    self.tmHandler = tmHandler
    
    for msgName, func in pairs(tm) do
        tmHandler[msgName] = Event.AddListener(msgName, handler(self, func) )
    end
end

function M:dispose()

    --
    for msgName, handler in ipairs(self.tmHandler) do
        Event.RemoveListener(msgName, handler)
    end
    --
    M.super.dispose(self)
end

--添加entiy
function M:OnAdd(cmdSceneAddEntityAppMsg)

    local function AddTl(tlCmdSceneEntity)
        for _, cmdSceneEntity in ipairs(tlCmdSceneEntity) do
            self.comEntity:Add(cmdSceneEntity)
        end
    end

    local tlCmdScenePlayer = cmdSceneAddEntityAppMsg.tlCmdScenePlayer
    if tlCmdScenePlayer then
        AddTl( tlCmdScenePlayer )        
    end
    local tlCmdSceneMonster = cmdSceneAddEntityAppMsg.tlCmdSceneMonster
    if tlCmdSceneMonster then
        AddTl(tlCmdSceneMonster)
    end
    
end

--删除enttiy
function M:OnRemove(cmdSceneDeleteEntityAppMsg)
    local tlCmdSceneEntityKey = cmdSceneDeleteEntityAppMsg.tlCmdSceneEntityKey
    if not tlCmdSceneEntityKey then return end
    for _, key in ipairs(tlCmdSceneEntityKey) do
        self.comEntity:Remove(key)
    end
end

--移动
function M:OnMove(cmdSceneMoveAppMsg)
    local cmdSceneMoveEvent = cmdSceneMoveAppMsg.cmdSceneMoveEvent
    local subEvent = self:GetSub(cmdSceneMoveEvent.cmdSceneEntityKey)

    --添加event
    if subEvent then
        subEvent:AddObjEvent( ObjEvent.new("CmdSceneMoveEvent",cmdSceneMoveEvent) )
    end
end

--主机
function M:OnHost(cmdSceneHostAppMsg)
    local cmdSceneHostEvent = cmdSceneHostAppMsg.cmdSceneHostEvent
    local subEvent = self:GetSub(cmdSceneHostAppMsg.cmdSceneEntityKey)

    if subEvent then
        subEvent:AddObjEvent( ObjEvent.new("CmdSceneHostEvent", cmdSceneHostEvent) )
    end
end

--攻击
function M:OnAttack(cmdSceneAttackAppMsg)

end

--攻击特效
function M:OnAttackEffect(cmdSceneAttackEffectAppMsg)

end




return M