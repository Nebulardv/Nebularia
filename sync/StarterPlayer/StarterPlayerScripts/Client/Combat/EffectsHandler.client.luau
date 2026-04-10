local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local Shared = ReplicatedStorage.SharedModules
local Signals = Events.Signals
local Services = Shared.Services

local EffectsService = require(Services.EffectsService)

local SendEffectsToAllClientsEvent: RemoteEvent = Signals.SendEffectsToAllClients
local SendSoundEffectsToAllClientsEvent: RemoteEvent = Signals.SendSoundEffectsToAllClients

local SendSlashEffectToAllClients = Signals.SendSlashEffectToAllClients :: RemoteEvent

SendEffectsToAllClientsEvent.OnClientEvent:Connect(function(TargetCharacter, BloodHitVFX, VfxPosition, EmitCount)
	local BloodHitVfxClone = BloodHitVFX:Clone()
	EffectsService.PlayVisualEffects(VfxPosition, BloodHitVfxClone, TargetCharacter, EmitCount, 0.5)
end)

SendSoundEffectsToAllClientsEvent.OnClientEvent:Connect(function(SoundEffect: Sound, SoundParent: Model | BasePart)
	local SoundEffectClone = SoundEffect:Clone()
	EffectsService.PlaySoundEffects(SoundEffectClone, SoundParent)
end)

SendSlashEffectToAllClients.OnClientEvent:Connect(function(OwnerSlashCharacter: Model, WeaponSlashEffect: Attachment)
	local OwnerRootPart = OwnerSlashCharacter:WaitForChild("HumanoidRootPart") :: BasePart

	local SlashPosition = OwnerRootPart.CFrame
		* CFrame.new(0, 0, -4)
		* CFrame.Angles(math.rad(0), math.rad(45), math.rad(0))

	EffectsService.PlayVisualEffects(SlashPosition, WeaponSlashEffect:Clone(), OwnerSlashCharacter, 5, 0.5)
end)
