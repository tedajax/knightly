extends Node

class_name StateMachine

var body
var states
var animator

var state

func _init(body, states, animator):
	self.body = body
	self.states = states
	self.animator = animator

func change_state(state_name, on_create = null):
	if not states.has(state_name):
		printerr("No state named '%s' is available" % state_name)
		pass

	if state != null:
		state.cleanup()
		state.queue_free()

	state = states.get(state_name).new(self)
	print("Changed State: %s" % state_name)
	add_child(state)
	if on_create:
		on_create.call(state)

