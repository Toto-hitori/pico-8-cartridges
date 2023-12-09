pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function _init()
	pl ={
		x,y,dx,dy,ddx,ddy,dir,grounded,spr,grab,wall
	}
	pl.x = 140
	pl.y = 0
	pl.dx = 0
	pl.dy = 0
	pl.ddx = 0
	pl.ddy = 0.6
	pl.grab = false
	input = "a"
	dir = "still"
	lastdir = "right"
	grabdir = "none"
	pl.wall = false
	pl.spr = 1
	grounded = false
	pl.anim = 1
	timer = time()
	lastgrab = 10
	
	starsx = {}
	starsy = {}
	for c=0,100 do
			starsx[c] = rnd(128)
			starsy[c] = rnd(128)
		end
	map_timer = time()
	
	color = 0
end

function _update()
	
	if btn(0) then
	 walk_left()
	elseif btn(1) then
	 walk_right() 
	else
		if(dir != "still") then
			grabdir = dir
			lastgrab = time()
		end
		if pl.grounded then pl.anim = 1 end
		if(pl.anim != 1 and pl.grounded) then 
			pl.spr = pl.anim
		end
		dir = "still"
		pl.dx = 0
		pl.grab = false
	end
	if btn(4) then
		if(pl.wall and input != "x") then
			pl.y -= 2
			input = "x"
		else
		
		if( pl.grounded== true) then 
			jump()
			sfx(0)
		end
		end
	end
	if btn(5) then
		if(pl.wall and input != "z") then
			pl.y -= 2
			input = "z"
		end
	end
	check_grab()
	apply_gravity()
	check_collision()
	
	pl.x += pl.dx
	pl.y += pl.dy
	update_spr()
end

function _draw()
	cls(0)
	
	if(time() - map_timer > 3) then

		for c=0,100 do
			starsx[c] = rnd(128)
			starsy[c] = rnd(128)
		end
		map_timer = time()
	end
	for d=0,100 do
			pset( starsx[d],starsy[d],7) 
		end
	circfill(flr(pl.x/16/8)*16 + 40-flr(pl.x/8)/2,20,20,10)
	map(flr(pl.x/16/8)*16,flr(pl.y/16/8)*16)
	print(pl.x)
	print(pl.y,0,10)
	print(pl.dy)
	print(pl.grab)
	
	spr(pl.spr,pl.x -flr(pl.x/16/8)*128 ,pl.y -flr(pl.y/16/8)*128,1,1,lastdir == "left")
	
end
-->8
//player physics

function walk_right()
	lastdir = "right"
	if pl.grounded then pl.anim = 4 end
	if(dir != "right") then
		dir = "right"
		pl.dx = 0
	 if pl.grounded then	pl.spr = 4 end
	end
	pl.dx += 0.8
	if(pl.dx >= 2.4) then
		pl.dx = 2.4
	end
end


function walk_left()
	lastdir = "left"
	if pl.grounded then pl.anim = 4 end
	if(dir != "left") then
		dir = "left"
		pl.dx = 0
		if pl.grounded then pl.spr = 4 end
	end
	pl.dx -= 0.8
	if(pl.dx <= -2.4) then
		pl.dx = -2.4
	end

end

function check_grab()
	local timer = time() - lastgrab
	if(timer < 0.5 and timer >= 0) then
		if(dir == grabdir) then
			pl.grab = true
		end
	end

end

function apply_gravity()
	pl.ddy += 0.8
	if(pl.ddy >= 0.6) then
		pl.ddy = 0.6
	end
	pl.dy = pl.dy + pl.ddy
	if(pl.dy >= 3) then
		pl.dy = 3
	end
end

function jump()
	pl.grounded = false
	pl.ddy -= 3
	pl.anim = 7
	pl.anim = 7
	if(pl.ddy < -3) then
		pl.ddy = -1
	end
end


