extends Area2D

var damage = 5

func acknowlaged():
	set_collision_layer_value(5, false)
	$"../AttackWait".start()
