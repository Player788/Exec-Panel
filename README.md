# Documentation

Exec UI Library

## Loading the Library

```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/Exec-Panel/main/src.lua'))()
```

### Creating a Window

```lua
local Window = Library:Window{
	Name = <string>, 
	Creator = <string>,
	Script = <string>,
	Hotkey = {
		Key = <Enum.KeyCode>, 
		Enabled = <boolean>
	},
	Saves = {
		FileId = <string>,
		Enabled = <boolean>
	},
	KeySystem = {
		Enabled = <boolean>,
		External = <boolean>,
		Key = "", -- URL of raw site if External is true.
	},
	Sounds = <boolean>
}
```

***

### Creating a Section

```lua
local Section = Window:Section{Name = <string>, Image = <string>}
```

***

### Creating a Notification

```lua
Library:Notification{<number : 0 or 1 or 2>, Content = <string>}
```

***

### Creating a Button

```lua
Section:AddButton{
	Name = <string>,
	TextColor = <Color3>,
	Callback = <function>,
}
```

* You need to state your element as a variable to get its methods, Example `local Button = Section:AddButton{}`
* You can also chain element methods, Example `LeftSection:AddButton{}:AddButton{}`

#### Methods

```lua
Button:Set(<string>)
Button:Destroy()
```

***

### Creating a Toggle

```lua
Section:AddToggle{
	Name = <string>,
	TextColor = <Color3>,
	Default = <boolean>,
	Callback = <function> <returns : boolean>
}
```

#### Methods

```lua
Toggle:Set(<boolean>)
Toggle:Destroy()
```

***

### Creating a Slider

```lua
Section:AddSlider{
	Name = <string>,
	TextColor = <Color3>,
	Default = <number>,
	Min = <number>,
	Max = <number>,
	Increment = <number>,
	Callback = <function> <returns : number>
}
```

#### Methods

```lua
Slider:Set(<number>)
Slider:Destroy()
```

***

### Creating a Textbox

```lua
Section:AddTextBox{
	Name = <string>,
	TextColor = <Color3>,
	PressEnter = <boolean>,
	ClearOnFocus <boolean>,
	Default = <string>,
	Placeholder = <string>,
	Callback = <function> <returns : string>
}

```

#### Methods

```lua
Input:Set(<string>)
Input:Destroy()
```

***

### Creating a Keybind

```lua
Section:AddBind{
	Name = <string>,
	TextColor = <Color3>,
	Default = <Keycode : EnumItem>
	Hold = <boolean>,
	Callback = <function> <returns : <string> <holding : boolean>
}
```

#### Methods

```lua
Bind:Set(KeyCode : EnumItem)
Bind:Destroy()
```

***

### Creating a Dropdown

```lua
Section:AddDropDown{
	Name = <string>,
	Default = <any>,
	Options = <table>,
	Callback = function(Value)
		print(Value)
	end
}
```

#### Methods

```lua
Dropdown:Refresh(<options : table>, <clear : boolean>)
Dropdown:Remove(<index>)
Dropdown:Set(<index>)
```

***

### Creating a Colorpicker

```lua
Section:AddColor{
	Name = <string>,
	TextColor = <Color3>,
	Callback = <function> <returns : <color3>
}
```

#### Methods

```lua
Colorpicker:Set(<color3>)
```

***

## Miscellaneous

### Saves (Filesystem)

* Flags are used as global variables to store (Values, Tables, etc.) Toggles, Sliders, Dropdowns & binds. Adding a flag value will automatically save its configs. Example:

```lua
Section:AddToggle{
    Name = "Toggle",
    Default = true,
    Flag = "toggle"
}
```
* Use `Library:Get(<Flag : string>)` to get an element's value
Example:

```lua
print(Library:Get(<Flag : string>).Value)
```

#### Methods

### Window Methods
```lua
Window:Save()
Window:Load() -- Always add at last or in a button
```

### Library Methods

```lua
Library:Destroy()
Library:Get(<Flag : string>) <returns element>
```
