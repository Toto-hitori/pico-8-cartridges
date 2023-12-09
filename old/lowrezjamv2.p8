pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	poke(0x5f2c,3)
	win_game = peek(0x5f80)
	raccoon = {
		active = true,
		sprite = 2
	}
	setup_title_screen()
	setup_end()
	setup_textbox()
	setup_shapes()
	setup_western()
	setup_coins()
	setup_rana()
	setup_button()
	current_lines_skipped = 0
	total_lines_skipped = 0
	empty = 0
	lempty = 0
	started = false
	win = false
	lost = false
	game =-1
end
function _update()
	check_flag()
	update_raccoon()
	if(text_box.active) then
		update_textbox()
	end
	if(game == -2) then
		update_end()
	elseif(game == -3) then
		update_credits()
	elseif(game == -1) then
		update_title_screen()
		
	elseif(game == 0) then
		start_text()
		//update_start()
	elseif(game == 1) then
		western_text()
		if started then
			update_western()
		end
	elseif(game == 2) then
		coins_text()
		if started then
			update_coins()
		end
	elseif(game == 3) then
		shapes_text()
		if started then
			update_shapes()
		end
		
	elseif(game == 4) then
		rana_text()
		if started then
			update_rana() 
		end
	else
		button_text()
		if started then
			update_button()
		end
	end
end

function _draw()
	cls()
	
	if(game == -2) then
		draw_end()
	elseif(game == -3) then
		draw_credits()
	elseif game == -1 then
		draw_title_screen()
	elseif(game == 0) then
		draw_start()
	elseif(game == 1) then
		draw_western()
	elseif(game == 2) then
		draw_coins()
	elseif(game == 3) then
		draw_shapes()
	elseif(game == 4) then
		draw_rana()
	else
		draw_button()
	end
	
	//print(debug)
	
	if text_box.active then
		draw_textbox()
		//racoon
		if(raccoon.active) then 
			spr( raccoon.sprite, text_box.x+45, 30, 2, 2)
		end
		
	end
	
	
	//fill corners
	
	//top left
	line(0,0,0,1,15)
	line(0,0,1,0,15)
	
	//top right
	line(63,0,62,0,15)
	line(63,0,63,1,15)
	
	//bottom left
	line(0,63,0,62,15)
	line(0,63,1,63,15)
	
	//bottom right
	line(63,63,63,62,15)
	line(63,63,62,63,15)
	
	//map(16+8,0,0,0,8,8)
	//map(16+8,0,0,0,8,8)
end

