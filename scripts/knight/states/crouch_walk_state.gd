extends State
class_name CrouchWalkState

const MOVE_ACCEL = 800.0
const MAX_SPEED = 70.0
const FRICTION = 0.4

func _ready():
	body.walk_move_accel = MOVE_ACCEL
	body.walk_max_speed = MAX_SPEED
	body.walk_friction = FRICTION

	play_anim("CrouchWalk")

func _process(delta):
	body.sync_sprite_facing()

	if body.input_y >= 0:
		machine.change_state("crouch_transition", func(s): s.reverse())
	
	if not body.input_x:
		machine.change_state("crouch_idle")
	else:
		body.apply_walk_accel(delta)

func _physics_process(delta):
	body.apply_gravity(delta)
	body.do_jump_if_valid()
	body.move_and_slide()

	if not body.is_on_floor():
		machine.change_state("air")
