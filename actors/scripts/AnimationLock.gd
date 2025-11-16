class_name AnimationLock extends RefCounted	

var prio: int
var lockTotal: float
var current : float = 0
var loops: int = 1

signal lockReleased()


func _init(prio: int, lockTotal: float, loops: int = 1) -> void:
	self.prio = prio
	self.lockTotal = lockTotal
	self.loops = loops
	self.current = lockTotal