function start_text()
	if(not text_box.started) then
		text_box.timer = time()
		text_box.active = true
		text_box.current_text = [[hey! I'm Maya and I have a huge problem. I've been playing these games on my arcade, but for some reason I can never win. Would you help me?]]
		text_box.started = true
	elseif(text_box.text == 1) then
		text_box.current_text = [[ "have you tried turning it on and off?"]]
	elseif(text_box.text == 2) then
		text_box.current_text = [[of course dummy, it's the first thing i tried. don't do humansplaining on me, please. okay, ready? let's go!]]
	elseif(text_box.text == 3) then
		next_game()
	end
end

function draw_start()
	
end


-->8
function print_text(text,num)
	local index = num*(text_box.length)+1
	lempty = empty
	total_lines_skipped = current_lines_skipped
	for i=0,2 do 
		if  (text[i*15+index-total_lines_skipped+lempty] == " ") then
			lempty +=1
		end
		local num = i*15+index-total_lines_skipped+lempty
		text_line = sub(text,num, num+14)
		if(i == 2) then
			text_line= sub(text,num,num+13)
			if(text_line[14] != " " and text[num+14] != " " and text[num+14] != nil) then
				for j = 0,14 do 
					if(text_line[14-j] == " ") then
						text_line = sub(text,num,num+13-j)
						total_lines_skipped += j
						break
					end
				end
			end
		end
		local num = i*15+index-total_lines_skipped+lempty
		if i!=2 and text_line[15] != " " and text[num+15] != " " then
		
			if(text_line[14] == " ") then
				text_line = sub(text_line,0,14).." "
			else
				local broken = false
				for j = 0,2 do 
					if(text_line[14-j] == " ") then
						text_line = sub(text,num,num+13-j)
						total_lines_skipped += j
						broken = true
						break
					end
				end
				if not broken then 
					text_line = sub(text_line,0,14).."-"
				end
			end
			
			total_lines_skipped += 1
		end
		print(smallcaps(text_line),text_box.x+2,text_box.y+1+5*i,2)
	end
end

function setup_textbox()
	text_box = {
			x = 0,
			y = 46,
			n = 0,
			length=44,
			current_text = "",
			text = 0,
			ended = false,
			timer = 0,
			active = false,
			started = false
			}
		old_snd = 4
		textarrow_spr = 6
	
end
function update_textbox()
	local length = flr((#text_box.current_text+total_lines_skipped+lempty)/text_box.length)
	update_textarrow()
	if btn(❎) and time()-text_box.timer > 1 and text_box.n <= length then
	 
	 text_box.n+=1
	 empty = lempty
	 current_lines_skipped = total_lines_skipped
	 text_box.timer = time()
	 
	 local snd = 4+flr(rnd(3))
	 while snd == old_snd do
	 	snd = 4+flr(rnd(3))
	 end
	 sfx(snd)
	 old_snd = snd
	end
	if(text_box.n > length) then
		if (not wrong and not musk and not trashcan.dialog) then
			text_box.text +=1
		end	
		text_box.n = 0
		empty = 0
		current_lines_skipped = 0
		wrong = false
		musk = false
		trashcan.dialog = false
		disk.timer = time()
	end
end

function draw_textbox()
	//text box
	rectfill(text_box.x,text_box.y,63,63,6)
	rect(text_box.x,text_box.y,63,63,0)
	//text
	print_text(text_box.current_text,text_box.n)
	if text_box.n < flr((#text_box.current_text+total_lines_skipped+lempty)/text_box.length) then
	 spr(textarrow_spr,text_box.x+58,text_box.y+10,1,1)
	end
end

function update_textarrow()
	if((time()+1) % 2 == 0) then 
				if(textarrow_spr == 7) then
					textarrow_spr = 6
				else 
					textarrow_spr = 7
				end
			end
end

function smallcaps(s)
  local d=""
  local l,c,t=false,false
  for i=1,#s do
    local a=sub(s,i,i)
    if a=="^" then
      if(c) d=d..a
      c=not c
    elseif a=="~" then
      if(t) d=d..a
      t,l=not t,not l
    else 
      if c==l and a>="a" and a<="z" then
        for j=1,26 do
          if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
            a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
            break
          end
        end
      end
      d=d..a
      c,t=false,false
    end
  end
  return d
end

-- draws a filled convex polygon
-- v is an array of vertices
-- {x1, y1, x2, y2} etc
function render_poly(v,col)
 col=col or 5

 -- initialize scan extents
 -- with ludicrous values
 local x1,x2={},{}
 for y=0,127 do
  x1[y],x2[y]=128,-1
 end
 local y1,y2=128,-1

 -- scan convert each pair
 -- of vertices
 for i=1, #v/2 do
  local next=i+1
  if (next>#v/2) next=1

  -- alias verts from array
  local vx1=flr(v[i*2-1])
  local vy1=flr(v[i*2])
  local vx2=flr(v[next*2-1])
  local vy2=flr(v[next*2])

  if vy1>vy2 then
   -- swap verts
   local tempx,tempy=vx1,vy1
   vx1,vy1=vx2,vy2
   vx2,vy2=tempx,tempy
  end 

  -- skip horizontal edges and
  -- offscreen polys
  if vy1~=vy2 and vy1<128 and
   vy2>=0 then

   -- clip edge to screen bounds
   if vy1<0 then
    vx1=(0-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
    vy1=0
   end
   if vy2>127 then
    vx2=(127-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
    vy2=127
   end

   -- iterate horizontal scans
   for y=vy1,vy2 do
    if (y<y1) y1=y
    if (y>y2) y2=y

    -- calculate the x coord for
    -- this y coord using math!
    x=(y-vy1)*(vx2-vx1)/(vy2-vy1)+vx1

    if (x<x1[y]) x1[y]=x
    if (x>x2[y]) x2[y]=x
   end 
  end
 end

 -- render scans
 for y=y1,y2 do
  local sx1=flr(max(0,x1[y]))
  local sx2=flr(min(127,x2[y]))

  local c=col*16+col
  local ofs1=flr((sx1+1)/2)
  local ofs2=flr((sx2+1)/2)
  memset(0x6000+(y*64)+ofs1,c,ofs2-ofs1)
  pset(sx1,y,c)
  pset(sx2,y,c)
 end 
end

function count_digits(number)
	local counter = 0
	while(flr(number/10) > 0)  do
		number = number/10
		counter += 1
	end
	return counter
end
-->8
function update_raccoon()
	if(time() % 2 == 0) then 
			if(raccoon_spr == 2) then
				raccoon_spr = 34
			else 
				raccoon_spr = 2
			end
	end
end
function next_game()
		text_box.text = 0
		text_box.n = 0
		text_box.timer = time()
		empty = 0
		current_lines_skipped = 0
		game +=1
		text_box.started = false
		text_box.active = false
		lost = false
		win = false
		started = false
end

function check_flag()
	win_game = peek(0x5f80)
 if (win_game == 1) then
 	game = -2
		raccoon.active = false
		text_box.active = true
		text_box.current_text = [[   You did it!     you figured       it out!]]
 end
end

function setup_title_screen()
	selected = 0
	select_time = 0
	tailtime = 0
	tailspr = false
end

function update_title_screen()
if time() - select_time > 0.5 then
	
 if btn(❎)then
 	if selected == 0 then
 		next_game()
 		sfx(0)
 	else
 		select_time = time()
 		game = -3
 		sfx(3)
 	end
 end
	if(time() - tailtime > 1) then
		tailspr = not tailspr
		tailtime = time()
	end
 if btn(⬇️) then
 	selected = 1
 	sfx(2)
 elseif btn(⬆️) then
 	selected = 0
 	sfx(1)
 end
end
end

function draw_title_screen()
	rectfill(0,0,63,63,15)
	spr(192,1,1,4,4)
	spr(196,3,36,4,2)
	spr(228,3,48,4,2)
	spr(220,33,3,4,3)
	spr(200,33,31-4,4,4)
	if tailspr then
		spr(206,57,3+8,1,1)
		spr(207,57,3,1,1)
	end
	rect(6,39+12*selected,28,47+12*selected,11)
end
function setup_end()
	end_timerx = time()
	end_timery = time()
	flx = true
	fly = false
	disco_ball = 14
end
function update_end()

end

function draw_end()
 map(8,8,0,0)
	if time() - end_timerx > 0.25 then
		flx = not flx
		end_timerx = time()
	end
	if time() - end_timery > 1 then
		fly = not fly
		end_timery = time()
		disco_ball += 1
		if disco_ball > 15 then
			disco_ball = 14
		end
	end
	print("you win!",32-(8*3+1)/2,14,8)
	rectfill(31,0,32,2,13)
	spr(disco_ball,28,2,1,1)
	spr(8,24,32-8,2,2,flx,fly)
end

function draw_credits()
	rectfill(0,0,63,63,15)
	print("a game by",16,6,8)
	print("ari", 26,20)
	print("@womenvideogames",1,26)
	print("and",26,34)
	print("dario",22,42)
	print("@totohitori",9,48)
	
end
function update_credits()
 if btn(❎) and time() - select_time > 1 then
 	select_time = time()
 	game = -1
 end
end
-->8
function western_text()
	if(not text_box.started) then
		text_box.active = true
		text_box.current_text = [[for this first game "shoot-out your shot" you find yourself in the most realistic looking western retro game you've ever seen. a gun duel that could live up to any tarantino movie scene. your goal is to battle this distinguished gentleman named stanley to death and take out his three lives before he takes yours. good luck, friend.]]
		text_box.started = true
	elseif(text_box.text == 1 and lost) then
		text_box.active = true
		text_box.current_text = [[you were violently pierced by stanley's bullets and lost all your lives. now we will never know if this was the key to win this. lets try something else. ]]
		music(-1, 300)
		
	elseif(text_box.text == 1 and win) then
		text_box.active = true
		text_box.current_text = [[you did it! ..... although this does not seem the way of actually winning this game.let's try something else.]]
		music(-1, 300)
	elseif(text_box.text == 1) then
		text_box.active =false
		if(not started) then
			cowboy.shoot = time()
			//music(0)
		end
		started = true
		
		
	elseif( text_box.text == 2) then
		next_game()
	end
	

end

function setup_western()
	crosshair = {
		x = 28,
		y = 34,
		dx = 0,
		dy = 0
	}
	life = 3
	cowboy ={
		x = 28,
		y = 20,
		hit = false,
		dx = 0.3,
		sprite = {
			torso = 64,
			leg = 80
		},
		anim = 0,
		life = 3,
		shoot = 0,
		bullet_x = 28,
		bullet_y = 20
	}
	shot_timer = 0
	reloading = false
	shot_cooldown = 0.5
	bullet_x = 0
	bullet_y = 0
end
function draw_western()
	rectfill(0,0,63,32,9)
	circfill(32,35,24,10)
	circfill(32,32,16,7)
	rectfill(0,31,63,63,4)
	map(8,0,0,0,8,8)
	
	//draw cowboy
	if(cowboy.hit)then
	 spr(83,cowboy.x,cowboy.y+8,1,1)
	else
		spr(cowboy.sprite.torso,cowboy.x,cowboy.y,1,1)
		spr(cowboy.sprite.leg,cowboy.x,cowboy.y+8,1,1)
		for i=0,cowboy.life-1 do
			spr(99,cowboy.x-3+i*4,cowboy.y-5,1,1)
		end
	end
	local len = (time()-shot_timer)/shot_cooldown*22
	if( cowboy.life > 0 and life > 0 ) then 
		//draw enemy bullet
		local len2 = (time()-cowboy.shoot)/2*22
		if time() - cowboy.shoot < 2 then
			local size = (time()-cowboy.shoot)/2*6
			rectfill(cowboy.bullet_x+4,cowboy.bullet_y+len2+12,cowboy.bullet_x+(size+4)+4,cowboy.bullet_y+(4+size)+len2+12,12)
		end
		
		//draw bullet player
		
		if reloading and time() - shot_timer < 0.2 then
			local size = (time()-shot_timer)/0.2*6
			rectfill(bullet_x+4,bullet_y-len+12,bullet_x-(6-size)+4,bullet_y-(6-size)-len+12,14)
		end
	end
	//draw crosshair
	spr(69,crosshair.x,crosshair.y,1,1)
	
	//draw hearts
	for i=0,life-1 do
			spr(97,1+i*8+38,1,1,1)
	end
	for i=0,2-life do
			spr(98,17-i*8+38,1,1,1)
	end
	//draw hat
	rectfill(16,56,51,60,1)
	rectfill(20,50,44,55,1)
	rectfill(21,59,43,63,15)
	rectfill(21,59,43,61,9)

	//reload bar
	local bar_height = 9
	line(39,bar_height,61,bar_height,7)
	//line(39,bar_height-1,61,bar_height-1,5)
	//line(39,bar_height+1,61,bar_height+1,6)
	
	if(len > 22) then
		len = 22
	end
	local col = 8
	if reloading then
		//col = 10
		//if len < 10 then 
			col = 8
		//end
	else
	 col = 11
	end
	
	line(39,bar_height,39+len,bar_height,col)
	
end

function update_western()
	if(life <= 0 and not lost) then
		lost = true
		sfx(13)
	elseif(cowboy.life <= 0 and not win) then
		win = true
		sfx(14) 
	end
	if btn(⬆️) then
		crosshair.dy = -1
	elseif btn(⬇️) then
		crosshair.dy = 1
	else
		crosshair.dy = 0
	end
	if btn(⬅️) then
		crosshair.dx = -1
	elseif btn(➡️) then
		crosshair.dx = 1
	else
		crosshair.dx = 0
	end	
	
	if time() - shot_timer > shot_cooldown then
		reloading = false
	end
	if btn(❎) and reloading == false and life  > 0 and cowboy.life > 0 then
		check_shot()
		sfx(7)
		shot_timer = time()
		bullet = {crosshair.x,crosshair.y}
		reloading = true
	end
	update_cowboy()
	//apply physics
	if time() - cowboy.shoot > 2 and cowboy.life > 0 then
		cowboy.shoot = time()
		cowboy.shot = {cowboy.x,cowboy.y}
		if(life > 0) then
			life -= 1
			sfx(8)
		end
	end
	crosshair.x += crosshair.dx
	crosshair.y += crosshair.dy
	if crosshair.x > 56 then
		crosshair.x = 56
	elseif crosshair.x < 0 then
		crosshair.x = 0
	end
	if crosshair.y > text_box.y-8 then
		crosshair.y = text_box.y-8
	elseif crosshair.y < 0 then
		crosshair.y = 0
	end
end

function update_cowboy()
 if(cowboy.hit != true) then
 	if(cowboy.x+8 >= 52 or cowboy.x <= 12) then 
 		cowboy.dx *= -1
 	end
 	cowboy.x += cowboy.dx
 end
 if(time() - cowboy.anim > 0.3)then
 	cowboy.anim = time()
 	if(cowboy.sprite.leg == 80) then
 		cowboy.sprite.leg = 96
 	else
 		cowboy.sprite.leg = 80
 	end
 end
 
end
function check_shot()
	//todo:check input release as well
	insidex = crosshair.x+4 > cowboy.x+1 and crosshair.x +4 < cowboy.x+7
	insidey = crosshair.y+4 > cowboy.y and crosshair.y +4 < cowboy.y+16
	if insidex and insidey then
		cowboy.life -= 1
		if(cowboy.life == 0) then
			cowboy.hit = true
		end
		
	end
end
-->8
function shapes_text()
	if(not text_box.started) then
		text_box.active = true
		text_box.current_text = [[The next game is called "Trying to fit in". You will have to select the shape and drag it to the correct spot. There's no way you can do this wrong... or can you?]]
		text_box.started = true
	elseif(wrong) then
		text_box.active = true
		text_box.current_text = [[Oh, come on.]]
	elseif(musk) then
		text_box.active = true
		text_box.current_text = [[Ah, yeah, about that. Don't we love multimillionaires having a mid-life crisis?]]
	elseif(trashcan.dialog) then
		text_box.active = true
		text_box.current_text = [[I will give you a new piece, free of charge, just because I like you.]]
	elseif(text_box.text == 1 and win) then
		text_box.active = true
		text_box.current_text = [[That should be it, right?  ....  ....right? Welp, it seems we did not win, lets try something different]]
	elseif(text_box.text == 1) then
		text_box.active =false
		started = true
		
	elseif( text_box.text == 2) then
		next_game()
	end
	

end
function setup_shapes()
	box = {
		x = -5,
		y = 0
	}
	holes= {
		x = {17,30,17,30},
		y = {28,14,15,28},
		sprites = {74,91,75,90},
		name= {"circle","square",
										"racoon","bird"},
		placed = {false,false,false,false}
	}
	shapes= {
		x = {51,51,51,51},
		y = {3,14,25,35},
		sprites = {72,89,73,88},
		name= {"circle","square",
										"racoon","x"},
		placed = {false,false,false,false}
	}
	hand = {
			x = 28,
			y = 34,
			dx = 0,
			dy = 0,
			closed = false,
			sprite = 86,
			piece = "none"
			}
	trashcan = {
	 x = 0,
	 y = 25,
	 active = false,
	 dialog = false
	 }	
end
function update_shapes()
	if(not trashcan.dialog and not musk)then
		hand.closed = false
		move_hand()
		//trashcan
		if btn(❎) then
			hand.closed = true
			check_grab()
		else
			if hand.piece != "none" then
				check_drop()
				hand.piece = "none"
			end
		end	
	end
	hand.x += hand.dx
	hand.y += hand.dy
	if hand.x > 64-8 then
		hand.x = 64-8
	elseif hand.x < 0 then
		hand.x = 0
	end
	
	if hand.y > text_box.y-8 then
		hand.y = text_box.y-8
	elseif hand.y < 0 then
		hand.y = 0
	end
	check_ended()
end

function draw_shapes()
	map(0,0,0,0)
	//rectfill(0,0,47,23,2)
	local lx = box.x+13
	local rx = box.x+42
	local ty = box.y+10
	local by = box.y+39
	render_poly({lx-5,ty-5,lx,ty,rx,ty,rx-5,ty-5},9)
	render_poly({lx,ty,lx-5,ty-5,lx-5,by-5,lx,by},8)
	line(lx,ty,lx-5,ty-5,8)
	line(lx,by,lx-5,by-5,8)
	line(rx,ty,rx-5,ty-5,8)
	line(lx-5,ty-5,lx-5,by-5,8)
	line(lx-5,ty-5,lx-5,by-5,8)
	line(lx-5,ty-5,rx-5,ty-5,8)
	rectfill(lx,ty,rx,by,9)
	rect(lx,ty,rx,by,8)
	line(46,0,46,63,7)
	rectfill(47,0,63,63,0)
	rectfill(0,47,63,63,0)
	line(0,47,46,47,7)
	
	
	
	if trashcan.active then
		spr(76,trashcan.x,trashcan.y,2,2)
	end
	//draw holes
	for i= 1,4 do
		spr(holes.sprites[i],box.x+holes.x[i],box.y+holes.y[i],1,1)
	end
	
	//draw shapes
	for i= 1,4 do
		if not shapes.placed[i] then
			spr(shapes.sprites[i],shapes.x[i],shapes.y[i],1,1)
		end
	end
	//draw hand
	hand.sprite = 86
	if hand.closed then
		hand.sprite = 87
	end
	spr(hand.sprite,hand.x,hand.y,1,1)
end

function check_grab()
	for i= 1,4 do
		local insidex = hand.x+2 > shapes.x[i] and hand.x +4 < shapes.x[i]+8
		local insidey = hand.y+2 > shapes.y[i] and hand.y +4 < shapes.y[i]+8
		if insidex and insidey 
		and hand.piece == "none" or hand.piece == shapes.name[i] then
			shapes.x[i] = hand.x
			shapes.y[i] = hand.y
			hand.piece = shapes.name[i]
			return
		end
		
	end
end

function check_drop()
	if hand.piece == "x" and trashcan.active then
		local insidex = box.x+5+hand.x+4 > trashcan.x-2 and hand.x +6 < trashcan.x+16
		local insidey = box.y+hand.y+4 > trashcan.y-2 and hand.y +6 < trashcan.y+16
		if(insidex and insidey) then
			shapes.name[4] = "bird"
			shapes.sprites[4] = 104
			trashcan.active = false
			box.x = -5
			trashcan.dialog = true
			sfx(11)
		end
		
	else
	
		for i = 1,4 do
			local insidex = box.x+5+hand.x+4 > holes.x[i]-2 and hand.x +6 < holes.x[i]+9
			local insidey = box.y+hand.y+4 > holes.y[i]-2 and hand.y +6 < holes.y[i]+9
			if insidex and insidey then
				if holes.name[i] == hand.piece then 
					//well done dialog
					shapes.placed[i] = true
					sfx(9)
					break
				elseif holes.name[i] == "square" then
					//bad dialog
					wrong = true
						sfx(9)
					for i = 1,4 do
					 if hand.piece == shapes.name[i] then
					 	shapes.placed[i] = true
					 end
					end	
					break	
				elseif holes.name[i] == "bird" and hand.piece =="x" then
					//x dialog + show trashcan
					musk = true
					show_trashcan()
					break
				end
				end
			end
		end
		reset_pieces()
	
end

function check_ended()
	debug = "entered"
 win = shapes.placed[1] and shapes.placed[2] and shapes.placed[3] and shapes.placed[4]
end
function reset_pieces()
	for i= 1,4 do
		shapes.x[i] = 51
		shapes.y[i] = 3+(i-1)*11
		if i == 4 then
			shapes.y[i] -= 1
		end
	end
end

function show_trashcan()
	trashcan.active = true
	box.x = 2
end

function hide_trashcan()
	trashcan.active = false
	box.x = -5
end
-->8
function coins_text()
	if(not text_box.started) then
		text_box.active = true
		text_box.current_text = [[This (next) game is called Money, Money, Money. In order to keep feeding this hellscape of a machine called capitalism, you will need to collect all the coins to make this greedy bastard (me!) happier. Careful with the spikes, tho, or you will end up like the Penitent.]]
		text_box.started = true
	elseif(text_box.text == 1) then
		text_box.current_text =[[Huh... this coin shape looks oddly familiar]]
	elseif(text_box.text == 2 and lost) then
		text_box.active = true
		text_box.current_text = [[You were SO close to getting all the coins... now we won't know what happens if you do. let's jump to the next game ]]
	elseif(text_box.text == 2 and win) then
		text_box.active = true
		if(check_coins()) then 
			text_box.current_text = [[Yes! Money! Money! Money! ... who cares if we did not win? lets jump to the next thing.]]
		else 
			text_box.current_text = [[NooOoOoOoooO. What did you do???? You left some coins behind!! lets jump to the next thing before i get sad :( )]]
		end
	elseif(text_box.text == 2) then
		text_box.active = false
		started = true
		if(not started) then
			cowboy.shoot = time()
		end
	elseif( text_box.text == 3) then
		next_game()
	end
	

end
//player physics
function setup_coins()
	pl ={
		x = 186,
		y = 0,
		dx = 0,
		dy = 0,
		ddx = 0,
		ddy = 0.6,
		dir = "still",
		grounded = false,
		sprite = 128,
		wall = false,
		anim = 128,
		dead = false,
		win = false
	}
	coins = {
		x = {16,32,48,0,8,42,48},
		y = {0,0,0,24,24,24,32},
		collected = {}
	}
	input = "a"
	dir = "still"
	lastdir = "left"
	timer = time()
	color = 0
end
function update_coins()
	if not pl.dead and not pl.win then
		if btn(0) then
			walk_left()
		elseif btn(1) then
			walk_right() 
		else
			if pl.grounded then pl.anim = 128 end
			if(pl.anim != 128 and pl.grounded) then 
				pl.sprite = pl.anim
			end
			dir = "still"
			pl.dx = 0
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
	end
	apply_gravity()
	check_collision()
	
	pl.x += pl.dx
	if(pl.x < 128) then 
		pl.x = 128
	elseif(pl.x > 185) then 
		pl.x = 185
	end
	pl.y += pl.dy
	if(pl.y < 0) then 
		pl.y = 0
	end
	update_spr()
	check_collect()
	check_win()
	check_spikes()
	//check_end()
end 
function draw_coins()
	set_coins()
	map(16,0,0,0,8,8)
	spr(pl.sprite,pl.x -flr(pl.x/16/8)*128 ,pl.y -flr(pl.y/16/8)*128,1,1,lastdir == "left")
end

function check_coins()
 for i=1,count(coins.collected) do
	if not coins.collected[i] then
		return false
	end
 end
end
function check_collect()
	for i = 1,count(coins.x)-1 do
		if not coins.collected[i] then
			local checkx =  pl.x +2 > coins.x[i]+128 and pl.x + 6 < coins.x[i]+8+128;
			local checky =  pl.y +2 > coins.y[i] and pl.y + 6 < coins.y[i]+16
			if checkx and checky and not coins.collected[i]  then 
				coins.collected[i] = true
				sfx(10)
			end
		end
	end
	if not coins.collected[count(coins.x)] then
		local checkx =  pl.x +2 > coins.x[count(coins.x)]+128 and pl.x + 6 < coins.x[count(coins.x)]+16+128;
		local checky =  pl.y +2 > coins.y[count(coins.y)]and pl.y + 6 < coins.y[count(coins.y)]+8
		if checkx and checky and not coins.collected[count(coins.x)] then 
			//play sound
			coins.collected[count(coins.x)] = true
			sfx(3)
		end
	end
end
function check_spikes()
	local check =  fget(mget((pl.x +3)/8,(pl.y+7)/8),2);
	if check and not lost then
		pl.sprite = 140
		pl.anim = 140
		pl.dead = true
		pl.dx = 0
		lost = true
		sfx(13)
	end
end
function check_win()
	local check =  fget(mget((pl.x +3)/8,(pl.y+7)/8),3);
	if check then
		pl.win = true
		pl.dx = 0
		win = true
	end
end
function set_coins()
	for i = 1,count(coins.x)-1 do
		if not coins.collected[i] then
			spr(146,coins.x[i],coins.y[i],1,1,false,false)
			spr(146,coins.x[i],coins.y[i]+8,1,1,false,true)
		end
	end
	if not coins.collected[count(coins.x)] then
		spr(147,coins.x[count(coins.x)],coins.y[count(coins.x)],1,1,false,false)
		spr(147,coins.x[count(coins.x)]+8,coins.y[count(coins.x)],1,1,true,false)
	end
end
function walk_right()
	lastdir = "right"
	if pl.grounded then pl.anim = 128+3 end
	if(dir != "right") then
		dir = "right"
		pl.dx = 0
	 if pl.grounded then	pl.sprite = 128+3 end
	end
	pl.dx += 0.8
	if(pl.dx >= 2.4) then
		pl.dx = 2.4
	end
end


function walk_left()
	lastdir = "left"
	if pl.grounded then pl.anim = 128+3 end
	if(dir != "left") then
		dir = "left"
		pl.dx = 0
		if pl.grounded then pl.sprite = 128+3 end
	end
	pl.dx -= 0.8
	if(pl.dx <= -2.4) then
		pl.dx = -2.4
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
	pl.anim = 128+7
	pl.anim = 128+7
	if(pl.ddy < -3) then
		pl.ddy = -1
	end
end


function check_collision()
	local collided = false
	newx1 = pl.x + pl.dx +2
	newy1 = pl.y + pl.dy +1
	newx2 = pl.x + pl.dx + 6 
	newy2 = pl.y + pl.dy + 8
	
	local ul = mget(newx1/8, newy1/8)
	local dl = mget(newx1/8, newy2/8)
	local ur = mget(newx2/8, newy1/8)
	local dr = mget(newx2/8, newy2/8)
 
 if(fget(ul, 1)) then
		if(fget(dl, 1)) then
		//left side collision
		pl.x = flr(newx1/8)*8+6
		pl.dx = 0
		collided = true
		end
   if(fget(ur, 1)) then
    //collision with ceiling
    pl.y = flr((newy1)/8)*8 +7
    pl.dy = 0
    collided = true
   else
    //collision with left down corner
    pl.x = flr(newx1/8)*8+6
    pl.dx = 0
    collided = true
   end
 elseif(fget(ur, 1)) then
  if(fget(dr, 1)) then
   //right side collision
   pl.x = flr(newx2/8)*8-6
   pl.dx = 0
   collided = true
  else
   //collision with right down corner
   pl.x = flr(newx2/8)*8-6
   pl.dx = 0
   collided = true
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
    pl.sprite = 128+5
    pl.anim = 128+5
    sfx(01)
   end
   pl.grounded = true
   pl.dy = 0
   collided = true
  else
   //partial left corner step
   pl.y = flr(newy2/8)*8-8 
   if(not pl.grounded) then
    pl.spr = 128+5
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
	if(pl.anim == 128+4 or pl.anim == 128+7) then 
		speed = 0.07
	end
	if(time() - timer > speed) then
				pl.sprite += 1
				timer = time()
				if(pl.sprite >= pl.anim + 3) then
					pl.sprite = pl.anim
				end 
	end
end

-->8
function rana_text()
	if(not text_box.started) then
		text_box.active = true
		text_box.current_text = [[In true Asturian fashion, I present to you: La Rana! This classic game consists in throwing three disks onto the holes in the board. Aim for the frog to get maximum points!]]
		text_box.started = true
	elseif(musk) then
		text_box.active = true
		text_box.current_text =[[Hm... I could eat that frog, but I'm vegetarian, so I should stay away from it.]]
	elseif(text_box.text == 1 and win) then
		text_box.active = true
		text_box.current_text = [[Woowie that was fun! If i was not working i would drink some cyder. Ok I think the next game must be the key to winning]]
	elseif(text_box.text == 1) then
		text_box.active = false
		started = true
	elseif(text_box.text == 2) then
		next_game()
	end
end
function setup_rana()
	board_rana = {
	x = 0,
	y = -9
	}
	bridges = {
		x1 = board_rana.x+12,
		x2 = board_rana.x+44,
		y1 = board_rana.y+32,
		y2 = board_rana.y+32,
		sprite = 161
	}
	
	spinner = {
		x = board_rana.x+28,
		y = board_rana.y+36,
		sprite = 162,
		anim = false,
		timer = 0,
		counter = 0
	}
	
	holes_rana = {
		sprite = 166
	}
	
	rana = {
		 x = board_rana.x+28,
		 y = board_rana.y+26,
		 sprite = 160
		 }
	disk = {
		x = 28,
		y = 48,
		dx = 1,
		dy = 0,
		aimx = 0,
		aimy = 0,
		timer = 0,
		sprite = 191,
		entered = false,
		respawn = 0,
		left = 3
	}
	points ={
		x = 0,
		y = 0,
		sprite = 172,
		value = 0,
		counter = 0
	}
	scoreboard = {
		names = {"pepe","paco","lara","lalo","maya"},
		points = {1000,700,600,200,0}
	}
end

function update_rana()
	if(disk.left > 0 and not text_box.active) then
		if btn(❎) and time() - disk.timer > 1 then
			if disk.aimx == 0 then 
				disk.dx = 0
				disk.aimx = (disk.x-13)/40*31+16
				disk.dy = 1
				disk.timer = time()
			elseif disk.aimy == 0 then
				disk.aimy = (disk.y-48+6)/12*(37-9)+2
				disk.dy = 0
			end
		end
		
		if(disk.aimy != 0 and disk.aimx != 0) then
			disk.dy = 0
			disk.dx = 0
			if(disk.y > disk.aimy) then
				disk.dy = -0.5
			end
			if(disk.x > disk.aimx and disk.aimx > 32) then
				disk.dx = -0.1*0.5
			elseif(disk.x < disk.aimx and disk.aimx < 32) then
				disk.dx = 0.1*0.5
			end
			if(disk.dy == 0 and disk.dx == 0) then
			  check_end()
			end
			
		end
		disk.x += disk.dx
		disk.y += disk.dy
		if (disk.x > 50-4 or disk.x < 11) and disk.aimx == 0 then
			disk.dx *= -1
		elseif (disk.y > 48+4 or disk.y < 44) and disk.aimy == 0 then
			disk.dy *= -1
		end
		
		if(disk.y >= 36) then
			disk.sprite = 191
		else
			disk.sprite = (191-((43-disk.y-12)/(43-9)*4))
		end
		
		if(spinner.anim and time()-spinner.timer > 0.1)then
			spinner.sprite +=1
			spinner.timer = time()
			if(spinner.sprite > 164) then
			 spinner.sprite = 162
			 spinner.counter += 1
			end
			if( spinner.counter > 6) then
				spinner.anim = false	
				spinner.counter = 0	
			end
		end 
	end
end

function draw_rana()
	map(0,8,0,0,8,8)
	spr(171,2,46,1,2)
	spr(171,54,47,1,2)
	spr(171,60,43,1,2)
	if(disk.left > 0) then
		//legs for table
		rectfill(10,40,16,60,4)
		rect(10,40,16,60,2)
		render_poly({16,60,18,56,18,30,16,30},2)
		render_poly({47,60,46,56,46,30,47,30},4)
		rectfill(53,40,47,60,2)
		rect(53,40,47,60,2)
		line(47,60,44,57,2)
		line(44,57,44,37,2)
		
		//table
		local tl1 = board_rana.x+16
		local tl2 = board_rana.y+18
		local tr1 = board_rana.x+47
		local tr2 = board_rana.y+18
		local bl1 = board_rana.x+2
		local bl2 = board_rana.y+46
		local br1 = board_rana.x+63-2
		local br2 = board_rana.y+46
		
		render_poly({bl1,bl2,bl1+2,bl2-9,tl1,tl2-9,tl1,tl2},2)
		render_poly({br1,br2,br1-1,br2-9,tr1,tr2-9,tr1,tr2},4)
		rectfill(tl1,tl2-9,tr1,tr2,4)
		render_poly({tl1,tl2,tl1,tl2-9,tr1,tr2},2)
		//border axis
		line(bl1,bl2,bl1+1,bl2-10,4)
		line(br1,br2,br1-1,br2-10,2)
		line(tl1,tl2,tl1,tl2-10,4)
		line(tr1,tr2,tr1,tr2-10,2)
		//top borders
		line(bl1+1,bl2-10,tl1,tl2-10,4)
		line(br1-1,br2-10,tr1,tr2-10,2)
		
		
		render_poly({bl1+1,bl2-1,tl1+1,tl2+1,tr1,tr2+1,br1-1,br2-1},4)
		render_poly({bl1+1,bl2-1,tl1+1,tl2+1,tr1,tr2+1},2)
		rectfill(br1,br2,bl1,bl2+8,2)
		rect(28,40,35,42,4)
		line(bl1,bl2,tl1,tl2,4)
		line(br1,br2,tr1,tr2,2)
		line(br1,br2,bl1,bl2,2)
		line(tl1,tl2,tr1,tr2,4)
		line(br1,br2,br1,br2+8,2)
		line(bl1,bl2,bl1,bl2+8,2)
		line(br1,br2+8,bl1,bl2+8,2)
		
		local board_rana_x = board_rana.x+20
		local board_rana_y = board_rana.y+20
		//draw holes
		//ovalfill(28,20,34,25,5)
		//oval(28,20,34,25,3)
		spr(holes_rana.sprite,board_rana_x-4,board_rana_y-1,1,1)
		rectfill(board_rana_x,board_rana_y+1,board_rana_x+2,board_rana_y-1+3,0)
		rectfill(board_rana_x-1,board_rana_y+2,board_rana_x+1,board_rana_y+3,0)
		
		spr(holes_rana.sprite+1,board_rana_x+8,board_rana_y-1,1,1)
		rectfill(board_rana_x+10,board_rana_y+1,board_rana_x+13,board_rana_y+3,0)
		line(board_rana_x+9,board_rana_y+2,board_rana_x+14,board_rana_y+2,0)
		spr(170,board_rana_x+18,board_rana_y-1,1,1)
		rectfill(board_rana_x+21,board_rana_y+1,board_rana_x+23,board_rana_y-1+3,0)
		rectfill(board_rana_x+22,board_rana_y+2,board_rana_x+24,board_rana_y+3,0)
		
		//draw rana
		spr(rana.sprite,rana.x,rana.y,1,1)
		
	 	//draw bridges
		local bridges_x1 = bridges.x1
		local bridges_x2 = bridges.x2
		local bridges_y1 = bridges.y1
		local bridges_y2 = bridges.y2
		spr(bridges.sprite,bridges_x1,bridges_y2,1,1)
		rect(bridges_x1+3,bridges_y1+5,bridges_x1+4,bridges_y1+6,0)
		pset(bridges_x1+2,bridges_y1+6,0)
		spr(bridges.sprite+7,bridges_x2,bridges_y2,1,1,true)
		pset(11,bridges_y1+6,3)
		rect(bridges_x2+2,bridges_y2+5,bridges_x2+3,bridges_y2+6,0)
		pset(bridges_x2+4,bridges_y2+6,0)


		local spinner_x = spinner.x
		local spinner_y = spinner.y
		//draw spinner
		spr(spinner.sprite,spinner_x,spinner_y,1,1)
		line(spinner_x,spinner_y+5,spinner_x,spinner_y+7,0)	
		line(spinner_x+7,spinner_y+5,spinner_x+7,spinner_y+7,0)	
		line(spinner_x,spinner_y+7,spinner_x+7,spinner_y+7,0)
		spr(184,48,48,1,1)
		spr(184,9,48,1,1,true)
		line(12,52,52,52,8)
	
		if disk.aimx != 0 then
			spr(183,disk.x,42)
			rectfill(disk.x+3,45,disk.x+4,58,8)
			
		end
		if not disk.entered then
			spr(disk.sprite,disk.x,disk.y,1,1)
		else
			spr(points.sprite,points.x,points.y-(time() - disk.respawn),1,1)
		end
	
		for i = 0, disk.left-1 do
			spr(191,1+9*i,0)
		end
		//rect(disk.x+3,disk.y+3,disk.x+4,disk.y+4,15)
		print(points.counter,59-count_digits(points.counter)*4,2,10)
	else
		rectfill(5,9,58,54,4)
		print_scoreboard()
		
	end
	
end

function check_end()
	local checkx = disk.x+3 > rana.x+1 and disk.x+4 < rana.x+6
	local checky = disk.y+3 > rana.y and disk.y+4 < rana.y+6
	//rana hitbox
	if(checkx and checky) then
		disk.entered = true
		points.x = rana.x
		points.y = rana.y-7
		points.sprite = 175
		points.value = 500
	end

	local checkx = disk.x+3 > spinner.x +1 and disk.x+4 < spinner.x + 7
 local checky = disk.y+3 > spinner.y and disk.y+4 < spinner.y+7 
 //spinner hitbox
 if(checkx and checky) then
		disk.entered = true
		spinner.anim = true
		points.x = spinner.x
		points.y = spinner.y -7
		points.sprite = 174
		points.value = 300
	end
	
	for i = 0,2 do
		local checkx = disk.x+3 > 17 +i*11 and disk.x+4 < 17 +i*11+ 7
	 local checky = disk.y+3 > 10 and disk.y+4 < 16 
	 //holes hitbox
	 if(checkx and checky) then
			disk.entered = true
			points.x = 17+i*11
			points.y = 10 -6
			points.sprite = 172
			points.value = 100
		end
	end
	
	local checkx1 = disk.x+3 > bridges.x1-1 and disk.x+4 < bridges.x1+6
	local checky1 = disk.y+3 > bridges.y1+2 and disk.y+4 < bridges.y1+8
	local checkx2 = disk.x+3 > bridges.x2 and disk.x+4 < bridges.x2+7
	local checky2 = disk.y+3 > bridges.y2+2 and disk.y+4 < bridges.y2+8
	//bridges hitbox
	 if(checkx1 and checky1 ) then
			disk.entered = true
			points.x = bridges.x1
			points.y = bridges.y1-5
			points.sprite = 173
			points.value = 200
		elseif(checkx2 and checky2) then
			disk.entered = true
			points.x = bridges.x2
			points.y = bridges.y2-5
			points.sprite = 173
			points.value = 200
		end
		
	reset_disk()
end
function reset_disk()
	if(disk.respawn == 0) then
		disk.respawn = time()
	elseif time() - disk.respawn > 2 then
		
		if(disk.left > 0) then
			points.counter += points.value
			disk.left -= 1
			points.value = 0
			disk.respawn = 0
			disk.x = 28
			disk.y = 48
			disk.dx = 1
			disk.dy = 0
			disk.aimx = 0
			disk.aimy = 0
			disk.timer = 0
			disk.sprite = 191
			disk.entered = false
			if(disk.left == 2) then
				musk = true
			end
		else
			
		end
		
	end
	
end

function print_scoreboard()
	local pos = 1
	local done = false
	for i =1,count(scoreboard.points)-1 do
		if(points.counter > scoreboard.points[i] and not done) then
			print(pos..".maya -"..points.counter,8,6+8*i,10)
			done = true
			pos += 1
		end
		print(pos.."."..scoreboard.names[i].." -"..scoreboard.points[i],8,6+8*pos,1)
		pos += 1
	end
	if(btn(❎)) then
	 win = true
	end
end

-->8
function button_text()
	if(not text_box.started) then
		text_box.active = true
		text_box.current_text = [[This final minigame is the simplest of them all. You only need to find the red button in this sea of multicolored pressable devices. Find it, click on it, and you're done. Good luck, and remember that in these scenarios it's vital to think outside the box.]]
		text_box.started = true
	elseif(musk) then
		text_box.active = true
		text_box.current_text =[[Nope, that was definitively not the button we were looking for. Remember to think "outside the box".]]
	elseif(text_box.text == 1) then
		text_box.active = false
		started = true
	end
end
function setup_button()
	buttons = {
		x = {},
		y = {}
		}
	for i = 1, 8 do
	 for j = 1,8 do
	 	buttons.x[i*8+j] = rnd(7)
	 	buttons.y[i*8+j] = rnd(7)
	 end
	end
end
function move_hand()
	if btn(⬆️) then
		hand.dy = -1
	elseif btn(⬇️) then
		hand.dy = 1
	else
		hand.dy = 0
	end
	if btn(⬅️) then
		hand.dx = -1
	elseif btn(➡️) then
		hand.dx = 1
	else
		hand.dx = 0
	end	
end
function update_button() 
	hand.closed = false
	move_hand()
	if btn(❎) and time() - disk.timer >1 then
		hand.closed = true
		check_point()
	end
	
	hand.x += hand.dx
	hand.y += hand.dy
	if hand.x > 64-7 then
		hand.x = 64-7
	elseif hand.x < 0 then
		hand.x = 0
	end
	
	if hand.y > 64-8 then
		hand.y = 64-8
	elseif hand.y < 0 then
		hand.y = 0
	end
end
function draw_button()
	map(32,0,0,0)
		for i = 1, 8 do
	 for j = 1,8 do
	 	spr(41+buttons.x[i*8+j],(i-1)*8+buttons.x[i*8+j]-3,(j-1)*8+buttons.y[i*8+j]-4,1,1,false,(buttons.y[i*8+j])%2==0)
	 end
	end
	//draw hand
	
	hand.sprite = 86
	if hand.closed then
		hand.sprite = 87
	end
	spr(hand.sprite,hand.x,hand.y,1,1)
	
	rectfill(45,0,63,19,0)
	rect(45,0,63,19,15)
	rectfill(47,13,61,16,13)
	rectfill(47,13,61,16,13)
	rectfill(50,9,58,12,8)
end

function check_point()
 musk = true
end

__gfx__
00000000bbbbbbbb00000000000110000000000000011000000000000000000001110000001111007cc008876666666616111111010000000011160000111600
00000000bbbbbbbb01110000001111000111000000111100000000000000000001f155555551f100cc00887766666666111111610000001001dbce6001ce9b60
00700700bbbbbbbb01f155555551f10001f155555551f10000000000000000000115555555551100e77bbaae66666666616166661010111117e7acd617acdfc6
00077000bbbbbbbb011555555555110001155555555511000222000000000000005511551155500077bbaaee6666666666666166111110111cdad9b61ad9be76
00077000bbbbbbbb00551155115550000055115511555000002000000222000000511111111550008aa00998666a66a66616666111011110179dcd761dcd7a96
00700700bbbbbbbb0051111111155000005111111115500000000000002000000051711117155000aa0099886a66666616166616010111011b9aba911aba9b91
00000000bbbbbbbb005171111715500000517111171550000000000000000000001111dd111150009bbcc779aaaaaaaa666166661110111101aece1001cefc10
00000000bbbbbbbb001111dd11115000001111dd1111500000000000000000000011dd11dd110000bbcc77997777777766666666111111110011110000111100
00000000000000000011dd11dd1100000011dd11dd11000000000000000000000005558855500110000000000000000000000000000000000000000000000000
00000000000000000005555555500000000555885550000000000000000000000000555555555110000000000000000000000000000000000000000000000000
00000000000000000000555555550000000055555555000000000000000000000000555dd5555510000000000000000000000000000000000000000000000000
0000000000000000000055555555501100005555555550110000000000000000005555dddd550000000000000000000000000000000000000000000000000000
0000000000000000000555ddd55550d1000555ddd55550d10000000000000000011555dddd550d11000000000000000000000000000000000000000000000000
000000000000000000055ddddd555ddd00055ddddd555ddd00000000000000000110111ddd551dd1000000000000000000000000000000000000000000000000
0000000000000000005511dddd1151dd005511dddd1151dd00000000000000000000111dd111d110000000000000000000000000000000000000000000000000
00000000000000000051111dd1115d110051111dd1115d1100000000000000000000000001110000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000111000000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000001f1555555511110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000011555555555f11000000000000000000000000000000000008888000099990000eeee0000bbbb00003333000022220000cccc0000111100
0000000000000000015511151115510000000000000000000000000000000000008888000099990000eeee0000bbbb00003333000022220000cccc0000111100
0000000000000000005111111111500000000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000001111111111100000000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000001111dd111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
00000000000000000001dd11dd1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
000000000000000000005555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
000000000000000000005555555550110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
00000000000000000005555d555550d10000000000000000000000000000000000eeee00004444000000000000000000000000000000000000000000ffffffff
0000000000000000000555ddd5555ddd0000000000000000000000000000000000eeee00004444000000000000000000000000000000000000000000ffffffff
000000000000000000555ddddd5551dd00000000000000000000000000000000dddddddddddddddd0000000000000000000000000000000000000000ffffffff
0000000000000000005511dddd115d1100000000000000000000000000000000dddddddddddddddd0000000000000000000000000000000000000000ffffffff
00111000000000000000000000000000000000000008800000000000000000000033330011100111003333001110011100000000000000000000000000000000
001111000000000000000000000000000000000000000000000000000000000003bbbb3015555551034444301441144100000555000000000000000000000000
011111100033000000000ee000000000000000000000000000000000000000003bbbbbb311111111344444431444444100005677500000000000000000000000
0039930000353030000e000eee0000eeee0000008008800800000000000000003bbbbbb301711710344444430144441000555555555000000000000000000000
00ffff00003330300eeeeeeeeeeeeeeeeeeee0008008800800000000000000003bbbbbb301155110344444430144441005677777766500000000000000000000
000ff0000033333000eeeeeeeeeeeeeeeeeeee000000000000000000000000003bbbbbb301522510344444430144441005ddddddddd500000000000000000000
001221000053330000000eee0eeeeeee0000000000000000000000000000000003bbbb3000555500034444300011110005555555555500000000000000000000
001221dd003350000000eeeeeee00000ee000000000880000000000000000000003333000000000000333300000000000057d7d6d65000000000000000000000
001221dd000000000000000000000000000000000000000000e7000000000000770000072222222200000000222222220057d7d6d65000000000000000000000
001221f0000000000000000000000000000000000000000000e70000000000007070007028888882c000ccc0244444420057d7d6d65000000000000000000000
001121d0000000000000000000000000000000000000000000e7e70000e7e7000707070028888882ccc0c44c244444420057d7d6d65000000000000000000000
00112100000300000000000000000000000000000000000000e7e7e000e7e7e00070700028888882c4cc44c0244444420057d7d6d65000000000000000000000
005555000003030000003000001111000000000000000000707777e007e777e000070700288888820c4444c0244444420057d7d6d65000000000000000000000
005555000003300000033000013f11fd0000000000000000e777777007777770007070702888888200c444c02444444200575756565000000000000000000000
0080050000030000003300000885588d00000000000000000e7777700e77777007000707288888820c44cc002444444200567776665000000000000000000000
00000800000000000003000008855880000000000000000000e7770000e777007000007722222222cccc00002222222200055555550000000000000000000000
001221dd00000000000000000000000000000000000000000000000000000000c000ccc055555555000000000000000000000000000000000000000000000000
001221f002202200055055000808000000000000000000000000000000000000ccc0cccc44544444000000000000000000000000000000000000000000000000
001121d028828720500500500888000000000000000000000000000000000000ccccccc044454444000000000000000000000000000000000000000000000000
00112100288888205000005000800000000000000000000000000000000000000cccccc044445444000000000000000000000000000000000000000000000000
005555000288820005000500000000000000000000000000000000000000000000ccccc055555555000000000000000000000000000000000000000000000000
00555500002820000050500000000000000000000000000000000000000000000ccccc0054444444000000000000000000000000000000000000000000000000
0050080000020000000500000000000000000000000000000000000000000000cccc000045444444000000000000000000000000000000000000000000000000
00800000000000000000000000000000000000000000000000000000000000000000000044544444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000002200000000000000000000000000000000000000
00222220002222200022222000222220022222202222220022000000000000000000000000222220202222202222222000000000000000000000000000000000
02222220022222200222222002222220222222202222222022222220222222200222222022222220222222202222222000222200000000000000000000000000
022fcf90222fcf90222fcf902222cf902222cf902222cf9022222f2022222f2022222f202222cf902222cf902222cf9022222200000000000000000000000000
222ffff0222ffff0222ffff0222ffff0222ffff0222ffff0222fcf90222fcf90222fcf90222ffff0222ffff0022ffff022222220000000000000000000000000
222131002221310022213100222133102221310002013110022ffff0222ffff0222ffff02221310002113100001131102211ff22000000000000000000000000
2211310022113100022131000011330000113100001131000011310000113100221131000011314004113140041131002111ff22000000000000000000000000
0040040000400400004004000040004000040400004000400411314004113140041131400040000000000000000000404333fc22000000000000000000000000
11111111000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555000000000099990000999999048800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5515555500000000099aa990099aaaaa048888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
151551160000000009a99a9009a99999048888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161666660000000009a99a9009a99999040088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666660860028009a99a90099aaaaa040008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666650682668609a99a9000999999040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
566666666776677609a99a9000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbb000000000000bbbb00003333000033330000bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000
01b11b1000333300033333300bbbbbb0033333300111111000033330033333300003333000033330000333300004000000000000000000000000000000000000
0b1111b0033bb33003333330033333300bbbbbb003333330003322233322223300bbbb330033bb33003222bb003430000a0aa0aaee0ee0eecc0cc0cc88088088
0b1881b03311bb300bbbbbb003333330033333300bbbbbb000325553325555230bb11bb303311bb30035554b003b3000aa0aa0aa0e0ee0ee0c0cc0cc80088088
0bbbbbb031110b30711111177bbbbbb7733333377111111700355533335555330b1110b3031110b3003b555b003b30000a0aa0aaee0ee0eecc0cc0cc88088088
3bbbbbb331155b3353333335511111155bbbbbb55333333500033330033333303b1155b3031155b3000bbbb0003b30000a0aa0aae00ee0ee0c0cc0cc08088088
3bb33bb331555bbb533333355111111551111115533333350000000000000000bb1555bb331555bb0000000003bb33000a0aa0aaee0ee0eecc0cc0cc88088088
0bb00bb00000000055555555555555555555555555555555000000000000000000000000000000000000000003bb330000000000000000000000000000000000
000000006d66666655566666000000000000000066666566111522110000000000000000000000000000000003bb330000000000000000000000000000000000
00000000667666665555633500000000000000006666666666766666000000000000000000000000000000000399430000000000000000000000000001111110
0000000066666666dd55335500000000000000006666766666666666000880000000000000000000000000000955540000000000001111000011110015511551
00000000666616666655356d00000000000000006666666666666666008888000000880000000000000000000999840000111100015115100155551015155151
000000007666666665d55d6600000000000000006666677676666666088888800000888800000000000000000989440000111100015555100151151015511551
0000000066666dd66555d666000000000000000066d6666666666dd6000880000000880000000000000000000394430000000000001111000155551015555551
000000006656666655dd6666000000000000000066666616665666660008800000000000000000000000000003b3330000000000000000000011110001111110
00000000556666665dd6666600000000000000006666666655666666000880000000000000000000000000000333330000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000002777777777777777777772885000000000000000001112222000000000
20200000000000000000000000000000000000000000000000000000000000000000002777777777777777777772885000000000000000001119925000000000
2022000000000000002000000022222200008888888888888888888888200000000000277777777777777777777288500000000000000000d199285000000000
2002000000000000002000000000900000099999999999999999999999200000000000277777777777777777777288500000000000000000dd92885000000000
20020000000000000020000000009000000911111111111111111111192000000000002777777777777777777772885000000000000000009928885001110000
22220000000020022220222000009000000912221222122212221222192000000000002777777777777888777772885000000000000000009288885011110000
200222222002200220202020000090000009121111211212121211211920000000000027777777777778887777728850000000000000000028888850dd100000
900990909999009900909090000090000009122211211222122211211920000000000027777777777778887777728850000000000000000028888850ddd00000
90099090099900990990999009999900000911121121121212211121192000000000002777777777777727777772885000000000000000000000000000000000
90099990090900099900000000000000000912221121121212121121192000000000002222222222222222222222885000000000000000000000000000000000
0000000000000000000000000000000000091111111111111111111119200000000002eeeeeeeeeeeeee2eeeeee2885000000000000000000000000000000000
0800000000000000000800000001100000099999999999999999999999000000000022eee88eeccceeee2eeeee22885000000000000000000000000000000000
80000000000000000000800000dddd000000000000000000000000000000000000022eee88eeccceeebe2eeeee22885000111000000011110000000000000000
80088000000088000000800001000000000000000000000000000000000000000022eeeeeeeeeeeeeeeeeeeee2288850001e1555555511e10000000000000000
808008080808008080008100110101000000000000000000000000000000000000222222222222222222222e2288885000115555555551110000000000000000
80888808080888808880811110010111000000000000000000000000000000000229999999999999999999222888885000055115511555155555000000000000
8080000888080000808080ddd00d0d0d0000000000000000000000000000000002991119999999999991119928888850000511111111555555555111d2222220
8008880080008880808080d0d00d0d0d0000000000000000000000000000000002911119999999999999111928888850005517111171555555555511dd189250
8000000000000000000080000000000000008888888888888888888888200000029111911119999111191119288888500051111dd11115555555555dd1112850
08000000000000000008000000000000000999999999999999999999992000000299199111111111111991192888885000511dd11dd115555555555511dd2850
000000000000000000000000000002200009111111111111111111111920000002999912222111111111999928888850000555555555555555555555dddd2850
00000000000000220000000000002022000912221222122212221222192000000299922444422111771119992888885000295555d55555555555555521112850
0200200000000220000000000000000200091211121212111212121119200000029924444444421177111999288888500222555ddd55522222222dd521128850
0200200000000200000000000000000200091211122212211212122219200000029922244442221111111199288888500299dd5888dd58999999111822288850
020020022000020200000000002220090009121112211211121211121920000002992442222442991111119928888850029111d89111d8999999911828828850
22202022220002002022002020222099000912221212122212221222192000000299922444422819991111992888885002991189991189999999988928228850
09009000002209009909099999900090000911111111111111111111192000000299924222242819999119992888850002999999999999999999999922228850
09009990909009999999990909999000000999999999999999999999990000000299224824842899999999992888500002999999999999999999999922728850
09009090909900000000000000000099000000000000000000000000000000000299248824894889999999992885000002222222222222222222222227728850
09009090900900000000000000000099000000000000000000000000000000000299248924894289999999992850000000000027777777777777777777728850
00000000009900000000000000000000000000000000000000000000000000000222242224224222222222222500000000000027777777777777777777728850
00000000000000000000000000000000000000000000000000000000000000000000240024004200000000000000000000000027777777777777777777728850
__label__
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ff22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ff22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ff2222ffffffffffffffffffffffffffff22ffffffffffffff222222222222ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ff2222ffffffffffffffffffffffffffff22ffffffffffffff222222222222ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ffff22ffffffffffffffffffffffffffff22ffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ffff22ffffffffffffffffffffffffffff22ffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ffff22ffffffffffffffffffffffffffff22ffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ffff22ffffffffffffffffffffffffffff22ffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22222222ffffffffffffffff22ffff22222222ff222222ffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22222222ffffffffffffffff22ffff22222222ff222222ffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff22ffff222222222222ffff2222ffff2222ff22ff22ff22ffffffffff99ffffffffff111111ffffffffffffff11111111ffffffffffffffffffffffffffffff
ff22ffff222222222222ffff2222ffff2222ff22ff22ff22ffffffffff99ffffffffff111111ffffffffffffff11111111ffffffffffffffffffffffffffffff
ff99ffff9999ff99ff99999999ffff9999ffff99ff99ff99ffffffffff99ffffffffff11ee11555555555555551111ee11ffffffffffffffffffffffffffffff
ff99ffff9999ff99ff99999999ffff9999ffff99ff99ff99ffffffffff99ffffffffff11ee11555555555555551111ee11ffffffffffffffffffffffffffffff
ff99ffff9999ff99ffff999999ffff9999ff9999ff999999ffff9999999999ffffffff1111555555555555555555111111ffffffffffffffffffffffffffffff
ff99ffff9999ff99ffff999999ffff9999ff9999ff999999ffff9999999999ffffffff1111555555555555555555111111ffffffffffffffffffffffffffffff
ff99ffff99999999ffff99ff99ffffff999999ffffffffffffffffffffffffffffffffff5555111155551111555555115555555555ffffffffffffffffffffff
ff99ffff99999999ffff99ff99ffffff999999ffffffffffffffffffffffffffffffffff5555111155551111555555115555555555ffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff551111111111111111555555555555555555111111dd222222222222
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff551111111111111111555555555555555555111111dd222222222222
ffff88ffffffffffffffffffffffffffffffffff88ffffffffffffff1111ffffffffff55551177111111117711555555555555555555551111dddd1188992255
ffff88ffffffffffffffffffffffffffffffffff88ffffffffffffff1111ffffffffff55551177111111117711555555555555555555551111dddd1188992255
ff88ffffffffffffffffffffffffffffffffffffff88ffffffffffddddddddffffffff5511111111dddd1111111155555555555555555555dddd111111228855
ff88ffffffffffffffffffffffffffffffffffffff88ffffffffffddddddddffffffff5511111111dddd1111111155555555555555555555dddd111111228855
ff88ffff8888ffffffffffffff8888ffffffffffff88ffffffff11ffffffffffffffff551111dddd1111dddd111155555555555555555555551111dddd228855
ff88ffff8888ffffffffffffff8888ffffffffffff88ffffffff11ffffffffffffffff551111dddd1111dddd111155555555555555555555551111dddd228855
ff88ff88ffff88ff88ff88ff88ffff88ff88ffffff8811ffff1111ff11ff11ffffffffff555555555555555555555555555555555555555555dddddddd228855
ff88ff88ffff88ff88ff88ff88ffff88ff88ffffff8811ffff1111ff11ff11ffffffffff555555555555555555555555555555555555555555dddddddd228855
ff88ff88888888ff88ff88ff88888888ff888888ff8811111111ffff11ff111111ffff229955555555dd55555555555555555555555555555522111111228855
ff88ff88888888ff88ff88ff88888888ff888888ff8811111111ffff11ff111111ffff229955555555dd55555555555555555555555555555522111111228855
ff88ff88ffffffff888888ff88ffffffff88ff88ff88ffddddddffffddffddffddff222222555555dddddd5555552222222222222222dddd5522111122888855
ff88ff88ffffffff888888ff88ffffffff88ff88ff88ffddddddffffddffddffddff222222555555dddddd5555552222222222222222dddd5522111122888855
ff88ffff888888ffff88ffffff888888ff88ff88ff88ffddffddffffddffddffddff229999dddd55888888dddd55889999999999991111118822222288888855
ff88ffff888888ffff88ffffff888888ff88ff88ff88ffddffddffffddffddffddff229999dddd55888888dddd55889999999999991111118822222288888855
ff88ffffffffffffffffffffffffffffffffffffff88ffffffffffffffffffffffff2299111111dd8899111111dd889999999999999911118822888822888855
ff88ffffffffffffffffffffffffffffffffffffff88ffffffffffffffffffffffff2299111111dd8899111111dd889999999999999911118822888822888855
ffff88ffffffffffffffffffffffffffffffffff88ffffffffffffffffffffffffff229999111188999999111188999999999999999988889922882222888855
ffff88ffffffffffffffffffffffffffffffffff88ffffffffffffffffffffffffff229999111188999999111188999999999999999988889922882222888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2222ffff229999999999999999999999999999999999999999999922222222888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2222ffff229999999999999999999999999999999999999999999922222222888855
ffffffffffffffffffffffffffffff2222ffffffffffffffffffffffff22ff2222ff229999999999999999999999999999999999999999999922227722888855
ffffffffffffffffffffffffffffff2222ffffffffffffffffffffffff22ff2222ff229999999999999999999999999999999999999999999922227722888855
ffff22ffff22ffffffffffffffff2222ffffffffffffffffffffffffffffffff22ff222222222222222222222222222222222222222222222222777722888855
ffff22ffff22ffffffffffffffff2222ffffffffffffffffffffffffffffffff22ff222222222222222222222222222222222222222222222222777722888855
ffff22ffff22ffffffffffffffff22ffffffffffffffffffffffffffffffffff22ffffffffffff22777777777777777777777777777777777777777722888855
ffff22ffff22ffffffffffffffff22ffffffffffffffffffffffffffffffffff22ffffffffffff22777777777777777777777777777777777777777722888855
ffff22ffff22ffff2222ffffffff22ff22ffffffffffffffffffff222222ffff99ffffffffffff22777777777777777777777777777777777777777722888855
ffff22ffff22ffff2222ffffffff22ff22ffffffffffffffffffff222222ffff99ffffffffffff22777777777777777777777777777777777777777722888855
ff222222ff22ff22222222ffffff22ffff22ff2222ffff22ff22ff222222ff9999ffffffffffff22777777777777777777777777777777777777777722888855
ff222222ff22ff22222222ffffff22ffff22ff2222ffff22ff22ff222222ff9999ffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff99ffffffffff2222ff99ffff9999ff99ff999999999999ffffff99ffffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff99ffffffffff2222ff99ffff9999ff99ff999999999999ffffff99ffffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff999999ff99ff99ffff999999999999999999ff99ff99999999ffffffffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff999999ff99ff99ffff999999999999999999ff99ff99999999ffffffffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff99ff99ff99ff9999ffffffffffffffffffffffffffffffffffff9999ffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff99ff99ff99ff9999ffffffffffffffffffffffffffffffffffff9999ffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff99ff99ff99ffff99ffffffffffffffffffffffffffffffffffff9999ffffffffffff22777777777777777777777777777777777777777722888855
ffff99ffff99ff99ff99ffff99ffffffffffffffffffffffffffffffffffff9999ffffffffffff22777777777777777777777777777777777777777722888855
ffffffffffffffffffffff9999ffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777777777777777777722888855
ffffffffffffffffffffff9999ffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777777777777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777888888777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777888888777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777888888777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777888888777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777888888777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777888888777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777772277777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22777777777777777777777777772277777777777722888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22222222222222222222222222222222222222222222888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22222222222222222222222222222222222222222222888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22eeeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeee22888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff22eeeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeee22888855
ffffffffffffff8888888888888888888888888888888888888888888822ffffffffffffff2222eeeeee8888eeeecccccceeeeeeee22eeeeeeeeee2222888855
ffffffffffffff8888888888888888888888888888888888888888888822ffffffffffffff2222eeeeee8888eeeecccccceeeeeeee22eeeeeeeeee2222888855
ffffffffffffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb22ffffffffffff2222eeeeee8888eeeecccccceeeeeebbee22eeeeeeeeee2222888855
ffffffffffffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb22ffffffffffff2222eeeeee8888eeeecccccceeeeeebbee22eeeeeeeeee2222888855
ffffffffffffbb111111111111111111111111111111111111111111bb22ffffffffff2222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee222288888855
ffffffffffffbb111111111111111111111111111111111111111111bb22ffffffffff2222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee222288888855
ffffffffffffbb112222221122222211222222112222221122222211bb22ffffffffff222222222222222222222222222222222222222222ee22228888888855
ffffffffffffbb112222221122222211222222112222221122222211bb22ffffffffff222222222222222222222222222222222222222222ee22228888888855
ffffffffffffbb112211111111221111221122112211221111221111bb22ffffffff222299999999999999999999999999999999999999222222888888888855
ffffffffffffbb112211111111221111221122112211221111221111bb22ffffffff222299999999999999999999999999999999999999222222888888888855
ffffffffffffbb112222221111221111222222112222221111221111bb22ffffffff229999111111999999999999999999999999111111999922888888888855
ffffffffffffbb112222221111221111222222112222221111221111bb22ffffffff229999111111999999999999999999999999111111999922888888888855
ffffffffffffbb111111221111221111221122112222111111221111bb22ffffffff229911111111999999999999999999999999991111119922888888888855
ffffffffffffbb111111221111221111221122112222111111221111bb22ffffffff229911111111999999999999999999999999991111119922888888888855
ffffffffffffbb112222221111221111221122112211221111221111bb22ffffffff229911111199111111119999999911111111991111119922888888888855
ffffffffffffbb112222221111221111221122112211221111221111bb22ffffffff229911111199111111119999999911111111991111119922888888888855
ffffffffffffbb111111111111111111111111111111111111111111bb22ffffffff229999119999111111111111111111111111999911119922888888888855
ffffffffffffbb111111111111111111111111111111111111111111bb22ffffffff229999119999111111111111111111111111999911119922888888888855
ffffffffffffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbffffffffff229999999911222222221111111111111111119999999922888888888855
ffffffffffffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbffffffffff229999999911222222221111111111111111119999999922888888888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff229999992222444444442222111111777711111199999922888888888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff229999992222444444442222111111777711111199999922888888888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff229999224444444444444444221111777711111199999922888888888855
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff229999224444444444444444221111777711111199999922888888888855
ffffffffffffff8888888888888888888888888888888888888888888822ffffffff229999222222444444442222221111111111111111999922888888888855
ffffffffffffff8888888888888888888888888888888888888888888822ffffffff229999222222444444442222221111111111111111999922888888888855
ffffffffffff999999999999999999999999999999999999999999999922ffffffff229999224444222222224444229999111111111111999922888888888855
ffffffffffff999999999999999999999999999999999999999999999922ffffffff229999224444222222224444229999111111111111999922888888888855
ffffffffffff991111111111111111111111111111111111111111119922ffffffff229999992222444444442222881199999911111111999922888888888855
ffffffffffff991111111111111111111111111111111111111111119922ffffffff229999992222444444442222881199999911111111999922888888888855
ffffffffffff991122222211222222112222221122222211222222119922ffffffff2299999922442222222244228811999999991111999999228888888855ff
ffffffffffff991122222211222222112222221122222211222222119922ffffffff2299999922442222222244228811999999991111999999228888888855ff
ffffffffffff991122111111221122112211111122112211221111119922ffffffff22999922224488224488442288999999999999999999992288888855ffff
ffffffffffff991122111111221122112211111122112211221111119922ffffffff22999922224488224488442288999999999999999999992288888855ffff
ffffffffffff991122111111222222112222111122112211222222119922ffffffff229999224488882244889944888899999999999999999922888855ffffff
ffffffffffff991122111111222222112222111122112211222222119922ffffffff229999224488882244889944888899999999999999999922888855ffffff
ffffffffffff991122111111222211112211111122112211111122119922ffffffff2299992244889922448899442288999999999999999999228855ffffffff
ffffffffffff991122111111222211112211111122112211111122119922ffffffff2299992244889922448899442288999999999999999999228855ffffffff
ffffffffffff991122222211221122112222221122222211222222119922ffffffff22222222442222224422224422222222222222222222222255ffffffffff
ffffffffffff991122222211221122112222221122222211222222119922ffffffff22222222442222224422224422222222222222222222222255ffffffffff
ffffffffffff991111111111111111111111111111111111111111119922ffffffffffffff2244ffff2244ffff4422ffffffffffffffffffffffffffffffffff
ffffffffffff991111111111111111111111111111111111111111119922ffffffffffffff2244ffff2244ffff4422ffffffffffffffffffffffffffffffffff
ffffffffffff9999999999999999999999999999999999999999999999ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffff9999999999999999999999999999999999999999999999ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000100000000000000000000020000020000000000000000000000000200000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001040000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
b1b1b1b1b1b1b1b100000042440000000000000000000000c0c1c2c3cccdcecf3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b1b1b1b1b1b1b1b100000000004243440000000000000000d0d1d2d3dcdddedf3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b1b1b1b1b1b1b1b142440000000000000000909090909090e0e1e2e3ecedeeef3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
696969696969696900510000005100520000000000000000f0f1f2f3fcfdfeff3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
696969696969696900410000000000410091000091000000c4c5c6c7c8c9cacb3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
696969696969696900000041000000009090909090000090d4d5d6d7d8d9dadb3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
696969696969696900000000000041000094000000009100e4e5e6e7e8e9eaeb3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
696969696969696941000000000000419090909090909090f4f5f6f7f8f9fafb3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2b2b2b2b2b2b2b2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2b2b2b2b2b2b2b20d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2b2b2b2b2b2b2b20c0c0c0c0c0c0c0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2b2b2b2b2b2b2b20b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b60a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b1b1b5b5b5b1b1b10a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b1b1b5b1b5b1b5b10a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b1b1b5b1b5b1b1b10a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000025720247202472024720247302572025720257202572026720267202772027720287202872029720297202a7202c7202b7202c7202c7202d7202e7202e7202e7202f7302f73030730307303173031730
00010000171101711017110171101711016110171101711008000090000a0000b0000b0000d0000e0000f0000f0001000027700277002770027700277001b7001b7001b7001b7001b7001c7001c7001c7001c700
000100001111011110101101011010110101101011010110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002775027750277502775027750005502775027750277502775027750277502775027750277502775027750277502775027750277502775027750277502775027750277502775027750277502775027750
000200002e310273102731026310261102611022110211101c010241101d3101c3101b2101c0101c0101d010241101c51016010190102011025110211101b1101b0101d0101b010180101f210222102421024210
000200001d1101e1101f11023110251102711022110211101c010241101d3101c3101b2101c0101c0101d010241101c510160102111024110251102711027110271102511021210202101f1101e1101b1101c110
00020000282102a2102b2102601025010233102b210284102b110293102c2102b2102b2102c21018010263102c2102c210283102b4102d410250102d1102e110270102f1102f4102b11029210282102721026210
000100000534005340053400534005340053400534005340053400534005340136401264012630126301263012630126301263012630126201262012610044100541004410044100441003410034500345003450
0001000006440094400b4400e4400f4401044011440114401044006440104400f4400e440054400d4400b4400a440044400844007440064400544004440044400544003440034400344003440024400244001440
0003000011050140501605017050190501c0501d0501f04020040210302203023020230202301022010210101f0101e0101c0101a010190101801016010150101401014010130101201012010110100f0100d010
000100003175031750317503175031750317503175031750317503175031750240502405024050240502405024050240502405024050240502405024050240502405024050240502405024050240502405025050
000100001b2401d2401b3401b3401b3401c3401c3401f2401d3401933017330163301533015320191201d4201d4101d4101c4101b4101b410000101861017610102100f6100f6100f6100e6100e6100d61012210
00120020170301c0301d7301d5301d7301c0301c0301a7301a5301a7301d5301d7301d5301c7301c7301d0301a5301a5301d0301c7301d7301a03018530187301d5301d5301c0301c0301a7301a730180301a030
0012000018530195301853017530165301653015530145301353013530135301353013530135301353013530145001550015500165001750017500185001850019500195001a5001b5001b5001a5001a50019500
000200000f550115501355014550165501755018550195501a5501b5501b5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c5501c550
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013002413045165451b0451d54513035165351b0351d53513025165251b0251d5251301501000010001b0452254527045295451f0352253527035295351f0252252527025295251f015205101b0101c5001c500
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000e75010750137501575016750167501475012750107500e7500d7500c7500b750000000b7500a7500a7500a7500a7500b7500b7500c7500c7500c7500c7500c7500c7500c7500d7500d7500d7500d750
__music__
02 0c5d4344
02 0d424344