function check_collision()
	local collided = false
	pl.wall = false
 local newx1 = pl.x + pl.dx +2
 local newy1 = pl.y + pl.dy +1
 local newx2 = pl.x + pl.dx + 6 
 local newy2= pl.y + pl.dy + 8
 
 local ul = mget(newx1/8, newy1/8)
 local dl = mget(newx1/8, newy2/8)
 local ur = mget(newx2/8, newy1/8)
 local dr = mget(newx2/8, newy2/8)
 
 if(fget(ul, 0)) then
  if(fget(dl, 0)) then
   //left side collision
   pl.x = flr(newx1/8)*8+6
   pl.dx = 0
   collided = true
   if(pl.grab)then
   	pl.dy = 0
   	pl.wall = true
   end
   elseif(fget(ur, 0)) then
    //collision with ceiling
    pl.y = flr((newy1)/8)*8 +7
    pl.dy = 0
    collided = true
   else
    //collision with left down corner
    pl.x = flr(newx1/8)*8+6
    pl.dx = 0
    collided = true
    if(pl.grab)then
   	pl.dy = 0
   	pl.wall = true
   end
   end
 elseif(fget(ur, 0)) then
  if(fget(dr, 0)) then
   //right side collision
   pl.x = flr(newx2/8)*8-6
   pl.dx = 0
   collided = true
   if(pl.grab)then
   	pl.dy = 0
   	pl.wall = true
   end
  else
   //collision with right down corner
   pl.x = flr(newx2/8)*8-6
   pl.dx = 0
   collided = true
   if(pl.grab)then
   	pl.dy = 0
   	pl.wall = true
   end
  end
 end
 //right down corner
 if(not pl.grounded and pl.dy < 0.25) then 
		if( fget(mget(newx2/8, newy2/8),0) and not fget(mget(newx1/8, newy2/8),0))then
			pl.x = flr(newx2/8)*8-6
			pl.dx = 0
			collided = true
			if(pl.grab)then
   	pl.dy = 0
   	pl.wall = true
   end
			//left down corner
		elseif(fget(mget(newx1/8, newy2/8),0) and not fget(mget(newx2/8, newy2/8),0))then
			pl.x = flr(newx1/8)*8+6
			pl.dx = 0
			collided = true
			if(pl.grab)then
   	pl.dy = 0
   	pl.wall = true
   end
	 end
 end
 //recalculate x
 newx1 = pl.x +2
 newx2 = pl.x + 5
 ul = mget(newx1/8, newy1/8)
 dl = mget(newx1/8, newy2/8)
 ur = mget(newx2/8, newy1/8)
 dr = mget(newx2/8, newy2/8)
    
 if(fget(dl, 0)) then
  if(fget(dr, 0) ) then
   //complete down collision
   pl.y = flr(newy2/8)*8-8        
   if(not pl.grounded) then
    pl.spr = 5
    pl.anim = 5
    sfx(01)
   end
   pl.grounded = true
   pl.dy = 0
   collided = true
  else
   //partial left corner step
   pl.y = flr(newy2/8)*8-8 
   if(not pl.grounded) then
    pl.spr = 5
    sfx(01)
   end    
   pl.grounded = true
   pl.dy = 0  
   collided = true    	
  end
  
 elseif(fget(dr, 0)) then
  pl.y = flr(newy2/8)*8-8
  if(not pl.grounded) then
   pl.spr = 5
   sfx(01)	
  end
  pl.grounded = true
  pl.dy = 0
  collided = true
	end
	if(not collided) then
		pl.grounded = false
	end
end

