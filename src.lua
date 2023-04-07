_G.Version = "1I"
setclipboard(_G.Version)
local Library = {
	Logs = {},
	Flags = {},
}
Library.__index = Library

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/Player788/luau1/main/lib2.lua"))()
local Create = Utils.Create
local Headshot = Utils.Headshot
local UserId = Utils.GetUserId
local Date = Utils.Date
local Tween = Utils.Tween
local MouseHover = Utils.MouseHover
local BoolToString = Utils.BoolToString
local toJSON = Utils.toJSON
local toTable = Utils.toTable
local EnumToString = Utils.EnumToString
local Drag = Utils.Drag
local OnClick = Utils.Click

local Exec = game:GetObjects("rbxassetid://12651264749")[1]
Exec.Enabled = true
local Main = Exec.Main
local Init = Main.Init
local Top = Main.Top Utils.Drag(Top, Main)
local NoteFrame = Exec.Noties.Note
local Elements = Main.ElementsScroll
local Section = Elements.Section
local Header = Elements.Header
local TextButton = Elements.Button
local ToggleButton = Elements.Toggle
local InputBox = Elements.Textbox
local KeybindButton = Elements.Keybind
local Slider = Elements.Slider
local Colorpicker = Elements.Colorpicker local Colorpicker_Frame = Init.Colorpicker
local Dropdown = Elements.Dropdown local Dropdown_Options = Elements.Dropdown_Options local OptTemp = Elements.Option
local Label = Elements.Label

local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

if syn then
	syn.protect_gui(Exec)
	Exec.Parent = game.CoreGui
elseif gethui then
	Exec.Parent = gethui()
else
	Exec.Parent = game.Players.LocalPlayer.PlayerGui
end

function Index(Table, Key)
	for _, v in next, Table do
		if v == Key then
			return true
		end
	end
end

--function HereditaryAnim(instance, properties, value, excluded)
--	for i,v in pairs(properties) do
--		pcall(function()
--			if instance[v] then
--				Tween(instance, v, 1)
--			end
--		end)
--	end
--	for i, v in pairs(instance:GetDescendants()) do
--		if v:IsA("GuiBase2d") then
--			for x, y in pairs(properties) do
--				pcall(function()
--					if v[y] then
--						if not excluded[v] then
--							Tween(v, y, 1)
--						end

--					end
--				end)
--			end
--		end
--	end
--end

function Library:Notification(Table)
	wait(0.5)
	spawn(function()
		table.insert(Library.Logs, Table.Content)
		local note = NoteFrame:Clone()
		note.Parent = Exec.Noties
		note.Message.Label.Text = Table.Content or ""
		if typeof(Table[1]) == "number" then
			local type_ = Table[1]
			if type_ == 0 then
				note.Type.ImageButton.Image = "rbxassetid://7733658271"
				note.Type.ImageButton.ImageColor3 = Color3.fromRGB(255 ,50, 50)
			elseif type_ == 1 then
				note.Type.ImageButton.Image = "rbxassetid://7733749837"
				note.Type.ImageButton.ImageColor3 = Color3.fromRGB(85, 170, 255)
			elseif type_ == 2 then
				note.Type.ImageButton.Image = "rbxassetid://7733715400"	
				note.Type.ImageButton.ImageColor3 = Color3.fromRGB(85, 170, 127)
			end
		end
		note.Transparency = 1
		note.Message.Label.TextTransparency = 1
		note.Type.ImageButton.ImageTransparency = 1
		note.Visible = true
		Tween(note, "Transparency", 0)
		Tween(note.Message.Label, "TextTransparency", 0)
		Tween(note.Type.ImageButton, "ImageTransparency", 0)

		-- highlight
		local highlight = note.Highlight
		highlight.BackgroundColor3 = note.Type.ImageButton.ImageColor3
		Tween(highlight, "Size", UDim2.fromScale(1.05,1.4), "Out", "Linear", 0.5)
		Tween(highlight, "BackgroundTransparency", 1, "Out", "Linear", 0.5)

		wait(Table.Time or 5)
		Tween(note, "Transparency", 1)
		Tween(note.Message.Label, "TextTransparency", 1)

		local final = Tween(note.Type.ImageButton, "ImageTransparency", 1)
		final.Completed:Connect(function()
			note:Destroy()
		end)

	end)
end

