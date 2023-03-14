extends Node2D

class_name State

var machine
var body
var animator
var state_name

func _init(machine, state_name):
	self.machine = machine
	self.body = machine.body
	self.animator = machine.animator
	self.state_name = state_name

func play_anim(anim):
	if animator.animation != anim:
#		print("Animation Play: %s" % anim)
		animator.play(anim)

func cleanup():
	pass
