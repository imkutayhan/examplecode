local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local NumPerMap = ReplicatedStorage:WaitForChild("NumPerMap")
local Doors = Workspace:WaitForChild("Doors")
local ObjectFindEvent = RemoteEvents:WaitForChild("ObjectFindEvent")
local CharChangeEvent = RemoteEvents:WaitForChild("CharChangeEvent")
local TrailEvent = RemoteEvents:WaitForChild("TrailEvent")
local UnlockDoorEvent = RemoteEvents:WaitForChild("UnlockDoorEvent")
local DataStoreService = game:GetService("DataStoreService")
local PlayerData = DataStoreService:GetDataStore("PlayerData")
local BadgeService = game:GetService("BadgeService")
local GamePassIDs = {
	Vip = 852237365,
	Carpet = 852336194,
	Hook = 852371019,
	TrippleJump = 852332151,
	DoubleJump = 852201556,
	FusionCoil = 852431056,
	GravityCoil = 852308346,
	SpeedCoil = 852413116,
	Unicorn = 852317290,
	Balloon = 852204569,
	Cat = 852108968,
	RainbowTrail = 852347457,
	FlameTrail = 852402377,
	RedTrail = 852329560,
	PurpleTrail = 852432319,
	BlueTrail = 852464229,
	YellowTrail = 852233807,
	GreenTrail = 852381447,
	WhiteTrail = 852291565
}
local function giveTool(player, toolName)
	local toolClone = ReplicatedStorage.Tools:FindFirstChild(toolName):Clone()
	toolClone.Parent = player.Backpack
	if toolClone.Name == "SpeedCoil" or toolClone.Name == "FusionCoil" then
		local new = Instance.new("IntValue", toolClone)
		new.Name = "Speed"
		new.Value = player:GetAttribute("WalkSpeed")
	end
end
local function handleGamePass(player, gamePassID, callback)
	local retries = 3
	local success, ownsPass
	for i = 1, retries do
		success, ownsPass = pcall(function()
			return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID)
		end)
		if success then
			break
		else
			warn("Retrying game pass check... Attempt " .. i)
			task.wait(1)
		end
	end
	if success and ownsPass then
		callback()
	elseif not success then
		warn("Error checking game pass ownership after " .. retries .. " attempts: " .. tostring(ownsPass))
	end
end
local function onPromptPurchaseFinished(player, purchasedPassID, purchaseSuccess)
	if not purchaseSuccess then return end
	local gamePassActions = {
		[GamePassIDs.Vip] = function()
			player:SetAttribute("VIP", true)
			giveTool(player, "FusionCoil")
			player:SetAttribute("Jumps", (player:GetAttribute("Jumps") or 0) + 2)
		end,
		[GamePassIDs.TrippleJump] = function()
			player:SetAttribute("Jumps", (player:GetAttribute("Jumps") or 0) + 3)
		end,
		[GamePassIDs.DoubleJump] = function()
			player:SetAttribute("Jumps", (player:GetAttribute("Jumps") or 0) + 2)
		end,
		[GamePassIDs.Carpet] = function()
			giveTool(player, "MagicCarpet")
		end,
		[GamePassIDs.Hook] = function()
			giveTool(player, "Hook")
		end,
		[GamePassIDs.FusionCoil] = function()
			giveTool(player, "FusionCoil")
		end,
		[GamePassIDs.GravityCoil] = function()
			giveTool(player, "GravityCoil")
		end,
		[GamePassIDs.SpeedCoil] = function()
			giveTool(player, "SpeedCoil")
		end,
		[GamePassIDs.Unicorn] = function()
			giveTool(player, "Unicorn")
		end,
		[GamePassIDs.Balloon] = function()
			giveTool(player, "Balloon")
		end,
		[GamePassIDs.Cat] = function()
			giveTool(player, "Cat")
		end,
		[GamePassIDs.RainbowTrail] = function()
			CreateTrail(player, "RainbowTrail")
		end,
		[GamePassIDs.FlameTrail] = function()
			CreateTrail(player, "FlameTrail")
		end,
		[GamePassIDs.RedTrail] = function()
			CreateTrail(player, "RedTrail")
		end,
		[GamePassIDs.PurpleTrail] = function()
			CreateTrail(player, "PurpleTrail")
		end,
		[GamePassIDs.BlueTrail] = function()
			CreateTrail(player, "BlueTrail")
		end,
		[GamePassIDs.YellowTrail] = function()
			CreateTrail(player, "YellowTrail")
		end,
		[GamePassIDs.GreenTrail] = function()
			CreateTrail(player, "GreenTrail")
		end,
		[GamePassIDs.WhiteTrail] = function()
			CreateTrail(player, "WhiteTrail")
		end
	}
	if gamePassActions[purchasedPassID] then
		gamePassActions[purchasedPassID]()
	end
end
MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptPurchaseFinished)
function CreateTrail(player, TrailName)
	local playerTrails = player.Character:FindFirstChild("Trails") or Instance.new("Folder", player.Character)
	playerTrails.Name = "Trails"
	task.wait(0.1)
	if playerTrails:FindFirstChild(TrailName) then
		playerTrails:ClearAllChildren()
	else
		playerTrails:ClearAllChildren()
		task.wait(0.01)
		local TrailsFolder = ReplicatedStorage:WaitForChild("TrailsFolder")
		local Trails = TrailsFolder:FindFirstChild(TrailName)
		if not Trails then
			return
		end
		local part1 = Trails.Part1:Clone()
		local part2 = Trails.Part2:Clone()
		local weld1 = Trails.weld1:Clone()
		local weld2 = Trails.weld2:Clone()
		part1.Parent = playerTrails
		part2.Parent = playerTrails
		weld1.Parent = playerTrails
		weld1.Part0 = player.Character.HumanoidRootPart
		weld1.Part1 = part1
		weld2.Parent = playerTrails
		weld2.Part0 = player.Character.HumanoidRootPart
		weld2.Part1 = part2
		part1.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 0.7, 0)
		part2.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 0.7, 0)
		local newTrail = Trails:FindFirstChildWhichIsA("Trail"):Clone()
		newTrail.Attachment0 = part1.Attachment
		newTrail.Attachment1 = part2.Attachment
		newTrail.Parent = playerTrails
		player:SetAttribute("Trail", newTrail.Name)
	end
