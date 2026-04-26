local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WorkspaceAssets = workspace.Assets
local ChestsFolder = WorkspaceAssets.Chests

local _SharedModules = ReplicatedStorage.SharedModules
local Services = _SharedModules.Services
local Chests = require(script.Chests)
local _InventoryService = require(Services.InventoryService)

local ChestsModuleObject = script.Chests

export type ChestStatesType = {
	[string]: {
		AlreadyOpened: boolean,
		IsOpening: boolean,
		Tagged: boolean,
	},
}

type Chest = "Common Chest" | "Uncommon Chest" | "Rare Chest" | "Epic Chest" | "Legendary Chest"

local Random = Random.new()

local ChestStates: ChestStatesType = {}

local ChestsService = {}

const function GetRandomKey(ItemsDict: { [string]: any })
	local KeysArray = {} :: { string } 

	for Key, _ in ItemsDict do
		table.insert(KeysArray, Key)
	end

	local RandomIndex = Random:NextInteger(1, #KeysArray)

	return KeysArray[RandomIndex]
end

function ChestsService.OpenChest(ChestName: Chest, ChestModel: Model)
	local ChestData = Chests[ChestName]
	local RandomItemKey = GetRandomKey(ChestData.Items)
	local RandomItem = ChestData.Items[RandomItemKey]:Clone()

	local SHORTENED_NAME = string.gsub(ChestName, " Chest", "")
	--// Adding the space right before Chest removes the spacing in RARITY Chest; leaving only RARITY without the space afterwards
	
	local Module = ChestsModuleObject[SHORTENED_NAME]
	if not Module then
		print("Module not found")
		return
	end

	local ChestModule = require(Module)

	local Completed = ChestModule(ChestModel, RandomItem)

	if Completed then
		local OpenPrompt = (ChestModel.PrimaryPart :: BasePart):FindFirstChild("OpenPrompt")

		if not OpenPrompt then
			print("No OpenPrompt Found")
			return
		end

		OpenPrompt:Destroy()
		
		local ItemsFolder = ChestModel:FindFirstChild("Items")
		local Item = ItemsFolder:FindFirstChildOfClass("Model")
		if not Item then
			print("No Item Found")
			return
		end
		
		return Item
	end

	return nil
end

function ChestsService.Init()
	for _, Chest: Model in ChestsFolder:GetChildren() do
		ChestStates[Chest.Name] = {
			AlreadyOpened = false,
			IsOpening = false,
			Tagged = false,
		}
		if not ChestStates[Chest.Name].Tagged then
			local OpenPrompt = Instance.new("ProximityPrompt")
			OpenPrompt.Name = "OpenPrompt"
			OpenPrompt.ActionText = "Open " .. Chest.Name
			OpenPrompt.RequiresLineOfSight = false
			OpenPrompt.HoldDuration = 0.25
			OpenPrompt.Parent = Chest.PrimaryPart
			ChestStates[Chest.Name].Tagged = true
		end

		local OpenPrompt = (Chest.PrimaryPart :: BasePart):FindFirstChild("OpenPrompt") :: ProximityPrompt
		if not OpenPrompt then
			return
		end

		local _TriggerConnection: RBXScriptConnection = nil
	end
end

return ChestsService
