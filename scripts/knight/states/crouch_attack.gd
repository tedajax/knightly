extends State

class_name CrouchAttackState

func _ready():
	play_anim("CrouchAttack")

func _process(delta):
	return

func _physics_process(delta):
	body.apply_gravity(delta)
	body.apply_friction(delta)
	body.move_and_slide()
	if not body.is_on_floor():
		machine.change_state("air")

func on_anim_finished():
	machine.change_state("crouch_idle")
