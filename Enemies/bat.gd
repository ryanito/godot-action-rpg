extends CharacterBody2D

const FRICTION: int = 5
const KNOCKBACK_SPEED: int = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

@export var acceleration: int = 300
@export var max_speed: int = 50

@onready var stats = $Stats
@onready var animated_sprite = $AnimatedSprite2D
@onready var player_detection_zone = $PlayerDetectionZone
@onready var enemy_death_effect = preload("res://Effects/enemy_death_effect.tscn")


func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			move_and_slide()
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			
			if player_detection_zone.can_see_player():
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
			else:
				state = IDLE
				
			animated_sprite.flip_h = velocity.x < 0
	
	move_and_slide()

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED


func _on_stats_no_health():
	queue_free()
	var instance = enemy_death_effect.instantiate()
	$"..".add_child(instance)
	instance.global_position = global_position
