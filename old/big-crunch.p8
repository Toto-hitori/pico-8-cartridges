pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--big crunch
--init
function _init()

	--graphic variables
	
	colors = {1,2,4,5,8,9,11,12,13,14}
	sl = false
	clr = 0
	animation = {light,pl,eye}
	animation.light = 0
	animation.player = 0
	animation.eye = 0
	light = 124
	eye = 81
	--logic variables
	final_time = 60.00
	cooldown = 0
	game_status = "title_screen"
	time_then = time() --time counter
	timer = 0 -- game timer
	lvl = 0 -- current level
	level_name = "alimerka" --level name
	pl={ x,y,dx,dy,mov,flip,spr,key} --player variables
	spawn = {x,y} --spawn coords
	init_char() --starts char
	caffeine = 0
	dead = {x,y,is} --char is dead
	dead.is = false
	
	
	--test variables
	
	text_shown = true
	text = "hola"
	
	--text variables 
	text_num = 1
	intro_text = { 
	"*5h antes del examen - casa de un estudiante  medio de uniovi*",
	"probablemente deberia  empezar a estudiar el  final...",
	"o... me echo una run   al isaac y ya si eso   despues...",
	"*3 runs de 1h mas      tarde...*",
	"bueno, ahora si toca   ponerse",
	"* 5 min despues *      ",
	"muuuuuucho textoooooooono voy a llegar ni de  broma :(",
	"debe de haber una      manera mejor de        aprovechar el tiempo",
	"* una busqueda en      google despues *",
	"ok, big brain moment",
	"segun este video de    fractum quanture tu    metabolismo se acelera➡️",
	"al consumir bebidas    cafeinadas, y segun la teoria de einstein➡️",
	"el tiempo se dilata conel aumento de la       velocidad, lo que➡️",
	"significa... que lo queen la realidad son     6 min seran 6h para mi!",
	"tendre todo el tiempo  del mundo para         estudiar!",
	"* y asi da comienzo la epica busqueda de      bebidas cafeinadas *"
	}
end

function init_char()
	
	find_spawn()
	scan_lock()
	pl.x = spawn.x*8
	pl.y = spawn.y*8
	
	pl.dx = 0
	pl.dy = 0
	
	pl.mov = 0
	pl.flip = false
	pl.spr = 49
	pl.key = false
	--sfx(5)
end 




-->8
--update
function _update()
	check_input()
	if game_status == "title_screen" then
		--changes color of title screen
		clr += 0.1
		if clr > 9 then
			clr = 0
		end
	end
	if game_status == "game" then
		--game updates
		apply_acc()
		apply_speed()
		actions()
		check_end()
		if(has_lock) then
			lock_col()
		end
	end
	update_animation()
	update_light()
	animate_eye()
end

function check_input()
	if game_status == "game"then
		input_game()
	else if game_status == "intro" then
		input_intro()
	else if game_status == "title_screen" then
		input_title()
	end
	end
	end
end

function check_end()
	if ( time()-timer > 60) then
		game_over()
	end
end

function game_over()
	game_status = "ending"
end

function input_title()
	--input for title screen
		if(btn(4)) then
			game_status = "intro"
			timer = time()
		end
end

function input_intro()
	--input for title screen
		if(btn(4) and time() - cooldown > 1.2) then
			if text_num < #intro_text then
				cooldown = time()
				text_num += 1
				--sfx(3)
			else
				cooldown = time()
				game_status = "start"
				timer = time()
			end
		else if btn(5) then 
			cooldown = time()
			game_status = "start"
			music(2)
			timer = time()
		end
		end
end
function input_game()
	--input for game screen
	if(btn(0) and  pl.mov != 1) then
			--left
			pl.dx = -1
			pl.mov = 1
			pl.flip = true
			animation.player = 0
			pl.spr = 49
		else if btn(1) and pl.mov != 1 then
			--right
			pl.dx = 1
			pl.mov = 1
			pl.flip = false
			animation.player = 0
			pl.spr = 49
		else if(btn(2) and pl.mov != 2) then
			--up
			pl.dy = -1
			pl.mov = 2
			animation.player = 0
			pl.spr = 51
		else if(btn(3) and pl.mov != 2) then
			--down
			pl.dy = 1
			pl.mov = 2
			animation.player = 0
			pl.spr = 53
			end
		end
		end
		end
end

function update_animation()
	animation.player +=1
	if animation.player == 22 then
		pl.spr += 1
	
	end
	if animation.player > 45 then
		pl.spr -= 1
		
		animation.player = 0
	end

end
function animate_eye()
	animation.eye += 1
		if animation.light == 22 then
		eye = 81
	else if animation.light == 28 then
		eye = 126
	
	else if animation.light == 34 then
		eye = 127
	else if animation.light == 38 then
		eye = 126
	
	else if animation.light == 42 then
		eye = 81
	else if animation.light == 150 then
		animation.eye = 0
	end
	end
	end
	end
	end
	end
end
function update_light()
	animation.light +=1
	if animation.light == 122 then
		light += 1
	else if animation.light == 128 then
		light -= 1
	
	else if animation.light == 134 then
		light += 1
	else if animation.light == 142 then
		light -= 1
	end
	end
	end
	end
	if animation.light > 150 then
		
		animation.light = 0
	end

end






-->8
--draw

