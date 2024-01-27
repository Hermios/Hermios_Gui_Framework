# *_Please send any request to Github (See Source URL!)_*
This mods lets use the gui part of the Hermios Framework. It works using the same principles

# Why this mod
## Static description
This mods lets describe guis statistically:
Instead of using command "add" to add in runtime the children, simply describe the content once for all, then when the gui will be open, children will be added automatically

## Storage of data
Data for an entity are automatically stored in the global table __custom_entities__ for this entity, under the key __control_behavior__ with appropriate structure. When reopening the gui for an entity, data are automatically loaded, and the gui appears exactly like it was before closing

## Dynamic children
This mods includes a mechanism to handle dynamic children, for example when a frame shall display a list of sub elements, and this list may vary.
By declaring dynamic children, a button "add" is automatically set, and buttons "x" are as well added for each child, to remove it

## Extra tools
This mods includes a new lua gui element, named choose-elem-quantity-button, which has the same role as the choose-elem-button, with an extra frame to choose quantity (like for instance in combinator, to check if a signal shall be compared to another one, or to a constant)
More details below

# require
During the data stage, the line ```require "__Hermios_Gui_Framework__.data-libs"``` must be called
During the runtime stage, the line ```require "__Hermios_Gui_Framework__.control-libs"``` must be called

# How to use
The same way a prototype must be registered in custom_prototypes, define a gui for an element (via its type, name, train or any) using the table **custom_guis**
Then, in the value for this element, describes the gui for the element.
## Global options
the gui to describe handle following options:
- position (mandatory): where the screen shall be displayed (top, left, center, screen). See LuaGui object for more information
- clear_default (optional, default false): If set to true, the original screen of the item won't be displayed. Shall be set to true, when the entity to open is a new creation, based on an existing entity
- gui (mandatory): description of the gui

description for each lua gui element is as described in the help of Factorio. Some extra options are available, that must be stored in the __tags__ attribute of the element.
- id (string): if set, the content of the lua gui element will be stored for this entity, as value, and id is the key
- children (array): children of this element, list of lua gui elements 
- get_or_set (string to a function): the mod can handle default setter/getter per type of lua gui element (for instance, textfield return the text, sprite-button the sprite etc). this option lets override this default behavior. It is indeed a string (tags don't allow functions), that point to a function, with input paramters __lua_gui_element__, and __value__. When __value__ is set, it is a setter for the lua_gui_element, otherwise the function shall return the value expected
- model (array): Define dynamic children. It contains an array of children expected, as template. 
When applied, a button to add is automtically set, and for each child, a button to remove them is automatically set too. The element which use this option shall be a container (flow or frame). 
This will work only if an id has been set
- add_text(string): used in case of model, to override the default text of the button to add children
- on_load (string to function): function to execute when loading the element
- on_action (string to function): function to execute when a change happened on this element.__This is not necessary to set an action to store data, the mod handle this part on his own__

## choose-elem-quantity-button
This new lua gui element can be used as others (But require the framework to work).
It generated a "button", that will display either an item, with or without number, or a constant.
When clicking on the button, this opens a new screen which let choose item or quantity or both.
The element has 3 possible outputs:
- If only constant, it returns a number
- If only sprite, it returns a signalID table {type,name}
- If both, it returns a signal table {count,{type,name}}
It has 1 option:
- is_or: if set, the button will behave to deliver either a signalid or a constant number.

Full example of use of this mod can be found with the mod Logistic Train Scheduler