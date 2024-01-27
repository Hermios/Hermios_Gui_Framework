local choose_elem_quantity_button={}
local choose_elem_quantity_gui_data={}
choose_elem_quantity_button.gui={type="flow",tags={
        children={
            {name="sprite-button",type="sprite-button",tags={on_action="open_elem_quantity_screen"}},
            {name="button", style="elem-quantity-button",type="button",tags={on_action="open_elem_quantity_screen",on_load="finish_loading_elem_quantity_screen"}}
        },
        get_or_set="get_or_set_elem_quantity_button"
    }
}
custom_gui_prototypes["choose-elem-quantity-button"]=choose_elem_quantity_button

function choose_elem_quantity_button:new(lua_gui_element)
    local o=self.gui
    o.tags.is_or=lua_gui_element.is_or
    for k,v in pairs(lua_gui_element.tags) do
        o.tags[k]=v
    end
    return o
end

function open_elem_quantity_screen(lua_gui_element)
    choose_elem_quantity_screen:new(lua_gui_element.parent)
end

local function update_elem_quantity_button_data(lua_gui_element)
    lua_gui_element["sprite-button"].visible=true
    lua_gui_element["button"].visible=false
    local value=get_or_set_elem_quantity_button(lua_gui_element)
    if not value then
        return
    end
    if type(value)=="number" then
        lua_gui_element["button"].visible=true
        lua_gui_element["button"].caption=tostring(value)
        lua_gui_element["sprite-button"].visible=false
    elseif value.count then
        lua_gui_element["sprite-button"].number=value.count
        lua_gui_element["sprite-button"].sprite=get_spritepath_from_signal(value.signal)
    else
        lua_gui_element["sprite-button"].sprite=get_spritepath_from_signal(value)
    end

end

function get_or_set_elem_quantity_button(lua_gui_element,value)
    if value then
        choose_elem_quantity_gui_data[lua_gui_element.index]=value
        table.insert(list_events.on_gui_closed,function ()
            choose_elem_quantity_gui_data={}
        end)
        if #lua_gui_element.children>0 then
            update_elem_quantity_button_data(lua_gui_element)
            update_control_behavior()
        end
    else
        return choose_elem_quantity_gui_data[lua_gui_element.index]
    end
end

function finish_loading_elem_quantity_screen(lua_gui_element)
    update_elem_quantity_button_data(lua_gui_element.parent)
end