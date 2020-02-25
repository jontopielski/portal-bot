extends FSM_State

func initialize():
	obj.vel.y = 0
	obj.vel.x = 0
	obj.arm.scale = Vector2.ONE
#	obj.collision_shape.disabled = true

func terminate():
	pass

func run(_delta):
	var lerp_scale_weight = 5
	var lerp_rotate_weight = 1
	
	obj.rotate.rotation = lerp(obj.rotate.rotation, 25, lerp_rotate_weight * _delta)
	obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ZERO, lerp_scale_weight * _delta)
	obj.arm.scale = lerp(obj.arm.scale, Vector2.ZERO, lerp_scale_weight * _delta)
	
	if obj.rotate.scale.y <= .1:
		if Globals.HasWarpedIntoSpecialPortal:
			print("End of game!")
			obj.end_game()
		if Globals.PortalQueue.size() > 0:
			obj.position = Globals.get_next_portal_position(obj.last_portal_coordinates, true)
			fsm.state_next = fsm.states.WarpOut

#	if obj.rotate.scale.y <= .1:
#		if !$Timer.is_stopped() and Globals.PortalQueue.size() == 2:
#			$Timer.stop()
#			obj.position = Globals.get_next_portal_position()
#			fsm.state_next = fsm.states.WarpOut
##			print("interuppted timer case")
#		elif Globals.PortalQueue.size() < 2 and $Timer.is_stopped():
#			$Timer.start()
##			print("timer starting")
#		elif Globals.PortalQueue.size() == 2 and $Timer.is_stopped():
#			obj.position = Globals.get_next_portal_position()
#			fsm.state_next = fsm.states.WarpOut
##			print("default case")

func _on_Timer_timeout():
	if Globals.PortalQueue.size() < 2:
		fsm.state_next = fsm.states.Death
#		print("timeout death")
	elif Globals.PortalQueue.size() == 2:
		obj.position = Globals.get_next_portal_position(obj.last_portal_coordinates, true)
		fsm.state_next = fsm.states.WarpOut
#		print("timeout found portal")
