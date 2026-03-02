extends Node2D

const sprites = {
	"Blanc Norman": preload("res://assets/Blanc.png"),
	"Ninja Girl Denn": preload("res://assets/Ninja.png"),
	"Cosmo": preload("res://assets/Cosmo.png"),
	"Ren": preload("res://assets/Ren.png"),
	"John Arcade": preload("res://assets/John Arcade.png"),
	"Ernie": preload("res://assets/Bert.png"),
	"Felix": preload("res://assets/Felix.png")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$P2Sprite.texture = sprites[GlobalVars.p2Character]
	$P1Sprite.texture = sprites[GlobalVars.p1Character]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	if GlobalVars.characterList.size() == 0:
		get_tree().change_scene_to_file("res://Title.tscn")
		return
	GlobalVars.cpu_level += 1
	var next_foe = GlobalVars.characterList.pick_random()
	GlobalVars.p2Character = next_foe
	GlobalVars.p2Special1 = GlobalVars.special1[next_foe]
	GlobalVars.p2Special2 = GlobalVars.special2[next_foe]
	GlobalVars.p2Special1PointsNeeded = GlobalVars.powerCost[GlobalVars.p2Special1]
	GlobalVars.p2Special2PointsNeeded = GlobalVars.powerCost[GlobalVars.p2Special2]
	GlobalVars.characterList.erase(next_foe)
	get_tree().change_scene_to_file("res://main.tscn")
