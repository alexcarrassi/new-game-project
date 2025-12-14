class_name EnemyIntent extends RefCounted


# Enemy intents are used for AI.
# They are capable of thinking. Rather than using a think() function that would mutate
# states, we use an EnemyIntent struct.
# This struct gets consumed by the states capable of consuming them,
# and then take appropriate action by switching states. This makes it so that States can only be changed
# from within the StateMachine architecture itself

var locomotion: StringName = &""
var act: StringName = &""

func clear() -> void:
	self.locomotion = &""
	self.act = &""
	
	
func clear_locomotion() -> void:
	self.locomotion = &""

func clear_act() -> void:
	self.act = &""
