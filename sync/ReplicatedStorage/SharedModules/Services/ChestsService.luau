local _ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _TweenService = game:GetService("TweenService")

local WorkspaceAssets = workspace.Assets
local ChestsFolder = WorkspaceAssets.Chests

local _SharedModules = ReplicatedStorage.SharedModules
local Chests = require(script.Chests)
local Services = _SharedModules.Services
local _InventoryService = require(Services.InventoryService)

export type ChestStatesType = {
	[string]: {
		AlreadyOpened: boolean,
		IsOpening: boolean,
		Tagged: boolean,
	},
}

local ChestStates: ChestStatesType = {}

local ChestsService = {}

function ChestsService.OpenChest(ChestName: string, ChestModel: Model)
	local ChestData = Chests[ChestName]
	local OpenCallback = ChestData.OpenCallback

	OpenCallback(ChestModel)
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

		local TriggerConnection: RBXScriptConnection = nil
		TriggerConnection = OpenPrompt.Triggered:Connect(function(Player: Player)
			ChestsService.OpenChest(Chest.Name, Chest)
		end)

		OpenPrompt.TriggerEnded:Connect(function(Player: Player)
			TriggerConnection:Disconnect()
		end)
	end
end

return ChestsService
