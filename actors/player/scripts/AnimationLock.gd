class_name AnimationLock extends RefCounted	

var prio: int
var lockTotal: float
var current : float = 0

func _init(prio: int, lockTotal: float) -> void:
	self.prio = prio
	self.lockTotal = lockTotal
