-- Bytox Hub — سكربت كامل يجمع Library (WindUI)، Utility، Module، ويحمّل موارد Bytox2.lua
-- ملاحظة: هذا السكربت يفترض أن الملفات الخارجية (Utility, Module, Resources) تُرجع جداول أو وظائف عند تحميلها.

-- =========================
-- مكتبة الواجهة (Bytox Hub) — مصححة وجاهزة
-- =========================
local Library = {}
Library.__index = Library
Library.Async = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local UI = Library.Async
local Window = nil

-- Notification helper (يتوقع WindUI أن يوفر دالة Notification)
function Library:Notify(Table)
	-- محاولات متعددة لأن بعض نسخ WindUI قد تستخدم أسماء مختلفة
	if UI and UI.Notification then
		pcall(function() UI:Notification(Table) end)
	elseif UI and UI.Notify then
		pcall(function() UI:Notify(Table) end)
	else
		-- fallback: طباعة
		print((Table and Table.Title or "Notification") .. " - " .. (Table and Table.Content or "No Content"))
	end
end

function Library:Setup()
	local version = (getgenv().LRM_ScriptVersion and "v" .. tostring(getgenv().LRM_ScriptVersion)) or "Dev Version"
	local premium = getgenv().premium or false

	Window = UI:CreateWindow({
		Title = "Bytox Hub",
		Icon = "rbxassetid://128278170341835",
		Author = (premium and "Premium" or "Public") .. " | " .. version,
		Folder = "BytoxHub",
		Size = UDim2.fromOffset(820, 520),
		Transparent = true,
		Theme = "Dark",
		Resizable = true,
		SideBarWidth = 240,
		Background = "",
		BackgroundImageTransparency = 0.42,
		HideSearchBar = false,
		ScrollBarEnabled = true,
		User = {
			Enabled = true,
			Anonymous = false,
			Callback = function()
				print("Bytox Hub user clicked profile")
			end,
		},
	})

	return Window
end

function Library:CreateTab(Name, Icon)
	local win = Window or self:Setup()

	if not win then
		error("[Bytox Library]: Failed to find Window")
		return
	end

	local Tab = win:Tab({
		Title = Name,
		Icon = Icon,
		Locked = false,
	})

	return Tab
end

function Library:CreateSection(Tab, Title, Size)
	return Tab:Section({
		Title = Title,
		TextXAlignment = "Left",
		TextSize = Size or 17,
	})
end

function Library:CreateToggle(Tab, Table) return Tab:Toggle(Table) end
function Library:CreateButton(Tab, Table) return Tab:Button(Table) end
function Library:CreateSlider(Tab, Table) return Tab:Slider(Table) end
function Library:CreateDropdown(Tab, Table) return Tab:Dropdown(Table) end
function Library:CreateInput(Tab, Table) return Tab:Input(Table) end

function Library:SetupAboutUs(AboutUs)
	local win = Window or self:Setup()
	if not win then error("[Bytox Library]: Failed to find Window") return end

	AboutUs:Paragraph({
		Title = "About Bytox Hub",
		Icon = "info",
		Desc = "Bytox Hub — custom script hub. Use responsibly. Bytox rights reserved.",
	})

	AboutUs:Paragraph({
		Title = "Discord Invites",
		Icon = "discord",
		Desc = "Join the Bytox community for updates and support!",
	})

	AboutUs:Button({
		Title = "Discord Link (Click to Copy)",
		Icon = "link",
		Callback = function()
			pcall(function() setclipboard("discord.gg/BytoxHub") end)
			Library:Notify({ Title = "Copied!", Content = "Discord link copied!", Duration = 3 })
		end,
	})
end

-- =========================
-- تحميل وحدات خارجية: Utility, Module, Resources
-- (نستعمل روابط raw من GitHub — عدّل إذا تريد الاستضافة في مكان آخر)
-- =========================
local successUtil, Utility = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/hajibeza/Module/refs/heads/main/GAG_Utility.lua"))()
end)
if not successUtil or not Utility then
	warn("[Bytox Hub] Failed to load Utility module.")
	Utility = {} -- fallback فارغ لتجنب الأخطاء
end

local successModule, Module = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/hajibeza/Module/refs/heads/main/GAG_Module.lua"))()
end)
if not successModule or not Module then
	warn("[Bytox Hub] Failed to load Module module.")
	Module = {} -- fallback
end

