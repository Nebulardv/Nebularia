type AreaNames = "Dark Cave" | "Cold Cavern"

type Entity = "Character" | "Object"
type AreaData = {
	MaxEntities: number,
}

export type AreaDefinitions = {
	[AreaNames]: {
		["EntityType"]: Entity,
		["AreaData"]: AreaData,
		["Area"]: BasePart | UnionOperation | Model,
	},
}

return table.freeze({})
