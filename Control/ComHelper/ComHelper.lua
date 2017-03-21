-----------------------------------------------------------------------------------------------  
-- @description  若干辅助函数
-- @author  ny
-- @coryright  蜂鸟工作室
-- @release  2017/11/30
--------------------------------------------------------------------------------------------

local ComBase = import("..ComBase")
local M = class(..., ComBase)


--判断一些列的点是否在 
function M:IsInPolygon(point, vs)
    -- ray-casting algorithm based on
    -- http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
    
    local x = point[1]
    local y = point[2]
    
    local inside = false;
    
    for i = 1,#vs do
        local j = i - 1
        if j == 0 then
            j=#vs
        end
    
        local pi = vs[i]
        local pj = vs[j]

        local xi, yi = pi[1],pi[2]
        local xj, yj = pj[1],pj[2]


        local  intersect = 
            ((yi > y) ~= (yj > y))
                and
            (x < (xj - xi) * (y - yi) / (yj - yi) + xi)

        if intersect then
            inside = not inside;
        end
    end

    return inside;
end


--单元测试
if false then
    local polygon = { { 1, 1 }, { 1, 2 }, { 2, 2 }, { 2, 1 } }
    assert( M:ptInPolygon({ 1.5, 1.5 }, polygon))
    assert( M:ptInPolygon({ 1.2, 1.9 }, polygon))
    assert( not M:ptInPolygon({ 0, 1.9 }, polygon))
    assert( not M:ptInPolygon({ 1.5, 2 }, polygon))
    assert( not M:ptInPolygon({ 1.5, 2.2 }, polygon))
    assert( not M:ptInPolygon({ 3, 5 }, polygon))
end


return M


