--------------------------
--      BR UI Tweaks	--
-- a BellinRattin addon --
-- All Rights Reserved 	--
--------------------------
local addonName, Addon = ...
local F = Addon.Functions
local E = Addon.Events

local UIParent = UIParent

--local GetCVar, SetCVar = C_CVar.GetCVar, C_CVar.SetCVar
local GetCVar, SetCVar = GetCVar, SetCVar
local SetScreenResolution, RestartGx, SetScale = SetScreenResolution, RestartGx, SetScale

local CVAR_RESOLUTION = "gxWindowedResolution"

E:RegisterEvent("PLAYER_ENTERING_WORLD")
E:RegisterEvent("ADDON_LOADED")
E:RegisterEvent("PLAYER_REGEN_DISABLED")
E:RegisterEvent("PLAYER_REGEN_ENABLED")
--E:RegisterEvent("ITEM_LOCKED")
--E:RegisterEvent("ITEM_UNLOCKED")

function E:PLAYER_ENTERING_WORLD(initialLogin, reloadingUI)
	F.SetResolution()
	--F.StartSorting()
end
function E:ADDON_LOADED(arg1)

end

------------------------------------------------------------------------
-- set the correct resolution and scale
------------------------------------------------------------------------
function F.SetResolution()
	-- set the right resolution and UI scale
	if GetCVar(CVAR_RESOLUTION) == "1600x900" then
		-- something something learn to negate something something
	else
		SetCVar(CVAR_RESOLUTION, "1600x900")
		RestartGx()
	end
	UIParent:SetScale(768/900)
end
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Vendor button to sell all Grey items
------------------------------------------------------------------------
function F.SellGreyCoroutine()
	for bag = 0, 4 do 
		for slot = 1, GetContainerNumSlots(bag) do
			local _, _, _, quality, _, _, _, _, noValue = GetContainerItemInfo(bag,slot)
			if quality == 0 and not noValue then
				UseContainerItem(bag, slot) -- use item, with vendor open it sell it
				--coroutine.yield()
			end
		end
	end
end

function F.SellIt(bag, slot)
	UseContainerItem(bag, slot) -- use item, with vendor open it sell it
end

function F.SellGreyItems()
	local count = 0
	for bag = 0, 4 do 
		for slot = 1, GetContainerNumSlots(bag) do
			local _, _, _, quality, _, _, _, _, noValue = GetContainerItemInfo(bag,slot)
			if quality == 0 and not noValue then
				count = count + 1
				C_Timer.After(count * 0.1 + 0.1, UseContainerItem(bag, slot))
				--C_Timer.After(count* 0.1 + 0.1, Addon.Functions.SellIt(bag, slot))
			end
		end
	end
end
------------------------------------------------------------------------

-- TODO
-- Settings Page
-- SellGrey Items button (like Zygor one) - click/toggle onoff
-- All bars and bindings (even new characters)

------------------------------------------------------------------------
-- Bag Enhancement
------------------------------------------------------------------------
local function Item(bag, slot)
	local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(bag, slot)
	
	if itemID then
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemID) 

		local item = {}
		item.ID = itemID
		item.count = itemCount
		item.max = itemStackCount
		item.quality = itemRarity
		item.bag = bag
		item.slot = slot

		return item
	end
end

-- temp -------------------------------------------------------------------------
-- this should come from settings
local active = {
	["HEARTHSTONE"] = true,
	["MOUNTS"] = true,
	["KEYS"] = true,
	["TOOLS"] = true,
	["RODS"] = true,
	["ENCH"] = true,
	["HERBS"] = true,
	["SEEDS"] = true,
	["ARROWS"] = true,
	["BULLETS"] = true,
	["SOULS"] = true,
	["OTHERS"] = true, -- do not remove this or set to false
}
local priority = {
	["HEARTHSTONE"]=1 ,
	["MOUNTS"]=3,
	["KEYS"]=4,
	["TOOLS"]=5,
	["RODS"]=2,
	["OTHERS"]=6,
}
-- temp -------------------------------------------------------------------------

local IDS = Addon.Data.IDS
local CAT = Addon.Data.CAT

local function sort_comparator(a, b)
	if a.ID == b.ID then
		return a.count > b.count
	else
		return a.ID < b.ID
	end
end

local sorted
local bags
local function GetAllItems()
	bags = {}
	bags[0] = {}
	bags[1] = {}
	bags[2] = {}
	bags[3] = {}
	bags[4] = {}
	sorted = {}
	for bag = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local currentItem = Item(bag, slot)
			if currentItem then
				local kind = IDS[currentItem.ID]
				if not kind or not active[kind] then kind = "OTHERS" end
				if kind and active[kind] then  -- this should not be necessary.. check 
					sorted[kind] = sorted[kind] or {}
					tinsert(sorted[kind], currentItem)
					bags[bag][slot] = currentItem
				end
			end
		end
	end
end

