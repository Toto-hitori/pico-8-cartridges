pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function _init()
	make_player()
	counter = 0
end

function _update()
	cls()
	apply_gravity()
	move_player()
end

function _draw()

	draw_map()
	draw_player()
end

function make_player()
	plyr = {}
	plyr.x = 20
	plyr.y = 20
	plyr.spr = 1
	speed = {}
	speed.x = 0
	speed.y = 0
	grounded = false
end

function apply_gravity()
	if(speed.y < 4 and not grounded)then
		speed.y += 0.2
	end
end

function move_player()
	if(btn(0)) then
		walk_left()--left
	elseif(btn(1)) then
		walk_right()--right
	else speed.x = 0	
	end
	
	if(btn(2)) jump() --jump
	if(btn(3)) roll()
	apply_speed()
	if(plyr.x < 0)then
		plyr.x = 127
	elseif(plyr.x > 127)then
		plyr.x = 0
		end
	end
function apply_speed()
	if(plyr.y < 81) then
		plyr.y += speed.y
	else
		plyr.y = 80
		speed.y = 0
		grounded = true
	
	end
	if(speed.x > 3) then
		speed.x = 3
	elseif(speed.x < -3)then 
		speed.x = -3
	end	
	plyr.x += speed.x
end
function walk_right()
	if(speed.x < 2)then
		speed.x += 0.8
	end
end
function walk_left()
	if(speed.x > -2)then
		speed.x -= 0.8
	end
end
function jump()
	if(speed.y > -4 and grounded) then
		speed.y -= 3
		grounded = false
	end
end
function roll()
	if(grounded)then
		speed.x *=21
		end
end
function draw_player()
	if(counter == 15) then
		if(plyr.spr == 1)then
		 plyr.spr = 21
		else 
		 plyr.spr = 1
		end
		counter = 0
	end
	spr(plyr.spr,plyr.x,plyr.y)
	counter +=1
end	
function draw_map()
	map(0,0,0,0,128,128,0)
end


__gfx__
0000000000000000cccccccc333333331ccccccc11111111ccccccc1ccccccc1111111111ccccccc11111111cccccccc33333333333333333333333344444444
0000000000555500cccccccc3bbbbbb31cccccccccccccccccccccc1ccccccc11ccccccc1cccccccccccccc1ccccccccbbbbbbbbbbbbbbb33bbbbbbb44444444
0070070005555550cccccccc3b333b331cccccccccccccccccccccc1ccccccc11ccccccc1cccccccccccccc1ccccccccb3333b3bb3333b3333333b3b44444444
0007700005555055cccccccc334443431cccccccccccccccccccccc1ccccccc11ccccccc1cccccccccccccc1cccccccc34444343344443433444434344444444
0007700055555555cccccccc544444451cccccccccccccccccccccc1ccccccc11ccccccc1cccccccccccccc1cccccccc44444444444444455444444444444444
0070070055055555cccccccc544444451cccccccccccccccccccccc1ccccccc11ccccccc1cccccccccccccc1cccccccc44444444444444455444444444444444
0000000055555555cccccccc544444451cccccccccccccccccccccc1ccccccc11ccccccc1cccccccccccccc1cccccccc44444444444444455444444444444444
0000000005555500cccccccc555555551cccccccccccccccccccccc1111111111ccccccc11111111ccccccc11111111144444444444444455444444444444444
44444444544444444444444554444444444444450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444544444444444444554444444444444450555550000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444544444444444444554444444444444450555555000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444544444444444444554444444444444455555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444544444444444444554444444444444455505505500000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444544444444444444554444444444444455555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444544444444444444554444444444444455555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555544444444444444555555555555555550555555000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000000000000000
__map__
0805050505050505050505050505050a00000000000000000000000000000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020600000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020600000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020600000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020600000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020602020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0c0c0c0c0c0c0c0c0c0c0c0c0c0c0d02020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
110f0f0f0f0f0f0f0f0f0f0f0f0f0f1202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
110f0f0f0f0f0f0f0f0f0f0f0f0f0f1202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
110f0f0f0f0f0f0f0f0f0f0f0f0f0f1202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1310101010101010101010101010101402020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
