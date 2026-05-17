type AreaNames = "Dark Cave" | "Cold Cavern"
type Entity = "Character" | "Object"

type AreaData = {
	Area: PVInstance,
	Size: Vector3,
	CFrame: CFrame,
	Padding: number,
	Y_Padding: number,
	MaxEntities: number,
	CurrentEntities: number,
	SpawnIntervalDelay: number,
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
	},
}

return table.freeze({})
