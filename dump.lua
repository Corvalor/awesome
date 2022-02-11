local radical  = require("radical")
local debug = require("gears.debug")

local capi = {client = client,mouse=mouse}

local module = {}

local dumpWindow = nil

module.run = function(msg)
    local screen = capi.client.focus and capi.client.focus.screen or capi.mouse.screen
    if not dumpWindow then

        dumpWindow = radical.box {
            filter      = false,
            item_style  = radical.item.style.rounded,
            item_height = 45,
            column      = 1,
            layout      = radical.layout.grid,
            screen      = screen
        }

    end
    dumpWindow:clear()
    dumpWindow:add_item( { text = debug.dump_return( msg ) } )

    dumpWindow.screen = screen
    dumpWindow.visible = true
end

return module
