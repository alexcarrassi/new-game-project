class_name AnimationLock extends RefCounted	

var prio: int
var frames: int

func _init(prio: int, frames: int) -> void:
	self.prio = prio
	self.frames = frames 

func tick() -> void:
	self.frames -= 1
