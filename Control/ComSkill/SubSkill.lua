-----------------------------------------------------------------------------------------------  
-- @description  ComSkill的Sub
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------
local SubBase = import("..SubBase")
local M = class(..., SubBase)

function M:ctor(...)
    M.super.ctor(self, ...)
    
    --entity组件
    self.comEntity = self.com.comEntity

    --目标entity的key
    self.cmdSceneEntityKey_target = nil
    --self.nextSkill 
    --self.skillRefId
end

function M:Update()

end

function M:PushSkill(skillRefId)

end


--寻找目标
function M:FindTarget()
    

    self
end




return M