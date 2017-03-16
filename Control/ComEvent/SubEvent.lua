-----------------------------------------------------------------------------------------------  
-- @description  ComEvent的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local SubBase = import("..SubBase")



local M = class(..., SubBase)

function M:ctor(...)
    M.super.ctor(self, ...)
    self.tlObjEvent = {}
    self.comMove = self.com.comMove
end

function M:Update()

    --
    local tlObjEvent = self.tlObjEvent 
    if #tlObjEvent==0 then return end
    self.tlObjEvent = {}
    
    
    --排序
    table.sort(tlObjEvent, function(objEvent1, objEvent2)
        return objEvent1.eventIndex < objEvent2.eventIndex
    end)

    --modelEntity
    local modelEntity = self.modelEntity
    local cmdSceneHost = modelEntity:GetCmd("CmdSceneHost")



    --处理事件
    for _, objEvent in ipairs(tlObjEvent) do
        local protoName = objEvent.protoName
        local cmdSceneEvent = objEvent.cmdSceneEvent
        local func = self[protoName]

        assert(func, string.format("%s", protoName) )

        --事件索引过小 不处理
        if cmdSceneHost and cmdSceneHost.eventIndex >= objEvent.eventIndex then
            func(self, cmdSceneEvent)
        else
            func(self, cmdSceneEvent)
        end
    end

end

function M:AddObjEvent(objEvent)
    local tlObjEvent = self.tlObjEvent
    tlObjEvent[#tlObjEvent+1] = objEvent
end

-------------------------
-- 事件黑醋栗
-------------------------
function M:CmdSceneMoveEvent(cmdSceneMoveEvent)
 
    local modelEntity = self.modelEntity 

    --更新数据
    local cmdSceneHost = modelEntity:GetCmd("CmdSceneHost")
    if cmdSceneHost then
        cmdSceneHost:UpdateProto(cmdSceneMoveEvent.cmdSceneHost)
    end

    local cmdSceneMove = modelEntity:GetCmd("CmdSceneMove")
    if cmdSceneMove then
        cmdSceneMove:UpdateProto(cmdSceneMoveEvent.cmdSceneMove)
    end

    local cmdScenePosition = modelEntity:GetCmd("CmdScenePosition")
    if cmdScenePosition then
        cmdScenePosition:UpdateProto(cmdSceneMoveEvent.cmdScenePosition)
    end
    self.comMove:MoveTo(
        modelEntity:GetCmdSceneEntityKey(), cmdScenePosition:GetVec3()
    )
end

--
function M:CmdSceneHostEvent(cmdSceneHostEvent)
end

function M:CmdSceneAttackEvent(cmdSceneAttackEvent)
end

function M:CmdSceneAttackEffectEvent(cmdSceneAttackEffectEvent)
end

------------------------
--ObjEvent
------------------------
local ObjEvent = class(...)
M.ObjEvent = ObjEvent
function ObjEvent:ctor(protoName, cmdSceneEvent)
    self.protoName = protoName
    self.cmdSceneEvent = cmdSceneEvent

    --索引
    local cmdSceneHost = cmdSceneEvent.cmdSceneHost
    self.eventIndex = cmdSceneHost.eventIndex
end


return M
