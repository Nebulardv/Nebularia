--!strict

export type Quests = {
	[string]: {
		ID: string,
		GoalAmount: number,
		Reward: number,
		Objective: string,
		ObjectiveTarget: string ,
		Description: string,
		CompletedText: string,
	}

}

return {}