function show_skull()
	--draw skull
	if dead.is then
		if(time()-time_then < 0.5)then
			spr(24,dead.x,dead.y)
		else
		dead.is = false
		end
		
	end
end

function show_lvl()
	--shows lvl card
	sl = true
	time_then = time()
end

function show_lvlcard()
		if sl then
			if(time()-time_then < 0.5)then
				rectfill( 20,50,107,70,0 )
				print(level_name,44,57,7)
				print(lvl%4,82,57,7)
			else
			sl = false
			end
		end
end

function draw_start()
	if(time() - cooldown < 1) then
		print("start!",55,59,9)

	
	else 
		show_lvl()
		game_status = "game"

	end
end

function draw_title_screen()
	for i=0,5,1 do
		local num = flr(clr+i)
		if num > 11 then
			num = 1
		end
		circfill(64, 64, 20*(6-i), colors[num+1])	
	end
	--rectfill( 42, 30, 87,60, 0 )
	spr(67,47,30,4,4)
	spr(87,79,38)
	if text_shown then
		if time()-time_then < 1 then
			print("press z to start",33,80,7)
		else
			time_then = time()
			text_shown = false
		end
	else 
			if time()-time_then < 1 then
		else 
			time_then = time()
			text_shown = true
		end
	end
	
end

function draw_intro()
	--rectfill(0,0,128,128,)
	
		rectfill(0,97,128,128,1)
		rect(0,96,127,127,2)
		rectfill(27,100,124,124,14)
		rect(27,100,124,124,2)
		rectfill(3,100,24,124,0)
		spr(64,4,99,2.5,4) --portrait
		spr(eye,12,107)--eye
		rect(3,100,24,124,2)
		--rect(4,103,124,125,1)
		--rectfill(4,90,124,100,14)
		local string = intro_text[text_num]
		print(sub(string,0,23),30,103,2)
		print(sub(string,24,46),30,110,2)
		print(sub(string,47),30,117,2)
		circfill(64,56,28,6) --circle char
		spr(light,61,32) --light bulb
		spr(120,67,42,2,1) --upper window
		spr(122,67,50,2,1) --lower window
		spr(72,47,55,4,3) --desk
		spr(pl.spr,53,60) --character
		print("avanzar(z)",88,3,5)
		print("saltar(x)")
end

function draw_game()
	rectfill( 0, 0, 127,127, 1 )
	
	for i=0,50,1 do	
	 pset(rnd(127),rnd(127),9)
	end
	map(lvl%8*16,flr(lvl/8)*16,0,0,16,16)
	spr(pl.spr,pl.x%128,pl.y-flr(lvl/8)*128,1,1,pl.flip)
	local tim = 60-flr((time()-timer)*100)/100
	print("tiempo:"..tostr(tim),1,1,9)
	print("cafeina:",80,1,9)
	print(caffeine,120,1,9)
	show_skull()
	show_lvlcard()
	if flr(lvl/4) == 0 then
		print("alimerka",50,122,9)
		level_name = "alimerka"
	else if flr(lvl/4) == 1 then
		print("lidl",50,122,10)
		level_name = "lidl"
	else if flr(lvl/4) == 2 then
		print("mercadona",50,122,3)
		level_name = "mercadona"
	else if flr(lvl/4) == 3 then
		print("eroski",50,122,7)
		level_name = "eroski"
	end
	end
	end
	end
	if lvl ==3 then
		print("girar",99,43,7)
	end

end

function draw_ending()
		rectfill(0,97,128,128,1)
		rect(0,96,127,127,2)
		rectfill(27,100,124,124,14)
		rect(27,100,124,124,2)
		rectfill(3,100,24,124,0)
		spr(64,4,99,2.5,4) --portrait
		spr(eye,12,107)--eye
		rect(3,100,24,124,2)
		print("",0,0,7)
	local mark = 0
	local hours = 0
	local text = ""
	if caffeine <= 0 then
		mark = 110
		hours = 0
		text = "sacas un 0 :("
	else if caffeine < 7 then
		mark = 95
		hours = 2
			text = "sacas un 3 :("
	else if caffeine < 16 then
		mark = 94
		hours = 6
		text = "sacas un 5 :)"
	else if caffeine < 25 then
		mark = 79
		hours = 14
		text = "sacas un 8 :d"
	else if caffeine >= 25 then
		mark = 78
		hours = 45
		text = "sacas un 10!"
		if(caffeine == 28) then
			spr(13,50,55)
			print("perfect!",47,70,9)
		end
	end
	end
	end
	end
	end
	local string = "*llegas a casa,te bebes las bebidas y dilatas el tiempo a "..tostr(hours).." horas*"
	
		print("tu tiempo: "..tostr(flr(final_time*100)/100),34,38)
		--circfill(64,56,28,6) --circle char
		print(text,38,78)
		print("cafeina:"..tostr(caffeine))
		print(sub(string,0,23),30,103,2)
		print(sub(string,24,46),30,110,2)
		print(sub(string,47),30,117,2)
		spr(76,56,50,2,2)
		spr(mark,63,52)
end

function _draw()
	cls()
	
	if game_status == "game" then
		draw_game()
	else if game_status == "intro" then
		draw_intro()
	else if game_status == "ending" then
		music(-1)
		draw_ending()
	else if game_status == "start" then
		draw_start()
	else if game_status == "title_screen" then
		draw_title_screen()
		end
	end
	end
	end
	end
	
