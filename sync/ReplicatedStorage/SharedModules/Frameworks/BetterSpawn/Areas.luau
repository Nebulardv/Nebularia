const Workspace = game:GetService("Workspace")
const Assets = Workspace.Assets
const Characters = Assets.Characters
const SpawnAreas = Assets.SpawnAreas
const AreaModule = require(script.AreasType)

type AreaDefinitions = AreaModule.AreaDefinitions

const Areas: AreaDefinitions = {
	["Dark Cave"] = {
		EntityType = "Character",
		EntityObject = {
			Object = Characters["Cave Gladiator"],
			ID = "Cave Gladiator",
		},
		AreaData = {
			Area = SpawnAreas["Dark Cave"],
			CFrame = SpawnAreas["Dark Cave"].CFrame,
			Size = SpawnAreas["Dark Cave"].Size,
			Padding = 5,
			Y_Padding = 3,
			MaxEntities = 10,
			CurrentEntities = 0,
			SpawnIntervalDelay = 2,
		},
	},
	["Woodland Creek"] = {
		EntityType = "Character",
		EntityObject = {
			Object = Characters["Creek Commander"],
			ID = "Creek Commanders",
		},
		AreaData = {
			Area = SpawnAreas["Woodland Creek"],
			CFrame = SpawnAreas["Woodland Creek"].CFrame,
			Size = SpawnAreas["Woodland Creek"].Size,
			Padding = 5,
			Y_Padding = 3,
			MaxEntities = 10,
			CurrentEntities = 0,
			SpawnIntervalDelay = 2,
		},
	},
}

return Areas
