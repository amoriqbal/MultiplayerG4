extends Node
const port:int = 5000
@export
var PlayerScene:PackedScene = preload("res://player.tscn")
@export
var WorldScene:PackedScene = preload("res://world.tscn")

func _on_host_button_pressed():
	%ConnectUI.visible = false
	startServer()

func _on_join_button_pressed():
	%ConnectUI.visible = false
	startClient()

func startServer():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port);
	multiplayer.multiplayer_peer = peer
	print("Server running")
	
	multiplayer.peer_connected.connect(onClientConnected)
	multiplayer.peer_disconnected.connect(onClientDisconnected)
	
	loadWorld()

func startClient():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", port);
	multiplayer.multiplayer_peer = peer
	print("Client running")
	multiplayer.connected_to_server.connect(onConnectedToServer)

func onConnectedToServer():
	var GlobalNode = get_node("/root/Global")
	var id = multiplayer.get_unique_id()
	print("Connected to server")
	loadWorld()
	addPlayer.rpc_id(1, id, GlobalNode.getSpawnPos())
	

func loadWorld():
	var world = WorldScene.instantiate()
	%MapInstance.add_child(world)

func onClientConnected(id:int):
	print("Client connected: %d"%id)

func onClientDisconnected(id:int):
	print("Client disconnected: %d"%id)
	removePlayer(id)

@rpc("any_peer")
func addPlayer(id : int, pos : Vector2 = Vector2.ZERO):
	var player = PlayerScene.instantiate()
	player.name = str(id)
	player.position = pos
	%SpawnPositions.add_child(player)

@rpc("any_peer")
func removePlayer(id:int):
	var player = %SpawnPositions.find_child(str(id))
	player.queue_free()
