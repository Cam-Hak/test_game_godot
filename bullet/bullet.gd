extends Area2D

var speed := 500.0
var direction := Vector2.ZERO


func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1)
		queue_free()
