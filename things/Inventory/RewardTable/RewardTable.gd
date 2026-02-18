class_name RewardTable extends Resource 

@export var rewardEntries: Array[RewardEntry] = []

# Returns the first found reward for the players.
# It goes through its table of RewardEntries, until it finds a requirement that has been met.
# It then returns the item, and terminates.
func returnFirstReward(talliedStats: Dictionary[StringName, int] = {}) -> Item:
	
	for rewardEntry: RewardEntry in self.rewardEntries : 
		var statValue = talliedStats.get(rewardEntry.playerStatDef.key, null)
		if(statValue and statValue >= rewardEntry.requirement * (rewardEntry.rewards_given + 1) ):
			print("rewarded for %s" % [rewardEntry.playerStatDef.key])
			rewardEntry.rewards_given += 1
			
			print("this was the %d reward for this stat" % [rewardEntry.rewards_given])
			return rewardEntry.rewardPool.pick_random()
			
			
	#No reward. Pick a random Point item from the ItemDB		
	print("No reward")
	var pointItemID = ItemDB.items.keys().pick_random()
	var reward: Item = ItemDB.getItem(pointItemID)
	
	return reward
