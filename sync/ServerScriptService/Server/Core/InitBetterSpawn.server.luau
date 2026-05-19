const ReplicatedStorage = game:GetService("ReplicatedStorage")

const SharedModules = ReplicatedStorage.SharedModules
const Frameworks = SharedModules.Frameworks
const BetterSpawn = require(Frameworks.BetterSpawn)

const Assets = workspace.Assets
const SpawnAreas = Assets.SpawnAreas

for _, SpawnArea in SpawnAreas:GetChildren() do
	BetterSpawn.InitSpawnInRandomPosition(SpawnArea.Name)
end
