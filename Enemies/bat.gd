extends CharacterBody2D

const KNOCKBACK_SPEED: int = 175

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
@onready var hurtbox = $Hurtbox
@onready var soft_collision = $SoftCollision


func _physics_process(delta):
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

	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
		
	move_and_slide()

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED
	hurtbox.create_hit_effect()


func _on_stats_no_health():
	queue_free()
	var instance = enemy_death_effect.instantiate()
	$"..".add_child(instance)
	instance.global_position = global_position
