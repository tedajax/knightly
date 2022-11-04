extends Node2D

class_name State

var machine
var body
var animator

func _init(machine):
	self.machine = machine
	self.body = machine.body
	self.animator = machine.animator
	
func play_anim(anim):
	if animator.animation != anim:
#		print("Animation Play: %s" % anim)
		animator.play(anim)

func cleanup():
	pass
