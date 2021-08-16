extends Node2D

func _on_Sludge_body_entered(body):
	if body.has_method("handle_sludge_entered"):
		body.handle_sludge_entered()
