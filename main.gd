extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
	
func _on_mob_timer_timeout():
	#untuk membuat instansi baru pada mob scene
	var mob = mob_scene.instantiate()
	
	#memilih lokasi acak pada path 2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#mengatur lokasi mob pada lokasi acak yang sudah ditentukan
	mob.position = mob_spawn_location.position
	
	#mengatur arah mob tergantung pada jalur nya
	var direction = mob_spawn_location.rotation + PI / 2
	
	#mengacak arah mob
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#pilih acak kecepatan mob (kalo sama bakal bosen jir)
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#menambahkan mob pada main scene
	add_child(mob)
	
	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
