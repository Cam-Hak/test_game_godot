extends CharacterBody2D

@export var speed := 80.0
@export var health := 3

var player: Node2D = null


func _ready() -> void:
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		rotation = direction.angle() - PI/2
		move_and_slide()


func take_damage(amount: int) -> void:
	health -= amount
	# Flash white briefly (juice!)
	modulate = Color.WHITE
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	
	if health <= 0:
		queue_free()