end
TrailEvent.OnServerEvent:Connect(function(player, trailName)
	if player then
		CreateTrail(player, trailName)
	end
end)
ObjectFindEvent.OnServerEvent:Connect(function(player, object)
	local ObjectsValue = player:WaitForChild("ObjectsValue")
	ObjectsValue.Value += 1
	local ObjectsName = player:WaitForChild("ObjectsName")
	local newObject = Instance.new("StringValue", ObjectsName)
	newObject.Name = object
end)
local DoorClientEvent = RemoteEvents:WaitForChild("DoorClientEvent")
DoorClientEvent.OnServerEvent:Connect(function(player,message)
	if player then
		if not player:FindFirstChild("Doors"):FindFirstChild(message) then
			local new = Instance.new("StringValue",player:FindFirstChild("Doors"))
			new.Name = message
		end
	end
end)
game.ReplicatedStorage.AllObjects.Value = (#Doors:GetChildren() + 1) * NumPerMap.Value  
local WelcomeId = 2498866318158630
local World1Id = 2347215276041396 
local World2Id = 4393594776630457
local World3Id = 117452718386376
local World4Id = 2730976067705314
Players.PlayerAdded:Connect(function(player)
	local ObjectsValue = Instance.new("IntValue", player)
	ObjectsValue.Name = "ObjectsValue"
	local ObjectsName = Instance.new("Folder", player)
	ObjectsName.Name = "ObjectsName"
	local Doors = Instance.new("Folder", player)
	Doors.Name = "Doors"
	local Donates = Instance.new("IntValue", player)
	Donates.Name = "Donates"
	ObjectsValue.Changed:Connect(function()
		if ObjectsValue.Value >= 10 then
			pcall(function() BadgeService:AwardBadge(player.UserId, World1Id) end)
		end
		if ObjectsValue.Value >= 30 then
			pcall(function() BadgeService:AwardBadge(player.UserId, World2Id) end)
		end
		if ObjectsValue.Value >= 50 then
			pcall(function() BadgeService:AwardBadge(player.UserId, World3Id) end)
		end
		if ObjectsValue.Value >= 100 then
			pcall(function() BadgeService:AwardBadge(player.UserId, World4Id) end)
		end
	end)
	player:SetAttribute("WalkSpeed", 16)
	player:SetAttribute("Jumps", 1)
	player:SetAttribute("Trail", nil)
	CharChangeEvent.OnServerEvent:Connect(function(char)
		local playerCharacter = player.Character or char
		local HRP = playerCharacter:WaitForChild("HumanoidRootPart")
		handleGamePass(player, GamePassIDs.Vip, function()
			player:SetAttribute("VIP", true)
			giveTool(player, "FusionCoil")
			player:SetAttribute("Jumps", (player:GetAttribute("Jumps") or 0) + 2)
		end)
		handleGamePass(player, GamePassIDs.Carpet, function()
			giveTool(player, "MagicCarpet")
		end)
		handleGamePass(player, GamePassIDs.Hook, function()
			giveTool(player, "Hook")
		end)
		handleGamePass(player, GamePassIDs.TrippleJump, function()
			player:SetAttribute("Jumps", (player:GetAttribute("Jumps") or 0) + 3)
		end)
		handleGamePass(player, GamePassIDs.DoubleJump, function()
			player:SetAttribute("Jumps", (player:GetAttribute("Jumps") or 0) + 2)
		end)
		handleGamePass(player, GamePassIDs.SpeedCoil, function()
			giveTool(player, "SpeedCoil")
		end)
		handleGamePass(player, GamePassIDs.FusionCoil, function()
			giveTool(player, "FusionCoil")
		end)
		handleGamePass(player, GamePassIDs.GravityCoil, function()
			giveTool(player, "GravityCoil")
		end)
		handleGamePass(player, GamePassIDs.Unicorn, function()
			giveTool(player, "Unicorn")
		end)
		handleGamePass(player, GamePassIDs.Balloon, function()
			giveTool(player, "Balloon")
		end)
		handleGamePass(player, GamePassIDs.Cat, function()
			giveTool(player, "Cat")
		end)
		handleGamePass(player, GamePassIDs.RainbowTrail, function()
			CreateTrail(player, "RainbowTrail")
		end)
		handleGamePass(player, GamePassIDs.FlameTrail, function()
			CreateTrail(player, "FlameTrail")
		end)
		handleGamePass(player, GamePassIDs.RedTrail, function()
			CreateTrail(player, "RedTrail")
		end)
		handleGamePass(player, GamePassIDs.PurpleTrail, function()
			CreateTrail(player, "PurpleTrail")
		end)
		handleGamePass(player, GamePassIDs.BlueTrail, function()
			CreateTrail(player, "BlueTrail")
		end)
		handleGamePass(player, GamePassIDs.YellowTrail, function()
			CreateTrail(player, "YellowTrail")
		end)
		handleGamePass(player, GamePassIDs.GreenTrail, function()
			CreateTrail(player, "GreenTrail")
		end)
		handleGamePass(player, GamePassIDs.WhiteTrail, function()
			CreateTrail(player, "WhiteTrail")
		end)
	end)
end)