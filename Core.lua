-----------------------------------------------------------------------------------------------  
-- @description  Core模块
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local M = class(...)

local CameraManager = import(".Camera.CameraManager")
M.CameraManager = CameraManager

local CoreControl = import(".CoreControl")

--切换Core场景
function M.LoadScene(params, fCallback, fErrorCallback )
    

    local cmdPlayer = GameCacheMgr.GetCmdX("CmdPlayer")

    Core.palyerId = cmdPlayer.playerId

    --params 参数
    --local transferRefId = params.transferRefId or ""
    --local targetSceneId = params.targetSceneId or ""

    coroutine.start(function()

        --请求数据
        ---[[
        local params = {
            transferRefId = "sceneArea_29",
        }
        local suc, cmdSceneEnterRspMsg = Network.Send2_cor("CmdSceneEnter", params)
        if not suc then
            if fErrorCallback then fErrorCallback() end
            return 
        end


        --获取场景配置表
        local refScene = RefMgr.RefScene.GetRef{
            refId = cmdSceneEnterRspMsg.sceneRefId
        }

        --切换场景
        local cor = CorUtil.new()
        SceneManager.LoadUnityScene({
            name = refScene.model,
            callback = function() cor:Resume() end })
        cor:Yield()    


        local coreControl = CoreControl.new(cmdPlayer.playerId)
        M.coreControl = coreControl

        local tlCmdScenePlayer = cmdSceneEnterRspMsg.tlCmdScenePlayer or {}
        local tlCmdSceneMonster = cmdSceneEnterRspMsg.tlCmdSceneMonster or {}

        for _, cmdSceneEntity in ipairs(tlCmdScenePlayer) do
            coreControl.comEntity:Add(cmdSceneEntity)
        end

        for _, cmdSceneEntity in ipairs(tlCmdSceneMonster) do
            coreControl.comEntity:Add(cmdSceneEntity)
        end

        if fCallback then fCallback() end
        

    end)
end

--协程版接口
function M.LoadScene_cor(params)
    local cor = CorUtil.new()
    M.LoadScene(params, 
        function()
            cor:Resume(true)
        end, 
        function()
            cor:Resume(false)
        end
    )
    return cor:Yield()
end

--
function M.GetPlayerId()
    return M.playerId
end

function M.GetCoreControl()
    return M.coreControl
end

function M.OnUpdate()
end

return M