end
-->8
--character mechanics

function actions()
	col = mget((pl.x+4)/8,(pl.y+4)/8)
	if fget(col,2)then
		--grab drink
		mset((pl.x+4)/8,(pl.y+4)/8,3)
		sfx(1)
		caffeine += 1
	else if fget(col,7)then
		--reach end of level
		lvl += 1
		if(lvl <= 15) then
			init_char()
			show_lvl()
		else
			final_time = time() - timer
			game_status = "ending"
		end
	else if fget(col,3)then
		--die
		show_lvl()
		die()
	else if fget(col,4)then
		--pick key
		pl.key = true
		has_lock = false
	 mset((pl.x+4)/8,(pl.y+4)/8,3)
	 sfx(6)
	else if fget(col,5)then
		--open lock
		pl.key = false
	 mset((pl.x+4)/8,(pl.y+4)/8,3)
	 sfx(6)
	end
	end
	end
	end
	end
end


function die()
		sfx(2)
		time_then = time()
		dead.is = true
		dead.x = pl.x - (lvl%8*128)
		dead.y = pl.y+1
		animation.player = 0
	 local key_state = pl.key
	 init_char()
	 pl.key = key_state1
	 
end

function apply_acc()
		
	if(abs(pl.dx) < 8 and pl.mov == 1)then
		pl.dx *= 1.2
		if(not wall_col())then
			pl.dy *= 0
		end
	end
	if(abs(pl.dy) < 8 and pl.mov == 2)then
		pl.dy *= 1.2
		if(not wall_col())then
			pl.dx *= 0
		end
	
	end
	if(pl.dx > 8)then
		pl.dx = 8
	else if(pl.dx < -8)then
		pl.dx = -8
	else if(pl.dy < -8) then
		pl.dy = -8
	else if(pl.dy > 8)then
		pl.dy = 8
	end
	end
	end
	end
end

function apply_speed()
	if(not wall_col())then
		pl.x += pl.dx
		pl.y += pl.dy
	end
end
-->8
--level


function find_spawn()
	--finds the spawn for the player
	for i=0,15,1 do
		for j=0,15,1 do
			if fget(mget(i+16*(lvl%8),j+16*flr(lvl/8)),6) then
					spawn.x = i+16*(lvl%8)
					spawn.y = j+16*flr(lvl/8)
				end
		end
	end
end

function scan_lock()
	--finds the spawn for the player
	for i=0,15,1 do
		for j=0,15,1 do
			if fget(mget(i+16*(lvl%8),j+16*flr(lvl/8)),5) then
					has_lock = true
				end
		end
	end
end

function lock_col()
	xcell = pl.x/8
	ycell = pl.y/8
	if((fget(mget(pl.x/8,(pl.y+pl.dy)/8),5) or fget(mget((pl.x+7)/8,(pl.y+pl.dy)/8),5)) and pl.dy < 0 and not pl.key)then
		--up collision
		
		pl.y = flr((pl.y+pl.dy)/8)*8+8
		pl.dy  = 0
		pl.mov = 0
		sfx(0)
		return true
	end	
	if((fget(mget((pl.x+pl.dx+8)/8,pl.y/8),5) or fget(mget((pl.x+pl.dx+8)/8,(pl.y+7)/8),5))and pl.dx > 0 and not pl.key)then
		--right collision
		pl.x = flr((pl.x+pl.dx+8)/8)*8-8
		pl.dx = 0
		pl.mov = 0
		sfx(0)
		return true
	end
	if((fget(mget((pl.x+pl.dx)/8,pl.y/8),5) or fget(mget((pl.x+pl.dx)/8,(pl.y+7)/8),5)) and pl.dx < 0 and not pl.key)then
		--left collision
		pl.x = flr((pl.x+pl.dx)/8)*8+8
		pl.dx = 0
		pl.mov = 0
		sfx(0)
		return true
	end
	if((fget(mget(pl.x/8,(pl.y+pl.dy+8)/8),5) or fget(mget((pl.x+7)/8,(pl.y+pl.dy+8)/8),5)) and pl.dy > 0 and not pl.key)then
		--down collision
		pl.y = flr((pl.y+pl.dy+8)/8)*8-8
		pl.dy = 0
		pl.mov = 0
		sfx(0)
		return true
	end	
	return false			
end

function wall_col()
	xcell = pl.x/8
	ycell = pl.y/8
	if((fget(mget(pl.x/8,(pl.y+pl.dy)/8),1) or fget(mget((pl.x+7)/8,(pl.y+pl.dy)/8),1)) and pl.dy < 0)then
		--up collision
		pl.y = flr((pl.y+pl.dy)/8)*8+8
		pl.dy  = 0
		pl.mov = 0
		sfx(0)
		return true
	end	
	if((fget(mget((pl.x+pl.dx+8)/8,pl.y/8),1) or fget(mget((pl.x+pl.dx+8)/8,(pl.y+7)/8),1))and pl.dx > 0)then
		--right collision
		pl.x = flr((pl.x+pl.dx+8)/8)*8-8
		pl.dx = 0
		pl.mov = 0
		sfx(0)
		return true
	end
	if((fget(mget((pl.x+pl.dx)/8,pl.y/8),1) or fget(mget((pl.x+pl.dx)/8,(pl.y+7)/8),1)) and pl.dx < 0)then
		--left collision
		pl.x = flr((pl.x+pl.dx)/8)*8+8
		pl.dx = 0
		pl.mov = 0
		sfx(0)
		return true
	end
	if((fget(mget(pl.x/8,(pl.y+pl.dy+8)/8),1) or fget(mget((pl.x+7)/8,(pl.y+pl.dy+8)/8),1)) and pl.dy > 0)then
		--down collision
		pl.y = flr((pl.y+pl.dy+8)/8)*8-8
		pl.dy = 0
		pl.mov = 0
		sfx(0)
		return true
	end	
	return false			
