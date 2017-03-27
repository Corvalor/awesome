local radical  = require("radical")
local tag_menu = require( "radical.impl.common.tag" )

local capi = {client = client,mouse=mouse}

local module = {}

local centered = nil

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function vertical_convert( a, columns, total_size )
   rows = math.ceil( total_size / columns )
   tmp = 1000 * ((a - 1) % rows) + math.floor((a - 1) / rows )
   return tmp
end

function order_vertical( columns )
    return function( t, a, b )
       return vertical_convert(a, columns, #t) < vertical_convert(b, columns, #t)
    end
end

module.centered_menu = function(layouts,backward)
    local screen = capi.client.focus and capi.client.focus.screen or capi.mouse.screen
    if not centered then

       local columns = 4
        centered = radical.box {
            filter      = false,
            item_style  = radical.item.style.rounded,
            item_height = 45,
            column      = columns,
            layout      = radical.layout.grid,
            screen      = screen
        }

	local tmp = client_mode_order
	while #tmp % columns ~= 0 do
	   tmp[ #tmp + 1 ] = {}
	end

	for k, v in spairs( client_mode_order, order_vertical(columns) ) do
	   if client_mode[v] then
	      centered:add_item( { text = v .. " = " .. client_mode[v].h } )
	   else
	      centered:add_item( { text = "" } )
	   end
	end
    end
    centered.screen = screen
    centered.visible = true
end

return module
