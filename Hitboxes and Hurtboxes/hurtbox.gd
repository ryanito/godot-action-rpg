extends Area2D

@export var show_hit : bool = true

const hit_effect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area):
	if (show_hit):
		var effect = hit_effect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
