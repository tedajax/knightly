extends State
class_name JumpState

func _ready():
	body.velocity.y = body.JUMP_VELOCITY
	play_anim("Jump")
	machine.change_state("air")
