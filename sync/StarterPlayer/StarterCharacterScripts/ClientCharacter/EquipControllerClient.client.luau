local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Utilities = SharedModules.Utilities
local SendSignals = require(Utilities.SendSignals)

local Data = SharedModules.Data
local Services = SharedModules.Services

local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()

local WeaponDataDictionary = require(Data.Weapons)

local AnimationService = require(Services.AnimationService)

local Registered = {}

const function HandleWeapon(Weapon: Tool)
	local ToolWeaponName = Weapon.Name
	local WeaponData = WeaponDataDictionary[ToolWeaponName]
	if not WeaponData then
		return
	end

	local IdleAnim = WeaponData.AttackAnims.Idle

	if Weapon:IsA("Tool") then
		Weapon.Equipped:Connect(function()
			AnimationService.PlayAnimation(Character, IdleAnim.Name, "Yes", 0.2)
			SendSignals.RequestWeaponHandlerSignal("Equip")
		end)

		Weapon.Unequipped:Connect(function()
			AnimationService.StopAnimation(Character, IdleAnim.Name, "Yes", 0.2)
			SendSignals.RequestWeaponHandlerSignal("Unequip")
		end)
	end
end

for _, Weapon in pairs(Client.Backpack:GetChildren()) do
	HandleWeapon(Weapon)
	table.insert(Registered, Weapon)
end

Character.ChildAdded:Connect(function(NewWeapon)
	if table.find(Registered, NewWeapon) then
		return
	end
	table.insert(Registered, NewWeapon)
	HandleWeapon(NewWeapon)
end)

Client.Backpack.ChildAdded:Connect(function(NewWeapon)
	if table.find(Registered, NewWeapon) then
		return
	end
	table.insert(Registered, NewWeapon)
	HandleWeapon(NewWeapon)
end)

Client.CharacterAdded:Connect(function(Character: Model)
	Character.ChildAdded:Connect(function(NewWeapon)
		if table.find(Registered, NewWeapon) then
			return
		end
		table.insert(Registered, NewWeapon)
		HandleWeapon(NewWeapon)
	end)
end)
