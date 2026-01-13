extends Node2D

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene
@export var p1Special1Active: bool
@export var p1Special2Active: bool
var p2Special1Active: bool
var p2Special2Active: bool

const specialAssets = {
	"Rock": preload("res://assets/Rock.png"),
	"Meteor": preload("res://assets/Meteor.png"),
	"Star Crossing Lovers": preload("res://assets/Star Crossing Lovers.png"),
	"00X": preload("res://assets/00X.png"),
	"Shinobi Ashi": preload("res://assets/Shinobi Ashi.png"),
	"BAM!": preload("res://assets/BAM!.png")
}

var p1Special1Button: Button
var p1Special2Button: Button
var p2Special1Button: Button
var p2Special2Button: Button

var p1SpecialPoints: int = 0 : set = updateP1Special

func updateSpecialSplash(newval, threshold1, threshold2, button1, button2):
	button1.disabled = newval < threshold1
	button2.disabled = newval < threshold2

func updateP1Special(new_value):
	p1SpecialPoints = new_value
	$PlayerPanel/PlayerSpecialPointCount.text = str(new_value)
	updateSpecialSplash(new_value, GlobalVars.p1Special1PointsNeeded, GlobalVars.p1Special2PointsNeeded, p1Special1Button, p1Special2Button)
	
var p2SpecialPoints: int = 0: set = updateP2Special
func updateP2Special(new_value):
	p2SpecialPoints = new_value
	$OpponentPanel/OpponentSpecialPointCount.text = str(new_value)
	updateSpecialSplash(new_value, GlobalVars.p2Special2PointsNeeded, GlobalVars.p2Special2PointsNeeded, $OpponentPanel/P2Special1Button, $OpponentPanel/P2Special2Button)

var turn_count: int = 0
var player : int
var grid_data : Array
var grid_pos : Vector2i
var board_size: int
var cell_size: int
const grid_size = 6
var row_sum: int
var col_sum: int
var diag1_sum: int
var diag2_sum: int

func new_game():
	print(GlobalVars.play_mode)
	grid_data = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
	row_sum = 0
	col_sum = 0
	diag1_sum = 0
	diag2_sum = 0
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	get_tree().paused = false
	player = 1
	turn_count = 0
	$InfoPanel/RoundTimer.text = "Round Timer: 30"
	$GameOverMenu.hide()
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1Special1Button = $PlayerPanel/P1Special1Button
	p1Special2Button = $PlayerPanel/P1Special2Button
	p2Special1Button = $OpponentPanel/P2Special1Button
	p2Special2Button = $OpponentPanel/P2Special2Button
	board_size = $Board.texture.get_width()
	cell_size = board_size / grid_size
	new_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# check if mouse is on game board
			if event.position.x < board_size && event.position.y < board_size && event.position.x > 0 && event.position.y > 0:
				var grid_pos = Vector2i(event.position / (board_size / grid_size))
				if grid_data[grid_pos.x][grid_pos.y] == 0:
					handle_move(grid_pos.x, grid_pos.y)
					if GlobalVars.play_mode == 1:
						CPU_Pick_Move(GlobalVars.cpu_level)

func handle_move(x, y):
	grid_data[x][y] = player
	var nodePosition = Vector2i(x,y) * cell_size + Vector2i(cell_size / 2, cell_size /2)
	var newNode = create_marker(nodePosition, Vector2i(x,y))
	if !newNode.is_in_group("Shinobi Ashi"):
		move_markers(nodePosition,Vector2i(x,y), newNode)
	check_upgrade()
	if check_win() != 0:
		print("Game Over")
		get_tree().paused = true
		$GameOverMenu.show()
	player *= -1
	
	if player == 1:
		turn_count +=1
		$InfoPanel/RoundTimer.text = "Round Timer: " + str(30-turn_count)
		if turn_count == 30:
			print("Game Ended via Timeout")
			$GameOverMenu.show()
	$PlayerPanel.visible = !$PlayerPanel.visible
	$OpponentPanel.visible = !$OpponentPanel.visible
	
func CPU_Pick_Move(level):
	await get_tree().create_timer(1.0).timeout
	var x = 0
	var y = 0
	if (level == 1):			
		x = randi() % 6
		y = randi() % 6
		while grid_data[x][y] != 0:
			x = randi() % 6
			y = randi() % 6
	if (level == 2):
		# avoids playing on the edges
		x = randi() % 4
		y = randi() % 4
		while grid_data[x+1][y+1] != 0:
			x = randi() % 4
			y = randi() % 4
		x += 1
		y += 1
	handle_move(x,y)

func add_node_to_group(node, special_name):
	node.add_to_group(special_name)
	if special_name != "Paint It Black" and special_name != "Rotate":
		node.texture = specialAssets[special_name]


