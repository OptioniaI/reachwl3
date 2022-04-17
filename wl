if LEGENDSOPREACH_LOADED and not _G.LEGENDSOPREACH_DEBUG == true then
         game.StarterGui:SetCore("SendNotification", {
         Title = "Legend's OP Reach";
         Text = "Already Loaded!";
         Icon = "";
         Duration = 5;})
   return
end

pcall(function() getgenv().LEGENDSOPREACH_LOADED = true end)

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "Legend's OP Reach";
	Text = "Loaded!";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 10;

print("Press G to get more reach. (30 best if you want.)")
print("Press H to lower reach.")
print("Press F to auto click.")


mt = getrawmetatable(game)
oldIndex = mt.__index 
setreadonly(mt, false)


mt.__index = function(a,b)
	if a == "Weld" or b == "Weld" then 
		return "Part"
	end
	return oldIndex(a,b)
end


local Player = game.Players.LocalPlayer
local Char = Player.Character
local KeyBindHigh = "g"
local IncreaseAmmount = 1 
local KeyBindLow = "h"
local settings = {repeatamount = 2}
_G.Dist = 15
_G.SphereActivated = true

local Whitelisted = {}
local PlayersNamesWithCommands = {}

local function AddUser(plr)
	table.insert(Whitelisted, plr)		
	game.StarterGui:SetCore("SendNotification", {
		Title = "Legend's Hub";
		Text = "Whitelisted " .. tostring(plr) .. "!";
		Icon = "";
		Duration = 1;})
end

local function WAddUser(plr)
	table.insert(PlayersNamesWithCommands, plr)		
	game.StarterGui:SetCore("SendNotification", {
		Title = "Legend's Hub";
		Text = "Gave " .. tostring(plr) .. " whitelist and blacklist commands!";
		Icon = "";
		Duration = 1;})
end

local function WRemoveUser(plr)
	for num,user in pairs (PlayersNamesWithCommands) do
		if user == plr then
			table.remove(PlayersNamesWithCommands, num)
			game.StarterGui:SetCore("SendNotification", {
				Title = "Legend's Hub";
				Text = "Blacklisted " .. tostring(plr) .. " from using commands.";
				Icon = "";
				Duration = 1;})
		end
	end
end

local function RemoveUser(plr)
	for num,user in pairs (Whitelisted) do
		if user == plr then
			table.remove(Whitelisted, num)
			game.StarterGui:SetCore("SendNotification", {
				Title = "Legend's Hub";
				Text = "Blacklisted " .. tostring(plr) .. "!";
				Icon = "";
				Duration = 1;})
		end
	end
end

