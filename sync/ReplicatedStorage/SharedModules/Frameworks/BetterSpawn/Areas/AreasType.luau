type AreaNames = "Dark Cave" | "Cold Cavern"
type Entity = "Character" | "Object"
type AreaData = {
	MaxEntities: number,
}
type EntityData = {
	EntityName: string,
	EntityObject: Model | BasePart | UnionOperation,
}

export type AreaDefinitions = {
	[AreaNames]: {
		["EntityType"]: Entity,
		["EntityData"]: EntityData,
		["AreaData"]: AreaData,
		["Area"]: BasePart | UnionOperation | Model,
	},
}

return table.freeze({})