function Library:Window(Table)

	local Window = {
		Name = Table.Name or "Panel", 
		Creator = Table.Creator or "Exec",
		Script = Table.Script or "Script",
		Hotkey = {
			Key = Enum.KeyCode.Semicolon, 
			Enabled = true
		},
		Saves = {
			FileId = "raw",
			Enabled = false
		},
		Sounds = Table.Sounds or "true",
		KeySystem = {
			Enabled = true,
			External = false,
			Key = "", -- URL of raw site if External is true.
		},
		Flag = Table.Flag or false
	}

	local Access = false
	if Table.Hotkey then
		Window.Hotkey.Enabled = Table.Hotkey.Enabled or Window.Hotkey.Enabled
		Window.Hotkey.Key = Table.Hotkey.Key or Window.Hotkey.Key
	end
	if Table.Saves then
		Window.Saves.Enabled = Table.Saves.Enabled or Window.Saves.Enabled
		Window.Saves.FileId = Table.Saves.FileId or Window.Saves.FileId
		if not isfolder(Window.Saves.FileId) then
			makefolder(Window.Saves.FileId)
		end	
	end

	-- Loading
	Exec.Main.ElementsScroll.Visible = false
	Top.Visible = false
	Init.Note2.Text = Window.Name .. " by " .. Window.Creator
	Init.Note.Visible = true
	Init.Note2.Visible = true
	Init.Visible = true

	if Table.KeySystem and Table.KeySystem.Enabled then
		Window.KeySystem.Enabled = Table.KeySystem.Enabled or Window.KeySystem.Enabled
		Window.KeySystem.External = Table.KeySystem.External or Window.KeySystem.External
		Window.KeySystem.Key = Table.KeySystem.Key or Window.KeySystem.Key

		if Window.KeySystem.External then
			local Success, Response = pcall(function()
				Window.KeySystem.Key = game:HttpGet(Window.KeySystem.Key)
			end)
			if not Success then
				Library:Warn(Window.KeySystem.Key.." Error " ..tostring(Response))
			end	
		end
		if not Access then
			local Attempts = math.random(3,5)
			Init.Frame.Visible = true
			Init.Frame.Textbox.FocusLost:Connect(function(Enter)
				if Enter then
					if Init.Frame.Textbox.Text == Window.KeySystem.Key then
						Tween(Init.Frame, "BackgroundTransparency", 1)
						Tween(Init.Frame.Textbox, "TextTransparency", 1)
						Tween(Init.Note, "Position", UDim2.fromScale(0.5, 0.45))
						Tween(Init.Note2, "Position", UDim2.fromScale(0.5, 0.55))
						wait(0.3)
						Tween(Init.Note, "TextTransparency", 1, "InOut", "Linear", 0.1)
						wait(0.1)
						Init.Note.Text = "Loading.."
						Tween(Init.Note, "TextTransparency", 0, "InOut", "Linear", 0.1)
						--Top.Visible = true
						--Exec.Main.ElementsScroll.Visible = true
						Access = true
					else
						Library:Warn("Invalid key, try again!")
						if Attempts == 0 then
							game.Players.LocalPlayer:Kick("KeySystem attempt limit exceeded")
						end
						Attempts -=1
					end
				end
			end)

		end
	else
		Tween(Init.Note, "Position", UDim2.fromScale(0.5, 0.45))
		Tween(Init.Note2, "Position", UDim2.fromScale(0.5, 0.55))
		wait(0.3)
		Tween(Init.Note, "TextTransparency", 1, "InOut", "Linear", 0.1)
		wait(0.1)
		Init.Note.Text = "Loading.."
		Tween(Init.Note, "TextTransparency", 0, "InOut", "Linear", 0.1)
		Access = true
	end

	if Window.KeySystem then
		repeat wait() until Access
	end

	local Sections = {}
	Sections.__index = Section

	local Elements = {}
	Elements.__index = Elements

	Top.Box.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		local Search = string.lower(Top.Box.TextBox.Text)
		for i, v in pairs(Elements) do
			if typeof(v) ~= "table" and v:IsA("Frame") then
				v.Parent.Visible = false
				if Search ~= "" then
					local Opt_ = string.lower(v.Name)
					if string.find(Opt_, Search) then
						v.Parent.Visible = true
					end
					if Search == Opt_ then
						Tween(v.Frame, "BackgroundTransparency", 0)
						wait(0.3)
						Tween(v.Frame, "BackgroundTransparency", 1)
					end
				elseif Search == "" then
					v.Parent.Visible = true
				end
			end
		end
	end)

	function Window:Save()
		local Data = {}
		for i,v in pairs(Library.Flags) do
			if v.Type == "Colorpicker" then
				Data[i] = {R = v.Value.R * 255, G = v.Value.G * 255, B = v.Value.B * 255}
			elseif v.Type == "Bind" then
				Data[i] = v.Value.Name
			else
				Data[i] = v.Value
			end
		end
		writefile(Window.Saves.FileId .. "/" .. game.GameId .. ".txt", tostring(HttpService:JSONEncode(Data)))
	end

	function Window:Load()
		if isfile(Window.Saves.FileId .. "/" .. game.GameId .. ".txt") then
			local file = readfile(Window.Saves.FileId .. "/" .. game.GameId .. ".txt")
			local Data = HttpService:JSONDecode(file)
			for i,v in pairs(Data) do
				if Library.Flags[i] then
					spawn(function() 
						if Library.Flags[i].Type == "Colorpicker" then
							Library.Flags[i]:Set(Color3.fromRGB(v.R, v.G, v.B))
						elseif Library.Flags[i].Type == "Bind" then
							Library.Flags[i]:Set(Enum.KeyCode[v])
						else
							Library.Flags[i]:Set(v)
						end    
					end)
				else
					Library:Warn("Filesystem could not find flag '" .. i .."'")
				end
			end
			Library:Notification{2, Content = "Save loaded!"}
		end
	end

	function Window:AddSection(Table, Parent)
		local Section_mt = setmetatable({}, Sections)
		Section_mt.Name = Table.Name or "Section"
		Section_mt.Image = Table.Image or "rbxassetid://7733917120"
		Section_mt.Flag = Table.Flag or #Elements
		local Section = Section:Clone() 
		Section.Name = Section_mt.Name
		Section.Parent = Table.Parent or Exec.Main.ElementsScroll
		local newHeader = Header:Clone() newHeader.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
		newHeader.Parent = Section
		newHeader.Icon.Image = Section_mt.Image
		newHeader.Label.Text = Section_mt.Name
		newHeader.Visible = true Section.Visible = true

		--table.insert(Elements, Section)

		-- Label
		function Section_mt:AddLabel(Table)
			local Label_mt = setmetatable({
				Name = Table.Name or Table.Text or "Label",
				CopiedText = Table.CopiedText or self.Name,
				TextColor = Table.TextColor or Color3.fromRGB(150,150,150),
				Flag = Table.Flag or #Elements,
			}, Elements)
			local Label = Label:Clone() 
			Label.Parent = Section or Main.ElementsScroll
			Label.Frame.TextButton.Text = Label_mt.Name
			Label.Frame.TextButton.TextColor3 = Label_mt.TextColor
			Label.Name = Label_mt.Name
			Label.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			Label.Visible = true

			table.insert(Elements, Label)	

			local Click = OnClick{Label, function() 
				local x,y = pcall(function()
					--Label_mt.Callback()
					setclipboard(Label_mt.CopiedText)
					print(Label_mt.CopiedText)
				end)
				if not x then Library:Warn(y) end
			end}

			Utils.ProxyHover(Click, Label.Frame, "BackgroundTransparency", 0,1)

			function Label_mt:AddLabel(Table)
				return Section_mt:AddLabel(Table)
			end

			function Label_mt:Set(Name : string | number)
				Label.Frame.TextButton.Text = tostring(Name)
			end
			function Label_mt:Destroy()
				Label:Destroy()
			end
			Library.Flags[Label_mt.Flag] = Label_mt
			return Label_mt
		end

		-- Button
		function Section_mt:AddButton(Table)
			local Button_mt = setmetatable({
				Name = Table.Name or "Button",
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Image = Table.Image or "rbxassetid://7734010405",
				Callback = Table.Callback or function() end,
				Flag = Table.Flag or #Elements,
			}, Elements)

			local Button = TextButton:Clone() 
			Button.Parent = Section or Main.ElementsScroll
			Button.Frame.Icon.Image = Button_mt.Image
			Button.Frame.TextButton.Text = Button_mt.Name
			Button.Frame.TextButton.TextColor3 = Button_mt.TextColor
			Button.Name = Button_mt.Name
			Button.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			Button.Visible = true

			table.insert(Elements, Button)	

			local Click = OnClick{Button, function() 
				local x,y = pcall(function()
					Button_mt.Callback()
				end)
				if not x then Library:Warn(y) end
			end}

			Utils.ProxyHover(Click, Button.Frame, "BackgroundTransparency", 0,1)

			function Button_mt:AddButton(Table)
				return Section_mt:AddButton(Table)
			end

			function Button_mt:Set(Name : string | number)
				Button.Frame.TextButton.Text = tostring(Name)
			end
			function Button_mt:Destroy()
				Button:Destroy()
			end
			Library.Flags[Button_mt.Flag] = Button_mt
			return Button_mt
		end

		-- Textbox
		function Section_mt:AddTextbox(Table)
			local Input_mt = setmetatable({
				Name = Table.Name or "Textbox",
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Image = Table.Image or "rbxassetid://7743874740",
				Callback = Table.Callback or function() end,
				PressEnter = Table.PressEnter or false,
				ClearOnFocus = Table.ClearOnFocus or true,
				--Default = Table.Default or "",
				Placeholder = Table.Placeholder or "Textbox",
				Flag = Table.Flag or #Elements,
			}, Elements)

			local Textbox = InputBox:Clone() 
			Textbox.Parent = Section or Main.ElementsScroll
			Textbox.Frame.Icon.Image = Input_mt.Image
			--Textbox.Frame.Textbox.Text = Input_mt.Name
			Textbox.Frame.Textbox.TextColor3 = Input_mt.TextColor
			Textbox.Frame.Textbox.ClearTextOnFocus = Input_mt.ClearOnFocus
			Textbox.Frame.Textbox.PlaceholderText = Input_mt.Placeholder
			Textbox.Name = Input_mt.Name
			Textbox.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			Textbox.Visible = true

			table.insert(Elements, Textbox)

			local Click = OnClick{Textbox, function()
				Textbox.Frame.Textbox:CaptureFocus()
			end}

			Textbox.Frame.Textbox.FocusLost:Connect(function(enterPressed, v)
				if Input_mt.PressEnter and enterPressed then
					local x,y = pcall(function()
						Input_mt.Callback(Textbox.Frame.Textbox.Text)
					end)
					if not x then Library:Warn(y) end
				elseif not Input_mt.PressEnter then
					local x,y = pcall(function()
						Input_mt.Callback(Textbox.Frame.Textbox.Text)
					end)
					if not x then Library:Warn(y) end
				end

			end)

			Utils.ProxyHover(Click, Textbox.Frame, "BackgroundTransparency", 0,1)

			function Input_mt:AddTextbox(Table)
				return Section_mt:AddTextbox(Table)
			end

			function Input_mt:Set(Name : string | number)
				Textbox.Frame.Textbox.Text = tostring(Name)
			end
			function Input_mt:Destroy()
				Textbox:Destroy()
			end

			Library.Flags[Input_mt.Flag] = Input_mt
			return Input_mt
		end

		-- Toggle
		function Section_mt:AddToggle(Table)
			local Toggle_mt = setmetatable({
				Name = Table.Name or "Toggle",
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Callback = Table.Callback or function() end,
				Value = Table.Default or false,
				Flag = Table.Flag or #Elements,
				Type = "Toggle",
			}, Elements)

			local Toggle = ToggleButton:Clone() 
			Toggle.Parent = Section or Main.ElementsScroll
			Toggle.Frame.TextButton.Text = Toggle_mt.Name
			Toggle.Frame.TextButton.TextColor3 = Toggle_mt.TextColor
			Toggle.Name = Toggle_mt.Name
			Toggle.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			Toggle.Visible = true

			table.insert(Elements, Toggle)

			function Toggle_mt:Set(Boolean)
				Toggle_mt.Value = Boolean
				if Boolean then
					Tween(Toggle.Frame.Image, "BackgroundTransparency", 0)
				elseif not Boolean then
					Tween(Toggle.Frame.Image, "BackgroundTransparency", 0.85)
				end
				local x,y = pcall(function()
					Toggle_mt.Callback(Toggle_mt.Value)
				end)
				if not x then Library:Warn(y) end
			end	

			local Click = OnClick{Toggle, function()
				Toggle_mt:Set(not Toggle_mt.Value)
				if Table.Flag and Window.Saves.Enabled == true then
					Window:Save()
				end
			end}

			function Toggle_mt:AddToggle(Table)
				return Section_mt:AddToggle(Table)
			end

			function Toggle_mt:Destroy()
				Toggle:Destroy()
			end
			Utils.ProxyHover(Click, Toggle.Frame, "BackgroundTransparency", 0,1)
			Toggle_mt:Set(Toggle_mt.Value)
			Library.Flags[Toggle_mt.Flag] = Toggle_mt
			return Toggle_mt
		end

		-- Bind
		function Section_mt:AddBind(Table)
			local Bind_mt = setmetatable({
				Name = Table.Name or "Bind",
				Image = Table.Image or "rbxassetid://7733799275",
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Callback = Table.Callback or function() end,
				Value = Table.Default or Enum.KeyCode.LeftAlt,
				Flag = Table.Flag or #Elements,
				Hold = Table.Hold or false,
				Type = "Bind",
			}, Elements)

			local Bind = KeybindButton:Clone() 
			Bind.Parent = Section or Main.ElementsScroll
			Bind.Frame.Icon.Image = Bind_mt.Image
			Bind.Frame.TextButton.Text = Bind_mt.Name
			Bind.Frame.TextButton.TextColor3 = Bind_mt.TextColor
			Bind.Name = Bind_mt.Name
			Bind.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			Bind.Visible = true

			table.insert(Elements, Bind)

			local Focus = false
			local Holding = false

			local Click = OnClick{Bind, function() 
				local x,y = pcall(function()
					Focus = true
					Bind.Frame.Bind.Text = "..."
				end)
				if not x then Library:Warn(y) end
			end}

			UserInputService.InputBegan:Connect(function(Input)
				if Focus and Input.UserInputType == Enum.UserInputType.Keyboard then
					Bind_mt:Set(Input.KeyCode)
				elseif not Focus and Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Bind_mt.Value then
					if Bind_mt.Hold then
						Holding = true
						local x,y = pcall(function()
							Bind_mt.Callback(Holding)
						end)
						if not x then Library:Warn(y) end
					else
						local x,y = pcall(function()
							Bind_mt.Callback(Bind_mt.Value)
						end)
						if not x then Library:Warn(y) end
					end
				end
			end)
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Bind_mt.Value then
					if Bind_mt.Hold and Holding then
						Holding = false
						local x,y = pcall(function()
							Bind_mt.Callback(Holding)
						end)
						if not x then Library:Warn(y) end
					end
				end
			end)

			function Bind_mt:Set(EnumItem)
				if not Index(BlacklistedKeys, EnumItem) then
					Bind_mt.Value  = EnumItem
					Bind.Frame.Bind.Text = EnumItem.Name
					Focus = false
					if Table.Flag and Window.Saves.Enabled == true then
						Window:Save()
					end
				else
					Bind.Frame.Bind.Text = Bind_mt.Value.Name
					Focus = false
					Library:Warn(EnumItem.Name .. " is a blacklisted key, try another one.")
				end
			end

			function Bind_mt:AddBind(Table)
				return Section_mt:AddBind(Table)
			end

			function Bind_mt:Destroy()
				Bind:Destroy()
			end

			Utils.ProxyHover(Bind, Bind.Frame, "BackgroundTransparency", 0,1)
			Utils.ProxyHover(Bind, Bind.Frame.Bind, "BackgroundColor3", Color3.fromRGB(35,35,35), Color3.fromRGB(45,45,45))
			Bind_mt:Set(Bind_mt.Value)
			Library.Flags[Bind_mt.Flag] = Bind_mt
			return Bind_mt
		end

		function Section_mt:AddSlider(Table)
			local Slider_mt = setmetatable({
				Name = Table.Name or "Slider",
				Image = Table.Image or "rbxassetid://12622785342",
				Min = Table.Min or 0,
				Max = Table.Max or Table.Default or 25,
				Value = Table.Default or Table.Min or 0,
				Flag = Table.Flag or #Elements,
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Increment = Table.Increment or 1,
				Callback = Table.Callback or function() end,
				Type = "Slider",
			}, Elements)

			local newSlider = Slider:Clone()  
			newSlider.Parent = Section or Main.ElementsScroll
			newSlider.Frame.Textbox.Text = Slider_mt.Value
			newSlider.Frame.Textbox.TextColor3 = Slider_mt.TextColor
			newSlider.Frame.Textbox.PlaceholderText = Slider_mt.Name
			newSlider.Frame.Icon.Image = Slider_mt.Image
			newSlider.Name = Slider_mt.Name
			newSlider.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			newSlider.Visible = true
			local SliderBar = newSlider.Frame.Bar
			local Click = OnClick({newSlider})

			table.insert(Elements, newSlider)

			local dragging = false
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			SliderBar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			newSlider.Frame.Textbox.FocusLost:Connect(function()
				Slider_mt:Set(tonumber(newSlider.Frame.Textbox.Text))
			end)
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Slider_mt:Set(Slider_mt.Min + ((Slider_mt.Max - Slider_mt.Min) * SizeScale)) 
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Slider_mt:Set(Slider_mt.Min + ((Slider_mt.Max - Slider_mt.Min) * SizeScale))
				end
			end)
			local function Round(Number, Factor)
				local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
				if Result < 0 then 
					Result = Result + Factor
				end
				return Result
			end
			function Slider_mt:Set(Value)
				if typeof(Value) == "number" then
					if Value > self.Max then 
						Library:Warn("'".. Slider_mt.Name .. "' Value can't be greater than " .. self.Max)
						self:Set(Slider_mt.Value)
						return
					elseif Value < self.Min  then
						Library:Warn("'".. Slider_mt.Name .. "' Value can't be less than " .. self.Min) 
						self:Set(Slider_mt.Value)
						return
					end
					if self.Increment < 1 then
						self.Value = string.format("%.".. #tostring(self.Increment)-string.find(tostring(self.Increment) or 0,"%.").."f", Value)
					else
						self.Value = math.clamp(Round(Value, self.Increment), self.Min, self.Max)
					end
					Tween(SliderBar.Fill, "Size", UDim2.fromScale((self.Value - self.Min) / (self.Max - self.Min), 1), "Out", "Quint", 0.1)
					newSlider.Frame.Textbox.Text = '<font color="rgb(150,150,150)">'.. Slider_mt.Name ..'</font>, ' .. self.Value
					local x,y = pcall(function()
						Slider_mt.Value = self.Value
						Slider_mt.Callback(self.Value)
						if Table.Flag and Window.Saves.Enabled == true then
							Window:Save()
						end
					end)
					if not x then Library:Warn(y) end
				else
					Library:Warn("'".. Slider_mt.Name .. "' Expected number got " .. tostring(typeof(Value)))
				end

			end
			function Slider_mt:Destroy()
				newSlider:Destroy()
			end
			function Slider_mt:AddSlider(Table)
				return Section_mt:AddSlider(Table)		
			end
			Slider_mt:Set(Slider_mt.Value)
			Utils.ProxyHover(newSlider, newSlider.Frame, "BackgroundTransparency", 0,1)
			Library.Flags[Slider_mt.Flag] = Slider_mt
			return Slider_mt
		end

		--Dropdown
		function Section_mt:AddDropdown(Table)
			local Dropdown_mt = setmetatable({
				Name = Table.Name or Table.Default or "Dropdown",
				Options = Table.Options or {},
				Image = Table.Image or "rbxassetid://7733717447",
				Flag = Table.Flag or #Elements,
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Callback = Table.Callback or function() end,
				Toggled = false,
				Value = Table.Default or false;
				Type = "Dropdown"
			}, Elements)

			local newdrop = Dropdown:Clone(); newdrop.Parent = Section or Main.ElementsScroll
			newdrop.Frame.Icon.Image = Dropdown_mt.Image
			newdrop.Frame.Textbox.PlaceholderText = Dropdown_mt.Name
			local Options = Dropdown_Options:Clone() Options.Parent = Section or Main.ElementsScroll
			newdrop.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			Options.Size = UDim2.new(1,0,0, 0)
			newdrop.Visible = true
			newdrop.Name = Dropdown_mt.Name
			Options.Name = Dropdown_mt.Name
			local Input = newdrop.Frame.Textbox
			local Button = newdrop.Frame.Icon

			table.insert(Elements, newdrop) table.insert(Elements, Options)

			Button.Activated:Connect(function()
				Dropdown_mt.Toggled = not Dropdown_mt.Toggled
				if Dropdown_mt.Toggled then
					Options.Visible = true
					Tween(Options, "Size",  UDim2.new(1,0,0, Dropdown_Options.AbsoluteSize.Y))
				elseif not Dropdown_mt.Toggled then			
					Tween(Options, "Size", UDim2.new(1,0,0,0))
					wait(0.3)
					Options.Visible = false
				end
				for i, v in pairs(Options.Frame.Dropdown_Options:GetChildren()) do
					if v:IsA("Frame") then
						v.Visible = true
					end
				end
			end)
			local function OnActivate(Option)
				if Option ~= false then
					if Index(Dropdown_mt.Options, Option) then
						local x,y = pcall(function()
							Dropdown_mt.Value = Option
							Dropdown_mt.Callback(Option)
							if Table.Flag and Window.Saves.Enabled == true then
								Window:Save()
							end
						end)
						if x then Input.Text = tostring('<font color="rgb(150,150,150)">'.. Dropdown_mt.Name ..'</font>, ' .. Option or Option.Name) else Library:Warn(y) end
					else
						OnActivate(Dropdown_mt.Value)
						Library:Warn("'" .. Input.PlaceholderText .. "' " .. tostring(Option) .. " is not an available option to set")
					end
					Dropdown_mt.Toggled = false
					Tween(Options, "Size", UDim2.new(1,0,0,0))
					wait(0.3)
					Options.Visible = false
				end
			end
			Input.Focused:Connect(function()
				Dropdown_mt.Toggled = true			
				Options.Visible = true
				Tween(Options, "Size",  UDim2.new(1,0,0, Dropdown_Options.AbsoluteSize.Y))
			end)
			Input.FocusLost:Connect(function(enterPressed)
				if not enterPressed then return end
				OnActivate(Input.Text)
			end)
			Input.Changed:Connect(function()
				local Search = string.lower(Input.Text)
				for i, v in pairs(Options.Frame.Dropdown_Options:GetChildren()) do
					if v:IsA("Frame") then
						if Search ~= "" then
							local Opt = string.lower(v.Text.Text)
							if string.find(Opt, Search) then
								v.Visible = true
							else
								v.Visible = false
							end
						else
							v.Visible = true
						end
					end
				end
			end)

			function Dropdown_mt:Set(Option)
				OnActivate(Option)
			end
			function Dropdown_mt:Remove(Option)
				if Index(Dropdown_mt.Options, Option) then
					for index, v in pairs(Dropdown_mt.Options) do
						if v == Option then
							table.remove(Dropdown_mt.Options, index)
						end
					end
					Dropdown_mt:Refresh(Dropdown_mt.Options, true)
				else
					Library:Warn("'" .. Input.PlaceholderText .. "' " .. tostring(Option) .. " is not an available option to remove")
				end
			end
			local function CreateOpt(v)
				local newOp = OptTemp:Clone()
				newOp.Parent = Options.Frame.Dropdown_Options
				newOp.Visible = true
				newOp.Text.Text = tostring(v)
				newOp.Text.Activated:Connect(function()
					OnActivate(v)
				end)
				Utils.ProxyHover(newOp, newOp.Text, "TextColor3", Color3.fromRGB(200,200,200), Color3.fromRGB(150,150,150))
			end
			function Dropdown_mt:Refresh(List, clear)
				if clear then
					Dropdown_mt.Options = List
					for _, v in pairs(Options.Frame.Dropdown_Options:GetChildren()) do
						if v:IsA("Frame") then
							v:Destroy()
						end
					end
					for _, v in pairs(Dropdown_mt.Options) do
						CreateOpt(v)
					end
				else
					for _, v in pairs(List) do
						table.insert(Dropdown_mt.Options, v)
					end
					for _, v in pairs(Options.Frame.Dropdown_Options:GetChildren()) do
						if v:IsA("Frame") then
							v:Destroy()
						end
					end
					for _, v in pairs(Dropdown_mt.Options) do
						CreateOpt(v)
					end
				end
			end
			function Dropdown_mt:Destroy()
				newdrop:Destroy()
			end
			function Dropdown_mt:AddDropdown(Table)
				return Section_mt:AddDropdown(Table)
			end
			Dropdown_mt:Refresh(Dropdown_mt.Options, true)
			Dropdown_mt:Set(Dropdown_mt.Value)
			Utils.ProxyHover(newdrop, newdrop.Frame, "BackgroundTransparency", 0,1)
			Library.Flags[Dropdown_mt.Flag] = Dropdown_mt
			return Dropdown_mt
		end

		-- Colorpicker
		function Section_mt:AddColorpicker(Table)

			local Colorpicker_mt = setmetatable({
				Name = Table.Name or "Colorpicker",
				Value = Table.Default or Color3.fromRGB(255, 255, 127),
				Flag = Table.Flag or #Elements, 
				TextColor = Table.TextColor or Color3.fromRGB(200,200,200),
				Callback = Table.Callback or function() end,
				Toggled = false,
				Type = "Colorpicker"
			}, Elements)

			local ColorH, ColorS, ColorV = 1, 1, 1
			local newColor = Colorpicker:Clone(); newColor.Parent = Section or Main.ElementsScroll
			newColor.Size = UDim2.new(1,0,0, Header.AbsoluteSize.Y)
			newColor.Frame.Label.Text = Colorpicker_mt.Name
			newColor.Visible = true
			local Display = newColor.Frame.Image
			local Color = Colorpicker_Frame.Color local ColorSelection = Color.ImageLabel
			local Hue = Colorpicker_Frame.Hue local HueSelection = Hue.Line
			local HideButton = Colorpicker_Frame.Minimize

			table.insert(Elements, newColor)

			ColorH = 1- (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
			ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
			ColorV =1- (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

			OnClick{ZIndex = 5, Colorpicker_Frame.Minimize, function() 
				for i, v in pairs(Library.Flags) do
					pcall(function()
						if v.Type == "Colorpicker" then
							v.Toggled = false
						end
					end)
				end
				Tween(Colorpicker_Frame, "Position", UDim2.fromScale(0,1.5))
			end}

			function Colorpicker_mt:Set(Value)
				Colorpicker_mt.Value = Value
				Display.BackgroundColor3 = Colorpicker_mt.Value
				local x, y = pcall(function()
					Colorpicker_mt.Callback(Display.BackgroundColor3)
					if Table.Flag and Window.Saves.Enabled == true then
						Window:Save()
					end
				end)
				if not x then Library:Warn(y) end
			end

			local function Update()
				if not Colorpicker_mt.Toggled then return end
				Display.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				Colorpicker_mt:Set(Display.BackgroundColor3)
			end

			OnClick{newColor, function()
				for i, v in pairs(Library.Flags) do
					pcall(function()
						if v ~= Colorpicker_mt then
							v.Toggled = false
						end
					end)
				end
				Colorpicker_mt.Toggled = not Colorpicker_mt.Toggled
				if Colorpicker_mt.Toggled then
					Tween(Colorpicker_Frame, "Position", UDim2.fromScale(0,1))
					Color.BackgroundColor3 = Colorpicker_mt.Value
					Colorpicker_mt:Set(Colorpicker_mt.Value)

				else
					Tween(Colorpicker_Frame, "Position", UDim2.fromScale(0,1.5))
				end
			end}

			local dragging
			Color.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			Color.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			Color.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
					local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
					ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
					ColorS = ColorX
					ColorV = 1 - ColorY
					Update()
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
					local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
					ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
					ColorS = ColorX
					ColorV = 1 - ColorY
					Update()
				end
			end)
			local dragging2
			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging2 = true
				end
			end)
			Hue.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging2 = false
				end
			end)

			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
					HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
					ColorH = 1 - HueY
					Update()
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
					local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
					HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
					ColorH = 1 - HueY					
					Update()
				end
			end)	
			function Colorpicker_mt:AddColorpicker(Table)
				return Section_mt:AddColorpicker(Table)
			end
			Colorpicker_mt:Set(Colorpicker_mt.Value)
			-- change color background
			Utils.ProxyHover(newColor, newColor.Frame, "BackgroundTransparency", 0,1)
			Library.Flags[Colorpicker_mt.Flag] = Colorpicker_mt
			return Colorpicker_mt
		end
		function Section_mt:AddSection(Table)
			return Window:AddSection(Table)
		end
		function Section_mt:Destroy(Table)
			Section:Destroy()
		end
		Library.Flags[Section_mt.Flag] = Section_mt

		return Section_mt
	end

	Window:AddSection{Name = "Credits", Image = "rbxassetid://7743876054", Parent = Main.UIScroll}
	:AddLabel{Text = Window.Name .. " by " .. Window.Creator}
	:AddLabel{Text = Window.Script .. " by " .. Window.Creator}
	:AddLabel{Text = "UI by Exec", CopiedText = "github.com/Player788"}

	local Misc = Window:AddSection{Name = "Miscellaneous", Image = "rbxassetid://7743868936", Parent = Main.UIScroll}
	Misc:AddButton{Name = "Load Save", Image = "rbxassetid://7733964240", TextColor = Color3.fromRGB(150,150,150),
		Callback = function()
			Window:Load()
		end,
	}
	Misc:AddButton{Name = "Get Logs", Image = "rbxassetid://7733789088", TextColor = Color3.fromRGB(150,150,150),
		Callback = function()
			if typeof(setclipboard) == "function" then
				setclipboard(HttpService:JSONEncode(Library.Logs))
				Library:Notification{Content = "Logs copied to clipboard"}
			else
				for i, v in pairs(Library.Logs) do
					print("Log#"..i, v)
				end
				--print(HttpService:JSONEncode(Library.Logs))
				Library:Notification{1, Content = "Logs printed in output"}
			end
		end
	}

	pcall(function()
		local rbx_join = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/rbxscripts/main/roblox_join.lua'))()
		Misc:AddTextbox{Name = "Join Player",
			Placeholder = "Join by UserId",
			Image = "rbxassetid://7743875962",
			Callback = function(userid)
				Library:Notification{1, Content = "Searching..."}
				local var = rbx_join.Join(userid)
				if var.Success then
					Library:Notification{2, Content = var.Message}
				elseif not var.Success then
					Library:Notification{0, Content = var.Message}
				end
			end
		}
	end)

	local frameToggle = true
	OnClick{ZIndex = 2, Top.Info, function()
		Tween(Top.Info.ImageButton, "ImageColor3", frameToggle and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(200,200,200))
		frameToggle = not frameToggle
		Main.ElementsScroll.Visible = not Main.ElementsScroll.Visible
		Main.UIScroll.Visible = not Main.UIScroll.Visible
	end}

	Library.Flags[Window.Flag] = Window

	wait(0.3)
	Tween(Init, "BackgroundTransparency", 1)
	Tween(Init.Note, "TextTransparency", 1)
	Tween(Init.Note2, "TextTransparency", 1)
	wait(0.3)
	Top.Visible = true
	Exec.Main.ElementsScroll.Visible = true

	Library:Notification{2, Content = "Loaded Exec's Panel v" .. _G.Version}
	return Window
end

function Library:Warn(T)
	Library:Notification {0, Content = T}
end

function Library:Get(Flag : string | number)
	if not Library.Flags[Flag] then Library:Warn("Flag: " .. Flag .. " not found.") return end
	return Library.Flags[Flag]
end

function Library:Destroy()
	Exec:Destroy()
end

return Library
