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
            ID = "Cave Gladiator" 
        },
        AreaData = { MaxEntities = 10, CurrentEntities = 0},
        Area = SpawnAreas["Dark Cave"]
    }
} 

return Areas


