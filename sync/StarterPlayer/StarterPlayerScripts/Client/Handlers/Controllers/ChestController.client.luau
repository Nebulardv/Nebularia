local Workspace = game:GetService("Workspace")
local WorkspaceAssets = Workspace.Assets

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Utilities = SharedModules.Utilities
local SendSignals = require(Utilities.SendSignals)

local Chests = WorkspaceAssets.Chests

for _, AvailableChest: Model in Chests:GetChildren() do
	if not AvailableChest then
		print("No Available Chest Found in ChestsFolder")
		return
	end
	local TopPart = AvailableChest:WaitForChild("Top") :: BasePart
	if not TopPart then
		print("No TopPart found")
		return
	end

	local OpenPrompt = TopPart:WaitForChild("OpenPrompt") :: ProximityPrompt

	OpenPrompt.Triggered:Connect(function(_PlayerWhoTriggered: Player)
		SendSignals.RequestOpenChest(AvailableChest.Name :: string, AvailableChest :: Model)
	end)
end

