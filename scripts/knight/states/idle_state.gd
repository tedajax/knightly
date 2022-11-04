extends State

class_name IdleState

func _ready():
	play_anim("Idle")

func _process(delta):
	if body.input_x:
		machine.change_state("run")
	if body.input_y < 0:
		machine.change_state("crouch_transition")
	body.sync_sprite_facing()

func _physics_process(delta):
	body.apply_gravity(delta)
	body.do_jump_if_valid()
	body.apply_friction(delta)
	body.move_and_slide()
	
	if not body.is_on_floor():
		machine.change_state("air")
