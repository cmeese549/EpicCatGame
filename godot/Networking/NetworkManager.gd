extends Control

@onready var menu = find_child("Menu")
@onready var host_button = find_child("HostButton")
@onready var join_button = find_child("JoinButton")
@onready var address_entry = find_child("AddressEntry")

@onready var Arena = $".."

var PlayerScene = preload("res://Multiplayer/MultiPlayer.tscn")

var DEBUG := true

var PORT = 9999
var peer = ENetMultiplayerPeer.new()

func _ready():
	host_button.pressed.connect(host_game)
	join_button.pressed.connect(join_game)
	
func host_game():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(spawn_player)
	var player_id = multiplayer.get_unique_id()
	spawn_player(player_id)
	upnp_setup()
	
func join_game():
	peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = peer
	visible = false
	
func spawn_player(player_id):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var player = PlayerScene.instantiate()
	player.name = str("Player_" + str(player_id))
	player.network_id = player_id
	Arena.add_child(player)
	visible = false
	
func upnp_setup():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Discover Failed! Error %s" % discover_result)
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), "UPNP Invalid Gateway!")
	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP PORT MAP FAILED! %s" % map_result)
	printt("SUCCESS, join at", upnp.query_external_address())
