extends CharacterBody2D

const FRICTION = 5
const KNOCKBACK_SPEED = 200

@onready var stats = $Stats

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED


func _on_stats_no_health():
	queue_free()