end

__gfx__
000000000000000066666446666666665555555500000000777577755666666666666666666655576677776666777d6666666666000000000000000000000000
000000000000000055566ff466666666511da115000000005756575675556666666666666655777767666676676667d666654666009000000000000000000000
007007000000000055566ff466666666591d1115000000005756575677775566665666566666555767676676676667d6666286660aaa90000000000000000000
00077000000000006566111666666666511d11150000000057565756755566666656665666666665687777869999999466288866a4494a000000000000000000
000770000000000022222222666666665111d1950000000065666566566666666575657566665557688888869944499466171766a4444a990000000000000000
0070070000000000555555556666666651a1d1150000000065666566755566666575657566557777688778869944499466177166aaaaaa090000000000000000
000000000000000055555555666666665111d1150000000066666666777755666575657566665557688878869994999466288866aaaaaa990000000000000000
000000000000000055555555666666665111d19500000000666666667555666657775777666666656687886669999946666666660aaaa0000000000000000000
777777777aaaaaaa7aaaaaaaaaaaaaaa7777777777777777aaaaaaa7aaaaaaa70000000077777777666666666666666666666666666666667666666600000000
77aaaaaa7aaaaaaa7aaaaaaaaaaaaaaaaaaaaa77aaaaaaaaaaaaaaa7aaaaaaa70077770077aaaa77666666666676666666666666676666666767666600000000
7aaaaaaa7aaaaaaa7aaaaaaaaaaaaaaaaaaaaaa7aaaaaaaaaaaaaaa7aaaaaaa7067777707aaaaaa7699666666eee76667eeee6667eee76666eee766600000000
7aaaaaaa7aaaaaaa7aaaaaaaaaaaaaaaaaaaaaa7aaaaaaaaaaaaaaa7aaaaaaa7067d7d707aaaaaa796699999e4474e66e7474e66e4474e66e4444e6600000000
7aaaaaaa7aaaaaaa7aaaaaaaaaaaaaaaaaaaaaa7aaaaaaaaaaaaaaa7aaaaaaa7006777007aaaaaa796696969e4444effe4444effe4444effe4444eff00000000
7aaaaaaa7aaaaaaa7aaaaaaaaaaaaaaaaaaaaaa7aaaaaaaaaaaaaaa7aaaaaaa7006767007aaaaaa769966666eeeeee6feeeeee6feeeeee6feeeeee6f00000000
7aaaaaaa7aaaaaaa77aaaaaaaaaaaaaaaaaaaaa7aaaaaaaaaaaaaaa7aaaaaa770000000077aaaa7766666666eeeeeeffeeeeeeffeeeeeeffeeeeeeff00000000
7aaaaaaa7aaaaaaa7777777777777777aaaaaaa7aaaaaaaaaaaaaaa7777777770000000077777777666666666eeee6666eeee6666eeee6666eeee66600000000
77777777aaaaaaaadddddddd33333333377777773777777777777777333333333333333377777773777777733777777377777777777777770000000000000000
77aaaa77aaaaaaaadddddddd33777777377777773777777777777777777777337777777777777773777777733777777377777777777777770000000000000000
7aaaaaa7aaaaaaaadddddddd37777777377777773777777777777777777777737777777777777773777777733777777377777777777777770000000000000000
7aaaaaa7aaaaaaaadddddddd37777777377777773777777777777777777777737777777777777773777777733777777377777777777777770000000000000000
7aaaaaa7aaaaaaaadddddddd37777777377777773777777777777777777777737777777777777773777777733777777377777777777777770000000000000000
7aaaaaa7aaaaaaaadddddddd37777777377777773777777777777777777777737777777777777773777777733777777377777777777777770000000000000000
7aaaaaa7aaaaaaaadddddddd37777777377777773377777777777777777777737777777777777773777777333377773377777777777777770000000000000000
7aaaaaa7aaaaaaaadddddddd37777777377777773333333333333333777777737777777777777773333333333333333377777777777777770000000000000000
00222220002222000022220000222200002222000022220000222200000000000000000000000000000000000000000000000000000000000000000000000000
02888880028888200288882002222220022222200288882002888820000070000000000000000000000000000000000000000000000000000000000000000000
0288fff0088f8f80088f8f80022222200222222008f88f8008f88f80000070000000070000070000000000000000000000000000000000000000000000000000
028dfdf0088c8c20088c8c20022222200222222008c8fc2008c8fc20000070000000007000700000000000000000000000000000000000000000000000000000
008fff00028fff20028fff20022222200222222002ffff2002ffff20007070700077777707777770000000000000000000000000000000000000000000000000
001111000f1111f0001111000f1221f0001221000f1111f000111100000777000000007000700000000000000000000000000000000000000000000000000000
00111100001111000f1111f0001111000f1111f0001111000f1111f0000070000000070000070000000000000000000000000000000000000000000000000000
00555500004004000040040000400400004004000040040000400400000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000555500000000000000000000000000000080000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000055555500000000000000000000000000080888000088000
00000000022020000000000000000077000000770000000000000000000000000000011000000005555555500000000000000077777777700888080000800800
00000000020000000000000000000777000077770000000000000000000000000001133100000055555555500000000000000077777777700808000008888800
00000002288880000000000000000777000077700000000000000000000000000001333100000055555555500000000000000077777777008888000088008000
00000022888888000000000000000000000077700077700000000000000000000013333100000055555555500000000000000777777777008008000008008000
00000228888888800000000000000000770077700077700000000000000000000013333310000055555555444440000000000777777777000000000000880000
00002228888882880000000007777700777077700000700000077000000000000001333310000055555544444444000000007777777770000000000000000000
0000222888288f280000000077777770777707777007700000077700000000000001333310000055555555444444000000007766677770000000000000000000
00022288822822f20000000077770770777770777777700000007770777700000001133331111055445555444444000000077777766660000008800000888000
00022288828f17f20000000077770770077770777770000000000777777770000000133313333104455554444044000000076666777700000080080000808000
0002228822ffd7f2000000007777777007777700000000000077777770077700000013313333314445544444dd44000000777776677000000800000008800800
000222282ffffff200000000077777777777770000000000077770777700770000000113333334444444444ddd44d00000777777767000000800800008008800
00002222f555ff800000000007770077707777000000000077700007777000000000001333331444444444dddd44dd0000000077770000000088000008880000
00002222fffff8800000000007777777707770000000000077700000777000000000dd111111144444444ddddddddd0000000000770000000000000000000000
00000220ffff8800000000000077777700007000000077700777077000000000000dddd11dd1144dddd44ddddddddd0000000000000000000000000000000000
0000dd15ffff51dd000000000007770000000000077077770077777000000000000dddd11dd1144dddd44dddddddd00000000000000000000000000000000000
000dd15ffffff51dd00000000000000000000000077770777007770000000000000dddddddddd44dddd44ddddddd000000000000000000000088880000000000
000dd1155ff5551dd000000000000000000000770077700777000000000000000000dddddddddddddddddddddd00000000000000000000000080000000000000
0011dd11155111dd11000000000000000777007770077700770000000000000000000ddddddddddddddddddd0000000000000000000000000888800000000000
01111111d11d111111100000000000770777000777007770000000000000000000000000ddddddddddd000000000000000000000000000000800000000000000
11111111d11d11111111000000777077770077007770077000000000000000000000000000000000000000000000000000000000000000000800000000000000
1111111d111d11111111000007777077770077777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111d1111d1111111000077777007777007777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111d1111d11111110000777700007777007700000000000000000000000004444444444444404111115a51111114005550000055500088288f2888288f28
111111111111111111110000777000007777000000000000000000000000000044111111111111444111115a5111111400555000005550008228fff28228fff2
11111111111111111111000077777777077000000000000000000000000000004111111119111114411911aaa111111400a9a00000d1d000828f22f2828ffff2
00000000000000000000000007777777000000000000000000000000000000004111a111111111144111115a51aa19140aa9aa000dd1dd0022ffd7f222ff22f2
00000000000000000000000000077770000000000000000000000000000000004111111111111114411111a5aaaa11140aa9a7000dd1d7002ffffff22ffffff2
00000000000000000000000000000000000000000000000000000000000000004111111111111a144111111aaaa111140a9a97000d1d1700f555ff80f555ff80
00000000000000000000000000000000000000000000000000000000000000004911111aaaaa111444a11111111111440a9a97000d1d1700fffff880fffff880
0000000000000000000000000000000000000000000000000000000000000000411111aaaa1a1114044444444444444000aa700000dd7000ffff8800ffff8800
aaaaaaaaa5555555a555555555555555aaaaaaaaaaaaaaaa5555555a5555555aaaaaaaaa55555555a555555a0000000000000000000000000000000000000000
aa555555a5555555a555555555555555555555aa555555555555555a5555555aaa5555aa55555555a555555a0000000000000000000000000000000000000000
a5555555a5555555a5555555555555555555555a555555555555555a5555555aa555555a55555555a555555a0000000000000000000000000000000000000000
a5555555a5555555a5555555555555555555555a555555555555555a5555555aa555555a55555555a555555a0000000000000000000000000000000000000000
a5555555a5555555a5555555555555555555555a555555555555555a5555555aa555555a55555555a555555a0000000000000000000000000000000000000000
a5555555a5555555a5555555555555555555555a555555555555555a5555555aa555555a55555555a555555a0000000000000000000000000000000000000000
a5555555a5555555aa555555555555555555555a555555555555555a555555aaa555555a55555555a555555a0000000000000000000000000000000000000000
a5555555a5555555aaaaaaaaaaaaaaaa5555555a555555555555555aaaaaaaaaa555555a55555555a555555a0000000000000000000000000000000000000000
77777777788888887888888888888888777777777777777788888887888888877777777788888888788888870000000000000000000000000000000000000000
77888888788888887888888888888888888888778888888888888887888888877788887788888888788888870000000000000000000000000000000000000000
78888888788888887888888888888888888888878888888888888887888888877888888788888888788888870000000000000000000000000000000000000000
78888888788888887888888888888888888888878888888888888887888888877888888788888888788888870000000000000000000000000000000000000000
78888888788888887888888888888888888888878888888888888887888888877888888788888888788888870000000000000000000000000000000000000000
78888888788888887888888888888888888888878888888888888887888888877888888788888888788888870000000000000000000000000000000000000000
78888888788888887788888888888888888888878888888888888887888888777888888788888888788888870000000000000000000000000000000000000000
78888888788888887777777777777777888888878888888888888887777777777888888788888888788888870000000000000000000000000000000000000000
__label__
9999999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999999999999
999999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999999999999
9999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999999999
999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999999999
99999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999999999
9999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999999
999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999999
99999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999999
9999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999
999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999
99999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999
9999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999
999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99
99bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9
99bbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9
9bbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccdddddddddddddcccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccdddddddddddddddddddddccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccdddddddddddddddddddddddddddcccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccccccccbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbcccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccccbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccccccbbbbbbbbbbbbbb
bbbbbbbbbbbbbbcccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccbbbbbbbbbbbbb
bbbbbbbbbbbbbcccccccccccccccccccccccccccddddddddddddd77dddddd77ddddddddddddddddddddddddddcccccccccccccccccccccccccccbbbbbbbbbbbb
bbbbbbbbbbbbbccccccccccccccccccccccccccddddddddddddd777dddd7777dddddddddddddddddddddddddddccccccccccccccccccccccccccbbbbbbbbbbbb
bbbbbbbbbbbbcccccccccccccccccccccccccddddddddddddddd777dddd777ddddddddddddddddddddddddddddddcccccccccccccccccccccccccbbbbbbbbbbb
bbbbbbbbbbbcccccccccccccccccccccccccddddddddddddddddddddddd777ddd777dddddddddddddddddddddddddcccccccccccccccccccccccccbbbbbbbbbb
bbbbbbbbbbbccccccccccccccccccccccccdddddddddddddddddddd77dd777ddd777ddddddddddddddddddddddddddccccccccccccccccccccccccbbbbbbbbbb
bbbbbbbbbbccccccccccccccccccccccccdddddddddddddd77777dd777d777ddddd7dddddd77dddddddddddddddddddccccccccccccccccccccccccbbbbbbbbb
bbbbbbbbbbccccccccccccccccccccccccddddddddddddd7777777d7777d7777dd77dddddd777ddddddddddddddddddccccccccccccccccccccccccbbbbbbbbb
bbbbbbbbbccccccccccccccccccccccccdddddddddddddd7777d77d77777d7777777ddddddd777d7777dddddddddddddccccccccccccccccccccccccbbbbbbbb
bbbbbbbbbcccccccccccccccccccccccddddddddddddddd7777d77dd7777d77777dddddddddd77777777dddddddddddddcccccccccccccccccccccccbbbbbbbb
bbbbbbbbbccccccccccccccccccccccdddddddddddddddd7777777dd77777dddddddddddd7777777dd777dddddddddddddccccccccccccccccccccccbbbbbbbb
bbbbbbbbcccccccccccccccccccccccddddddddddddddddd7777777777777ddddddddddd7777d7777dd77dddddddddddddcccccccccccccccccccccccbbbbbbb
bbbbbbbbccccccccccccccccccccccdddddddddddddddddd777dd777d7777dddddddddd777dddd7777dddddddddddddddddccccccccccccccccccccccbbbbbbb
bbbbbbbccccccccccccccccccccccddddddddddddddddddd77777777d777eeeeeeeeedd777ddddd777ddddddddddddddddddccccccccccccccccccccccbbbbbb
bbbbbbbccccccccccccccccccccccdddddddddddddddddddd777777ddee7eeeeeee777ee777d77ddddddddddddddddddddddccccccccccccccccccccccbbbbbb
bbbbbbbcccccccccccccccccccccdddddddddddddddddddddd777ddeeeeeeeee77e7777ee77777dddddddddddddddddddddddcccccccccccccccccccccbbbbbb
bbbbbbccccccccccccccccccccccdddddddddddddddddddddddddeeeeeeeeeee7777e777ee777ddddddddddddddddddddddddccccccccccccccccccccccbbbbb
bbbbbbcccccccccccccccccccccdddddddddddddddddddddddddeeeeeeeee77ee777ee777eeeedddddddddddddddddddddddddcccccccccccccccccccccbbbbb
bbbbbbcccccccccccccccccccccddddddddddddddddddddddddeeeee777ee777ee777ee77eeeeeddddddddddddddddddddddddcccccccccccccccccccccbbbbb
bbbbbbcccccccccccccccccccccdddddddddddddddddddddddeee77e777eee777ee777eeeeeeeeedddddddddddddddddddddddcccccccccccccccccccccbbbbb
bbbbbcccccccccccccccccccccddddddddddddddddddddddd777e7777ee77ee777ee77eeeeeeeeeedddddddddddddddddddddddcccccccccccccccccccccbbbb
bbbbbcccccccccccccccccccccdddddddddddddddddddddd7777e7777ee7777777eeeeeeeeeeeeeeeddddddddddddddddddddddcccccccccccccccccccccbbbb
bbbbbcccccccccccccccccccccddddddddddddddddddddd77777ee7777ee77777eeeeeeeeeeeeeeeeedddddddddddddddddddddcccccccccccccccccccccbbbb
bbbbbccccccccccccccccccccdddddddddddddddddddddd7777eeee7777ee77eeeeeeeeeeeeeeeeeeeddddddddddddddddddddddccccccccccccccccccccbbbb
bbbbbccccccccccccccccccccddddddddddddddddddddde777eeeee7777eeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbbb
bbbbbccccccccccccccccccccddddddddddddddddddddde77777777e77eeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbbb
bbbbcccccccccccccccccccccddddddddddddddddddddeee7777777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddcccccccccccccccccccccbbb
bbbbccccccccccccccccccccdddddddddddddddddddddeeeee7777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccdddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccdddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbb
bbbbccccccccccccccccccccdddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbb
bbbbcccccccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddcccccccccccccccccccccbbb
bbbbbccccccccccccccccccccdddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbbb
bbbbbccccccccccccccccccccdddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddccccccccccccccccccccbbbb
bbbbbccccccccccccccccccccddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddddccccccccccccccccccccbbbb
bbbbbcccccccccccccccccccccdddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddcccccccccccccccccccccbbbb
bbbbbcccccccccccccccccccccddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddddcccccccccccccccccccccbbbb
bbbbbcccccccccccccccccccccdddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddddcccccccccccccccccccccbbbb
bbbbbbcccccccccccccccccccccdddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddddcccccccccccccccccccccbbbbb
bbbbbbcccccccccccccccccccccddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddddddddddddddddcccccccccccccccccccccbbbbb
bbbbbbcccccccccccccccccccccdddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddddddcccccccccccccccccccccbbbbb
bbbbbbccccccccccccccccccccccdddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddddddddddddccccccccccccccccccccccbbbbb
bbbbbbbcccccccccccccccccccccdddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeedddddddddddddddddddddddddddcccccccccccccccccccccbbbbbb
bbbbbbbccccccccccccccccccccccddddddddddddddddddddddddddddeeeeeeeeeeeeeeeddddddddddddddddddddddddddddccccccccccccccccccccccbbbbbb
bbbbbbbccccccccccccccccccccccdddddddddddddddddddddddddddddddeeeeeeeeedddddddddddddddddddddddddddddddccccccccccccccccccccccbbbbbb
bbbbbbbbccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccbbbbbbb
bbbbbbbbcccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccbbbbbbb
bbbbbbbbbccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccbbbbbbbb
bbbbbbbbbcccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccbbbbbbbb
bbbbbbbbbccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccbbbbbbbb
bbbbbbbbbbccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccbbbbbbbbb
bbbbbbbbbbccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccbbbbbbbbb
bbbbbbbbbbbccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccbbbbbbbbbb
bbbbbbbbbbbcccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccbbbbbbbbbb
bbbbbbbbbbbbcccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccbbbbbbbbbbb
bbbbbbbbbbbbbccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccccbbbbbbbbbbbb
bbbbbbbbbbbbbcccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccbbbbbbbbbbbb
bbbbbbbbbbbbbbcccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccbbbbbbbbbbbbb
bbbbbbbbbbbbbbbccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccccccbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbcccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccccbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccccccccbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddcccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccdddddddddddddddddddddddddddcccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccdddddddddddddddddddddccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccdddddddddddddcccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbb
9bbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbb
99bbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9
99bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9
999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99
9999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999
99999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999
999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999
9999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999
99999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999999
999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999999
9999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999999
99999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999999999
999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999999999
9999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999999999999
999999999999999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb99999999999999

