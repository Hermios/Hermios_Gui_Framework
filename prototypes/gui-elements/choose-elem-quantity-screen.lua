local opened_elem_quantity_screen

choose_elem_quantity_screen={group_items={}}
choose_elem_quantity_screen.gui={
    name="elem-quantity-button-screen", type="frame", direction="vertical", tags={
        children={
            {name="groups",type="frame",direction="horizontal"},
            {name="sub-groups",type="frame",direction="vertical"},
            {name="quantity",type="frame",direction="vertical",tags={
                children={
                    {name="title",type="label",caption={"gui.or-set-a-constant"}},
                    {name="data",type="frame", direction="horizontal",tags={
                        children={
                            {name="slider", type="slider",tags={on_action="elem_quantity_screen_synchronize_slider_textfield_quantity"}},
                            {name="textfield", type="textfield",style="slider_value_textfield",numeric=true,allow_negative=false,allow_decimal=false,tags={on_action="elem_quantity_screen_synchronize_slider_textfield_quantity"}},
                            {name="validation", type="button",caption={"gui.set"},style="item_and_count_select_confirm",tags={on_action="close_elem_quantity_screen"}}
                        }
                    }}
                }}
            }
        }
    }
}

function choose_elem_quantity_screen:new(calling_element)
    if opened_elem_quantity_screen then
        opened_elem_quantity_screen.gui.destroy()
    else
        self:init_group_items()
    end

    -- add to gui
    local gui=add_guielement(game.get_player(1).gui.center,choose_elem_quantity_screen.gui)

    -- set new object
    local o={
        gui=gui,
        calling_button=calling_element,
        is_or=calling_element.tags.is_or,
        groups=gui.groups,
        sub_groups=gui["sub-groups"],
        quantity=gui.quantity,
        slider=gui.quantity.data.slider,
        textfield=gui.quantity.data.textfield
    }
    o.quantity.title.visible=o.is_or

    -- Add to event on gui closed
    table.insert(list_events.on_gui_closed,function ()
        if o.gui and o.gui.valid then
            o.gui.destroy()
        end
    end)

    setmetatable(o,self)
    self.__index=self
    o:set_quantity_enabled()
    opened_elem_quantity_screen=o
    -- Load groups
    for name,group in pairs(game.item_group_prototypes) do
        local filepath="item-group/"..name
        if self.group_items[name] and (not calling_element.parent.group_filter or calling_element.parent.group_filter==name) then
            local group=o.groups.add{type="sprite-button",style="filter_group_button_tab_slightly_larger",sprite=filepath,name=name,tooltip=group.localised_name,auto_toggle=true,tags={on_action="elem_quantity_screen_on_group_selected"}}
            o.selected_group=o.selected_group or group
        end
    end
    local value_to_load=get_or_set_elem_quantity_button(calling_element)
    o.selected_sprite=type(value_to_load)=="table" and value_to_load.sprite
    local item=get_item_from_spritepath(o.selected_sprite)
    o.selected_group=item and o.groups[item.group.name] or o.selected_group
    o.selected_group.toggled=true
    o:on_group_selected()
    if value_to_load then
        o.textfield.text=tostring(type(value_to_load)=="number" and value_to_load or value_to_load.count)
        o:synchronize_slider_textfield(o.textfield)
    end
end

function choose_elem_quantity_screen:init_group_items()
    self.group_items["logistics"]={game.get_filtered_item_prototypes,"item"}
    self.group_items["transport-logistics"]={game.get_filtered_item_prototypes,"item"}
    self.group_items["production"]={game.get_filtered_item_prototypes,"item"}
    self.group_items["intermediate-products"]={game.get_filtered_item_prototypes,"item"}
    self.group_items["combat"]={game.get_filtered_item_prototypes,"item"}
    self.group_items["fluids"]={game.get_filtered_fluid_prototypes,"fluid"}
    self.group_items["signals"]={get_filtered_signal_prototypes,"virtual-signal"}
    self.group_items["other"]={game.get_filtered_item_prototypes,"item"}
end

function choose_elem_quantity_screen:set_item(selected_sprite_button)
    if self.selected_sprite_button then
        self.selected_sprite_button.toggled=false
    end
    self.selected_sprite=selected_sprite_button.toggled and selected_sprite_button.sprite
    self:update_calling_button(get_signal_from_spritepath(self.selected_sprite))
    if self.is_or then
        self.gui.destroy()
    else
        self:set_quantity_enabled()
    end
end

function choose_elem_quantity_screen:set_quantity_enabled()
    for _,child in pairs(self.quantity.children[2].children) do
        child.enabled=self.is_or or self.selected_sprite
    end
end

function choose_elem_quantity_screen:on_group_selected(lua_gui_element)
    if lua_gui_element then
        self.selected_group.toggled=false
        self.selected_group=lua_gui_element
        self.sub_groups.clear()
    end
    local i=0
    local gui_subgroup
    for _,subgroup in pairs(game.item_group_prototypes[self.selected_group.name].subgroups) do
        for _,item in pairs(self.group_items[self.selected_group.name][1]({{filter="subgroup", subgroup=subgroup.name}})) do
            i=i+1
            if (i-1)%10==0 then
                gui_subgroup=self.sub_groups.add{type="flow",direction="horizontal"}
            end
            local sprite_button=gui_subgroup.add{type="sprite-button",auto_toggle=true,name=item.name,tooltip=item.localised_name,sprite=get_spritepath_from_item(item),tags={on_action="elem_quantity_screen_set_item"}}
            if sprite_button.sprite==self.selected_sprite then
                sprite_button.toggled=true
                self.selected_sprite_button=sprite_button
            end
            
        end
    end
end

function choose_elem_quantity_screen:synchronize_slider_textfield(lua_gui_element)
    if self.textfield.text=="nil" then
        self.textfield.text="0"
    end
    if lua_gui_element.type=="slider" then
        self.textfield.text=tostring(lua_gui_element.slider_value)
    elseif lua_gui_element.text~="" then
        self.slider.slider_value=tonumber(self.textfield.text) or 0
    end
    self:update_calling_button(tonumber(self.textfield.text))
end

function choose_elem_quantity_screen:update_calling_button(value)
    local data_to_update=
        self.is_or and value or
        (not self.is_or and {count=tonumber(self.textfield.text) or 0,signal=get_signal_from_spritepath(self.selected_sprite)})
    get_or_set_elem_quantity_button(self.calling_button,data_to_update)
end

function elem_quantity_screen_set_item(lua_gui_element)
    opened_elem_quantity_screen:set_item(lua_gui_element)
end

function elem_quantity_screen_on_group_selected(lua_gui_element)
    opened_elem_quantity_screen:on_group_selected(lua_gui_element)
end

function elem_quantity_screen_synchronize_slider_textfield_quantity(lua_gui_element)
	opened_elem_quantity_screen:synchronize_slider_textfield(lua_gui_element)
end

function close_elem_quantity_screen()
    opened_elem_quantity_screen.gui.destroy()
end