local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local Signals = Events.Signals

local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local WeaponData = require(Services.EquipService.WeaponData)
local EquipService = require(Services.EquipService)

local SendSlashEffectToAllClients = Signals.SendSlashEffectToAllClients :: RemoteEvent

SendSlashEffectToAllClients.OnServerEvent:Connect(function(Player: Player)
	local EquippedWeapon = EquipService.GetEquippedWeapon(Player.UserId)

	if not EquippedWeapon then
		return
	end

	local EquippedWeaponData = WeaponData[EquippedWeapon]
	if not EquippedWeaponData then
		return
	end

	local WeaponSlashEffect = EquippedWeaponData.Effects
	if not WeaponSlashEffect then
		print("Weapon Slash Effect for: " .. EquippedWeaponData.WeaponName .. "Not found")
	end

	local OwnerSlashCharacter = Player.Character
	SendSlashEffectToAllClients:FireAllClients(OwnerSlashCharacter, WeaponSlashEffect)
end)
