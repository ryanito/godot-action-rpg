extends CharacterBody2D

const FRICTION = 5
const KNOCKBACK_SPEED = 200

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _on_hurtbox_area_entered(area):
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED
