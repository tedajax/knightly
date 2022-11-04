extends CharacterBody2D

const SPEED = 140.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing = 1

var input_x = 0
var input_y = 0
var jump_request = false

var walk_move_accel = 800.0
var walk_max_speed = 140.0
var walk_friction = 0.4

@export var fall_blend_threshold: float = 20.0

@onready var _animator = $AnimatedSprite2D
@onready var sprite_offset_x = _animator.transform.get_origin().x

var debug_font

var state_machine
var states = {
	"idle": IdleState,
	"run": RunState,
	"jump": JumpState,
	"air": AirState,
	"crouch_transition": CrouchTransitionState,
	"crouch_idle": CrouchIdleState,
	"crouch_walk": CrouchWalkState,
}
func _ready():
	debug_font = load("res://fonts/prstartk.ttf")

	state_machine = StateMachine.new(self, states, _animator)
	add_child(state_machine)
	state_machine.change_state("idle")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _draw():
	
	draw_string(debug_font, Vector2(0, 0), "speed %0.2f" % velocity.x, HORIZONTAL_ALIGNMENT_LEFT, -1, 8)

func _process(delta):
	
	if Input.is_action_just_pressed("jump"):
		jump_request = true
		

func _physics_process(delta):
	if jump_request and not is_on_floor():
		jump_request = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_x = Input.get_axis("ui_left", "ui_right")
	input_y = Input.get_axis("ui_down", "ui_up")
	
	if input_x:
		facing = input_x
		
	queue_redraw()

func do_jump_if_valid():
	if jump_request and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_request = false

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func apply_walk_accel(delta):
	var change = walk_move_accel * input_x * delta
	
	velocity.x += walk_move_accel * input_x * delta
	var vel_x_mag = absf(velocity.x)
	if vel_x_mag > walk_max_speed:
		var excess = vel_x_mag - walk_max_speed
		var adjust = minf(10.0, excess) * -signf(velocity.x)
		velocity.x += adjust

func apply_friction(delta):
	var fric_mag = -velocity.x * walk_friction
	
	if fric_mag > 0:
		velocity.x = minf(velocity.x + fric_mag, 0.0)
	else:
		velocity.x = maxf(velocity.x + fric_mag, 0.0)

func sync_sprite_facing():
	_animator.flip_h = facing < 0
	# We use the base origin to figure out to the total offset but have to subtract it out of our offset when we set a new one so it's not added in.
	# really wish there was just a transform.set_origin call available...
#	_animator.offset.x = sprite_offset_x * facing - sprite_offset_x
	_animator.transform.origin.x = sprite_offset_x * facing
