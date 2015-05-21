extends RigidBody2D

# Character Demo, written by Juan Linietsky.
#
# Implementation of a 2D Character controller.
# This implementation uses the physics engine for
# controlling a character, in a very similar way
# than a 3D character controller would be implemented.
#
# Using the physics engine for this has the main
# advantages:
# -Easy to write.
# -Interaction with other physics-based objects is free
# -Only have to deal with the object linear velocity, not position
# -All collision/area framework available
# 
# But also has the following disadvantages:
#  
# -Objects may bounce a little bit sometimes
# -Going up ramps sends the chracter flying up, small hack is needed.
# -A ray collider is needed to avoid sliding down on ramps and  
#   undesiderd bumps, small steps and rare numerical precision errors.
#   (another alternative may be to turn on friction when the character is not moving).
# -Friction cant be used, so floor velocity must be considered
#  for moving platforms.

var anim=""
var life

var siding_left=false
var jumping=false
var stopping_jump=false
var shooting=false

var WALK_ACCEL = 800.0
var WALK_DEACCEL= 800.0
var WALK_MAX_VELOCITY= 250.0
var GRAVITY = 700.0
var AIR_ACCEL = 200.0
var AIR_DEACCEL= 200.0
var JUMP_VELOCITY=600
var STOP_JUMP_FORCE=900.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time=1e20
var shoot_time=1e20

var MAX_SHOOT_POSE_TIME = 0.3

var floor_h_velocity=0.0
var enemy

func is_healed():
	if(life<4):
		life += 1
		get_node("/root").get_node("Node2D").get_node("points").get_node("life").set_frame(4-life)

func _is_hurt():
	life -= 1
	if(life == 0):
		get_node("/root/global").load_scene("res://scene.xml")
	print("life: "+str(life))
	get_node("/root").get_node("Node2D").get_node("Label").set_text("life:"+str(life))
	get_node("/root").get_node("Node2D").get_node("points").get_node("life").set_frame(4-life)


func _integrate_forces(s):

	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim=anim
	var new_siding_left=siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_pressed("ui_up")
	var move_right = Input.is_action_pressed("ui_right")
	
	#deapply prev floor velocity
	lv.x-=floor_h_velocity
	floor_h_velocity=0.0
	
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor=false
	var floor_index=-1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if (ci.dot(Vector2(0,-1))>0.1):
			found_floor=true
			floor_index=x
	
	if (found_floor):	
		airborne_time=0.0 
	else:
		airborne_time+=step #time it spent in the air
		

	var on_floor=airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump		
	if (jumping):
		if (lv.y>0):
			#set off the jumping flag if going down
			jumping=false
		elif (not jump):
			stopping_jump=true
			
		if (stopping_jump):
			lv.y+=STOP_JUMP_FORCE*step


	if (on_floor):
		# Process logic when character is on floor
		if (move_left and not move_right):
			if (lv.x > -WALK_MAX_VELOCITY):
				lv.x-=WALK_ACCEL*step			
		elif (move_right and not move_left):
			if (lv.x < WALK_MAX_VELOCITY):
				lv.x+=WALK_ACCEL*step
		else:
			var xv = abs(lv.x)
			xv-=WALK_DEACCEL*step
			if (xv<0):
				xv=0
			lv.x=sign(lv.x)*xv
			
		#Check jump
		if (not jumping and jump):
			lv.y=-JUMP_VELOCITY
			jumping=true
			stopping_jump=false
			#get_node("sound").play("jump")
			
		#check siding
		
		if (lv.x < 0 and move_left):
			new_siding_left=true
		elif (lv.x > 0 and move_right):
			new_siding_left=false
		if (jumping):
			new_anim="idle"	
		elif (abs(lv.x)<0.1):
			new_anim = "idle"
		else:
			new_anim="walk"
	else:
		# Process logic when the character is in the air
		if (move_left and not move_right):
			if (lv.x > -WALK_MAX_VELOCITY):
				lv.x-=AIR_ACCEL*step			
		elif (move_right and not move_left):
			if (lv.x < WALK_MAX_VELOCITY):
				lv.x+=AIR_ACCEL*step
		else:
			var xv = abs(lv.x)
			xv-=AIR_DEACCEL*step
			if (xv<0):
				xv=0
			lv.x=sign(lv.x)*xv
			
		if (lv.y<0):
			new_anim="jumping"
		#	else:
			#new_anim="falling"
		

	#Update siding
	if (new_siding_left!=siding_left):
		if (new_siding_left):
			get_node("sprite").set_scale( Vector2(-0.5,0.5) )
		else:
			get_node("sprite").set_scale( Vector2(0.5,0.5) )
			
		siding_left=new_siding_left

	#Change animation
	if (new_anim!=anim):
		anim=new_anim
		get_node("anim").play(anim)
		


#Finally, apply gravity and set back the linear velocity
	lv+=s.get_total_gravity()*step
	s.set_linear_velocity(lv)
	



func _ready():
	pass



