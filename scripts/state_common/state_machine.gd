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

func change_state(state_name: StringName, on_create = null):
	if not states.has(state_name):
		printerr("No state named '%s' is available" % state_name)
		pass

	if state != null:
		state.cleanup()
		state.queue_free()

	state = states.get(state_name).new(self, state_name)
	print("Changed State: %s" % state_name)
	add_child(state)
	if on_create:
		on_create.call(state)

func get_active_state_name():
	if state == null:
		return "<null>"
	else:
		return state.state_name
		
func on_anim_looped():
	if state != null:
		state.on_anim_looped()

func on_anim_finished():
	if state != null:
		state.on_anim_finished()

func on_anim_changed():
	if state != null:
		state.on_anim_changed()