local successResources, Resources = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/ByxCommunityZz6/Zhzhz/refs/heads/main/Bytox2.lua"))()
end)
if not successResources or not Resources then
	warn("[Bytox Hub] Failed to load Resources (Bytox2.lua).")
	Resources = nil
end

-- =========================
-- واجهة المستخدم الرئيسية: إنشاء تبويبات وعناصر تفاعلية
-- =========================
local WindowObj = Library:Setup()

-- Tabs
local mainTab = Library:CreateTab("Main", "home")
local utilTab = Library:CreateTab("Utility", "cog")
local resTab = Library:CreateTab("Resources", "box-open")
local aboutTab = Library:CreateTab("About", "info")

-- Main Section (أزرار عامة)
local mainSec = Library:CreateSection(mainTab, "General", 18)
mainSec:CreateButton({
	Title = "Notify Test",
	Callback = function()
		Library:Notify({ Title = "Bytox Hub", Content = "Notification test successful.", Duration = 3 })
	end,
})

mainSec:CreateButton({
	Title = "Server Hop (same place) — random",
	Callback = function()
		if Module and Module.ServerHop then
			pcall(function()
				-- يستعمل PlaceId الموجود في اللعبة الحالية
				local placeId = game.PlaceId
				local jobId = game.JobId
				Module:ServerHop(placeId, jobId, false)
			end)
		else
			Library:Notify({ Title = "Error", Content = "ServerHop غير متوفر.", Duration = 3 })
		end
	end,
})

-- Utility Section (دوال مفيدة)
local utilSec = Library:CreateSection(utilTab, "Utilities", 17)

-- مثال: زر لالتقاط أفضل ثمرة (إن وُجدت الدالة في Module)
utilSec:CreateButton({
	Title = "Get Best Fruit",
	Callback = function()
		if Module and Module.GetBestFruit then
			local ok, best, value = pcall(function() return Module:GetBestFruit() end)
			if ok and best then
				Library:Notify({ Title = "Best Fruit", Content = tostring(best.Name or best) .. " | Value: " .. tostring(value or "N/A"), Duration = 4 })
			else
				Library:Notify({ Title = "Best Fruit", Content = "No best fruit found or error.", Duration = 4 })
			end
		else
			Library:Notify({ Title = "Error", Content = "Function GetBestFruit غير موجودة.", Duration = 3 })
		end
	end,
})