func create_marker(position, grid_pos):
	var newImg
	if player == 1:
		newImg = circle_scene.instantiate()
	else:
		newImg = cross_scene.instantiate()
	newImg.position = position

	newImg.name = str(position)
	if p1Special1Active:
		p1Special1Active = false
		add_node_to_group(newImg, GlobalVars.p1Special1)
		p1SpecialPoints -= GlobalVars.p1Special1PointsNeeded

	if p1Special2Active:
		p1Special2Active = false
		add_node_to_group(newImg, GlobalVars.p1Special2)
		p1SpecialPoints -= GlobalVars.p1Special2PointsNeeded

	if p2Special1Active:
		p2Special1Active = false
		add_node_to_group(newImg, GlobalVars.p2Special1)
		p2SpecialPoints -= GlobalVars.p2Special1PointsNeeded
	
	if p2Special2Active:
		p2Special2Active = false
		add_node_to_group(newImg, GlobalVars.p2Special2)
		p2SpecialPoints -= GlobalVars.p2Special2PointsNeeded

	if player == 1:
		newImg.modulate = Color(0, 1, 0, 1)
	else:
		newImg.modulate = Color(1, 0, 0, 1)
	
	if newImg.is_in_group("Paint It Black"):
		newImg.modulate = Color(0,0,0,1)
	add_child(newImg)	
	return newImg

func getEndPosition(pieceNode, startPosition, changeVector):
	var endPosition = Vector2i(startPosition.x + changeVector.x, startPosition.y + changeVector.y)
	print(str(startPosition) + " | startPosition")
	print(str(endPosition) + " | endPosition")
	#im like 90% sure this can be consolidated
	if pieceNode.is_in_group("Meteor"):
		if (endPosition.x < 0 and endPosition.y == startPosition.y):
			endPosition = Vector2i(grid_size-1, endPosition.y)
		elif (endPosition.x >= grid_size and endPosition.y == startPosition.y):
			endPosition = Vector2i(0, endPosition.y)
		elif (endPosition.y < 0 and endPosition.x == startPosition.x):
			endPosition = Vector2i(endPosition.x, grid_size-1)
		elif (endPosition.y >= grid_size and endPosition.x == startPosition.x):
			endPosition = Vector2i(endPosition.x, 0)
		elif (endPosition.x < 0 and changeVector.y == -1):
			endPosition = Vector2i(grid_size - 1 - startPosition.y, grid_size -1)
		elif (endPosition.x < 0 and changeVector.y == 1):
			endPosition = Vector2i(startPosition.y, 0)
		elif ((endPosition.x >= grid_size and changeVector.y == -1) or (endPosition.y < 0 and changeVector.x == 1)):
			endPosition = Vector2i(startPosition.y, startPosition.x)
		elif (endPosition.x >= grid_size and changeVector.y == 1):
			endPosition = Vector2i(grid_size - 1 - startPosition.y, 0)
		elif (endPosition.y < 0 and changeVector.x == -1):
			endPosition = Vector2i(grid_size -1, grid_size - 1 - startPosition.x)
		elif (endPosition.y >= grid_size and changeVector.x == 1):
			endPosition = Vector2i(0, grid_size - 1 - startPosition.x)
		elif (endPosition.y >= grid_size and changeVector.x == -1):
			endPosition = Vector2i(startPosition.y, startPosition.x)
			
	return endPosition

func getPieceMoveResult(pieceNode, startPosition, changeVector, group, bam):
	var endPosition = getEndPosition(pieceNode, startPosition, changeVector)
	print(str(endPosition) + "| endPosition")
	if (endPosition.x < 0 or endPosition.x >= grid_size or endPosition.y < 0 or endPosition.y >= grid_size):
		return 1 # piece is out of bounds
	if absi(grid_data[startPosition.x][startPosition.y]) > 1 and !bam:
		return 0 # evolved pieces are not moved except by bam nodes
	if grid_data[endPosition.x][endPosition.y] != 0:
		return 0 # there is already a piece in that zone, or the piece is evolved and cant move
	print("group: " +  str(group))
	print(str(pieceNode.get_groups()))
	if pieceNode.is_in_group(group) and pieceNode.is_in_group("Rock"):
		return 0 # rocks are not moved by nodes of the same color
	if !pieceNode.is_in_group(group) and pieceNode.is_in_group("00X"):
		return 0 # 00X agents are not moved by nodes of the other team
	return 2 # piece is safe to move

func move_piece(pieceNode, startPosition, endPosition):
	var old_data = grid_data[startPosition.x][startPosition.y]
	grid_data[endPosition.x][endPosition.y] = old_data # could be 1 or -1
	grid_data[startPosition.x][startPosition.y] = 0

	print(str(startPosition))
	print(str(endPosition))
	var board_position = Vector2i(cell_size * endPosition.x + cell_size / 2, cell_size * endPosition.y + cell_size/2)
	pieceNode.position = board_position
	pieceNode.name = str(board_position)

