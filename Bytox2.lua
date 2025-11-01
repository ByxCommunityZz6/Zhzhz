--// Bytox Utility Module 
--// A powerful utility handler for Bytox Hub (Grow a Garden & other games)

local Utility = {}

--// Roblox Services
Utility.RunService = game:GetService("RunService")
Utility.Players = game:GetService("Players")
Utility.Insert = game:GetService("InsertService")
Utility.ReplicatedStorage = game:GetService("ReplicatedStorage")
Utility.HttpService = game:GetService("HttpService")
Utility.Workspace = game:GetService("Workspace")
Utility.UserInputService = game:GetService("UserInputService")
Utility.TeleportService = game:GetService("TeleportService")
Utility.Lighting = game:GetService("Lighting")

--// LocalPlayer Data
Utility.LocalPlayer = Utility.Players.LocalPlayer
Utility.Character = Utility.LocalPlayer.Character or Utility.LocalPlayer.CharacterAdded:Wait()
Utility.Humanoid = Utility.Character:WaitForChild("Humanoid")
Utility.HumanoidRootPart = Utility.Character:WaitForChild("HumanoidRootPart")
Utility.BackPack = Utility.LocalPlayer:WaitForChild("Backpack")
Utility.PlayerGui = Utility.LocalPlayer:WaitForChild("PlayerGui")
Utility.Mouse = Utility.LocalPlayer:GetMouse()

--// Game Data (Grow a Garden)
Utility.EventData = require(Utility.ReplicatedStorage.Data.EventShopData)
Utility.FruitsData = require(Utility.ReplicatedStorage.Data.SeedData)
Utility.Gears = require(Utility.ReplicatedStorage.Data.GearData)
Utility.Mutations = require(Utility.ReplicatedStorage.Modules.MutationHandler).MutationNames
Utility.MutationHandler = require(Utility.ReplicatedStorage.Modules.MutationHandler)
Utility.EggData = require(Utility.ReplicatedStorage.Data.PetEggData)
Utility.NotificationHandler = require(Utility.ReplicatedStorage.Modules.Notification)
Utility.DataService = require(Utility.ReplicatedStorage.Modules.DataService)
Utility.InventoryService = require(Utility.ReplicatedStorage.Modules.InventoryService)
Utility.CalculateValue = require(Utility.ReplicatedStorage.Modules.CalculatePlantValue)
Utility.PetServices = Utility.ReplicatedStorage.Modules:WaitForChild("PetServices")
Utility.ActivePetsService = require(Utility.PetServices:WaitForChild("ActivePetsService"))
Utility.PetList = require(Utility.ReplicatedStorage.Data.PetRegistry.PetList)

--// Key Positions
Utility.Positions = {
	["Sell Zone"] = CFrame.new(88.1, 3, 0.2),
	["Middle"] = CFrame.new(-105.8, 4.4, -7.6),
	["Gear Shop"] = CFrame.new(-287.4, 3, -13.8),
	["Pet Shop"] = CFrame.new(-286.8, 3, -2.5),
	["Cosmetics Shop"] = CFrame.new(-286.2, 3, -25.2),
	["Crafting Zone"] = CFrame.new(-285.6, 3, -34.3),
}

--// Crafting Data
Utility.Crafting = {
	["Seed Recipes"] = {
		"Lumira", "Suncoil", "Honeysuckle", "Nectar Thorn",
		"Crafters Seed Pack", "Bee Balm", "Dandelion",
		"Guanabana", "Peace Lily", "Aloe Vera",
		"Manuka Flower",
	},
	["Gear Recipes"] = {
		"Lightning Rod", "Reclaimer", "Sweet Soaker Sprinkler",
		"Flower Froster Sprinkler", "Anti Bee Egg", "Honey Crafters Crate",
		"Mutation Spray Shocked",
	},
	["Dino Recipes"] = {
		"Ancient Seed Pack", "Mutation Spray Amber", "Dino Crate",
	},
}

--// Assets and Game Events
Utility.GameEvents = Utility.ReplicatedStorage:WaitForChild("GameEvents")
Utility.PetAssets = Utility.Insert:LoadAsset(125322775194286)
Utility.ActivePetsService = Utility.GameEvents:WaitForChild("ActivePetService")

--// Dynamic Data Loading
Utility.SeedStock, Utility.GearStock, Utility.EventItem = {}, {}, {}

for i, v in pairs(Utility.FruitsData) do
	if v.StockAmount and v.StockAmount[2] > 0 then
		table.insert(Utility.SeedStock, i)
	end
end

for i, v in pairs(Utility.Gears) do
	if v.StockAmount and v.StockAmount[2] > 0 then
		table.insert(Utility.GearStock, i)
	end
end

for i, _ in pairs(Utility.EventData) do
	table.insert(Utility.EventItem, i)
end

--// Add "All" filters
for _, list in pairs({ Utility.FruitsData, Utility.Mutations }) do
	if not table.find(list, "All") then
		table.insert(list, "All")
	end
end

--// Egg Stock
Utility.EggStock = {
	"Common Egg", "Bug Egg", "Paradise Egg",
	"Rare Summer Egg", "Common Summer Egg", "Mythical Egg"
}

return Utility