-- زر تلقائي لزراعة بذرة عشوائية (يستخدم Module:Plant إذا متوفر)
utilSec:CreateButton({
	Title = "Plant Random Seed (Under Player)",
	Callback = function()
		if Module and Module.Plant and Utility and Utility.Positions then
			local seeds = {}
			-- نحاول الحصول على البذور من Utility.FruitsData أو Module:GetSeeds
			if type(Module.GetSeeds) == "function" then
				local ok, s = pcall(function() return Module:GetSeeds() end)
				if ok and type(s) == "table" and #s > 0 then seeds = s end
			end
			if #seeds == 0 and Utility and Utility.SeedStock then seeds = Utility.SeedStock end

			if #seeds > 0 then
				local seedName = seeds[math.random(1, #seeds)]
				local pos = Module and Module.GetPosition and Module:GetPosition("UnderPlayer") or (Utility and Utility.Positions and Utility.Positions["Middle"] and Utility.Positions["Middle"].Position or nil)
				if pos then
					-- إذا Module:Plant يتوقّع Vector3 أو CFrame فنبعث Position مناسب
					local ok, err = pcall(function() Module:Plant(pos, seedName) end)
					if ok then
						Library:Notify({ Title = "Planted", Content = tostring(seedName), Duration = 3 })
					else
						Library:Notify({ Title = "Error", Content = "Plant failed: " .. tostring(err), Duration = 4 })
					end
				else
					Library:Notify({ Title = "Error", Content = "No valid position found.", Duration = 3 })
				end
			else
				Library:Notify({ Title = "Error", Content = "No seeds available.", Duration = 3 })
			end
		else
			Library:Notify({ Title = "Error", Content = "Module or Utility غير متاح.", Duration = 3 })
		end
	end,
})

-- Resources Tab — عرض وتحكّم بالموارد المحمّلة من Bytox2.lua
local resSec = Library:CreateSection(resTab, "Bytox Resources", 16)

if Resources == nil then
	resSec:CreateButton({
		Title = "Resources Not Loaded",
		Callback = function()
			Library:Notify({ Title = "Resources", Content = "لم يتم تحميل ملف Bytox2.lua بنجاح.", Duration = 4 })
		end,
	})
else
	-- نتعامل مع Resources كـ جدول أو دالة ترجع جدول
	local resourceTable = nil
	if type(Resources) == "table" then
		resourceTable = Resources
	elseif type(Resources) == "function" then
		local ok, ret = pcall(Resources)
		if ok and type(ret) == "table" then resourceTable = ret end
	end

	if not resourceTable then
		-- fallback: نعرض الرسالة ونخزّن القيمة الأولية
		resSec:CreateButton({
			Title = "Resources Loaded (unknown format)",
			Callback = function()
				Library:Notify({ Title = "Resources", Content = "تم التحميل لكن التنسيق غير مدعوم للعرض التلقائي.", Duration = 4 })
			end,
		})
	else
		-- نعرض مفاتيح الموارد كقائمة Dropdown
		local keys = {}
		for k, v in pairs(resourceTable) do
			table.insert(keys, tostring(k))
		end
		table.sort(keys, function(a,b) return a:lower() < b:lower() end)

		local selected = keys[1] or "None"
		resSec:CreateDropdown({
			Title = "Select Resource",
			Options = keys,
			Callback = function(opt)
				selected = opt
			end,
		})

		-- زر لعرض التفاصيل في الإخراج أو نسخ اسم المورد
		resSec:CreateButton({
			Title = "Show Selected Resource (print)",
			Callback = function()
				if resourceTable[selected] ~= nil then
					print("[Bytox Resources] Selected:", selected, resourceTable[selected])
					Library:Notify({ Title = "Resources", Content = "Printed resource to console: " .. tostring(selected), Duration = 3 })
				else
					Library:Notify({ Title = "Resources", Content = "Selection invalid.", Duration = 3 })
				end
			end,
		})

		-- زر لنسخ اسم المورد
		resSec:CreateButton({
			Title = "Copy Resource Name",
			Callback = function()
				pcall(function() setclipboard(selected) end)
				Library:Notify({ Title = "Clipboard", Content = "Copied: " .. tostring(selected), Duration = 2 })
			end,
		})

		-- إذا كان المورد عبارة عن موديل assetId أو وظيفة إنشاء، نضيف زر محاولة الإدخال
		resSec:CreateButton({
			Title = "Try Load/Insert Selected (if assetId or func)",
			Callback = function()
				local val = resourceTable[selected]
				-- إذا كانت قيمة رقمية فنعاملها كـ asset id
				if type(val) == "number" then
					local ok, ins = pcall(function()
						return game:GetService("InsertService"):LoadLocalAsset("rbxassetid://" .. tostring(val))
					end)
					if ok and ins then
						Library:Notify({ Title = "Inserted", Content = "Inserted asset id: " .. tostring(val), Duration = 3 })
					else
						Library:Notify({ Title = "Error", Content = "Insert failed for id: " .. tostring(val), Duration = 4 })
					end
				elseif type(val) == "string" and tonumber(val) then
					local ok, ins = pcall(function()
						return game:GetService("InsertService"):LoadLocalAsset("rbxassetid://" .. tostring(val))
					end)
					if ok and ins then
						Library:Notify({ Title = "Inserted", Content = "Inserted asset id: " .. tostring(val), Duration = 3 })
					else
						Library:Notify({ Title = "Error", Content = "Insert failed for id: " .. tostring(val), Duration = 4 })
					end
				elseif type(val) == "function" then
					local ok, ret = pcall(val)
					if ok then
						Library:Notify({ Title = "Function", Content = "Resource function executed.", Duration = 3 })
					else
						Library:Notify({ Title = "Error", Content = "Resource function failed.", Duration = 4 })
					end
				else
					Library:Notify({ Title = "Info", Content = "Resource type: " .. type(val), Duration = 3 })
				end
			end,
		})
	end
end

-- About tab
local aboutSec = Library:CreateSection(aboutTab, "About / Credits", 16)
Library:SetupAboutUs(aboutSec)

-- =========================
-- انتهاء الإعداد — تنبيه للمستخدم
-- =========================
Library:Notify({ Title = "Bytox Hub", Content = "Loaded core UI and attempted to load Utility, Module, and Resources.", Duration = 4 })

-- =========================
-- نهاية الملف
-- =========================