local function FindPlayer(User)
	for _,players in pairs(game.Players:GetPlayers()) do
		if players.Name ~= Player.Name then
			if User:lower() == (players.Name:lower()):sub(1, #User) then
				return players
			end			
		end
	end
end

game:GetService("RunService").Stepped:Connect(function()
	local Player = game.Players.LocalPlayer
	local Char = Player.Character
	pcall(function()
		for i,v in pairs(game.Players:GetPlayers()) do 
			if v ~= Player and not table.find(Whitelisted, v.Name) and not table.find(PlayersNamesWithCommands, v.Name) then 
				if v.Character.Humanoid.Health ~= 0 then 
					if (v.Character.HumanoidRootPart.Position - Char.HumanoidRootPart.Position).Magnitude <= _G.Dist then 
						for _,x in pairs(v.Character:GetChildren()) do 
							if table.find(Whitelisted, v.Name) then return end
							if x:IsA("Part") then 
								if v.Character:FindFirstChild('LLeft Aarm') then
									v.Character:FindFirstChild('LLeft Aarm'):Destroy()						
								end
								for i = 1,settings.repeatamount do 
									firetouchinterest(Char:FindFirstChildOfClass("Tool").Handle, x, 0)
									firetouchinterest(Char:FindFirstChildOfClass("Tool").Handle, x, 1)
				                    			firetouchinterest(Char:FindFirstChildOfClass("Tool").Handle, x, 0)
									firetouchinterest(Char:FindFirstChildOfClass("Tool").Handle, x, 1)
								end
							end
						end
					end
				end
			end
		end
	end)
end)

if _G.SphereActivated then
	function Update()
		game.Players.LocalPlayer.Character.ChildAdded:Connect(function(tool)
			if tool:FindFirstChild("Handle") then
				Part = Instance.new("Part")
				Weld = Instance.new("Weld", workspace)
				Part.Parent = workspace
				Part.Transparency = 1 
				Part.CanCollide = false
				Sphere = Instance.new("SelectionSphere",game:GetService("CoreGui").RobloxGui.Modules)
				Sphere.Transparency = 1
				Sphere.SurfaceColor3 = Color3.new(0,0,0)
				Sphere.Transparency = 1
				Sphere.Name = "Sphere"
				Sphere.SurfaceTransparency = .8
				Sphere.Adornee = Part 
				Part.Massless = true
				Part.Position = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle.Position
				Weld.Part0 = Part 
				Weld.Part1 = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle
				game:GetService("RunService").Stepped:Connect(function()
					Part.Size = Vector3.new(_G.Dist,_G.Dist,_G.Dist)
				end)
			end
		end)
	end
	function UnEquip()
		game.Players.LocalPlayer.Character.ChildRemoved:Connect(function(int)
			if int:FindFirstChild("Handle") then
				for i,v in pairs(game:GetService("CoreGui").RobloxGui.Modules:GetDescendants()) do 
					if v.Name == 'Sphere' then
						v:Destroy()
					end
				end
			end
		end)
	end

	Update()
	UnEquip()

	game.Players.LocalPlayer.CharacterAdded:Connect(Update)
	game.Players.LocalPlayer.CharacterAdded:Connect(UnEquip)    
end

local function AddAndRemove(plr)
	print(plr)
	plr.Chatted:Connect(function(Message)
		if plr.Name == Player.Name or table.find(PlayersNamesWithCommands, plr.Name) then
			if Message:sub(1, 4) == "!wl " then
				print(plr.Name)
				local plr = Message:sub(5)
				local User = FindPlayer(plr)
				if User ~= nil and User.Name ~= Player.Name and User.Name ~= plr.Name and not table.find(PlayersNamesWithCommands, plr.Name) then
					AddUser(User.Name)			
				end
			elseif Message:sub(1, 4) == "!bl " then
				print(plr.Name)
				local plr = Message:sub(5)
				local User = FindPlayer(plr)
				if User ~= nil and User.Name ~= Player.Name and User.Name ~= plr.Name and not table.find(PlayersNamesWithCommands, plr.Name) then
					RemoveUser(User.Name)			
				end
			elseif Message == "!c" then
				if plr.Name == Player.Name then
					table.clear(Whitelisted)
					table.clear(PlayersNamesWithCommands)
						game.StarterGui:SetCore("SendNotification", {
						Title = "Legend's Hub";
						Text = "Cleared whitelist!";
						Icon = "";
						Duration = 1;})
				end
			elseif Message:sub(1, 3) == "!p " then
				if plr.Name == Player.Name then
					local plr = Message:sub(4)
					local User = FindPlayer(plr)
					if User ~= nil and User.Name ~= Player.Name then
						WAddUser(User.Name)			
					end
				end
			elseif Message:sub(1, 5) == "!unp " then
				if plr.Name == Player.Name then
				local plr = Message:sub(6)
				local User = FindPlayer(plr)
				if User ~= nil and User.Name ~= Player.Name then
					WRemoveUser(User.Name)			
					end
				end
			end			
		end
	end)
end

for _,p in pairs (game.Players:GetPlayers()) do
	AddAndRemove(p)
end

game.Players.PlayerAdded:Connect(function(plr)
	AddAndRemove(plr)
end)

local AC = false
local Key = Enum.KeyCode.F

game:GetService("UserInputService").InputBegan:Connect(function(k,g)
	if not g and k.KeyCode == Key then
		AC = not AC
	end
end)

while wait() do
	if AC then
		pcall(function()
			local Sword = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass'Tool'
			Sword:Activate()
			Sword:Activate()
		end)
	end
end
