# 8. Animate a ball moving in circular motion around a fixed point. The size of
# the ball, distance to the point, initial position and angular velocity should
# be specified by user. To calculate values of the any trigonometric function
# find and use a simple numerical approximation. Use RARS bitmap display
# and, optionally, Sleep system call.

	.eqv SYS_EXIT0, 10
	.eqv SYS_RDINT, 5
	.eqv SYS_RDFLOAT, 6
	.eqv SYS_PRNSTR, 4
	.eqv SYS_SLEEP, 32
	.eqv red, 0xFF0000
	.eqv white, 0xFFFFFF
	
	.data
ask_size:	.ascii "Provide size: \0"
ask_x:		.ascii "Provide the X coordinate of the center point: \0"
ask_y:		.ascii "Provide the Y coordinate of the center point: \0"
ask_radius:	.ascii "Provide the radius: \0"
ask_velocity:	.ascii "Provide the angular velocity: \0"

	.text
main:
	li	t0, 0x10040000	# bitmap base address
    	li	t1, red		# load color
    	li 	s9, white
    		
    	li	s10, 0x40c00000	# load 6 constant for sine
    	fmv.s.x fs9, s10
    	
    	li	s10, 0x42f00000	# load 120 constant for sine
    	fmv.s.x fs10, s10
    	
    	li	s10, 0x459d8000	# load 5040 constant for sine
    	fmv.s.x fs11, s10
    	
    	fmv.s.x ft6, zero	# load zero to argument of sine
    	
    	li	s8, 0x3fc90fdb	# load pi/2 value
    	fmv.s.x fs0, s8
    	
    	li	s8, 0x40490fdb	# load pi value
    	fmv.s.x ft4, s8
    	
    	li	s8, 0xc0490fdb	# load -pi value
    	fmv.s.x fs4, s8	
    							
    	li	s8, 0x40c90fdb	#load 2pi value
    	fmv.s.x ft5, s8
    	li	s8, 0xc0c90fdb	#load -2pi value
    	fmv.s.x fs5, s8			
    	
    	li	a7, SYS_PRNSTR
    	la	a0, ask_size
    	ecall
    	li	a7, SYS_RDINT	# load size
    	ecall
	mv	t2, a0
	
	li	a7, SYS_PRNSTR
    	la	a0, ask_x
    	ecall
    	li	a7, SYS_RDINT
    	ecall		# load initial x position
	mv	t4, a0
	
	li	a7, SYS_PRNSTR
    	la	a0, ask_y
    	ecall
    	li	a7, SYS_RDINT
    	ecall		# load initial y position
	mv	t5, a0	
	
	li	a7, SYS_PRNSTR
    	la	a0, ask_radius
    	ecall
	li	a7, SYS_RDFLOAT
    	ecall		# load radius
	fmv.s	fs3, fa0
	
	li	a7, SYS_PRNSTR
    	la	a0, ask_velocity
    	ecall
    	li	a7, SYS_RDFLOAT
    	ecall		# load angular velocity to fa0
    		
check_velocity:
	flt.s	s7, fa0, ft5	# check if <2pi
	bnez	s7, not_greater
	fsub.s 	fa0, fa0, ft5	# subtract 2pi
	j	check_velocity
not_greater:
	flt.s	s7, fa0, fs5	# check if <-2pi
	beqz	s7, velocity_normalized
	fadd.s 	ft6, ft6, ft5	# add 2pi
	j	not_greater
velocity_normalized:
	fmv.s	ft6, fa0

# place center point	
	slli	t4, t4, 2	# normalize to x coordinate
	add	s1, t0, t4
	slli	t5, t5, 9	# normalize to y coordinate
	add	s1, s1, t5
	
	sw	s9, (s1)
	mv	s9, t1		#red color buffer for later use
	
# Place ball
	fcvt.w.s t3, fs3	# convert radius to integer
	slli 	t3, t3, 2	# normalize to x coordinate
	add	s3, s1, t3
place_ball:
	sw	t1, (s3)	# place middle point of ball
	beqz	t2, ball_placed
	mv	s2, t2		# store a copy of size for y axis manipulation
	mv	a4, t2		# store a copy of size for y axis manipulation
	mv	t6, s3		# store a copy of middle point address
	mv	a5, s3		# store a copy of middle point address
upper_row:
	#addi	s2, s2, -1	# subtract to check if done
	sw	t1, (t6)
	beqz	s2, lower_row
	mv	a3, s2		# store count for x axis manipulation
	mv	s11, t6
	mv	s0, t6
next_pair:
	addi	s11, s11, 4
	addi	s0, s0, -4
	sw	t1, (s11)
	sw	t1, (s0)
	addi	a3, a3, -1
	bnez	a3, next_pair
	beqz	s2, lower_row
	addi 	t6, t6, -512
	addi	s2, s2, -1	# subtract to check if done
	j	upper_row
lower_row:
	addi	a4, a4, -1
	addi	a5, a5, 512
	sw	t1, (a5)
	beqz 	a4, ball_placed
	mv	a3, a4		# store count for x axis manipulation
	mv	s11, a5
	mv	s0, a5
	j	next_pair
		
ball_placed:
	beqz	t1, ball_removed
	bnez	s5, ball_moved
	li	s5, 1		# used to check for sine/cosine
	
check_angle:			
	flt.s	s7, ft6, ft4	# check if <pi
	bnez	s7, no_subtract
	fsub.s 	ft6, ft6, ft5	# subtract 2pi
no_subtract:
	flt.s	s7, ft6, fs4	# check if <-pi
	beqz	s7, sine
	fadd.s 	ft6, ft6, ft5	# add 2pi
sine:				
	fmul.s	ft0, ft6, ft6	# x^2
	fmul.s	ft1, ft0, ft6	# x^3
	fmul.s	ft2, ft1, ft0	# x^5
	fmul.s	ft3, ft2, ft0	# x^7
	
	fdiv.s	ft1, ft1, fs9	# x^3 / 6
	fdiv.s	ft2, ft2, fs10	# x^5 / 120
	fdiv.s	ft3, ft3, fs11	# x^7 / 5040
	fsub.s	fs6, ft6, ft1
	fadd.s	fs6, fs6, ft2
	fsub.s	fs6, fs6, ft3
	
	fmul.s	fs7, fs3, fs6	# multiply result by radius
	fcvt.w.s s4, fs7	# convert to integer
	beqz	s5, move_ball
# calculate y coordinate
	slli	s4, s4, 9	# normalize to y coordinate
	add	s6, s4, s1
	
	addi	s5, s5 -1
	fadd.s 	ft6, ft6, fs0	# add pi/2 to convert to cosine
	j check_angle
	
move_ball:
	slli	s4, s4, 2	# normalize to x coordinate
	li	a7, SYS_SLEEP	# sleep
	li	a0, 100
	ecall
	
	mv	t1, zero	# set color to black
	j	place_ball	# remove ball from the previous location
ball_removed:
	add	s3, s6, s4	# get address of the new location
	mv	t1, s9		# set color to red
	addi	s5, s5, 1
	j	place_ball
ball_moved:
	fsub.s	ft6, ft6, fs0	# subtract pi/2 to convert back to sine
	fadd.s 	ft6, ft6, fa0	# advance to the next point
	j	check_angle
	
	
	li a7, SYS_EXIT0
	ecall