func move_markers(centerPosition, grid_pos, centerNode):
	#check all 8 squares around the placed area
	for x in range(-1,2):
		for y in range(-1,2):
			if !(x == 0 and y == 0):
				var startPosition = grid_pos + Vector2i(x, y)
				var cellPosition = Vector2i(centerPosition.x + (x * cell_size), centerPosition.y + (y * cell_size))
				# if we find an adjacent node
				var movingNode = get_node(str(cellPosition))
				if !movingNode and x == 1 and y == 0 and centerNode.is_in_group("Star Crossing Lovers"):
					#spawn another copy that doesnt push
					var loverNode = create_marker(cellPosition, Vector2i(grid_pos.x + 1, grid_pos.y))
					add_node_to_group(loverNode, "Star Crossing Lovers")
				if movingNode:
					var centerGroup
					if centerNode.is_in_group("circles"):
						centerGroup = "circles"
					else:
						centerGroup = "crosses"
					var pieceMoveTest = getPieceMoveResult(get_node(str(cellPosition)), startPosition, Vector2i(x, y), centerGroup, centerNode.is_in_group("BAM!"))
					if pieceMoveTest == 2:
						var endPosition = getEndPosition(movingNode, startPosition, Vector2i(x, y))
						move_piece(movingNode, grid_pos + Vector2i(x, y), endPosition)
					elif pieceMoveTest == 1: #out of bounds
						if centerGroup == "circles":
							p1SpecialPoints += 1
						else:
							p2SpecialPoints += 1
						grid_data[startPosition.x][startPosition.y] = 0
						movingNode.queue_free()
						print("node freed")

func get_sums(x, y):
	var row_sum = 0
	var col_sum = 0
	var diag1_sum = 0
	var diag2_sum = 0

	if (x < 4):
		row_sum = grid_data[x][y] + grid_data[x + 1][y] + grid_data[x + 2][y]
	if (y < 4):
		col_sum = grid_data[x][y] + grid_data[x][y + 1] + grid_data[x][y+2]
	if (x > 1 and y < 4):
		diag1_sum = grid_data[x][y] +  grid_data[x-1][y+1] + grid_data[x-2][y+2]
	if (x < 4 and y < 4):
		diag2_sum = grid_data[x][y] + grid_data[x+1][y+1] + grid_data[x+2][y+2]
	
	return [row_sum, col_sum, diag1_sum, diag2_sum]

func upgrade_piece(left, mid, right):
	grid_data[left.x][left.y] = 0
	grid_data[mid.x][mid.y] *= 7
	grid_data[right.x][right.y] = 0
	var leftPos = Vector2i(left.x,left.y) * cell_size + Vector2i(cell_size / 2, cell_size / 2)
	var centerPos = Vector2i(mid.x,mid.y) * cell_size + Vector2i(cell_size / 2, cell_size / 2)
	var rightPos = Vector2i(right.x,right.y) * cell_size + Vector2i(cell_size / 2, cell_size / 2)
					
	get_node(str(leftPos)).queue_free()
	get_node(str(rightPos)).queue_free()
	get_node(str(centerPos)).scale = Vector2(1.5, 1.5)
	

func check_upgrade():
	for x in range(6):
		for y in range(6):
			var sums = get_sums(x,y)
			if absi(sums[0]) == 3: #row upgrade
				upgrade_piece(Vector2i(x,y),Vector2i(x+1,y), Vector2i(x+2,y))
			elif absi(sums[1]) == 3: #col upgrade
				upgrade_piece(Vector2i(x,y), Vector2i(x, y+1), Vector2i(x, y+2))
			elif absi(sums[2]) == 3: #topright-botleft diagonal
				upgrade_piece(Vector2i(x,y), Vector2i(x-1,y+1), Vector2i(x-2, y+2))
			elif absi(sums[3]) == 3:
				#diag2 upgrade
				upgrade_piece(Vector2i(x,y), Vector2i(x+1, y+1), Vector2i(x+2, y+2))

func check_win():
	for x in range(grid_size):
		for y in range(grid_size):
			var sums = get_sums(x, y)
			if sums.has(21):
				return 1
			elif sums.has(-21):
				return -1
	return 0


func _on_game_over_menu_restart() -> void:
	new_game()

func _on_rock_button_pressed() -> void:
	if (!p1Special1Active):
		p1Special1Active = true
		p1Special2Active = false
	else:
		p1Special1Active = false

func _on_ninja_button_pressed() -> void:
	if (!p1Special2Active):
		p1Special2Active = true
		p1Special1Active = false
	else:
		p1Special2Active = false


func _on_p2_special1_button_pressed() -> void:
	if (!p2Special1Active):
		p2Special1Active = true
		p2Special2Active = false
	else: # press the button again to turn off special
		p2Special1Active = false 


func _on_p2_special_2_button_pressed() -> void:
	if (!p2Special2Active):
		p2Special2Active = true
		p2Special1Active = false
	else:
		p2Special2Active = false
