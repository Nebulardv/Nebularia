local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local Shared = ReplicatedStorage.SharedModules
local Signals = Events.Signals
local Services = Shared.Services


local EffectsService = require(Services.EffectsService)

local SendEffectsToAllClientsEvent: RemoteEvent = Signals.SendEffectsToAllClients
local SendSoundEffectsToAllClientsEvent: RemoteEvent = Signals.SendSoundEffectsToAllClients


SendEffectsToAllClientsEvent.OnClientEvent:Connect(function(
	TargetCharacter,
	BloodHitVFX,
	VfxPosition,
	EmitCount
)
	
	local BloodHitVfxClone = BloodHitVFX:Clone()
	EffectsService.PlayVisualEffects(
		VfxPosition,
		BloodHitVfxClone,
		TargetCharacter,
		EmitCount,
		0.5
	) 
end)

SendSoundEffectsToAllClientsEvent.OnClientEvent:Connect(function(
	SoundEffect: Sound,
	SoundParent: Model | BasePart
)
	local SoundEffectClone = SoundEffect:Clone()
	EffectsService.PlaySoundEffects(
		SoundEffectClone,
		SoundParent
	)
end)