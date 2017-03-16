-----------------------------------------------------------------------------------------------  
-- @description  玩家实体数据
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ModelEntityActor = import(".ModelEntityActor")



local M = class(..., ModelEntityActor)


function M.CreateCmdScenePlayer()
    local cmdScenePlayer = {};

    local cmdScenePosition = {
        x = 25,
        y = 1.46,
        z = 69.57,
    }

    local cmdSceneMoveInfo = {
        moveX = 0,
        moveY = 0,
        moveZ = 0,
        cmdMoveType = "rocker",
    }


    cmdScenePlayer.cmdScenePlayer = cmdScenePlayer
    cmdScenePlayer.cmdSceneMoveInfo = cmdSceneMoveInfo


end

function M:ctor(cmdScenePlayer)

    M.super.ctor(self, cmdScenePlayer)
    


end

return M