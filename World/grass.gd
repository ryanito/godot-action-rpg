extends Node2D

func _on_hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()


func _on_hurtbox_body_entered(_body):
	create_grass_effect()
	queue_free()


func create_grass_effect():
	var scene = load("res://Effects/grass_effect.tscn")
	var instance = scene.instantiate()
	$"..".add_child(instance)
	instance.global_position = global_position
