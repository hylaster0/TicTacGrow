extends Node

var play_mode: int = 0 # 0 = local pvp, 1 = cpu, 2 = online
var cpu_level: int = 2 # affects how they make moves
var p1Special1PointsNeeded = 1
var p1Special2PointsNeeded = 0
var p2Special1PointsNeeded = 1
var p2Special2PointsNeeded = 5
var p1Special1 = "Rotate"
var p1Special2 = "Paint It Black"
var p2Special1 = "Rock"
var p2Special2 = "Rock"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
