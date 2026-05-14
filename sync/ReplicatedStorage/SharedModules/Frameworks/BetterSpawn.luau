const Areas = require("@self/Areas")

local BetterSpawn = {}

function BetterSpawn.SpawnEntities(AreaName: string)
    const AreaData = Areas[AreaName]
    assert(AreaData, "No AreaData found")

    print(AreaData)
end

return BetterSpawn
