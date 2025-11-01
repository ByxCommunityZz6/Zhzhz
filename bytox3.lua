local Module = {}
Module.__index = Module

local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/ByxCommunityZz6/Zhzhz/refs/heads/main/Bytox2.lua"))()

local BackPack = Utility.BackPack
local HumanoidRootPart = Utility.HumanoidRootPart
local Humanoid = Utility.Humanoid
local LocalPlayer = Utility.LocalPlayer
local Character = Utility.Character
local Mouse = Utility.Mouse

--// Mechanic Funcs
function Module:Init(Function)
	if type(Function) ~= "function" then
		error("[Module]: {Function} must be a function")
		return
	end
	pcall(Function)
end

function Module:SendNotification(Text)
	if Utility.NotificationHandler and Utility.NotificationHandler.CreateNotification then
		Utility.NotificationHandler.CreateNotification(Text)
	else
		warn("[Module]: NotificationHandler not found")
	end
end

function Module:SpawnConnection()
	local ConnectionHandler = {}

	function ConnectionHandler:Connect(Type, Callback)
		local Connection
		if Type == "Heartbeat" then
			Connection = Utility.RunService.Heartbeat:Connect(Callback)
		elseif Type == "RenderStepped" then
			Connection = Utility.RunService.RenderStepped:Connect(Callback)
		end
		return Connection
	end

	function ConnectionHandler:Disconnect(Connection)
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end

	return ConnectionHandler
end

function Module:ServerHop(PlaceId, JobId, OldestServer)
	local Cursor, Servers, Valid = "", {}, nil
	while true do
		local Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=100&sortOrder=Asc&cursor=%s", PlaceId, Cursor)
		local Success, Response = pcall(function()
			return Utility.HttpService:JSONDecode(game:HttpGet(Url))
		end)
		if Success and Response and Response.data then
			for _, v in ipairs(Response.data) do
				if v.id ~= JobId and v.playing < v.maxPlayers then
					if OldestServer then
						Valid = v
						break
					else
						table.insert(Servers, v.id)
					end
				end
			end
			if OldestServer and Valid then break end
			if not Response.nextPageCursor then break end
			Cursor = Response.nextPageCursor
		else break end
	end

	if OldestServer and Valid then
		Utility.TeleportService:TeleportToPlaceInstance(PlaceId, Valid.id, LocalPlayer)
	elseif not OldestServer and #Servers > 0 then
		local RandomServerId = Servers[math.random(1, #Servers)]
		Utility.TeleportService:TeleportToPlaceInstance(PlaceId, RandomServerId, LocalPlayer)
	end
end

function Module:HasItem(ItemName, Apply)
	local function SearchIn(Container)
		for _, v in pairs(Container:GetChildren()) do
			if v:IsA("Tool") and v.Name:lower():find(ItemName:lower()) then
				if Apply then Humanoid:EquipTool(v) end
				return true, v
			end
		end
		return false
	end

	local Backpack = LocalPlayer:FindFirstChild("Backpack")
	if Backpack then
		local Has, Tool = SearchIn(Backpack)
		if Has then return true, Tool end
	end

	local Has, Tool = SearchIn(Character)
	if Has then return true, Tool end

	return false
end

function Module:SortArray(Array)
	assert(type(Array) == "table", "[Module]: Array must be a table")
	table.sort(Array, function(a, b)
		return tostring(a):lower() < tostring(b):lower()
	end)
	return Array
end

function Module:IsMaxInventory()
	return Utility.InventoryService and Utility.InventoryService.IsMaxInventory and Utility.InventoryService.IsMaxInventory() or false
end

function Module:GetFarm()
	local Farm = Utility.Workspace:FindFirstChild("Farm")
	for _, v in pairs(Farm:GetChildren()) do
		local Data = v:FindFirstChild("Important")
		if Data and Data:FindFirstChild("Data") and Data.Data:FindFirstChild("Owner") and Data.Data.Owner.Value == LocalPlayer.Name then
			return v, Data
		end
	end
	return nil, nil
end

-- باقي الدوال (Harvest, Plant, GetSeeds, BuyGear, GetPets, Craft...) تشتغل مثل ما أرسلتها، وما فيها مشاكل خطيرة.

return Module
