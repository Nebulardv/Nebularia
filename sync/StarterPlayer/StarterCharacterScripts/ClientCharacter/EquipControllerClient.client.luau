const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")

const SharedModules = ReplicatedStorage.SharedModules
const Utilities = SharedModules.Utilities
const SendSignals = require(Utilities.SendSignals)

const Data = SharedModules.Data

local Client = Players.LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()

local WeaponDataDictionary = require(Data.Weapons)


local Registered = {}

const function HandleWeapon(Weapon: Tool)
	local ToolWeaponName = Weapon.Name
	local WeaponData = WeaponDataDictionary[ToolWeaponName]
	if not WeaponData then
		return
	end


	if Weapon:IsA("Tool") then
		Weapon.Equipped:Connect(function()
			SendSignals.RequestWeaponHandlerSignal("Equip")
		end)

		Weapon.Unequipped:Connect(function()
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
