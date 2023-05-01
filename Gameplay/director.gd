extends Node

signal new_objective(target_pos)
signal score_update(new_score)

onready var spawns = get_tree().get_nodes_in_group("spawn")
onready var pickup = preload("res://Gameplay/Pickup.tscn")
onready var dropoff = preload("res://Gameplay/Dropoff.tscn")

var rng = RandomNumberGenerator.new()

var cur_spawn
var cur_pickup
var cur_dropoff
var score:int

func _ready():
	rng.randomize()
	spawn_pickup()

func _on_Pickup_body_entered(body):
	if body.is_in_group("player"):
		spawn_dropoff()

func _on_Dropoff_body_entered(body):
	if body.is_in_group("player"):
		spawn_pickup()
		score += 1
		emit_signal("score_update",score)

func spawn_pickup():
	var rand_spawn = rng.randi_range(0,spawns.size()-1)
	var next_spawn = spawns[rand_spawn]
	if next_spawn == cur_spawn:
		next_spawn = spawns[rand_spawn-1]
	var new_pickup = pickup.instance()
	next_spawn.add_child(new_pickup)
	cur_spawn = next_spawn
	cur_pickup = new_pickup
	new_pickup.connect("body_entered",self,"_on_Pickup_body_entered")
	emit_signal("new_objective",new_pickup.global_transform.origin)
	
func spawn_dropoff():
	var rand_spawn = rng.randi_range(0,spawns.size()-1)
	var next_spawn = spawns[rand_spawn]
	if next_spawn == cur_spawn:
		next_spawn = spawns[rand_spawn-1]
	var new_dropoff = dropoff.instance()
	next_spawn.add_child(new_dropoff)
	cur_spawn = next_spawn
	cur_dropoff = new_dropoff
	new_dropoff.connect("body_entered",self,"_on_Dropoff_body_entered")
	emit_signal("new_objective",new_dropoff.global_transform.origin)


func _on_Menu_restart():
	if is_instance_valid(cur_pickup):
		cur_pickup.queue_free()
	if is_instance_valid(cur_dropoff):
		cur_dropoff.queue_free()
	score = 0
	rng.randomize()
	spawn_pickup()
