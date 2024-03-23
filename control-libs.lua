require "__Hermios_Framework__.control-libs"
require "gui-libs"
require "prototypes.gui-elements.choose-elem-quantity-button"
require "prototypes.gui-elements.choose-elem-quantity-screen"

list_events.on_gui_action={}

local function update_gui(event)
	if event.element.get_mod()==get_gui_modname() then
		if event.element.tags.id then
			update_control_behavior()
		end
		if event.element.tags.on_action then
			_G[event.element.tags.on_action](event.element)
		end
	end
end

table.insert(list_events.on_gui_checked_state_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_click,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_elem_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_selected_tab_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_selection_state_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_switch_state_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_text_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_value_changed,function (event)
	for _,f in pairs(list_events.on_gui_action) do
		f(event)
	end
end)
table.insert(list_events.on_gui_action,function (event)
	update_gui(event)
end)

table.insert(list_events.on_gui_opened,function (event)
	open_gui(event.entity)
end)

table.insert(list_events.on_gui_closed,function ()
	if global.current_gui and global.current_gui.valid then
		global.current_gui.destroy()
	end
end)