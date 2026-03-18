local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local OnItemAdded: BindableEvent = Events.OnItemAdded
local OnItemRemoved: BindableEvent = Events.OnItemRemoved
local OnInventoryCleared: BindableEvent = Events.OnInventoryCleared


type InventoryType = {[number]: {[string]: number}}

local GlobalInventoryDictionary: InventoryType = {}

local InventoryService = {}
function InventoryService.CreatePlayerInventory(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	GlobalInventoryDictionary[PlayerID] = {}
	
	print("Created Player Inventory for: ".. tostring(PlayerID))
end

function InventoryService.AddToInventory(PlayerID: number, ItemName: string, Amount: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	assert(typeof(ItemName) == "string", "ItemName is not a string")
	if not GlobalInventoryDictionary[PlayerID] then
		print("Player Does not have an Inventory")
		return
	end
	if not GlobalInventoryDictionary[PlayerID][ItemName] then
		GlobalInventoryDictionary[PlayerID][ItemName] = Amount
	else
		GlobalInventoryDictionary[PlayerID][ItemName] += Amount
	end
	
	OnItemAdded:Fire(PlayerID, ItemName, Amount)
	
	print("Added Item To Inventory: ".. ItemName)
end

function InventoryService.RemoveFromInventory(PlayerID: number, ItemName: string, Amount: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	assert(typeof(ItemName) == "string", "ItemName is not a string")
	if not GlobalInventoryDictionary[PlayerID] then
		print("Player Does not have an Inventory")
		return
	end
	if not GlobalInventoryDictionary[PlayerID][ItemName] then
		return
	end
	
	GlobalInventoryDictionary[PlayerID][ItemName] -= Amount
	if GlobalInventoryDictionary[PlayerID][ItemName] <= 0 then
		GlobalInventoryDictionary[PlayerID][ItemName] = nil
	end
	OnItemRemoved:Fire(PlayerID, ItemName, Amount)
end

function InventoryService.GetInventory(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	return GlobalInventoryDictionary[PlayerID]
end

function InventoryService.HasItem(PlayerID: number, ItemName: string)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	assert(typeof(ItemName) == "string", "ItemName is not a string")
	if not GlobalInventoryDictionary[PlayerID] then
		print("Player Does not have an Inventory")
		return
	end
	if not GlobalInventoryDictionary[PlayerID][ItemName] then
		return false
	end
	return true
end


function InventoryService.ClearInventory(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	GlobalInventoryDictionary[PlayerID] = {}
	OnInventoryCleared:Fire(PlayerID)
	print("Cleared Player Inventory for: ".. tostring(PlayerID))
end

return InventoryService
