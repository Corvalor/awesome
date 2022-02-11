local json         = require( "lain.util.dkjson" )
local inspect      = require( "inspect" )

local task_all = {}

local function parse( status_filter )
    local value = {}
    local f = io.popen( "task status:"..status_filter.." export" )
    local task_data = json.decode(f:read("*all"))
    if task_data ~= nil then
        for i=1, #task_data do
        local entry = {}
        entry.id = task_data[i].id
        entry.description = task_data[i].description
        value[i] = entry
        end
    end
    return value
end

local function worker( format, warg )
    local pending = parse( "pending" )
    local waiting = parse( "waiting" )

    return {
       count_pending = #pending,
       pending = pending,
       count_waiting = #waiting,
       waiting = waiting
    };
end

return setmetatable( task_all, { __call = function(_, ...) return worker(...) end })
