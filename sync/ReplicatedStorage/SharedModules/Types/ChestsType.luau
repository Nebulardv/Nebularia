type Chest = "Common Chest" | "Uncommon Chest" | "Rare Chest" | "Epic Chest" | "Legendary Chest"

export type Chests = {
	[Chest]: {
		Items: { [string]: Model? | BasePart? | UnionOperation? },
		Data: {
			OpenTime: number,
			OpenPositionOffset: number,
			ItemPositionOffset: number,
			ItemRotationOffsetCFrame: CFrame,
		},
	},
}

return {}
