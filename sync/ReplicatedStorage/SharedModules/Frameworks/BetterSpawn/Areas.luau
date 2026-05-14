const Workspace = game:GetService("Workspace")
const Assets = Workspace.Assets
const Characters = Assets.Characters
const SpawnAreas = Assets.SpawnAreas
const AreaModule = require(script.AreasType)

type AreaDefinitions = AreaModule.AreaDefinitions

const Areas: AreaDefinitions = {
    ["Dark Cave"] = {
        EntityType = "Character",
        EntityData = {EntityName = "Cave Gladiator", EntityObject = Characters["Cave Gladiator"]},
        AreaData = { MaxEntities = 10 },
        Area = SpawnAreas["Dark Cave"]
    }
} 

return Areas


