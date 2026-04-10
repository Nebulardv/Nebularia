local _StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Utilities = SharedModules.Utilities
local SendSignals = require(Utilities.SendSignals)

local _ReplicatedStorage = game:GetService("ReplicatedStorage")

local _Events = ReplicatedStorage.Events

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local InventoryUpdData = {
	RequestedItemName = "Katana",
	Amount = 1,
	RequestedAction = "AddItem",
}

Player.CharacterAdded:Connect(function(Character: Model)
	if Character == Player.Character then
		SendSignals.RequestInventoryUpdateSignal(InventoryUpdData)
	else
		return
	end
end)
