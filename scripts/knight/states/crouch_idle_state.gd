extends State
class_name CrouchIdleState

func _ready():
	play_anim("Crouch")

func _process(delta):
	body.velocity.x = 0
	if body.input_y >= 0:
		machine.change_state("crouch_transition", func(s): s.reverse())
	if body.input_x:
		machine.change_state("crouch_walk")
	body.sync_sprite_facing()

func _physics_process(delta):
	body.apply_gravity(delta)
	body.do_jump_if_valid()
	body.apply_friction(delta)
	body.move_and_slide()
	
	if not body.is_on_floor():
		machine.change_state("air")