function update_spr()
	speed = 0.5
	if(pl.anim == 4 or pl.anim == 7) then 
		speed = 0.07
	end
	if(time() - timer > speed) then
				pl.spr += 1
				timer = time()
				if(pl.spr >= pl.anim + 3) then
					pl.spr = pl.anim
				end 
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000
00000000002222200022222000222220002222200222222022222200220000000000000000000000002222202022222022222220000000000000000000000000
00700700022222200222222002222220022222202222222022222220222222202222222002222220222222202222222022222220000000000000000000000000
00077000022fcf90222fcf90222fcf902222cf902222cf902222cf9022222f2022222f2022222f202222cf902222cf902222cf90000000000000000000000000
00077000222ffff0222ffff0222ffff0222ffff0222ffff0222ffff0222fcf90222fcf90222fcf90222ffff0222ffff0022ffff0000000000000000000000000
00700700222131002221310022213100222133102221310002013110022ffff0222ffff0222ffff0222131000211310000113110000000000000000000000000
00000000221131002211310002213100001133000011310000113100001131000011310022113100001131400411314004113100000000000000000000000000
00000000004004000040040000400400004000400004040000400040041131400411314004113140004000000000000000000040000000000000000000000000
0544444505445000003333000000000005444450544444450000000022444220244444204444444444444444dddddddd00000000001c7100000000000011100c
05445445054450000333b33b000005500554545054445445000bbb0002422228242242203344333324222222cddddddd00666666001cc10000700c11111ccc11
05445445054445bb03bb3bb300000544005454555544554400bb333302220022242000220033300002200000dddddddd06677776101cc100c00111ccccccc1cc
054444550544443b0555b3b30555054500545445054445440bb3333302300002022822320000000000000000dddddddd66777776001cc1000011ccc1177cccc1
544444550554450054445333544455400054444505454544b213333302200022022220220000000000000000dd8ddddd677777760017c10c0117c77c7717c77c
5444455500544500445bb300445544400054444505454445b333331b0200000e00e800b00000000000000000ddddddde677776600011c1000011c777ccccc777
554444450054455045333300450050000554444505455445b33333b300000000000000000000000000000000d3ddddbd666666000011c1000011c7ccccccc7cc
0545444500544450500000005000000005444450054454450332333300000000000000000000000000000000dddddddd000000000011710000117cc1111cccc1
33333333333333333bb333223333333324444444424444443333333333b333330333330000000000000000000000000000000000000000000000000000000000
3bbbbbbbbbbbbbbbbb2443bbbb33bbb324442444444444243bbbbbbbbb3bbbb33bbbbb3300000000000000000000000000000000000000000000000000000000
3b332b2bbb3bbb2b333bb2323332b3b344444444444244243b332b2bbb3243b33b3bbb2300000000000000000000000000000000000000000000000000000000
334223343b32233444444444d24423b344444424424444243bb223343b4423b33b322b3300000000000000000000000000000000000000000000000000000000
342444443434444444222444244422b34424444244442444332444443b3422b33434444300000000000000000000000000000000000000000000000000000000
d4244424444224444224444444443bb3444244422444444433344424bb3234b33442244300000000000000000000000000000000000000000000000000000000
d42244224442442242424424422432b342424424244244243b324422b3bbbbb33442442300000000000000000000000000000000000000000000000000000000
d4dd2442224444424444444422444bb344444444244444223b3d24423b3333b33244444300000000000000000000000000000000000000000000000000000000
11111111111111111551115511111111666666666566666600000000000000000000000000000000000000000000000000000000000000000000000000000000
15555555555555555556615555115551166666666666661600000000000000000000000000000000000000000000000000000000000000000000000000000000
155155555515555511155515111d5151666666666661661600000000000000000000000000000000000000000000000000000000000000000000000000000000
1165511615155116666666666d666151666666666666661600000000000000000000000000000000000000000000000000000000000000000000000000000000
16566666161666666666666666666d51661666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
d6666666666666666666666666661551666666651666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
d6566666666666656666666666661d51616666161661665600000000000000000000000000000000000000000000000000000000000000000000000000000000
d6dd66655666666666666666dd666551666666661666665500000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000010101010101010101000000000000000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1c00000010000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001100001513001c001413000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014001c10000000001100000000000000000000160030313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014002615120000002700000000000000000000110034343400000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001100161000241200000000000000000000160014001b1b1b00000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
262122212221252313001e271200202131313232313134343400300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
242525242524242512001d000000000034343434343434343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24181a181a191a1700001d000000000034343434343434340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
240026000000000000001d000000000034343434343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
240026002000200000001d000000000034343434340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2400260000000000303132330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3031323231323132343534350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3534353534343535343534000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000e750121501415017150181501a1501b1501c1501d1501a15018150161501515015150101500f1500e1500e1500375002750027500375003750047500475005750067502175026750297502d75031750
000100000160000600006000060000600006000060000600006000060000600006000405004050040500405004050040500405004050040500405004050040200402004020040200402004020040200403004030
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000362004620046200562006630066200762007610066100561007610086200862008620086200862007620076200662006620056200462004620046100461005610066100661006620046300462004620