local bag_dest
local slot_dest
local function SortTables()
	for _,v in pairs(sorted) do
		sort(v, sort_comparator)
	end

	bag_dest = 0
	slot_dest = 1
	local currentBagSize = GetContainerNumSlots(bag_dest)
	for v = 1, #CAT do
		local cat = CAT[v]
		if sorted[cat] then
			local sor = sorted[cat]
			for i = 1, #sor do
				local item = sor[i]

				bags[item.bag][item.slot].bag_dest = bag_dest
				bags[item.bag][item.slot].slot_dest = slot_dest
				slot_dest = slot_dest +1
				if currentBagSize < slot_dest then
					bag_dest = bag_dest + 1
					currentBagSize = GetContainerNumSlots(bag_dest)
					slot_dest = 1
				end
			end
		end
	end
end


local function GetBagsInfo()
	for bag = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		local slot = GetContainerNumSlots(bag)
		local special = "NONE"
		if bag>1 then
			local il = GetInventoryItemLink("player",19+bag)
			local id = string.match(il, "item:(%d+):")
			special = IDS[id] or "NONE"
		end
		bags[bag] = {["slot"]=slot, ["special"]=special}
	end
end


-- /run ClearCursor() a=PickupContainerItem a(0,1) a(0,2)
local function MoveItem(bag1, slot1, bag2, slot2)
	ClearCursor()
	PickupContainerItem(bag1, slot1)
	PickupContainerItem(bag2, slot2)
end



local function MoveAll()
	local b = 0
	local s = 1
	local currentBagSize = GetContainerNumSlots(b)

	while true do
		item = bags[b][s]
		if item then
			if  (not(item.bag_dest == b) or not(item.slot_dest == s)) then

				MoveItem(item.bag, item.slot, item.bag_dest, item.slot_dest)
				coroutine.yield()

				dest = bags[item.bag_dest][item.slot_dest]
				if dest then
					bags[item.bag_dest][item.slot_dest].bag = item.bag
					bags[item.bag_dest][item.slot_dest].slot = item.slot
					item.bag = item.bag_dest
					item.slot = item.slot_dest
					bags[b][s], bags[item.bag_dest][item.slot_dest] = bags[item.bag_dest][item.slot_dest], bags[b][s]
				else
					item.bag = item.bag_dest
					item.slot = item.slot_dest
					bags[item.bag_dest][item.slot_dest] = bags[b][s]
					bags[b][s] = nil 
				end
			else
				s = s + 1
				if s>currentBagSize then
					b = b + 1
					currentBagSize = GetContainerNumSlots(b)
					s = 1
					if b>4 then 
						E:UnregisterEvent("ITEM_LOCKED")
						E:UnregisterEvent("ITEM_UNLOCKED") 
						break 
					end
				end
			end
		else
			s = s + 1
			if s>currentBagSize then
				b = b + 1
				currentBagSize = GetContainerNumSlots(b)
				s = 1
				if b>4 then
					E:UnregisterEvent("ITEM_LOCKED")
					E:UnregisterEvent("ITEM_UNLOCKED") 
					break 
				end
			end
		end
	end
end

local co

function F.StartSorting()
	E:RegisterEvent("ITEM_LOCKED")
	E:RegisterEvent("ITEM_UNLOCKED")
	GetAllItems()
	SortTables()
	co = coroutine.create(MoveAll)
	coroutine.resume(co)
end

local lock_count = 0
function E:ITEM_LOCKED()
	lock_count = lock_count +1  
end

function E:ITEM_UNLOCKED()
	lock_count = lock_count -1 
	if lock_count == 0 then
		coroutine.resume(co)
	end
end

SLASH_SORT1, SLASH_SORT2, SLASH_SORT3 = '/brsort', '/sortbags', '/sortbag'
function SlashCmdList.SORT()
	print("Start sorting")
	F.StartSorting()
end

local sortButton = CreateFrame("Button", "sortButton", ContainerFrame1, "UIPanelButtonTemplate")
sortButton:SetPoint("TOP", ContainerFrame1CloseButton, "BOTTOM", -1, 4)
sortButton:SetSize(20, 20)
sortButton:SetText("S")
sortButton:SetScript("OnClick", F.StartSorting)



function F.CountEmptySpaces()
	local emptySpaces = 0
	for bag = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemInfo(bag,slot)
			if not item then
				emptySpaces = emptySpaces + 1
			end
		end
	end
	return emptySpaces
end

function F.CountGrayItems()
	local greyCount = 0
	for bag = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemInfo(bag,slot)
			if not item then
				greyCount = greyCount + 1
			end
		end
	end
	return greyCount
end

local function CycleThroughBags(fun, init, ...)
	local ret = init or 0
	for bag = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			fun(bag, slot, ret, ...)
		end
	end
	return ret
end

local function GetEmpty(bag, slot, ret)
	local item = GetContainerItemInfo(bag,slot)
	if not item then
		ret = ret + 1
	end
end
