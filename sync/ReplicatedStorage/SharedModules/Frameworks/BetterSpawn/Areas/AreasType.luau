type AreaNames = "Dark Cave" | "Cold Cavern"
type Entity = "Character" | "Object"
type AreaData = {
	MaxEntities: number,
	CurrentEntities: number,
}
type EntityObject = {
	Object: PVInstance,
	ID: string | number,
}

export type AreaDefinitions = {
	[AreaNames]: {
		["EntityType"]: Entity,
		["EntityObject"]: EntityObject,
		["AreaData"]: AreaData,
		["Area"]: BasePart | UnionOperation | Model,
	},
}

return table.freeze({})