__gff__
0002800040000808080804200404040402020202020202020002100404040400020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202000000000002020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2121131313131313131313131313131313132121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212189898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101211321010101010101010101010101010101010101010101010101010101010101010101010189838389010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101012113210101010101010101010101010101160411010101010101010101010101010101010101010101010101010101010101010101010186020981010101018983838383838383838901010101010101010101010101010101010101010101010101010189838383838383890101
010101010101010101010101010101010101160411010101010101010101010101010116031101010101010101010101010101010101010121132101010101013a010101010101010186030981010101018603030303030303038101010101010101010101010101010101010101010101010101010186060606060606810101
01010101010101010101010101010101010116031101010101010101010101010101011603110101010101010101010101010101010101011604110101010101010101010101010101860309810101010186038085858585840381010101010101018983838383838383838383890101010101010101860303030a0303810101
01010121131313131313131321010101010116031101010101010101010101010101011603110101211313132101010101010101010101011603110138373901010101010101010101860a098101010101861b810101010186038101010101010101860303030303030303031d81010101010101010186030303030302810101
01010116040303030a03030211010101010116031101010101010101010101010101011603110101160a0303110101010101010101010101160311010101010101010101010101010186030981010101018603828383838387038283838389010101860380858585858585840381010101010101010186030380858585890101
010101211515151515151515210101010101160311010101010101010101010101010116031213131703190311010101010101010101010116031101010101010101010101010101018603098101010101860303030303040303030a030981010101861b810303030403028a0381010101010101010186030381010101010101
0101010101010101010101010101010101011603110101010101010101010101010101160303030303030303110101010101012113131313170312131313210101010101010101010186030981010101018985858585858584038085858589010101860381038283838383870381010101010101010186030981010101010101
01010101010101010101010101010101010116031213131313131313132101010101012115151515140310152101010101010116020303030303030a03091101010101898383838383870309810101010101010101010101861b8101010101010101860381030303030a03030381010101010101010186030981010101010101
010101010101010101010101010101010101160a030303030303030302110101010101010101010116021101010101010101012115151515151515151515210101010186040303030303030981010101010101010101010186038101010101010101860382838383838383870381010101898383838387030981010101010101
010101010101010101010101010101010101211515151515151515151521010101010101010101012115210101010101010101010101010101010101010101010101018985858585858585858901010101010101010101018602810101010101010186030303030303030a030381010101860403030303030981010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010189858901010101010101898585858585858585858589010101898585858585858589010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
1515151515151515151515151515151515151515151515151521212121212121212121212121212121212121212121212121212121212121212121212121212189898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989
26262626262626262626262626262626262626262626262c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101012c262c0101010101010101010101999399010101010101010101010199939393939393939393939399010101010199939901010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101012c262c0101010101010101010101010101010101010101010101010101010101012902240101010101010101010199970292990101010101010101010196030303030303030303030391010101010196029101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010129042401010101010101010101010101010101010101010101010101010101010129032401010101010101010101960703099101010101010101010101960390959595959595959403910101010101961b9101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101010129032401010101010101010101012c26262626262c010101010101010101010101290a240101010101010101010196070a09929393939393990101010196039101010101999399960391010101010196039101010101010101010101010101010199939393999993939901
010101012c2626262626262626262c0101010101012903240101010101010101010101290403031a0a24010101010101010101012c2c2903252c01010101010101010199940303031b03030303910101010196039293939393970a9196039101010101019603929393939393939901010199939393939703030392971b0c9101
01010101291a0304030303030b022401010101012c2a032526262c01010101010101012903232828282c010101010101010101012c26290b092401010101010101010101960390959595959403910101010196030303030403030b919603910101010101960303060606060609910101019604030303030302030b030a0c9101
010101012c2828282828282828282c01010101012903031a030a2401010101010101012903252626262d0101010101010101010129042b03092401010101010101010101960392939393999603910101010199959595959595940392970391010101010196030303030303030991010101999595959594031a0390940a1b9101
01010101010101010101010101010101010101012903232828282c01010101010101012903060606062526262c010101010101012903030309240101010101010101010196030303030491960a9101010101010101010101019603030303910101010101960303030303030a0991010101010101010199959595999995959901
010101010101010101010101010101010101010129032401012c262c0101010101010129030303030303030224010101010101012c282703092401010101010101010101960390959595999603910101010101010101010101961a90959599010101010196030308080808080991010101010101010101010101010101010101
010101010101010101010101010101010101010129032526262a022401010101010101290b080808080823282c010101010101010101291a092401010101010101010101960b92939393939703910101010101010101010101960391010101010101010196039095959595959599010101010101010101010101010101010101
0101010101010101010101010101010101010101290303030b030324010101010101012c2828282828282c01010101010101010101012c28282c010101010101010101019603031a0303030303910101010101010101010101960291010101010101010196049101010101010101010101010101010101010101010101010101
01010101010101010101010101010101010101012c2828282828282c01010101010101010101010101010101010101010101010101010101010101010101010101010101999595959595959595990101010101010101010101999599010101010101010199959901010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
28282828282828282828282828282828282828282828282828282828282828282828282828282828282c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
__sfx__
0001000016010160101601014010130101301012010100100f0100d0100c0100a0100801007010060100501006010070100801008010080100b010110101401016010180101b0101b0101c0101d0101e0101e010
00010000057500675008750097500a7500b7500c7500c75011750127501275013750147501675017750187501a7501a7501a7501b7501c7501d7501f750207502175022750217502475026750267502675027750
0001000006050060500605006050060500605006050050502665028650296502a6502b6502b650286502b6502a650286502565022650136500b65009650096500965009650006500065000650006500065000650
0005000011130191201b1201b1201b1201513018130191201b120191201b130141201b120131201b1201b1201c13014130161301c1301c120181301913013130141301b1401b1401614018140191401614019150
00040000181401814018140181301813017130101201512011120101201513015130151301612016120171201812019120191201312015120161201813015130121300f1300f1300f13010130111401114016140
000100000775008750077500a7500a7500b7500c7500c7500d7500d7500d7500e7500f750107501275013750157501675018750187501a7501c7501d7501e7501f7501e750207502175022750227502175020750
0001000017550205502155023550225501c5501655010550185501655013550125501155011550105500f5500f5500f5500b55010550105500f5500f5500e5500e55012550145501455014550145501455015550
001c00000e73010730117300e73010730117300e73010730117300e73010730117300e7301073011730157300e73010730117300e73010730117300e73010730117300e73010730117300e730107301173015730
001c00001573015730157301373013730155001554000000000000000000000000000000000000000000000015730157301573013730137301550015540000000000000000000000000000000000000000000000
001c000005550055300010000100011000e1000e1000e10005550055300d1000d1000d1000c1000c1000c10005550055300b10000000000000000000000000000555005530000000000000000000000000000000
001c00001373013730137301573015730000001374000000000000000000000000000000000000000000000013730137301373015730157300000013740000000000000000000000000000000000000000000000
003700001c700207001f7002270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 4b454544
01 07080944
02 070a0944
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41420c44
00 4142430e
00 41424344
00 10424344
00 41114344

