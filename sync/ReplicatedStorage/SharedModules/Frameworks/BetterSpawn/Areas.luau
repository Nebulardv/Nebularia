const Workspace = game:GetService("Workspace")


const Assets = Workspace.Assets
const SpawnAreas = Assets.SpawnAreas
const AreaModule = require(script.Area)

type AreaDefinitions = AreaModule.AreaDefinitions

const Areas: AreaDefinitions = {
    ["Dark Cave"] = {
        EntityType = "Character",
        AreaData = { MaxEntities = 10 },
        Area = SpawnAreas["Dark Cave"]
    }
} 

return Areas


