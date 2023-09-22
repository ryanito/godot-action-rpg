extends CharacterBody2D

var max_speed = 80
var roll_speed = 120
var acceleration = 20

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_direction = Vector2.DOWN

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func _physics_process(_delta):
	match state:
		MOVE:
			move_state(_delta)

		ROLL:
			roll_state(_delta)

		ATTACK:
			attack_state(_delta)

func move_state(_delta):
	disable_enemy_collision()
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_direction != Vector2.ZERO:
		roll_direction = input_direction
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Run/blend_position", input_direction)
		animation_tree.set("parameters/Attack/blend_position", input_direction)
		animation_tree.set("parameters/Roll/blend_position", input_direction)

		animation_state.travel("Run")

		velocity += input_direction * acceleration
		velocity = velocity.limit_length(max_speed)
	else:
		animation_state.travel("Idle")
		velocity = Vector2.ZERO

	move_and_slide()

	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func roll_state(_delta):
	enable_enemy_collision()
	
	velocity = roll_direction * roll_speed
	animation_state.travel("Roll")
	move_and_slide()

func attack_state(_delta):
	disable_enemy_collision()
	
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	
func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func attack_animation_finished():
	state = MOVE
	
func enable_enemy_collision():
	set_collision_layer_value(3, true)
	set_collision_mask_value(5, true)
	
func disable_enemy_collision():
	set_collision_layer_value(3, false)
	set_collision_mask_value(5, false)
